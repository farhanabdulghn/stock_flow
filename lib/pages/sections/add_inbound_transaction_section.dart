import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/components/inputs/product_dropdown_field.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/states/stores/transaction_product_inbound/transaction_product_inbound_notifier.dart';

class AddInboundTransactionSection extends ConsumerStatefulWidget {
  const AddInboundTransactionSection({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const AddInboundTransactionSection(),
    );
  }

  @override
  ConsumerState<AddInboundTransactionSection> createState() =>
      _AddInboundTransactionSectionState();
}

class _AddInboundTransactionSectionState
    extends ConsumerState<AddInboundTransactionSection> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  ProductModel? _selectedProduct;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

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
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(transactionProductInboundProvider.notifier)
          .addTransaction(
            date: _selectedDate,
            productSku: _selectedProduct!.sku,
            quantity: int.parse(_quantityController.text.trim()),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.move_to_inbox_rounded,
                        color: colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tambah Barang Masuk',
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
                  onChanged: (product) {
                    setState(() => _selectedProduct = product);
                  },
                ),
                const SizedBox(height: 18),

                Text('Jumlah', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0',
                    prefixIcon: Icon(Icons.numbers_rounded),
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return 'Jumlah wajib diisi';

                    final parsed = int.tryParse(trimmed);
                    if (parsed == null || parsed <= 0) {
                      return 'Jumlah harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                Text(
                  'Keterangan (opsional)',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Catatan tambahan...',
                  ),
                ),
                const SizedBox(height: 28),

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
