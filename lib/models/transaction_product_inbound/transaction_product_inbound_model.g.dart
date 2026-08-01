// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_product_inbound_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionProductInboundModelAdapter
    extends TypeAdapter<TransactionProductInboundModel> {
  @override
  final typeId = 1;

  @override
  TransactionProductInboundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionProductInboundModel(
      date: fields[0] as DateTime,
      product: fields[1] as String,
      quantity: (fields[2] as num).toInt(),
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionProductInboundModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionProductInboundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionProductInboundModel _$TransactionProductInboundModelFromJson(
  Map<String, dynamic> json,
) => _TransactionProductInboundModel(
  date: DateTime.parse(json['date'] as String),
  product: json['product'] as String,
  quantity: (json['quantity'] as num).toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$TransactionProductInboundModelToJson(
  _TransactionProductInboundModel instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'product': instance.product,
  'quantity': instance.quantity,
  'description': instance.description,
};
