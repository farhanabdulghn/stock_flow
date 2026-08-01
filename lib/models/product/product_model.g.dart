// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      sku: json['sku'] as String,
      itemName: json['itemName'] as String,
      category: json['category'] as String,
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'itemName': instance.itemName,
      'category': instance.category,
      'unit': instance.unit,
    };
