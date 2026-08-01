import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/transaction_product_inbound/transaction_product_inbound_model.dart';
import 'package:untitled/utils/enums.dart';

part 'transaction_product_inbound_notifier.g.dart';

@riverpod
class TransactionProductInboundNotifier
    extends _$TransactionProductInboundNotifier {
  Box<TransactionProductInboundModel> get _box =>
      Hive.box<TransactionProductInboundModel>(
        HiveBox.transactionProductInbound.name,
      );

  @override
  List<TransactionProductInboundModel> build() {
    return _box.values.toList().reversed.toList();
  }

  Future<void> addTransaction({
    required DateTime date,
    required String product,
    required int quantity,
    String? description,
  }) async {
    if (product.trim().isEmpty) {
      throw ArgumentError('Barang wajib dipilih');
    }

    if (quantity <= 0) {
      throw ArgumentError('Jumlah harus lebih dari 0');
    }

    final transaction = TransactionProductInboundModel(
      date: date,
      product: product,
      quantity: quantity,
      description: description,
    );

    await _box.add(transaction);

    if (ref.mounted) {
      state = [transaction, ...state];
    }
  }

  Future<void> clear() async {
    await _box.clear();
    if (ref.mounted) state = [];
  }
}
