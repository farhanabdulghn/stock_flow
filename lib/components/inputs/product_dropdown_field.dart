import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/states/actions/product/product_state.dart';
import 'package:untitled/states/actions/stock/stock_state.dart';

class ProductDropdownField extends ConsumerWidget {
  const ProductDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    this.onlyAvailableStock = false,
    this.showStock = false,
  });

  final ProductModel? value;
  final ValueChanged<ProductModel?> onChanged;

  final bool onlyAvailableStock;

  final bool showStock;

  String _normalizeSku(String value) {
    return value.trim().toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(getProductsProvider);

    if (!onlyAvailableStock) {
      return productsState.when(
        loading: () => const _ProductDropdownLoading(),
        error: (error, stackTrace) {
          return _ProductDropdownError(
            onRetry: () {
              ref.invalidate(getProductsProvider);
            },
          );
        },
        data: (products) {
          return _buildDropdown(products: products);
        },
      );
    }

    final stocksState = ref.watch(stockListProvider);

    return productsState.when(
      loading: () => const _ProductDropdownLoading(),
      error: (error, stackTrace) {
        return _ProductDropdownError(
          onRetry: () {
            ref.invalidate(getProductsProvider);
            ref.invalidate(stockListProvider);
          },
        );
      },
      data: (products) {
        return stocksState.when(
          loading: () => const _ProductDropdownLoading(),
          error: (error, stackTrace) {
            return _ProductDropdownError(
              onRetry: () {
                ref.invalidate(stockListProvider);
              },
            );
          },
          data: (stocks) {
            final stockBySku = {
              for (final stock in stocks)
                _normalizeSku(stock.sku): stock.quantity,
            };

            final availableProducts = products.where((product) {
              final stock = stockBySku[_normalizeSku(product.sku)] ?? 0;

              return stock > 0;
            }).toList();

            return _buildDropdown(
              products: availableProducts,
              stockBySku: stockBySku,
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown({
    required List<ProductModel> products,
    Map<String, int>? stockBySku,
  }) {
    ProductModel? selectedProduct;

    if (value != null) {
      for (final product in products) {
        if (_normalizeSku(product.sku) == _normalizeSku(value!.sku)) {
          selectedProduct = product;
          break;
        }
      }
    }

    if (products.isEmpty && onlyAvailableStock) {
      return DropdownButtonFormField<ProductModel>(
        initialValue: null,
        isExpanded: true,
        items: const <DropdownMenuItem<ProductModel>>[],
        onChanged: null,
        decoration: const InputDecoration(
          labelText: 'Barang',
          prefixIcon: PhosphorIcon(PhosphorIconsRegular.package, size: 20),
          helperText: 'Belum ada barang dengan stok tersedia',
        ),
        validator: (_) {
          return 'Belum ada barang dengan stok tersedia';
        },
      );
    }

    return DropdownButtonFormField<ProductModel>(
      initialValue: selectedProduct,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Barang',
        prefixIcon: PhosphorIcon(PhosphorIconsRegular.package, size: 20),
      ),
      items: products.map((product) {
        final stock = stockBySku?[_normalizeSku(product.sku)];

        final label = showStock && stock != null
            ? '${product.itemName} (${product.sku}) • Stok $stock'
            : '${product.itemName} (${product.sku})';

        return DropdownMenuItem<ProductModel>(
          value: product,
          child: Text(label, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (selected) {
        if (selected == null) {
          return 'Barang wajib dipilih';
        }

        return null;
      },
    );
  }
}

class _ProductDropdownLoading extends StatelessWidget {
  const _ProductDropdownLoading();

  @override
  Widget build(BuildContext context) {
    return const InputDecorator(
      decoration: InputDecoration(
        labelText: 'Barang',
        prefixIcon: PhosphorIcon(PhosphorIconsRegular.package, size: 20),
      ),
      child: SizedBox(height: 20, child: LinearProgressIndicator()),
    );
  }
}

class _ProductDropdownError extends StatelessWidget {
  const _ProductDropdownError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Barang',
        prefixIcon: PhosphorIcon(PhosphorIconsRegular.package, size: 20),
      ),
      child: Row(
        children: [
          const Expanded(child: Text('Gagal memuat daftar barang')),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
