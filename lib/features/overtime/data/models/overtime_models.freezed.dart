// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overtime_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OvertimeReportModel {

@DateOnlyConverter() DateTime get from;@DateOnlyConverter() DateTime get to; int get totalMinutes;/// Working hours in the range, up to today (V2 profile): what the
/// schedule expected and what was worked, holidays and weekly offs
/// included. Null from an older backend.
 int? get expectedMinutes; int? get workedMinutes;/// Expected minutes of one working day under the current schedule; the
/// basis for showing [totalMinutes] as days.
 int get dayBasisMinutes;/// True when the schedule changed inside the range, so the day
/// conversion of the total is approximate.
 bool get scheduleChanged;/// Every month of the range up to today, oldest first.
 List<OvertimeMonthModel> get months; List<OvertimeDayModel> get days;
/// Create a copy of OvertimeReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeReportModelCopyWith<OvertimeReportModel> get copyWith => _$OvertimeReportModelCopyWithImpl<OvertimeReportModel>(this as OvertimeReportModel, _$identity);

  /// Serializes this OvertimeReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeReportModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.dayBasisMinutes, dayBasisMinutes) || other.dayBasisMinutes == dayBasisMinutes)&&(identical(other.scheduleChanged, scheduleChanged) || other.scheduleChanged == scheduleChanged)&&const DeepCollectionEquality().equals(other.months, months)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,totalMinutes,expectedMinutes,workedMinutes,dayBasisMinutes,scheduleChanged,const DeepCollectionEquality().hash(months),const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'OvertimeReportModel(from: $from, to: $to, totalMinutes: $totalMinutes, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes, dayBasisMinutes: $dayBasisMinutes, scheduleChanged: $scheduleChanged, months: $months, days: $days)';
}


}

/// @nodoc
abstract mixin class $OvertimeReportModelCopyWith<$Res>  {
  factory $OvertimeReportModelCopyWith(OvertimeReportModel value, $Res Function(OvertimeReportModel) _then) = _$OvertimeReportModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime from,@DateOnlyConverter() DateTime to, int totalMinutes, int? expectedMinutes, int? workedMinutes, int dayBasisMinutes, bool scheduleChanged, List<OvertimeMonthModel> months, List<OvertimeDayModel> days
});




}
/// @nodoc
class _$OvertimeReportModelCopyWithImpl<$Res>
    implements $OvertimeReportModelCopyWith<$Res> {
  _$OvertimeReportModelCopyWithImpl(this._self, this._then);

  final OvertimeReportModel _self;
  final $Res Function(OvertimeReportModel) _then;

/// Create a copy of OvertimeReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? totalMinutes = null,Object? expectedMinutes = freezed,Object? workedMinutes = freezed,Object? dayBasisMinutes = null,Object? scheduleChanged = null,Object? months = null,Object? days = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,expectedMinutes: freezed == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,dayBasisMinutes: null == dayBasisMinutes ? _self.dayBasisMinutes : dayBasisMinutes // ignore: cast_nullable_to_non_nullable
as int,scheduleChanged: null == scheduleChanged ? _self.scheduleChanged : scheduleChanged // ignore: cast_nullable_to_non_nullable
as bool,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as List<OvertimeMonthModel>,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<OvertimeDayModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeReportModel].
extension OvertimeReportModelPatterns on OvertimeReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeReportModel value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime from, @DateOnlyConverter()  DateTime to,  int totalMinutes,  int? expectedMinutes,  int? workedMinutes,  int dayBasisMinutes,  bool scheduleChanged,  List<OvertimeMonthModel> months,  List<OvertimeDayModel> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeReportModel() when $default != null:
return $default(_that.from,_that.to,_that.totalMinutes,_that.expectedMinutes,_that.workedMinutes,_that.dayBasisMinutes,_that.scheduleChanged,_that.months,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime from, @DateOnlyConverter()  DateTime to,  int totalMinutes,  int? expectedMinutes,  int? workedMinutes,  int dayBasisMinutes,  bool scheduleChanged,  List<OvertimeMonthModel> months,  List<OvertimeDayModel> days)  $default,) {final _that = this;
switch (_that) {
case _OvertimeReportModel():
return $default(_that.from,_that.to,_that.totalMinutes,_that.expectedMinutes,_that.workedMinutes,_that.dayBasisMinutes,_that.scheduleChanged,_that.months,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime from, @DateOnlyConverter()  DateTime to,  int totalMinutes,  int? expectedMinutes,  int? workedMinutes,  int dayBasisMinutes,  bool scheduleChanged,  List<OvertimeMonthModel> months,  List<OvertimeDayModel> days)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeReportModel() when $default != null:
return $default(_that.from,_that.to,_that.totalMinutes,_that.expectedMinutes,_that.workedMinutes,_that.dayBasisMinutes,_that.scheduleChanged,_that.months,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeReportModel implements OvertimeReportModel {
  const _OvertimeReportModel({@DateOnlyConverter() required this.from, @DateOnlyConverter() required this.to, required this.totalMinutes, this.expectedMinutes, this.workedMinutes, required this.dayBasisMinutes, this.scheduleChanged = false, required final  List<OvertimeMonthModel> months, required final  List<OvertimeDayModel> days}): _months = months,_days = days;
  factory _OvertimeReportModel.fromJson(Map<String, dynamic> json) => _$OvertimeReportModelFromJson(json);

@override@DateOnlyConverter() final  DateTime from;
@override@DateOnlyConverter() final  DateTime to;
@override final  int totalMinutes;
/// Working hours in the range, up to today (V2 profile): what the
/// schedule expected and what was worked, holidays and weekly offs
/// included. Null from an older backend.
@override final  int? expectedMinutes;
@override final  int? workedMinutes;
/// Expected minutes of one working day under the current schedule; the
/// basis for showing [totalMinutes] as days.
@override final  int dayBasisMinutes;
/// True when the schedule changed inside the range, so the day
/// conversion of the total is approximate.
@override@JsonKey() final  bool scheduleChanged;
/// Every month of the range up to today, oldest first.
 final  List<OvertimeMonthModel> _months;
/// Every month of the range up to today, oldest first.
@override List<OvertimeMonthModel> get months {
  if (_months is EqualUnmodifiableListView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_months);
}

 final  List<OvertimeDayModel> _days;
@override List<OvertimeDayModel> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of OvertimeReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeReportModelCopyWith<_OvertimeReportModel> get copyWith => __$OvertimeReportModelCopyWithImpl<_OvertimeReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeReportModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.dayBasisMinutes, dayBasisMinutes) || other.dayBasisMinutes == dayBasisMinutes)&&(identical(other.scheduleChanged, scheduleChanged) || other.scheduleChanged == scheduleChanged)&&const DeepCollectionEquality().equals(other._months, _months)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,totalMinutes,expectedMinutes,workedMinutes,dayBasisMinutes,scheduleChanged,const DeepCollectionEquality().hash(_months),const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'OvertimeReportModel(from: $from, to: $to, totalMinutes: $totalMinutes, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes, dayBasisMinutes: $dayBasisMinutes, scheduleChanged: $scheduleChanged, months: $months, days: $days)';
}


}

/// @nodoc
abstract mixin class _$OvertimeReportModelCopyWith<$Res> implements $OvertimeReportModelCopyWith<$Res> {
  factory _$OvertimeReportModelCopyWith(_OvertimeReportModel value, $Res Function(_OvertimeReportModel) _then) = __$OvertimeReportModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime from,@DateOnlyConverter() DateTime to, int totalMinutes, int? expectedMinutes, int? workedMinutes, int dayBasisMinutes, bool scheduleChanged, List<OvertimeMonthModel> months, List<OvertimeDayModel> days
});




}
/// @nodoc
class __$OvertimeReportModelCopyWithImpl<$Res>
    implements _$OvertimeReportModelCopyWith<$Res> {
  __$OvertimeReportModelCopyWithImpl(this._self, this._then);

  final _OvertimeReportModel _self;
  final $Res Function(_OvertimeReportModel) _then;

/// Create a copy of OvertimeReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? totalMinutes = null,Object? expectedMinutes = freezed,Object? workedMinutes = freezed,Object? dayBasisMinutes = null,Object? scheduleChanged = null,Object? months = null,Object? days = null,}) {
  return _then(_OvertimeReportModel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,expectedMinutes: freezed == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,dayBasisMinutes: null == dayBasisMinutes ? _self.dayBasisMinutes : dayBasisMinutes // ignore: cast_nullable_to_non_nullable
as int,scheduleChanged: null == scheduleChanged ? _self.scheduleChanged : scheduleChanged // ignore: cast_nullable_to_non_nullable
as bool,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as List<OvertimeMonthModel>,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<OvertimeDayModel>,
  ));
}


}


/// @nodoc
mixin _$OvertimeMonthModel {

@DateOnlyConverter() DateTime get month;/// Overtime in the month (inside the range).
 int get minutes;/// Working hours in the month (inside the range, up to today).
 int? get expectedMinutes; int? get workedMinutes;
/// Create a copy of OvertimeMonthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeMonthModelCopyWith<OvertimeMonthModel> get copyWith => _$OvertimeMonthModelCopyWithImpl<OvertimeMonthModel>(this as OvertimeMonthModel, _$identity);

  /// Serializes this OvertimeMonthModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeMonthModel&&(identical(other.month, month) || other.month == month)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,minutes,expectedMinutes,workedMinutes);

@override
String toString() {
  return 'OvertimeMonthModel(month: $month, minutes: $minutes, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes)';
}


}

/// @nodoc
abstract mixin class $OvertimeMonthModelCopyWith<$Res>  {
  factory $OvertimeMonthModelCopyWith(OvertimeMonthModel value, $Res Function(OvertimeMonthModel) _then) = _$OvertimeMonthModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime month, int minutes, int? expectedMinutes, int? workedMinutes
});




}
/// @nodoc
class _$OvertimeMonthModelCopyWithImpl<$Res>
    implements $OvertimeMonthModelCopyWith<$Res> {
  _$OvertimeMonthModelCopyWithImpl(this._self, this._then);

  final OvertimeMonthModel _self;
  final $Res Function(OvertimeMonthModel) _then;

/// Create a copy of OvertimeMonthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? minutes = null,Object? expectedMinutes = freezed,Object? workedMinutes = freezed,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,expectedMinutes: freezed == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeMonthModel].
extension OvertimeMonthModelPatterns on OvertimeMonthModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeMonthModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeMonthModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeMonthModel value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeMonthModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeMonthModel value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeMonthModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  int minutes,  int? expectedMinutes,  int? workedMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeMonthModel() when $default != null:
return $default(_that.month,_that.minutes,_that.expectedMinutes,_that.workedMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  int minutes,  int? expectedMinutes,  int? workedMinutes)  $default,) {final _that = this;
switch (_that) {
case _OvertimeMonthModel():
return $default(_that.month,_that.minutes,_that.expectedMinutes,_that.workedMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime month,  int minutes,  int? expectedMinutes,  int? workedMinutes)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeMonthModel() when $default != null:
return $default(_that.month,_that.minutes,_that.expectedMinutes,_that.workedMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeMonthModel implements OvertimeMonthModel {
  const _OvertimeMonthModel({@DateOnlyConverter() required this.month, required this.minutes, this.expectedMinutes, this.workedMinutes});
  factory _OvertimeMonthModel.fromJson(Map<String, dynamic> json) => _$OvertimeMonthModelFromJson(json);

@override@DateOnlyConverter() final  DateTime month;
/// Overtime in the month (inside the range).
@override final  int minutes;
/// Working hours in the month (inside the range, up to today).
@override final  int? expectedMinutes;
@override final  int? workedMinutes;

/// Create a copy of OvertimeMonthModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeMonthModelCopyWith<_OvertimeMonthModel> get copyWith => __$OvertimeMonthModelCopyWithImpl<_OvertimeMonthModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeMonthModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeMonthModel&&(identical(other.month, month) || other.month == month)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,minutes,expectedMinutes,workedMinutes);

@override
String toString() {
  return 'OvertimeMonthModel(month: $month, minutes: $minutes, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes)';
}


}

/// @nodoc
abstract mixin class _$OvertimeMonthModelCopyWith<$Res> implements $OvertimeMonthModelCopyWith<$Res> {
  factory _$OvertimeMonthModelCopyWith(_OvertimeMonthModel value, $Res Function(_OvertimeMonthModel) _then) = __$OvertimeMonthModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime month, int minutes, int? expectedMinutes, int? workedMinutes
});




}
/// @nodoc
class __$OvertimeMonthModelCopyWithImpl<$Res>
    implements _$OvertimeMonthModelCopyWith<$Res> {
  __$OvertimeMonthModelCopyWithImpl(this._self, this._then);

  final _OvertimeMonthModel _self;
  final $Res Function(_OvertimeMonthModel) _then;

/// Create a copy of OvertimeMonthModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? minutes = null,Object? expectedMinutes = freezed,Object? workedMinutes = freezed,}) {
  return _then(_OvertimeMonthModel(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,expectedMinutes: freezed == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$OvertimeDayModel {

@DateOnlyConverter() DateTime get date;@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind get dayKind; int get expectedMinutes; int get workedMinutes; int get overtimeMinutes;/// Expected minutes of a working day under this date's schedule (the
/// day basis, also on holidays and weekly offs where expected is 0).
 int get dayBasisMinutes;
/// Create a copy of OvertimeDayModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeDayModelCopyWith<OvertimeDayModel> get copyWith => _$OvertimeDayModelCopyWithImpl<OvertimeDayModel>(this as OvertimeDayModel, _$identity);

  /// Serializes this OvertimeDayModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeDayModel&&(identical(other.date, date) || other.date == date)&&(identical(other.dayKind, dayKind) || other.dayKind == dayKind)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes)&&(identical(other.dayBasisMinutes, dayBasisMinutes) || other.dayBasisMinutes == dayBasisMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,dayKind,expectedMinutes,workedMinutes,overtimeMinutes,dayBasisMinutes);

@override
String toString() {
  return 'OvertimeDayModel(date: $date, dayKind: $dayKind, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes, overtimeMinutes: $overtimeMinutes, dayBasisMinutes: $dayBasisMinutes)';
}


}

/// @nodoc
abstract mixin class $OvertimeDayModelCopyWith<$Res>  {
  factory $OvertimeDayModelCopyWith(OvertimeDayModel value, $Res Function(OvertimeDayModel) _then) = _$OvertimeDayModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date,@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind dayKind, int expectedMinutes, int workedMinutes, int overtimeMinutes, int dayBasisMinutes
});




}
/// @nodoc
class _$OvertimeDayModelCopyWithImpl<$Res>
    implements $OvertimeDayModelCopyWith<$Res> {
  _$OvertimeDayModelCopyWithImpl(this._self, this._then);

  final OvertimeDayModel _self;
  final $Res Function(OvertimeDayModel) _then;

/// Create a copy of OvertimeDayModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? dayKind = null,Object? expectedMinutes = null,Object? workedMinutes = null,Object? overtimeMinutes = null,Object? dayBasisMinutes = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dayKind: null == dayKind ? _self.dayKind : dayKind // ignore: cast_nullable_to_non_nullable
as AttendanceDayKind,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,workedMinutes: null == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int,overtimeMinutes: null == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int,dayBasisMinutes: null == dayBasisMinutes ? _self.dayBasisMinutes : dayBasisMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeDayModel].
extension OvertimeDayModelPatterns on OvertimeDayModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeDayModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeDayModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeDayModel value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeDayModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeDayModel value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeDayModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind,  int expectedMinutes,  int workedMinutes,  int overtimeMinutes,  int dayBasisMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeDayModel() when $default != null:
return $default(_that.date,_that.dayKind,_that.expectedMinutes,_that.workedMinutes,_that.overtimeMinutes,_that.dayBasisMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind,  int expectedMinutes,  int workedMinutes,  int overtimeMinutes,  int dayBasisMinutes)  $default,) {final _that = this;
switch (_that) {
case _OvertimeDayModel():
return $default(_that.date,_that.dayKind,_that.expectedMinutes,_that.workedMinutes,_that.overtimeMinutes,_that.dayBasisMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind,  int expectedMinutes,  int workedMinutes,  int overtimeMinutes,  int dayBasisMinutes)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeDayModel() when $default != null:
return $default(_that.date,_that.dayKind,_that.expectedMinutes,_that.workedMinutes,_that.overtimeMinutes,_that.dayBasisMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeDayModel implements OvertimeDayModel {
  const _OvertimeDayModel({@DateOnlyConverter() required this.date, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown) required this.dayKind, required this.expectedMinutes, required this.workedMinutes, required this.overtimeMinutes, required this.dayBasisMinutes});
  factory _OvertimeDayModel.fromJson(Map<String, dynamic> json) => _$OvertimeDayModelFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) final  AttendanceDayKind dayKind;
@override final  int expectedMinutes;
@override final  int workedMinutes;
@override final  int overtimeMinutes;
/// Expected minutes of a working day under this date's schedule (the
/// day basis, also on holidays and weekly offs where expected is 0).
@override final  int dayBasisMinutes;

/// Create a copy of OvertimeDayModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeDayModelCopyWith<_OvertimeDayModel> get copyWith => __$OvertimeDayModelCopyWithImpl<_OvertimeDayModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeDayModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeDayModel&&(identical(other.date, date) || other.date == date)&&(identical(other.dayKind, dayKind) || other.dayKind == dayKind)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes)&&(identical(other.dayBasisMinutes, dayBasisMinutes) || other.dayBasisMinutes == dayBasisMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,dayKind,expectedMinutes,workedMinutes,overtimeMinutes,dayBasisMinutes);

@override
String toString() {
  return 'OvertimeDayModel(date: $date, dayKind: $dayKind, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes, overtimeMinutes: $overtimeMinutes, dayBasisMinutes: $dayBasisMinutes)';
}


}

/// @nodoc
abstract mixin class _$OvertimeDayModelCopyWith<$Res> implements $OvertimeDayModelCopyWith<$Res> {
  factory _$OvertimeDayModelCopyWith(_OvertimeDayModel value, $Res Function(_OvertimeDayModel) _then) = __$OvertimeDayModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date,@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind dayKind, int expectedMinutes, int workedMinutes, int overtimeMinutes, int dayBasisMinutes
});




}
/// @nodoc
class __$OvertimeDayModelCopyWithImpl<$Res>
    implements _$OvertimeDayModelCopyWith<$Res> {
  __$OvertimeDayModelCopyWithImpl(this._self, this._then);

  final _OvertimeDayModel _self;
  final $Res Function(_OvertimeDayModel) _then;

/// Create a copy of OvertimeDayModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? dayKind = null,Object? expectedMinutes = null,Object? workedMinutes = null,Object? overtimeMinutes = null,Object? dayBasisMinutes = null,}) {
  return _then(_OvertimeDayModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dayKind: null == dayKind ? _self.dayKind : dayKind // ignore: cast_nullable_to_non_nullable
as AttendanceDayKind,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,workedMinutes: null == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int,overtimeMinutes: null == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int,dayBasisMinutes: null == dayBasisMinutes ? _self.dayBasisMinutes : dayBasisMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
