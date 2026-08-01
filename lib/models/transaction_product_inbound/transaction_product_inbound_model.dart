import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:untitled/storage/hive/hive_id.dart';

part 'transaction_product_inbound_model.freezed.dart';
part 'transaction_product_inbound_model.g.dart';

@freezed
@HiveType(typeId: HiveId.transactionProductInbound)
abstract class TransactionProductInboundModel
    with _$TransactionProductInboundModel {
  const factory TransactionProductInboundModel({
    @HiveField(0) required DateTime date,
    @HiveField(1) required String product,
    @HiveField(2) required int quantity,
    @HiveField(3) String? description,
  }) = _TransactionProductInboundModel;

  factory TransactionProductInboundModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionProductInboundModelFromJson(json);
}
