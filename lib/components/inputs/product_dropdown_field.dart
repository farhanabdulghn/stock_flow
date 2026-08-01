import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/states/actions/product/product_state.dart';

class ProductDropdownField extends ConsumerWidget {
  const ProductDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ProductModel? value;
  final ValueChanged<ProductModel?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(getProductsProvider);

    return productsState.when(
      loading: () => const _ProductDropdownLoading(),
      error: (error, _) {
        return _ProductDropdownError(
          onRetry: () => ref.invalidate(getProductsProvider),
        );
      },
      data: (products) {
        return DropdownButtonFormField<ProductModel>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Barang',
            prefixIcon: Icon(Icons.inventory_2_outlined),
          ),
          items: products.map((product) {
            return DropdownMenuItem<ProductModel>(
              value: product,
              child: Text(
                '${product.itemName} (${product.sku})',
                overflow: TextOverflow.ellipsis,
              ),
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
      },
    );
  }
}

class _ProductDropdownLoading extends StatelessWidget {
  const _ProductDropdownLoading();

  @override
  Widget build(BuildContext context) {
    return const InputDecorator(
      decoration: InputDecoration(labelText: 'Barang'),
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
      decoration: const InputDecoration(labelText: 'Barang'),
      child: Row(
        children: [
          const Expanded(child: Text('Gagal memuat daftar barang')),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
