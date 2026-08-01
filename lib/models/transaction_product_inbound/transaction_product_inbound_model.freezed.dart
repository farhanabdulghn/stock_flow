// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_product_inbound_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionProductInboundModel {

@HiveField(0) DateTime get date;@HiveField(1) String get product;@HiveField(2) int get quantity;@HiveField(3) String? get description;
/// Create a copy of TransactionProductInboundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionProductInboundModelCopyWith<TransactionProductInboundModel> get copyWith => _$TransactionProductInboundModelCopyWithImpl<TransactionProductInboundModel>(this as TransactionProductInboundModel, _$identity);

  /// Serializes this TransactionProductInboundModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionProductInboundModel&&(identical(other.date, date) || other.date == date)&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,product,quantity,description);

@override
String toString() {
  return 'TransactionProductInboundModel(date: $date, product: $product, quantity: $quantity, description: $description)';
}


}

/// @nodoc
abstract mixin class $TransactionProductInboundModelCopyWith<$Res>  {
  factory $TransactionProductInboundModelCopyWith(TransactionProductInboundModel value, $Res Function(TransactionProductInboundModel) _then) = _$TransactionProductInboundModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) DateTime date,@HiveField(1) String product,@HiveField(2) int quantity,@HiveField(3) String? description
});




}
/// @nodoc
class _$TransactionProductInboundModelCopyWithImpl<$Res>
    implements $TransactionProductInboundModelCopyWith<$Res> {
  _$TransactionProductInboundModelCopyWithImpl(this._self, this._then);

  final TransactionProductInboundModel _self;
  final $Res Function(TransactionProductInboundModel) _then;

/// Create a copy of TransactionProductInboundModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? product = null,Object? quantity = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionProductInboundModel].
extension TransactionProductInboundModelPatterns on TransactionProductInboundModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionProductInboundModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionProductInboundModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionProductInboundModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionProductInboundModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionProductInboundModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionProductInboundModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  DateTime date, @HiveField(1)  String product, @HiveField(2)  int quantity, @HiveField(3)  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionProductInboundModel() when $default != null:
return $default(_that.date,_that.product,_that.quantity,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  DateTime date, @HiveField(1)  String product, @HiveField(2)  int quantity, @HiveField(3)  String? description)  $default,) {final _that = this;
switch (_that) {
case _TransactionProductInboundModel():
return $default(_that.date,_that.product,_that.quantity,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  DateTime date, @HiveField(1)  String product, @HiveField(2)  int quantity, @HiveField(3)  String? description)?  $default,) {final _that = this;
switch (_that) {
case _TransactionProductInboundModel() when $default != null:
return $default(_that.date,_that.product,_that.quantity,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionProductInboundModel implements TransactionProductInboundModel {
  const _TransactionProductInboundModel({@HiveField(0) required this.date, @HiveField(1) required this.product, @HiveField(2) required this.quantity, @HiveField(3) this.description});
  factory _TransactionProductInboundModel.fromJson(Map<String, dynamic> json) => _$TransactionProductInboundModelFromJson(json);

@override@HiveField(0) final  DateTime date;
@override@HiveField(1) final  String product;
@override@HiveField(2) final  int quantity;
@override@HiveField(3) final  String? description;

/// Create a copy of TransactionProductInboundModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionProductInboundModelCopyWith<_TransactionProductInboundModel> get copyWith => __$TransactionProductInboundModelCopyWithImpl<_TransactionProductInboundModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionProductInboundModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionProductInboundModel&&(identical(other.date, date) || other.date == date)&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,product,quantity,description);

@override
String toString() {
  return 'TransactionProductInboundModel(date: $date, product: $product, quantity: $quantity, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TransactionProductInboundModelCopyWith<$Res> implements $TransactionProductInboundModelCopyWith<$Res> {
  factory _$TransactionProductInboundModelCopyWith(_TransactionProductInboundModel value, $Res Function(_TransactionProductInboundModel) _then) = __$TransactionProductInboundModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) DateTime date,@HiveField(1) String product,@HiveField(2) int quantity,@HiveField(3) String? description
});




}
/// @nodoc
class __$TransactionProductInboundModelCopyWithImpl<$Res>
    implements _$TransactionProductInboundModelCopyWith<$Res> {
  __$TransactionProductInboundModelCopyWithImpl(this._self, this._then);

  final _TransactionProductInboundModel _self;
  final $Res Function(_TransactionProductInboundModel) _then;

/// Create a copy of TransactionProductInboundModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? product = null,Object? quantity = null,Object? description = freezed,}) {
  return _then(_TransactionProductInboundModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
