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

  Future<void> clear() async {
    await _box.clear();
    if (ref.mounted) state = [];
  }
}
