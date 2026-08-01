import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:untitled/models/auth/auth_model.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/models/transaction_product_inbound/transaction_product_inbound_model.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
import 'package:untitled/networks/repositories/product_repository.dart';
import 'package:untitled/storage/hive/hive_transaction_reference_migration.dart';
import 'package:untitled/storage/secure_storage/secure_storage.dart';
import 'package:untitled/utils/enums.dart';

class HiveStorage {
  static Future<void> _seedProductsIfEmpty(Box<ProductModel> box) async {
    if (box.isNotEmpty) return;

    final products = await ProductRepository().getProducts();
    await box.addAll(products);
  }

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AuthModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(TransactionProductInboundModelAdapter());
    Hive.registerAdapter(TransactionProductOutboundModelAdapter());

    String? encryptionKeyString = await SecureStorage.read(K.hive);
    late List<int> encryptionKeyUint8List;

    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();

      await SecureStorage.write(key: K.hive, value: base64UrlEncode(key));
      encryptionKeyUint8List = key;
    } else {
      encryptionKeyUint8List = base64Url.decode(encryptionKeyString);
    }

    await Hive.openBox<AuthModel>(
      HiveBox.auth.name,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );

    final product = await Hive.openBox<ProductModel>(HiveBox.product.name);
    await _seedProductsIfEmpty(product);

    await Hive.openBox<TransactionProductInboundModel>(
      HiveBox.transactionProductInbound.name,
    );

    await Hive.openBox<TransactionProductOutboundModel>(
      HiveBox.transactionProductOutbound.name,
    );

    await HiveTransactionReferenceMigration.migrateToSku();
  }
}
