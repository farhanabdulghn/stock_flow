import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/utils/enums.dart';

part 'product_notifier.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  Box<ProductModel> get _box {
    return Hive.box<ProductModel>(HiveBox.product.name);
  }

  @override
  List<ProductModel> build() {
    return _getProducts();
  }

  List<ProductModel> _getProducts() {
    final products = _box.values.toList();

    products.sort((first, second) {
      return first.itemName.toLowerCase().compareTo(
        second.itemName.toLowerCase(),
      );
    });

    return products;
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  bool _isSkuTaken(String sku, {dynamic excludeKey}) {
    final normalizedSku = _normalize(sku);

    for (final key in _box.keys) {
      if (excludeKey != null && key == excludeKey) {
        continue;
      }

      final product = _box.get(key);

      if (product != null && _normalize(product.sku) == normalizedSku) {
        return true;
      }
    }

    return false;
  }

  dynamic _findKeyBySku(String sku) {
    final normalizedSku = _normalize(sku);

    for (final key in _box.keys) {
      final product = _box.get(key);

      if (product != null && _normalize(product.sku) == normalizedSku) {
        return key;
      }
    }

    return null;
  }

  void _validateProduct({
    required String sku,
    required String itemName,
    required String category,
    required String unit,
  }) {
    if (sku.trim().isEmpty) {
      throw ArgumentError('SKU wajib diisi');
    }

    if (itemName.trim().isEmpty) {
      throw ArgumentError('Nama barang wajib diisi');
    }

    if (category.trim().isEmpty) {
      throw ArgumentError('Kategori wajib diisi');
    }

    if (unit.trim().isEmpty) {
      throw ArgumentError('Satuan wajib diisi');
    }
  }

  Future<void> addProduct({
    required String sku,
    required String itemName,
    required String category,
    required String unit,
  }) async {
    final trimmedSku = sku.trim().toUpperCase();
    final trimmedItemName = itemName.trim();
    final trimmedCategory = category.trim();
    final trimmedUnit = unit.trim();

    _validateProduct(
      sku: trimmedSku,
      itemName: trimmedItemName,
      category: trimmedCategory,
      unit: trimmedUnit,
    );

    if (_isSkuTaken(trimmedSku)) {
      throw StateError('SKU "$trimmedSku" sudah digunakan');
    }

    final product = ProductModel(
      sku: trimmedSku,
      itemName: trimmedItemName,
      category: trimmedCategory,
      unit: trimmedUnit,
    );

    await _box.add(product);

    if (ref.mounted) {
      state = _getProducts();
    }
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

    final trimmedSku = sku.trim().toUpperCase();
    final trimmedItemName = itemName.trim();
    final trimmedCategory = category.trim();
    final trimmedUnit = unit.trim();

    _validateProduct(
      sku: trimmedSku,
      itemName: trimmedItemName,
      category: trimmedCategory,
      unit: trimmedUnit,
    );

    if (_isSkuTaken(trimmedSku, excludeKey: key)) {
      throw StateError('SKU "$trimmedSku" sudah digunakan');
    }

    final updatedProduct = ProductModel(
      sku: trimmedSku,
      itemName: trimmedItemName,
      category: trimmedCategory,
      unit: trimmedUnit,
    );

    await _box.put(key, updatedProduct);

    if (ref.mounted) {
      state = _getProducts();
    }
  }

  Future<void> deleteProduct(String sku) async {
    final key = _findKeyBySku(sku);

    if (key == null) {
      throw StateError('Barang dengan SKU "$sku" tidak ditemukan');
    }

    await _box.delete(key);

    if (ref.mounted) {
      state = _getProducts();
    }
  }
}
