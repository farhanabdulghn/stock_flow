// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_product_outbound_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionProductOutboundModel {

@HiveField(0) DateTime get date;@HiveField(1) String get product;@HiveField(2) int get quantity;@HiveField(3) String get destination;
/// Create a copy of TransactionProductOutboundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionProductOutboundModelCopyWith<TransactionProductOutboundModel> get copyWith => _$TransactionProductOutboundModelCopyWithImpl<TransactionProductOutboundModel>(this as TransactionProductOutboundModel, _$identity);

  /// Serializes this TransactionProductOutboundModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionProductOutboundModel&&(identical(other.date, date) || other.date == date)&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.destination, destination) || other.destination == destination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,product,quantity,destination);

@override
String toString() {
  return 'TransactionProductOutboundModel(date: $date, product: $product, quantity: $quantity, destination: $destination)';
}


}

/// @nodoc
abstract mixin class $TransactionProductOutboundModelCopyWith<$Res>  {
  factory $TransactionProductOutboundModelCopyWith(TransactionProductOutboundModel value, $Res Function(TransactionProductOutboundModel) _then) = _$TransactionProductOutboundModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) DateTime date,@HiveField(1) String product,@HiveField(2) int quantity,@HiveField(3) String destination
});




}
/// @nodoc
class _$TransactionProductOutboundModelCopyWithImpl<$Res>
    implements $TransactionProductOutboundModelCopyWith<$Res> {
  _$TransactionProductOutboundModelCopyWithImpl(this._self, this._then);

  final TransactionProductOutboundModel _self;
  final $Res Function(TransactionProductOutboundModel) _then;

/// Create a copy of TransactionProductOutboundModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? product = null,Object? quantity = null,Object? destination = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionProductOutboundModel].
extension TransactionProductOutboundModelPatterns on TransactionProductOutboundModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionProductOutboundModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionProductOutboundModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionProductOutboundModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionProductOutboundModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionProductOutboundModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionProductOutboundModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  DateTime date, @HiveField(1)  String product, @HiveField(2)  int quantity, @HiveField(3)  String destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionProductOutboundModel() when $default != null:
return $default(_that.date,_that.product,_that.quantity,_that.destination);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  DateTime date, @HiveField(1)  String product, @HiveField(2)  int quantity, @HiveField(3)  String destination)  $default,) {final _that = this;
switch (_that) {
case _TransactionProductOutboundModel():
return $default(_that.date,_that.product,_that.quantity,_that.destination);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  DateTime date, @HiveField(1)  String product, @HiveField(2)  int quantity, @HiveField(3)  String destination)?  $default,) {final _that = this;
switch (_that) {
case _TransactionProductOutboundModel() when $default != null:
return $default(_that.date,_that.product,_that.quantity,_that.destination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionProductOutboundModel implements TransactionProductOutboundModel {
  const _TransactionProductOutboundModel({@HiveField(0) required this.date, @HiveField(1) required this.product, @HiveField(2) required this.quantity, @HiveField(3) required this.destination});
  factory _TransactionProductOutboundModel.fromJson(Map<String, dynamic> json) => _$TransactionProductOutboundModelFromJson(json);

@override@HiveField(0) final  DateTime date;
@override@HiveField(1) final  String product;
@override@HiveField(2) final  int quantity;
@override@HiveField(3) final  String destination;

/// Create a copy of TransactionProductOutboundModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionProductOutboundModelCopyWith<_TransactionProductOutboundModel> get copyWith => __$TransactionProductOutboundModelCopyWithImpl<_TransactionProductOutboundModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionProductOutboundModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionProductOutboundModel&&(identical(other.date, date) || other.date == date)&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.destination, destination) || other.destination == destination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,product,quantity,destination);

@override
String toString() {
  return 'TransactionProductOutboundModel(date: $date, product: $product, quantity: $quantity, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$TransactionProductOutboundModelCopyWith<$Res> implements $TransactionProductOutboundModelCopyWith<$Res> {
  factory _$TransactionProductOutboundModelCopyWith(_TransactionProductOutboundModel value, $Res Function(_TransactionProductOutboundModel) _then) = __$TransactionProductOutboundModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) DateTime date,@HiveField(1) String product,@HiveField(2) int quantity,@HiveField(3) String destination
});




}
/// @nodoc
class __$TransactionProductOutboundModelCopyWithImpl<$Res>
    implements _$TransactionProductOutboundModelCopyWith<$Res> {
  __$TransactionProductOutboundModelCopyWithImpl(this._self, this._then);

  final _TransactionProductOutboundModel _self;
  final $Res Function(_TransactionProductOutboundModel) _then;

/// Create a copy of TransactionProductOutboundModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? product = null,Object? quantity = null,Object? destination = null,}) {
  return _then(_TransactionProductOutboundModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
