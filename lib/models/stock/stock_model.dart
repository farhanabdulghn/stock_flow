import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';

@freezed
abstract class StockModel with _$StockModel {
  const StockModel._();

  const factory StockModel({
    required String sku,
    required String itemName,
    required String category,
    required String unit,
    required int totalIn,
    required int totalOut,
  }) = _StockModel;

  int get quantity => totalIn - totalOut;
}
