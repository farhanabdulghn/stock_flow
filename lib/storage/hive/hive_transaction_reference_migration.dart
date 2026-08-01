import 'package:hive_ce/hive.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/models/transaction_product_inbound/transaction_product_inbound_model.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
import 'package:untitled/utils/enums.dart';

class HiveTransactionReferenceMigration {
  const HiveTransactionReferenceMigration._();

  static Future<void> migrateToSku() async {
    final productBox = Hive.box<ProductModel>(HiveBox.product.name);

    final inboundBox = Hive.box<TransactionProductInboundModel>(
      HiveBox.transactionProductInbound.name,
    );

    final outboundBox = Hive.box<TransactionProductOutboundModel>(
      HiveBox.transactionProductOutbound.name,
    );

    final products = productBox.values.toList();

    if (products.isEmpty) return;

    await _migrateInboundTransactions(box: inboundBox, products: products);

    await _migrateOutboundTransactions(box: outboundBox, products: products);
  }

  static Future<void> _migrateInboundTransactions({
    required Box<TransactionProductInboundModel> box,
    required List<ProductModel> products,
  }) async {
    final keys = box.keys.toList();

    for (final key in keys) {
      final transaction = box.get(key);

      if (transaction == null) continue;

      final sku = _resolveSku(
        reference: transaction.product,
        products: products,
      );

      if (sku == null) continue;

      if (_normalize(transaction.product) == _normalize(sku)) {
        continue;
      }

      await box.put(key, transaction.copyWith(product: sku));
    }
  }

  static Future<void> _migrateOutboundTransactions({
    required Box<TransactionProductOutboundModel> box,
    required List<ProductModel> products,
  }) async {
    final keys = box.keys.toList();

    for (final key in keys) {
      final transaction = box.get(key);

      if (transaction == null) continue;

      final sku = _resolveSku(
        reference: transaction.product,
        products: products,
      );

      if (sku == null) continue;

      if (_normalize(transaction.product) == _normalize(sku)) {
        continue;
      }

      await box.put(key, transaction.copyWith(product: sku));
    }
  }

  static String? _resolveSku({
    required String reference,
    required List<ProductModel> products,
  }) {
    final normalizedReference = _normalize(reference);

    for (final product in products) {
      if (_normalize(product.sku) == normalizedReference) {
        return product.sku.trim().toUpperCase();
      }
    }

    final matchedByName = products.where((product) {
      return _normalize(product.itemName) == normalizedReference;
    }).toList();

    if (matchedByName.length != 1) {
      return null;
    }

    return matchedByName.first.sku.trim().toUpperCase();
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}
