import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/transaction_product_inbound/transaction_product_inbound_model.dart';
import 'package:untitled/pages/sections/add_inbound_transaction_section.dart';
import 'package:untitled/states/stores/transaction_product_inbound/transaction_product_inbound_notifier.dart';

final _provider = transactionProductInboundProvider;

class TransactionProductInboundScreen extends ConsumerStatefulWidget {
  const TransactionProductInboundScreen({super.key});

  @override
  ConsumerState<TransactionProductInboundScreen> createState() =>
      _TransactionProductInboundScreenState();
}

class _TransactionProductInboundScreenState
    extends ConsumerState<TransactionProductInboundScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value.trim().toLowerCase());
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() => _searchQuery = '');

    FocusScope.of(context).unfocus();
  }

  Future<void> _refreshTransactions() async {
    ref.invalidate(_provider);
  }

  Future<void> _showClearConfirmation() async {
    final transactions = ref.read(_provider);

    if (transactions.isEmpty) return;

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_sweep_outlined,
            color: Theme.of(dialogContext).colorScheme.error,
            size: 32,
          ),
          title: Text('Hapus semua transaksi?'),
          content: Text(
            'Seluruh riwayat transaksi barang masuk akan dihapus secara permanen.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Hapus Semua'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) return;

    await ref.read(_provider.notifier).clear();

    if (!mounted) return;

    _clearSearch();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semua transaksi barang masuk berhasil dihapus.')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(_provider);

    final filteredTransactions = transactions.where((transaction) {
      if (_searchQuery.isEmpty) return true;

      final description = transaction.description;

      final searchableValues = [
        transaction.product,
        description,
        transaction.quantity.toString(),
        _formatDate(transaction.date),
      ];

      return searchableValues.any((value) {
        return value.toString().toLowerCase().contains(_searchQuery);
      });
    }).toList();

    final totalQuantity = transactions.fold<int>(0, (
      previousValue,
      transaction,
    ) {
      return previousValue + transaction.quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Barang Masuk'),
        actions: [
          IconButton(
            tooltip: 'Tambah',
            onPressed: () async {
              final added = await AddInboundTransactionSection.show(context);
              if (added == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Barang masuk berhasil disimpan.')),
                );
              }
            },
            icon: Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _refreshTransactions,
            icon: Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Hapus semua transaksi',
            onPressed: transactions.isEmpty ? null : _showClearConfirmation,
            icon: Icon(Icons.delete_sweep_outlined),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: _InboundSummaryCard(
                totalTransactions: transactions.length,
                totalQuantity: totalQuantity,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari barang atau keterangan...',
                  prefixIcon: Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: _clearSearch,
                          icon: Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
            Expanded(
              child: _buildContent(
                transactions: transactions,
                filteredTransactions: filteredTransactions,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required List<TransactionProductInboundModel> transactions,
    required List<TransactionProductInboundModel> filteredTransactions,
  }) {
    if (transactions.isEmpty) {
      return _InboundEmptyState(onRefresh: _refreshTransactions);
    }

    if (filteredTransactions.isEmpty) {
      return _InboundSearchEmptyState(
        searchQuery: _searchController.text,
        onClearSearch: _clearSearch,
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: _refreshTransactions,
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: filteredTransactions.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];

          return _InboundTransactionCard(transaction: transaction);
        },
      ),
    );
  }
}

class _InboundSummaryCard extends StatelessWidget {
  const _InboundSummaryCard({
    required this.totalTransactions,
    required this.totalQuantity,
  });

  final int totalTransactions;
  final int totalQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.move_to_inbox_rounded,
                color: colorScheme.onTertiary,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SummaryItem(
                label: 'Total Transaksi',
                value: '$totalTransactions',
                valueColor: colorScheme.onTertiaryContainer,
              ),
            ),
            Container(
              width: 1,
              height: 42,
              color: colorScheme.onTertiaryContainer.withValues(alpha: 0.16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryItem(
                label: 'Barang Masuk',
                value: '$totalQuantity',
                valueColor: colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: valueColor.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InboundTransactionCard extends StatelessWidget {
  const _InboundTransactionCard({required this.transaction});

  final TransactionProductInboundModel transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String? description = transaction.description;
    final hasDescription = description != null && description.trim().isNotEmpty;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showTransactionDetail(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.call_received_rounded,
                  color: colorScheme.tertiary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            transaction.product,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _QuantityBadge(quantity: transaction.quantity),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatDateTime(transaction.date),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (hasDescription) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          description.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(BuildContext context) {
    final String? description = transaction.description;
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Barang Masuk',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                _DetailRow(
                  icon: Icons.inventory_2_outlined,
                  label: 'Barang',
                  value: transaction.product,
                ),
                SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.numbers_rounded,
                  label: 'Jumlah',
                  value: '${transaction.quantity}',
                ),
                SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tanggal',
                  value: _formatDateTime(transaction.date),
                ),
                SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.notes_rounded,
                  label: 'Keterangan',
                  value: description == null || description.trim().isEmpty
                      ? '-'
                      : description.trim(),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(bottomSheetContext).pop();
                    },
                    child: Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  const _QuantityBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '+$quantity',
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.tertiary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: colorScheme.primary),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InboundEmptyState extends StatelessWidget {
  const _InboundEmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(32),
        children: [
          SizedBox(height: 50),
          Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.move_to_inbox_outlined,
                size: 42,
                color: colorScheme.tertiary,
              ),
            ),
          ),
          SizedBox(height: 22),
          Text(
            'Belum ada barang masuk',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Transaksi barang masuk yang sudah disimpan akan ditampilkan di halaman ini.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: OutlinedButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh_rounded),
              label: Text('Muat Ulang'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InboundSearchEmptyState extends StatelessWidget {
  const _InboundSearchEmptyState({
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
        padding: EdgeInsets.fromLTRB(32, 24, 32, 80),
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
            SizedBox(height: 20),
            Text(
              'Transaksi tidak ditemukan',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tidak ada transaksi dengan kata kunci '
              '"${searchQuery.trim()}".',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            TextButton.icon(
              onPressed: onClearSearch,
              icon: Icon(Icons.close_rounded),
              label: Text('Hapus Pencarian'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _formatDateTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '${_formatDate(date)}, $hour:$minute';
}
