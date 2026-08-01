import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
import 'package:untitled/pages/sections/add_outbound_transaction_section.dart';
import 'package:untitled/states/stores/transaction_product_outbound/transaction_product_outbound_notifier.dart';

class TransactionProductOutboundScreen extends ConsumerStatefulWidget {
  const TransactionProductOutboundScreen({super.key});

  @override
  ConsumerState<TransactionProductOutboundScreen> createState() =>
      _TransactionProductOutboundScreenState();
}

class _TransactionProductOutboundScreenState
    extends ConsumerState<TransactionProductOutboundScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Future<void> _refreshTransactions() async {
    ref.invalidate(transactionProductOutboundProvider);
  }

  Future<void> _showClearConfirmation() async {
    final transactions = ref.read(transactionProductOutboundProvider);

    if (transactions.isEmpty) {
      return;
    }

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          icon: Icon(
            Icons.delete_sweep_outlined,
            color: colorScheme.error,
            size: 32,
          ),
          title: const Text('Hapus semua transaksi?'),
          content: const Text(
            'Seluruh riwayat transaksi barang keluar akan dihapus secara permanen.',
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
              child: const Text('Hapus Semua'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) {
      return;
    }

    await ref.read(transactionProductOutboundProvider.notifier).clear();

    if (!mounted) {
      return;
    }

    _clearSearch();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua transaksi barang keluar berhasil dihapus.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProductOutboundProvider);

    final filteredTransactions = transactions.where((transaction) {
      if (_searchQuery.isEmpty) {
        return true;
      }

      final searchableValues = [
        transaction.product,
        transaction.destination,
        transaction.quantity.toString(),
        _formatDate(transaction.date),
        _formatDateTime(transaction.date),
      ];

      return searchableValues.any(
        (value) => value.toLowerCase().contains(_searchQuery),
      );
    }).toList();

    final totalQuantity = transactions.fold<int>(
      0,
      (total, transaction) => total + transaction.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang Keluar'),
        actions: [
          IconButton(
            tooltip: 'Tambah',
            onPressed: () async {
              final added = await AddOutboundTransactionSection.show(context);
              if (added == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Barang masuk berhasil disimpan.'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _refreshTransactions,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Hapus semua transaksi',
            onPressed: transactions.isEmpty ? null : _showClearConfirmation,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: _OutboundSummaryCard(
                totalTransactions: transactions.length,
                totalQuantity: totalQuantity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari barang atau tujuan...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.close_rounded),
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
    required List<TransactionProductOutboundModel> transactions,
    required List<TransactionProductOutboundModel> filteredTransactions,
  }) {
    if (transactions.isEmpty) {
      return _OutboundEmptyState(onRefresh: _refreshTransactions);
    }

    if (filteredTransactions.isEmpty) {
      return _OutboundSearchEmptyState(
        searchQuery: _searchController.text,
        onClearSearch: _clearSearch,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshTransactions,
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: filteredTransactions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];

          return _OutboundTransactionCard(transaction: transaction);
        },
      ),
    );
  }
}

class _OutboundSummaryCard extends StatelessWidget {
  const _OutboundSummaryCard({
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
      color: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.outbox_rounded,
                color: colorScheme.onSecondary,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SummaryItem(
                label: 'Total Transaksi',
                value: '$totalTransactions',
                valueColor: colorScheme.onSecondaryContainer,
              ),
            ),
            Container(
              width: 1,
              height: 42,
              color: colorScheme.onSecondaryContainer.withValues(alpha: 0.16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryItem(
                label: 'Barang Keluar',
                value: '$totalQuantity',
                valueColor: colorScheme.onSecondaryContainer,
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

class _OutboundTransactionCard extends StatelessWidget {
  const _OutboundTransactionCard({required this.transaction});

  final TransactionProductOutboundModel transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.call_made_rounded,
                  color: colorScheme.secondary,
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 17,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              transaction.destination,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  'Detail Barang Keluar',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                _DetailRow(
                  icon: Icons.inventory_2_outlined,
                  label: 'Barang',
                  value: transaction.product,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.numbers_rounded,
                  label: 'Jumlah',
                  value: '${transaction.quantity}',
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tanggal',
                  value: _formatDateTime(transaction.date),
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Tujuan',
                  value: transaction.destination,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(bottomSheetContext).pop();
                    },
                    child: const Text('Tutup'),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '-$quantity',
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.trim().isEmpty ? '-' : value,
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

class _OutboundEmptyState extends StatelessWidget {
  const _OutboundEmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        children: [
          const SizedBox(height: 50),
          Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.outbox_outlined,
                size: 42,
                color: colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Belum ada barang keluar',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Transaksi barang keluar yang sudah disimpan akan ditampilkan di halaman ini.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Muat Ulang'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutboundSearchEmptyState extends StatelessWidget {
  const _OutboundSearchEmptyState({
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
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 80),
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
              'Transaksi tidak ditemukan',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ada transaksi dengan kata kunci '
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
