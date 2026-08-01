import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/transaction_product_inbound/transaction_product_inbound_model.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
import 'package:untitled/utils/enums.dart';

part 'transaction_product_outbound_notifier.g.dart';

@riverpod
class TransactionProductOutboundNotifier
    extends _$TransactionProductOutboundNotifier {
  Box<TransactionProductOutboundModel> get _box {
    return Hive.box<TransactionProductOutboundModel>(
      HiveBox.transactionProductOutbound.name,
    );
  }

  Box<TransactionProductInboundModel> get _inboundBox {
    return Hive.box<TransactionProductInboundModel>(
      HiveBox.transactionProductInbound.name,
    );
  }

  @override
  List<TransactionProductOutboundModel> build() {
    return _box.values.toList().reversed.toList();
  }

  String _normalizeSku(String value) {
    return value.trim().toUpperCase();
  }

  int _getAvailableStock(String sku) {
    final normalizedSku = _normalizeSku(sku);

    final totalInbound = _inboundBox.values
        .where(
          (transaction) => _normalizeSku(transaction.product) == normalizedSku,
        )
        .fold<int>(0, (total, transaction) => total + transaction.quantity);

    final totalOutbound = _box.values
        .where(
          (transaction) => _normalizeSku(transaction.product) == normalizedSku,
        )
        .fold<int>(0, (total, transaction) => total + transaction.quantity);

    return totalInbound - totalOutbound;
  }

  Future<void> addTransaction({
    required DateTime date,
    required String productSku,
    required int quantity,
    required String destination,
  }) async {
    final normalizedSku = _normalizeSku(productSku);
    final normalizedDestination = destination.trim();

    if (normalizedSku.isEmpty) {
      throw ArgumentError('Barang wajib dipilih');
    }

    if (quantity <= 0) {
      throw ArgumentError('Jumlah harus lebih dari 0');
    }

    if (normalizedDestination.isEmpty) {
      throw ArgumentError('Tujuan wajib diisi');
    }

    final availableStock = _getAvailableStock(normalizedSku);

    if (quantity > availableStock) {
      throw StateError(
        'Stok tidak mencukupi. '
        'Stok tersedia: $availableStock, diminta: $quantity',
      );
    }

    final transaction = TransactionProductOutboundModel(
      date: date,
      product: normalizedSku,
      quantity: quantity,
      destination: normalizedDestination,
    );

    await _box.add(transaction);

    if (ref.mounted) {
      state = [transaction, ...state];
    }
  }

  Future<void> clear() async {
    await _box.clear();

    if (ref.mounted) {
      state = [];
    }
  }
}
