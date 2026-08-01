import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/components/inputs/product_dropdown_field.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/states/actions/stock/stock_state.dart';
import 'package:untitled/states/stores/transaction_product_outbound/transaction_product_outbound_notifier.dart';

class AddOutboundTransactionSection extends ConsumerStatefulWidget {
  const AddOutboundTransactionSection({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const AddOutboundTransactionSection(),
    );
  }

  @override
  ConsumerState<AddOutboundTransactionSection> createState() =>
      _AddOutboundTransactionSectionState();
}

class _AddOutboundTransactionSectionState
    extends ConsumerState<AddOutboundTransactionSection> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _destinationController = TextEditingController();

  ProductModel? _selectedProduct;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    setState(() => _errorMessage = null);

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(transactionProductOutboundProvider.notifier)
          .addTransaction(
            date: _selectedDate,
            productSku: _selectedProduct!.sku,
            quantity: int.parse(_quantityController.text.trim()),
            destination: _destinationController.text.trim(),
          );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      setState(() => _errorMessage = _getReadableError(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _getReadableError(Object error) {
    return error
        .toString()
        .replaceFirst('Invalid argument(s): ', '')
        .replaceFirst('Bad state: ', '')
        .replaceFirst('StateError: ', '')
        .replaceFirst('ArgumentError: ', '');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final selectedStockState = _selectedProduct == null
        ? null
        : ref.watch(stockQuantityBySkuProvider(_selectedProduct!.sku));

    final availableStock = selectedStockState?.maybeWhen<int?>(
      data: (stock) => stock,
      orElse: () => null,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.outbox_rounded,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tambah Barang Keluar',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Tanggal', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(_formatDate(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 18),
                ProductDropdownField(
                  value: _selectedProduct,
                  onlyAvailableStock: true,
                  showStock: true,
                  onChanged: (product) {
                    setState(() {
                      _selectedProduct = product;
                      _quantityController.clear();
                      _errorMessage = null;
                    });
                  },
                ),
                const SizedBox(height: 18),

                Text('Jumlah', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    if (_errorMessage != null) {
                      setState(() {
                        _errorMessage = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixIcon: const Icon(Icons.numbers_rounded),
                    helperText: availableStock == null
                        ? null
                        : 'Stok tersedia: $availableStock',
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';

                    if (trimmed.isEmpty) {
                      return 'Jumlah wajib diisi';
                    }

                    final parsed = int.tryParse(trimmed);

                    if (parsed == null || parsed <= 0) {
                      return 'Jumlah harus lebih dari 0';
                    }

                    if (availableStock != null && parsed > availableStock) {
                      return 'Jumlah melebihi stok tersedia '
                          '($availableStock)';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Text('Tujuan', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Toko Cabang A',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if ((value?.trim() ?? '').isEmpty) {
                      return 'Tujuan wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan'),
                  ),
                ),
              ],
            ),
          );
        },
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
