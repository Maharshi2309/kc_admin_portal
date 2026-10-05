// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_balance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveBalanceModel {

/// The day the figures are for (today, company time).
@DateOnlyConverter() DateTime get asOf;/// Casual days earned up to and including the current month.
 double get accrued;/// Approved Casual days (including leave booked for later dates).
 double get used;/// Pending Casual days: reserved until approved or rejected.
 double get pending; double get remaining;/// Approved Unpaid days.
 double get unpaidTaken;
/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceModelCopyWith<LeaveBalanceModel> get copyWith => _$LeaveBalanceModelCopyWithImpl<LeaveBalanceModel>(this as LeaveBalanceModel, _$identity);

  /// Serializes this LeaveBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalanceModel&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.accrued, accrued) || other.accrued == accrued)&&(identical(other.used, used) || other.used == used)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.unpaidTaken, unpaidTaken) || other.unpaidTaken == unpaidTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asOf,accrued,used,pending,remaining,unpaidTaken);

@override
String toString() {
  return 'LeaveBalanceModel(asOf: $asOf, accrued: $accrued, used: $used, pending: $pending, remaining: $remaining, unpaidTaken: $unpaidTaken)';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceModelCopyWith<$Res>  {
  factory $LeaveBalanceModelCopyWith(LeaveBalanceModel value, $Res Function(LeaveBalanceModel) _then) = _$LeaveBalanceModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime asOf, double accrued, double used, double pending, double remaining, double unpaidTaken
});




}
/// @nodoc
class _$LeaveBalanceModelCopyWithImpl<$Res>
    implements $LeaveBalanceModelCopyWith<$Res> {
  _$LeaveBalanceModelCopyWithImpl(this._self, this._then);

  final LeaveBalanceModel _self;
  final $Res Function(LeaveBalanceModel) _then;

/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asOf = null,Object? accrued = null,Object? used = null,Object? pending = null,Object? remaining = null,Object? unpaidTaken = null,}) {
  return _then(_self.copyWith(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,accrued: null == accrued ? _self.accrued : accrued // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,unpaidTaken: null == unpaidTaken ? _self.unpaidTaken : unpaidTaken // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveBalanceModel].
extension LeaveBalanceModelPatterns on LeaveBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime asOf,  double accrued,  double used,  double pending,  double remaining,  double unpaidTaken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
return $default(_that.asOf,_that.accrued,_that.used,_that.pending,_that.remaining,_that.unpaidTaken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime asOf,  double accrued,  double used,  double pending,  double remaining,  double unpaidTaken)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceModel():
return $default(_that.asOf,_that.accrued,_that.used,_that.pending,_that.remaining,_that.unpaidTaken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime asOf,  double accrued,  double used,  double pending,  double remaining,  double unpaidTaken)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
return $default(_that.asOf,_that.accrued,_that.used,_that.pending,_that.remaining,_that.unpaidTaken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveBalanceModel implements LeaveBalanceModel {
  const _LeaveBalanceModel({@DateOnlyConverter() required this.asOf, required this.accrued, required this.used, this.pending = 0, required this.remaining, this.unpaidTaken = 0});
  factory _LeaveBalanceModel.fromJson(Map<String, dynamic> json) => _$LeaveBalanceModelFromJson(json);

/// The day the figures are for (today, company time).
@override@DateOnlyConverter() final  DateTime asOf;
/// Casual days earned up to and including the current month.
@override final  double accrued;
/// Approved Casual days (including leave booked for later dates).
@override final  double used;
/// Pending Casual days: reserved until approved or rejected.
@override@JsonKey() final  double pending;
@override final  double remaining;
/// Approved Unpaid days.
@override@JsonKey() final  double unpaidTaken;

/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceModelCopyWith<_LeaveBalanceModel> get copyWith => __$LeaveBalanceModelCopyWithImpl<_LeaveBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalanceModel&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.accrued, accrued) || other.accrued == accrued)&&(identical(other.used, used) || other.used == used)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.unpaidTaken, unpaidTaken) || other.unpaidTaken == unpaidTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asOf,accrued,used,pending,remaining,unpaidTaken);

@override
String toString() {
  return 'LeaveBalanceModel(asOf: $asOf, accrued: $accrued, used: $used, pending: $pending, remaining: $remaining, unpaidTaken: $unpaidTaken)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceModelCopyWith<$Res> implements $LeaveBalanceModelCopyWith<$Res> {
  factory _$LeaveBalanceModelCopyWith(_LeaveBalanceModel value, $Res Function(_LeaveBalanceModel) _then) = __$LeaveBalanceModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime asOf, double accrued, double used, double pending, double remaining, double unpaidTaken
});




}
/// @nodoc
class __$LeaveBalanceModelCopyWithImpl<$Res>
    implements _$LeaveBalanceModelCopyWith<$Res> {
  __$LeaveBalanceModelCopyWithImpl(this._self, this._then);

  final _LeaveBalanceModel _self;
  final $Res Function(_LeaveBalanceModel) _then;

/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asOf = null,Object? accrued = null,Object? used = null,Object? pending = null,Object? remaining = null,Object? unpaidTaken = null,}) {
  return _then(_LeaveBalanceModel(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,accrued: null == accrued ? _self.accrued : accrued // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,unpaidTaken: null == unpaidTaken ? _self.unpaidTaken : unpaidTaken // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
