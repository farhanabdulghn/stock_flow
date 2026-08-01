import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/utils/enums.dart';

part 'product_notifier.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  Box<ProductModel> get _box => Hive.box<ProductModel>(HiveBox.product.name);

  @override
  List<ProductModel> build() {
    return _box.values.toList();
  }

  bool _isSkuTaken(String sku, {dynamic excludeKey}) {
    for (final key in _box.keys) {
      if (excludeKey != null && key == excludeKey) continue;

      final product = _box.get(key);
      if (product != null &&
          product.sku.trim().toLowerCase() == sku.trim().toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  dynamic _findKeyBySku(String sku) {
    for (final key in _box.keys) {
      final product = _box.get(key);
      if (product?.sku.trim().toLowerCase() == sku.trim().toLowerCase()) {
        return key;
      }
    }
    return null;
  }

  Future<void> addProduct({
    required String sku,
    required String itemName,
    required String category,
    required String unit,
  }) async {
    final trimmedSku = sku.trim();

    if (trimmedSku.isEmpty) throw ArgumentError('SKU wajib diisi');
    if (itemName.trim().isEmpty) throw ArgumentError('Nama barang wajib diisi');
    if (_isSkuTaken(trimmedSku)) {
      throw StateError('SKU "$trimmedSku" sudah digunakan');
    }

    final product = ProductModel(
      sku: trimmedSku,
      itemName: itemName.trim(),
      category: category.trim(),
      unit: unit.trim(),
    );

    await _box.add(product);

    if (ref.mounted) state = _box.values.toList();
  }

  Future<void> updateProduct({
    required String originalSku,
    required String sku,
    required String itemName,
    required String category,
    required String unit,
  }) async {
    final key = _findKeyBySku(originalSku);
    if (key == null) {
      throw StateError('Barang dengan SKU "$originalSku" tidak ditemukan');
    }

    final trimmedSku = sku.trim();
    if (trimmedSku.isEmpty) throw ArgumentError('SKU wajib diisi');
    if (_isSkuTaken(trimmedSku, excludeKey: key)) {
      throw StateError('SKU "$trimmedSku" sudah digunakan');
    }

    final updated = ProductModel(
      sku: trimmedSku,
      itemName: itemName.trim(),
      category: category.trim(),
      unit: unit.trim(),
    );

    await _box.put(key, updated);

    if (ref.mounted) state = _box.values.toList();
  }

  Future<void> deleteProduct(String sku) async {
    final key = _findKeyBySku(sku);
    if (key == null) {
      throw StateError('Barang dengan SKU "$sku" tidak ditemukan');
    }

    await _box.delete(key);

    if (ref.mounted) state = _box.values.toList();
  }
}
