// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockModel {

 String get sku; String get itemName; String get category; String get unit; int get totalIn; int get totalOut;
/// Create a copy of StockModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockModelCopyWith<StockModel> get copyWith => _$StockModelCopyWithImpl<StockModel>(this as StockModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockModel&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.totalIn, totalIn) || other.totalIn == totalIn)&&(identical(other.totalOut, totalOut) || other.totalOut == totalOut));
}


@override
int get hashCode => Object.hash(runtimeType,sku,itemName,category,unit,totalIn,totalOut);

@override
String toString() {
  return 'StockModel(sku: $sku, itemName: $itemName, category: $category, unit: $unit, totalIn: $totalIn, totalOut: $totalOut)';
}


}

/// @nodoc
abstract mixin class $StockModelCopyWith<$Res>  {
  factory $StockModelCopyWith(StockModel value, $Res Function(StockModel) _then) = _$StockModelCopyWithImpl;
@useResult
$Res call({
 String sku, String itemName, String category, String unit, int totalIn, int totalOut
});




}
/// @nodoc
class _$StockModelCopyWithImpl<$Res>
    implements $StockModelCopyWith<$Res> {
  _$StockModelCopyWithImpl(this._self, this._then);

  final StockModel _self;
  final $Res Function(StockModel) _then;

/// Create a copy of StockModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? itemName = null,Object? category = null,Object? unit = null,Object? totalIn = null,Object? totalOut = null,}) {
  return _then(_self.copyWith(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,totalIn: null == totalIn ? _self.totalIn : totalIn // ignore: cast_nullable_to_non_nullable
as int,totalOut: null == totalOut ? _self.totalOut : totalOut // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StockModel].
extension StockModelPatterns on StockModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockModel value)  $default,){
final _that = this;
switch (_that) {
case _StockModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String itemName,  String category,  String unit,  int totalIn,  int totalOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockModel() when $default != null:
return $default(_that.sku,_that.itemName,_that.category,_that.unit,_that.totalIn,_that.totalOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String itemName,  String category,  String unit,  int totalIn,  int totalOut)  $default,) {final _that = this;
switch (_that) {
case _StockModel():
return $default(_that.sku,_that.itemName,_that.category,_that.unit,_that.totalIn,_that.totalOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String itemName,  String category,  String unit,  int totalIn,  int totalOut)?  $default,) {final _that = this;
switch (_that) {
case _StockModel() when $default != null:
return $default(_that.sku,_that.itemName,_that.category,_that.unit,_that.totalIn,_that.totalOut);case _:
  return null;

}
}

}

/// @nodoc


class _StockModel extends StockModel {
  const _StockModel({required this.sku, required this.itemName, required this.category, required this.unit, required this.totalIn, required this.totalOut}): super._();
  

@override final  String sku;
@override final  String itemName;
@override final  String category;
@override final  String unit;
@override final  int totalIn;
@override final  int totalOut;

/// Create a copy of StockModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockModelCopyWith<_StockModel> get copyWith => __$StockModelCopyWithImpl<_StockModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockModel&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.totalIn, totalIn) || other.totalIn == totalIn)&&(identical(other.totalOut, totalOut) || other.totalOut == totalOut));
}


@override
int get hashCode => Object.hash(runtimeType,sku,itemName,category,unit,totalIn,totalOut);

@override
String toString() {
  return 'StockModel(sku: $sku, itemName: $itemName, category: $category, unit: $unit, totalIn: $totalIn, totalOut: $totalOut)';
}


}

/// @nodoc
abstract mixin class _$StockModelCopyWith<$Res> implements $StockModelCopyWith<$Res> {
  factory _$StockModelCopyWith(_StockModel value, $Res Function(_StockModel) _then) = __$StockModelCopyWithImpl;
@override @useResult
$Res call({
 String sku, String itemName, String category, String unit, int totalIn, int totalOut
});




}
/// @nodoc
class __$StockModelCopyWithImpl<$Res>
    implements _$StockModelCopyWith<$Res> {
  __$StockModelCopyWithImpl(this._self, this._then);

  final _StockModel _self;
  final $Res Function(_StockModel) _then;

/// Create a copy of StockModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? itemName = null,Object? category = null,Object? unit = null,Object? totalIn = null,Object? totalOut = null,}) {
  return _then(_StockModel(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,totalIn: null == totalIn ? _self.totalIn : totalIn // ignore: cast_nullable_to_non_nullable
as int,totalOut: null == totalOut ? _self.totalOut : totalOut // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
