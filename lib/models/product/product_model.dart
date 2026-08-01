import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String sku,
    required String itemName,
    required String category,
    required String unit,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
