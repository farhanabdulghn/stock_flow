import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:untitled/storage/hive/hive_id.dart';

part 'transaction_product_outbound_model.freezed.dart';
part 'transaction_product_outbound_model.g.dart';

@freezed
@HiveType(typeId: HiveId.transactionProductOutbound)
abstract class TransactionProductOutboundModel
    with _$TransactionProductOutboundModel {
  const factory TransactionProductOutboundModel({
    @HiveField(0) required DateTime date,
    @HiveField(1) required String product,
    @HiveField(2) required int quantity,
    @HiveField(3) required String destination,
  }) = _TransactionProductOutboundModel;

  factory TransactionProductOutboundModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionProductOutboundModelFromJson(json);
}
