import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
import 'package:untitled/states/actions/stock/stock_state.dart';
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

  @override
  List<TransactionProductOutboundModel> build() {
    return _box.values.toList().reversed.toList();
  }

  Future<void> addTransaction({
    required DateTime date,
    required String productSku,
    required int quantity,
    required String destination,
  }) async {
    final normalizedSku = productSku.trim().toUpperCase();
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

    final availableStock = await ref.read(
      stockQuantityBySkuProvider(normalizedSku).future,
    );

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
