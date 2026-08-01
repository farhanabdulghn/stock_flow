import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/pages/sections/product_form_section.dart';
import 'package:untitled/states/actions/product/product_state.dart';
import 'package:untitled/states/actions/stock/stock_state.dart';
import 'package:untitled/states/stores/product/product_notifier.dart';
import 'package:untitled/states/stores/transaction_product_inbound/transaction_product_inbound_notifier.dart';
import 'package:untitled/states/stores/transaction_product_outbound/transaction_product_outbound_notifier.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    ref.invalidate(getProductsProvider);
    ref.invalidate(stockListProvider);

    try {
      await ref.read(getProductsProvider.future);
    } catch (_) {
      //
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });

    FocusScope.of(context).unfocus();
  }

  String _normalizeProductReference(String value) {
    return value.trim().toLowerCase();
  }

  bool _transactionReferenceMatchesProduct(
    String reference,
    ProductModel product,
  ) {
    final normalizedReference = _normalizeProductReference(reference);

    final normalizedSku = _normalizeProductReference(product.sku);

    final normalizedItemName = _normalizeProductReference(product.itemName);

    return normalizedReference == normalizedSku ||
        normalizedReference == normalizedItemName;
  }

  bool _hasTransactionHistory(ProductModel product) {
    final inboundTransactions = ref.read(transactionProductInboundProvider);

    final outboundTransactions = ref.read(transactionProductOutboundProvider);

    final hasInboundHistory = inboundTransactions.any((transaction) {
      return _transactionReferenceMatchesProduct(transaction.product, product);
    });

    final hasOutboundHistory = outboundTransactions.any((transaction) {
      return _transactionReferenceMatchesProduct(transaction.product, product);
    });

    return hasInboundHistory || hasOutboundHistory;
  }

  Future<void> _showAddProductForm() async {
    final added = await ProductFormSection.show(context);

    if (added != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang berhasil ditambahkan.')),
    );
  }

  Future<void> _showEditProductForm(ProductModel product) async {
    final updated = await ProductFormSection.show(context, product: product);

    if (updated != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang berhasil diperbarui.')),
    );
  }

  Future<void> _showDeleteConfirmation(ProductModel product) async {
    final hasTransactionHistory = _hasTransactionHistory(product);

    if (hasTransactionHistory) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Barang tidak dapat dihapus karena sudah memiliki '
            'histori transaksi.',
          ),
        ),
      );

      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: colorScheme.error,
            size: 34,
          ),
          title: const Text('Hapus barang?'),
          content: Text(
            'Barang "${product.itemName}" dengan SKU '
            '"${product.sku}" akan dihapus secara permanen.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await ref.read(productProvider.notifier).deleteProduct(product.sku);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Barang berhasil dihapus.')));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus barang: ${_getReadableError(error)}'),
        ),
      );
    }
  }

  String _getReadableError(Object error) {
    return error
        .toString()
        .replaceFirst('Invalid argument(s): ', '')
        .replaceFirst('Bad state: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(getProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang'),
        actions: [
          IconButton(
            tooltip: 'Tambah Barang',
            onPressed: _showAddProductForm,
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Muat Ulang',
            onPressed: _refreshProducts,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: productsState.when(
          loading: () {
            return const _ProductLoadingState();
          },
          error: (error, stackTrace) {
            return _ProductErrorState(onRetry: _refreshProducts);
          },
          data: (products) {
            final filteredProducts = products.where((product) {
              if (_searchQuery.isEmpty) return true;

              final searchableValues = [
                product.sku,
                product.itemName,
                product.category,
                product.unit,
              ];

              return searchableValues.any((value) {
                return value.toLowerCase().contains(_searchQuery);
              });
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: _ProductSummaryCard(totalProducts: products.length),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Cari SKU, nama, kategori, atau satuan...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus Pencarian',
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildProductContent(
                    allProductsEmpty: products.isEmpty,
                    filteredProducts: filteredProducts,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductContent({
    required bool allProductsEmpty,
    required List<ProductModel> filteredProducts,
  }) {
    final stockState = ref.watch(stockListProvider);

    final stockBySku = stockState.maybeWhen(
      data: (list) {
        return {
          for (final stock in list)
            stock.sku.trim().toUpperCase(): stock.quantity,
        };
      },
      orElse: () => <String, int>{},
    );

    if (allProductsEmpty) {
      return _ProductEmptyState(
        onAddProduct: _showAddProductForm,
        onRefresh: _refreshProducts,
      );
    }

    if (filteredProducts.isEmpty) {
      return _SearchEmptyState(
        searchQuery: _searchController.text,
        onClearSearch: _clearSearch,
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: _refreshProducts,
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
        itemCount: filteredProducts.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          final product = filteredProducts[index];

          final stock = stockBySku[product.sku.trim().toUpperCase()] ?? 0;

          return _ProductCard(
            product: product,
            stock: stock,
            onEdit: () {
              _showEditProductForm(product);
            },
            onDelete: () {
              _showDeleteConfirmation(product);
            },
          );
        },
      ),
    );
  }
}

enum _ProductAction { edit, delete }

class _ProductSummaryCard extends StatelessWidget {
  const _ProductSummaryCard({required this.totalProducts});

  final int totalProducts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: colorScheme.onPrimary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Barang',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$totalProducts barang terdaftar',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.stock,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductModel product;
  final int stock;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isEmptyStock = stock <= 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: colorScheme.primary,
                size: 25,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.itemName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.sku,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _ProductInformationChip(
                        icon: Icons.category_outlined,
                        label: product.category,
                      ),
                      _ProductInformationChip(
                        icon: Icons.straighten_rounded,
                        label: product.unit,
                      ),
                      _ProductInformationChip(
                        icon: Icons.inventory_outlined,
                        label: 'Stok $stock',
                        isError: isEmptyStock,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<_ProductAction>(
              tooltip: 'Pilihan Barang',
              onSelected: (action) {
                switch (action) {
                  case _ProductAction.edit:
                    onEdit();
                  case _ProductAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: _ProductAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _ProductAction.delete,
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded),
                        SizedBox(width: 12),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductInformationChip extends StatelessWidget {
  const _ProductInformationChip({
    required this.icon,
    required this.label,
    this.isError = false,
  });

  final IconData icon;
  final String label;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isError
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isError
                ? colorScheme.onErrorContainer
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isError
                  ? colorScheme.onErrorContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductLoadingState extends StatelessWidget {
  const _ProductLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 18),
            Text(
              'Memuat daftar barang...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductEmptyState extends StatelessWidget {
  const _ProductEmptyState({
    required this.onAddProduct,
    required this.onRefresh,
  });

  final VoidCallback onAddProduct;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 110),
        children: [
          const SizedBox(height: 50),
          Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 42,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Belum ada barang',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan master barang agar transaksi barang masuk '
            'dan keluar dapat dilakukan.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: FilledButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Barang'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({
    required this.searchQuery,
    required this.onClearSearch,
  });

  final String searchQuery;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 110),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 40,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Barang tidak ditemukan',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.trim().isEmpty
                  ? 'Coba gunakan kata kunci yang berbeda.'
                  : 'Tidak ada barang dengan kata kunci '
                        '"${searchQuery.trim()}".',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(Icons.close_rounded),
              label: const Text('Hapus Pencarian'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductErrorState extends StatelessWidget {
  const _ProductErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Gagal memuat barang',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terjadi kesalahan saat mengambil data barang.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
