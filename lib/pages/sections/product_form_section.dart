import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/states/stores/product/product_notifier.dart';

class ProductFormSection extends ConsumerStatefulWidget {
  const ProductFormSection({
    super.key,
    this.product,
    this.lockItemName = false,
  });

  final ProductModel? product;
  final bool lockItemName;

  bool get isEditing => product != null;

  static Future<bool?> show(
    BuildContext context, {
    ProductModel? product,
    bool lockItemName = false,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return ProductFormSection(product: product, lockItemName: lockItemName);
      },
    );
  }

  @override
  ConsumerState<ProductFormSection> createState() => _ProductFormSectionState();
}

class _ProductFormSectionState extends ConsumerState<ProductFormSection> {
  final _formKey = GlobalKey<FormState>();

  final _skuController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final notifier = ref.read(productProvider.notifier);

      if (widget.isEditing) {
        final existingProduct = widget.product!;

        await notifier.updateProduct(
          originalSku: existingProduct.sku,
          sku: existingProduct.sku,
          itemName: _itemNameController.text,
          category: _categoryController.text,
          unit: _unitController.text,
        );
      } else {
        await notifier.addProduct(
          sku: _skuController.text,
          itemName: _itemNameController.text,
          category: _categoryController.text,
          unit: _unitController.text,
        );
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_getReadableError(error))));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _getReadableError(Object error) {
    final message = error.toString();

    return message
        .replaceFirst('Invalid argument(s): ', '')
        .replaceFirst('Bad state: ', '');
  }

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _skuController.text = product?.sku ?? '';
    _itemNameController.text = product?.itemName ?? '';
    _categoryController.text = product?.category ?? '';
    _unitController.text = product?.unit ?? '';
  }

  @override
  void dispose() {
    _skuController.dispose();
    _itemNameController.dispose();
    _categoryController.dispose();
    _unitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        widget.isEditing
                            ? Icons.edit_note_rounded
                            : Icons.inventory_2_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.isEditing ? 'Edit Barang' : 'Tambah Barang',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                Text('SKU', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _skuController,
                  readOnly: widget.isEditing,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Contoh: BRG-001',
                    prefixIcon: const Icon(Icons.qr_code_rounded),
                    helperText: widget.isEditing
                        ? 'SKU tidak dapat diubah'
                        : 'SKU harus unik',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'SKU wajib diisi';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 18),

                Text('Nama Barang', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _itemNameController,
                  readOnly: widget.isEditing && widget.lockItemName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama barang',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    helperText: widget.isEditing && widget.lockItemName
                        ? 'Nama dikunci karena barang memiliki histori transaksi'
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama barang wajib diisi';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 18),

                Text('Kategori', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _categoryController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Elektronik',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kategori wajib diisi';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 18),

                Text('Satuan', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _unitController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _submit();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Pcs, Box, Unit',
                    prefixIcon: Icon(Icons.straighten_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Satuan wajib diisi';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            widget.isEditing
                                ? Icons.save_rounded
                                : Icons.add_rounded,
                          ),
                    label: Text(
                      _isSubmitting
                          ? 'Menyimpan...'
                          : widget.isEditing
                          ? 'Simpan Perubahan'
                          : 'Tambah Barang',
                    ),
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
