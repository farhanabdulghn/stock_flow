import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/transaction_product_outbound/transaction_product_outbound_model.dart';
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

  Future<void> clear() async {
    await _box.clear();
    if (ref.mounted) state = [];
  }
}
