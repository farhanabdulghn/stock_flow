// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_product_outbound_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionProductOutboundModelAdapter
    extends TypeAdapter<TransactionProductOutboundModel> {
  @override
  final typeId = 3;

  @override
  TransactionProductOutboundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionProductOutboundModel(
      date: fields[0] as DateTime,
      product: fields[1] as String,
      quantity: (fields[2] as num).toInt(),
      destination: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionProductOutboundModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.destination);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionProductOutboundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionProductOutboundModel _$TransactionProductOutboundModelFromJson(
  Map<String, dynamic> json,
) => _TransactionProductOutboundModel(
  date: DateTime.parse(json['date'] as String),
  product: json['product'] as String,
  quantity: (json['quantity'] as num).toInt(),
  destination: json['destination'] as String,
);

Map<String, dynamic> _$TransactionProductOutboundModelToJson(
  _TransactionProductOutboundModel instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'product': instance.product,
  'quantity': instance.quantity,
  'destination': instance.destination,
};
