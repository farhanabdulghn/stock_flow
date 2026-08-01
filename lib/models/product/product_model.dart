import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:untitled/storage/hive/hive_id.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: HiveId.product)
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) required String sku,
    @HiveField(1) required String itemName,
    @HiveField(2) required String category,
    @HiveField(3) required String unit,
  }) = _ProductModel;
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
