import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
import 'package:untitled/states/actions/stock/stock_state.dart';
import 'package:untitled/utils/enums.dart';

part 'transaction_product_outbound_notifier.g.dart';

@riverpod
class TransactionProductOutboundNotifier
    extends _$TransactionProductOutboundNotifier {
  Box<TransactionProductOutboundModel> get _box =>
      Hive.box<TransactionProductOutboundModel>(
        HiveBox.transactionProductOutbound.name,
      );

  @override
  List<TransactionProductOutboundModel> build() {
    return _box.values.toList().reversed.toList();
  }

  Future<void> addTransaction({
    required DateTime date,
    required String product,
    required int quantity,
    required String destination,
  }) async {
    if (product.trim().isEmpty) {
      throw ArgumentError('Barang wajib dipilih');
    }

    if (quantity <= 0) {
      throw ArgumentError('Jumlah harus lebih dari 0');
    }

    if (destination.trim().isEmpty) {
      throw ArgumentError('Tujuan wajib diisi');
    }

    final availableStock = await ref.read(
      stockQuantityByItemNameProvider(product).future,
    );

    if (quantity > availableStock) {
      throw StateError(
        'Stok tidak mencukupi. Stok tersedia: $availableStock, diminta: $quantity',
      );
    }

    final transaction = TransactionProductOutboundModel(
      date: date,
      product: product,
      quantity: quantity,
      destination: destination,
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
