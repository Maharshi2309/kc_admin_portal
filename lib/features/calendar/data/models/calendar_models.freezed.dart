// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployeeCalendarModel {

@DateOnlyConverter() DateTime get month; List<CalendarDayModel> get days; CalendarSummaryModel get summary;
/// Create a copy of EmployeeCalendarModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeCalendarModelCopyWith<EmployeeCalendarModel> get copyWith => _$EmployeeCalendarModelCopyWithImpl<EmployeeCalendarModel>(this as EmployeeCalendarModel, _$identity);

  /// Serializes this EmployeeCalendarModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeCalendarModel&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,const DeepCollectionEquality().hash(days),summary);

@override
String toString() {
  return 'EmployeeCalendarModel(month: $month, days: $days, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $EmployeeCalendarModelCopyWith<$Res>  {
  factory $EmployeeCalendarModelCopyWith(EmployeeCalendarModel value, $Res Function(EmployeeCalendarModel) _then) = _$EmployeeCalendarModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime month, List<CalendarDayModel> days, CalendarSummaryModel summary
});


$CalendarSummaryModelCopyWith<$Res> get summary;

}
/// @nodoc
class _$EmployeeCalendarModelCopyWithImpl<$Res>
    implements $EmployeeCalendarModelCopyWith<$Res> {
  _$EmployeeCalendarModelCopyWithImpl(this._self, this._then);

  final EmployeeCalendarModel _self;
  final $Res Function(EmployeeCalendarModel) _then;

/// Create a copy of EmployeeCalendarModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? days = null,Object? summary = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<CalendarDayModel>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CalendarSummaryModel,
  ));
}
/// Create a copy of EmployeeCalendarModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarSummaryModelCopyWith<$Res> get summary {
  
  return $CalendarSummaryModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeCalendarModel].
extension EmployeeCalendarModelPatterns on EmployeeCalendarModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeCalendarModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeCalendarModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeCalendarModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeCalendarModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeCalendarModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeCalendarModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  List<CalendarDayModel> days,  CalendarSummaryModel summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeCalendarModel() when $default != null:
return $default(_that.month,_that.days,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  List<CalendarDayModel> days,  CalendarSummaryModel summary)  $default,) {final _that = this;
switch (_that) {
case _EmployeeCalendarModel():
return $default(_that.month,_that.days,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime month,  List<CalendarDayModel> days,  CalendarSummaryModel summary)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeCalendarModel() when $default != null:
return $default(_that.month,_that.days,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeCalendarModel implements EmployeeCalendarModel {
  const _EmployeeCalendarModel({@DateOnlyConverter() required this.month, required final  List<CalendarDayModel> days, required this.summary}): _days = days;
  factory _EmployeeCalendarModel.fromJson(Map<String, dynamic> json) => _$EmployeeCalendarModelFromJson(json);

@override@DateOnlyConverter() final  DateTime month;
 final  List<CalendarDayModel> _days;
@override List<CalendarDayModel> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  CalendarSummaryModel summary;

/// Create a copy of EmployeeCalendarModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeCalendarModelCopyWith<_EmployeeCalendarModel> get copyWith => __$EmployeeCalendarModelCopyWithImpl<_EmployeeCalendarModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeCalendarModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeCalendarModel&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,const DeepCollectionEquality().hash(_days),summary);

@override
String toString() {
  return 'EmployeeCalendarModel(month: $month, days: $days, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$EmployeeCalendarModelCopyWith<$Res> implements $EmployeeCalendarModelCopyWith<$Res> {
  factory _$EmployeeCalendarModelCopyWith(_EmployeeCalendarModel value, $Res Function(_EmployeeCalendarModel) _then) = __$EmployeeCalendarModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime month, List<CalendarDayModel> days, CalendarSummaryModel summary
});


@override $CalendarSummaryModelCopyWith<$Res> get summary;

}
/// @nodoc
class __$EmployeeCalendarModelCopyWithImpl<$Res>
    implements _$EmployeeCalendarModelCopyWith<$Res> {
  __$EmployeeCalendarModelCopyWithImpl(this._self, this._then);

  final _EmployeeCalendarModel _self;
  final $Res Function(_EmployeeCalendarModel) _then;

/// Create a copy of EmployeeCalendarModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? days = null,Object? summary = null,}) {
  return _then(_EmployeeCalendarModel(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<CalendarDayModel>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CalendarSummaryModel,
  ));
}

/// Create a copy of EmployeeCalendarModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarSummaryModelCopyWith<$Res> get summary {
  
  return $CalendarSummaryModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$CalendarDayModel {

@DateOnlyConverter() DateTime get date;@JsonKey(unknownEnumValue: CalendarDayType.unknown) CalendarDayType get dayType; String? get holidayName;/// The schedule on this date; null on holidays and weekly offs.
 ScheduleSnapshotModel? get schedule; CalendarAttendanceModel? get attendance;/// Leave touching this date, including pending and rejected requests.
 List<CalendarLeaveModel> get leaves; int get overtimeMinutes;
/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarDayModelCopyWith<CalendarDayModel> get copyWith => _$CalendarDayModelCopyWithImpl<CalendarDayModel>(this as CalendarDayModel, _$identity);

  /// Serializes this CalendarDayModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarDayModel&&(identical(other.date, date) || other.date == date)&&(identical(other.dayType, dayType) || other.dayType == dayType)&&(identical(other.holidayName, holidayName) || other.holidayName == holidayName)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&const DeepCollectionEquality().equals(other.leaves, leaves)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,dayType,holidayName,schedule,attendance,const DeepCollectionEquality().hash(leaves),overtimeMinutes);

@override
String toString() {
  return 'CalendarDayModel(date: $date, dayType: $dayType, holidayName: $holidayName, schedule: $schedule, attendance: $attendance, leaves: $leaves, overtimeMinutes: $overtimeMinutes)';
}


}

/// @nodoc
abstract mixin class $CalendarDayModelCopyWith<$Res>  {
  factory $CalendarDayModelCopyWith(CalendarDayModel value, $Res Function(CalendarDayModel) _then) = _$CalendarDayModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date,@JsonKey(unknownEnumValue: CalendarDayType.unknown) CalendarDayType dayType, String? holidayName, ScheduleSnapshotModel? schedule, CalendarAttendanceModel? attendance, List<CalendarLeaveModel> leaves, int overtimeMinutes
});


$ScheduleSnapshotModelCopyWith<$Res>? get schedule;$CalendarAttendanceModelCopyWith<$Res>? get attendance;

}
/// @nodoc
class _$CalendarDayModelCopyWithImpl<$Res>
    implements $CalendarDayModelCopyWith<$Res> {
  _$CalendarDayModelCopyWithImpl(this._self, this._then);

  final CalendarDayModel _self;
  final $Res Function(CalendarDayModel) _then;

/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? dayType = null,Object? holidayName = freezed,Object? schedule = freezed,Object? attendance = freezed,Object? leaves = null,Object? overtimeMinutes = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dayType: null == dayType ? _self.dayType : dayType // ignore: cast_nullable_to_non_nullable
as CalendarDayType,holidayName: freezed == holidayName ? _self.holidayName : holidayName // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleSnapshotModel?,attendance: freezed == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as CalendarAttendanceModel?,leaves: null == leaves ? _self.leaves : leaves // ignore: cast_nullable_to_non_nullable
as List<CalendarLeaveModel>,overtimeMinutes: null == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleSnapshotModelCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ScheduleSnapshotModelCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarAttendanceModelCopyWith<$Res>? get attendance {
    if (_self.attendance == null) {
    return null;
  }

  return $CalendarAttendanceModelCopyWith<$Res>(_self.attendance!, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarDayModel].
extension CalendarDayModelPatterns on CalendarDayModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarDayModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarDayModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarDayModel value)  $default,){
final _that = this;
switch (_that) {
case _CalendarDayModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarDayModel value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarDayModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date, @JsonKey(unknownEnumValue: CalendarDayType.unknown)  CalendarDayType dayType,  String? holidayName,  ScheduleSnapshotModel? schedule,  CalendarAttendanceModel? attendance,  List<CalendarLeaveModel> leaves,  int overtimeMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarDayModel() when $default != null:
return $default(_that.date,_that.dayType,_that.holidayName,_that.schedule,_that.attendance,_that.leaves,_that.overtimeMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date, @JsonKey(unknownEnumValue: CalendarDayType.unknown)  CalendarDayType dayType,  String? holidayName,  ScheduleSnapshotModel? schedule,  CalendarAttendanceModel? attendance,  List<CalendarLeaveModel> leaves,  int overtimeMinutes)  $default,) {final _that = this;
switch (_that) {
case _CalendarDayModel():
return $default(_that.date,_that.dayType,_that.holidayName,_that.schedule,_that.attendance,_that.leaves,_that.overtimeMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date, @JsonKey(unknownEnumValue: CalendarDayType.unknown)  CalendarDayType dayType,  String? holidayName,  ScheduleSnapshotModel? schedule,  CalendarAttendanceModel? attendance,  List<CalendarLeaveModel> leaves,  int overtimeMinutes)?  $default,) {final _that = this;
switch (_that) {
case _CalendarDayModel() when $default != null:
return $default(_that.date,_that.dayType,_that.holidayName,_that.schedule,_that.attendance,_that.leaves,_that.overtimeMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarDayModel implements CalendarDayModel {
  const _CalendarDayModel({@DateOnlyConverter() required this.date, @JsonKey(unknownEnumValue: CalendarDayType.unknown) required this.dayType, this.holidayName, this.schedule, this.attendance, final  List<CalendarLeaveModel> leaves = const <CalendarLeaveModel>[], this.overtimeMinutes = 0}): _leaves = leaves;
  factory _CalendarDayModel.fromJson(Map<String, dynamic> json) => _$CalendarDayModelFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override@JsonKey(unknownEnumValue: CalendarDayType.unknown) final  CalendarDayType dayType;
@override final  String? holidayName;
/// The schedule on this date; null on holidays and weekly offs.
@override final  ScheduleSnapshotModel? schedule;
@override final  CalendarAttendanceModel? attendance;
/// Leave touching this date, including pending and rejected requests.
 final  List<CalendarLeaveModel> _leaves;
/// Leave touching this date, including pending and rejected requests.
@override@JsonKey() List<CalendarLeaveModel> get leaves {
  if (_leaves is EqualUnmodifiableListView) return _leaves;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaves);
}

@override@JsonKey() final  int overtimeMinutes;

/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarDayModelCopyWith<_CalendarDayModel> get copyWith => __$CalendarDayModelCopyWithImpl<_CalendarDayModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarDayModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarDayModel&&(identical(other.date, date) || other.date == date)&&(identical(other.dayType, dayType) || other.dayType == dayType)&&(identical(other.holidayName, holidayName) || other.holidayName == holidayName)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&const DeepCollectionEquality().equals(other._leaves, _leaves)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,dayType,holidayName,schedule,attendance,const DeepCollectionEquality().hash(_leaves),overtimeMinutes);

@override
String toString() {
  return 'CalendarDayModel(date: $date, dayType: $dayType, holidayName: $holidayName, schedule: $schedule, attendance: $attendance, leaves: $leaves, overtimeMinutes: $overtimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$CalendarDayModelCopyWith<$Res> implements $CalendarDayModelCopyWith<$Res> {
  factory _$CalendarDayModelCopyWith(_CalendarDayModel value, $Res Function(_CalendarDayModel) _then) = __$CalendarDayModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date,@JsonKey(unknownEnumValue: CalendarDayType.unknown) CalendarDayType dayType, String? holidayName, ScheduleSnapshotModel? schedule, CalendarAttendanceModel? attendance, List<CalendarLeaveModel> leaves, int overtimeMinutes
});


@override $ScheduleSnapshotModelCopyWith<$Res>? get schedule;@override $CalendarAttendanceModelCopyWith<$Res>? get attendance;

}
/// @nodoc
class __$CalendarDayModelCopyWithImpl<$Res>
    implements _$CalendarDayModelCopyWith<$Res> {
  __$CalendarDayModelCopyWithImpl(this._self, this._then);

  final _CalendarDayModel _self;
  final $Res Function(_CalendarDayModel) _then;

/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? dayType = null,Object? holidayName = freezed,Object? schedule = freezed,Object? attendance = freezed,Object? leaves = null,Object? overtimeMinutes = null,}) {
  return _then(_CalendarDayModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dayType: null == dayType ? _self.dayType : dayType // ignore: cast_nullable_to_non_nullable
as CalendarDayType,holidayName: freezed == holidayName ? _self.holidayName : holidayName // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleSnapshotModel?,attendance: freezed == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as CalendarAttendanceModel?,leaves: null == leaves ? _self._leaves : leaves // ignore: cast_nullable_to_non_nullable
as List<CalendarLeaveModel>,overtimeMinutes: null == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleSnapshotModelCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ScheduleSnapshotModelCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of CalendarDayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarAttendanceModelCopyWith<$Res>? get attendance {
    if (_self.attendance == null) {
    return null;
  }

  return $CalendarAttendanceModelCopyWith<$Res>(_self.attendance!, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}
}


/// @nodoc
mixin _$CalendarAttendanceModel {

/// Null when nothing is recorded (an absence on a working day).
@JsonKey(fromJson: _optionalId) String? get id;@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus get status;@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind get dayKind;@CompanyDateTimeConverter() DateTime? get punchIn;@CompanyDateTimeConverter() DateTime? get punchOut; int? get workedMinutes; bool get corrected;
/// Create a copy of CalendarAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarAttendanceModelCopyWith<CalendarAttendanceModel> get copyWith => _$CalendarAttendanceModelCopyWithImpl<CalendarAttendanceModel>(this as CalendarAttendanceModel, _$identity);

  /// Serializes this CalendarAttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarAttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.dayKind, dayKind) || other.dayKind == dayKind)&&(identical(other.punchIn, punchIn) || other.punchIn == punchIn)&&(identical(other.punchOut, punchOut) || other.punchOut == punchOut)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.corrected, corrected) || other.corrected == corrected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,dayKind,punchIn,punchOut,workedMinutes,corrected);

@override
String toString() {
  return 'CalendarAttendanceModel(id: $id, status: $status, dayKind: $dayKind, punchIn: $punchIn, punchOut: $punchOut, workedMinutes: $workedMinutes, corrected: $corrected)';
}


}

/// @nodoc
abstract mixin class $CalendarAttendanceModelCopyWith<$Res>  {
  factory $CalendarAttendanceModelCopyWith(CalendarAttendanceModel value, $Res Function(CalendarAttendanceModel) _then) = _$CalendarAttendanceModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _optionalId) String? id,@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus status,@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind dayKind,@CompanyDateTimeConverter() DateTime? punchIn,@CompanyDateTimeConverter() DateTime? punchOut, int? workedMinutes, bool corrected
});




}
/// @nodoc
class _$CalendarAttendanceModelCopyWithImpl<$Res>
    implements $CalendarAttendanceModelCopyWith<$Res> {
  _$CalendarAttendanceModelCopyWithImpl(this._self, this._then);

  final CalendarAttendanceModel _self;
  final $Res Function(CalendarAttendanceModel) _then;

/// Create a copy of CalendarAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? status = null,Object? dayKind = null,Object? punchIn = freezed,Object? punchOut = freezed,Object? workedMinutes = freezed,Object? corrected = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceDayStatus,dayKind: null == dayKind ? _self.dayKind : dayKind // ignore: cast_nullable_to_non_nullable
as AttendanceDayKind,punchIn: freezed == punchIn ? _self.punchIn : punchIn // ignore: cast_nullable_to_non_nullable
as DateTime?,punchOut: freezed == punchOut ? _self.punchOut : punchOut // ignore: cast_nullable_to_non_nullable
as DateTime?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarAttendanceModel].
extension CalendarAttendanceModelPatterns on CalendarAttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarAttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarAttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _CalendarAttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarAttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _optionalId)  String? id, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus status, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind, @CompanyDateTimeConverter()  DateTime? punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  int? workedMinutes,  bool corrected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarAttendanceModel() when $default != null:
return $default(_that.id,_that.status,_that.dayKind,_that.punchIn,_that.punchOut,_that.workedMinutes,_that.corrected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _optionalId)  String? id, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus status, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind, @CompanyDateTimeConverter()  DateTime? punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  int? workedMinutes,  bool corrected)  $default,) {final _that = this;
switch (_that) {
case _CalendarAttendanceModel():
return $default(_that.id,_that.status,_that.dayKind,_that.punchIn,_that.punchOut,_that.workedMinutes,_that.corrected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _optionalId)  String? id, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus status, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind, @CompanyDateTimeConverter()  DateTime? punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  int? workedMinutes,  bool corrected)?  $default,) {final _that = this;
switch (_that) {
case _CalendarAttendanceModel() when $default != null:
return $default(_that.id,_that.status,_that.dayKind,_that.punchIn,_that.punchOut,_that.workedMinutes,_that.corrected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarAttendanceModel implements CalendarAttendanceModel {
  const _CalendarAttendanceModel({@JsonKey(fromJson: _optionalId) this.id, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) required this.status, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown) this.dayKind = AttendanceDayKind.working, @CompanyDateTimeConverter() this.punchIn, @CompanyDateTimeConverter() this.punchOut, this.workedMinutes, this.corrected = false});
  factory _CalendarAttendanceModel.fromJson(Map<String, dynamic> json) => _$CalendarAttendanceModelFromJson(json);

/// Null when nothing is recorded (an absence on a working day).
@override@JsonKey(fromJson: _optionalId) final  String? id;
@override@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) final  AttendanceDayStatus status;
@override@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) final  AttendanceDayKind dayKind;
@override@CompanyDateTimeConverter() final  DateTime? punchIn;
@override@CompanyDateTimeConverter() final  DateTime? punchOut;
@override final  int? workedMinutes;
@override@JsonKey() final  bool corrected;

/// Create a copy of CalendarAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarAttendanceModelCopyWith<_CalendarAttendanceModel> get copyWith => __$CalendarAttendanceModelCopyWithImpl<_CalendarAttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarAttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarAttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.dayKind, dayKind) || other.dayKind == dayKind)&&(identical(other.punchIn, punchIn) || other.punchIn == punchIn)&&(identical(other.punchOut, punchOut) || other.punchOut == punchOut)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.corrected, corrected) || other.corrected == corrected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,dayKind,punchIn,punchOut,workedMinutes,corrected);

@override
String toString() {
  return 'CalendarAttendanceModel(id: $id, status: $status, dayKind: $dayKind, punchIn: $punchIn, punchOut: $punchOut, workedMinutes: $workedMinutes, corrected: $corrected)';
}


}

/// @nodoc
abstract mixin class _$CalendarAttendanceModelCopyWith<$Res> implements $CalendarAttendanceModelCopyWith<$Res> {
  factory _$CalendarAttendanceModelCopyWith(_CalendarAttendanceModel value, $Res Function(_CalendarAttendanceModel) _then) = __$CalendarAttendanceModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _optionalId) String? id,@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus status,@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind dayKind,@CompanyDateTimeConverter() DateTime? punchIn,@CompanyDateTimeConverter() DateTime? punchOut, int? workedMinutes, bool corrected
});




}
/// @nodoc
class __$CalendarAttendanceModelCopyWithImpl<$Res>
    implements _$CalendarAttendanceModelCopyWith<$Res> {
  __$CalendarAttendanceModelCopyWithImpl(this._self, this._then);

  final _CalendarAttendanceModel _self;
  final $Res Function(_CalendarAttendanceModel) _then;

/// Create a copy of CalendarAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? status = null,Object? dayKind = null,Object? punchIn = freezed,Object? punchOut = freezed,Object? workedMinutes = freezed,Object? corrected = null,}) {
  return _then(_CalendarAttendanceModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceDayStatus,dayKind: null == dayKind ? _self.dayKind : dayKind // ignore: cast_nullable_to_non_nullable
as AttendanceDayKind,punchIn: freezed == punchIn ? _self.punchIn : punchIn // ignore: cast_nullable_to_non_nullable
as DateTime?,punchOut: freezed == punchOut ? _self.punchOut : punchOut // ignore: cast_nullable_to_non_nullable
as DateTime?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CalendarLeaveModel {

@JsonKey(fromJson: idFromJson) String get id; NamedRef get leaveType;@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus get status; bool get isHalfDay;
/// Create a copy of CalendarLeaveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarLeaveModelCopyWith<CalendarLeaveModel> get copyWith => _$CalendarLeaveModelCopyWithImpl<CalendarLeaveModel>(this as CalendarLeaveModel, _$identity);

  /// Serializes this CalendarLeaveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarLeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leaveType,status,isHalfDay);

@override
String toString() {
  return 'CalendarLeaveModel(id: $id, leaveType: $leaveType, status: $status, isHalfDay: $isHalfDay)';
}


}

/// @nodoc
abstract mixin class $CalendarLeaveModelCopyWith<$Res>  {
  factory $CalendarLeaveModelCopyWith(CalendarLeaveModel value, $Res Function(CalendarLeaveModel) _then) = _$CalendarLeaveModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, NamedRef leaveType,@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus status, bool isHalfDay
});


$NamedRefCopyWith<$Res> get leaveType;

}
/// @nodoc
class _$CalendarLeaveModelCopyWithImpl<$Res>
    implements $CalendarLeaveModelCopyWith<$Res> {
  _$CalendarLeaveModelCopyWithImpl(this._self, this._then);

  final CalendarLeaveModel _self;
  final $Res Function(CalendarLeaveModel) _then;

/// Create a copy of CalendarLeaveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leaveType = null,Object? status = null,Object? isHalfDay = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as NamedRef,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CalendarLeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get leaveType {
  
  return $NamedRefCopyWith<$Res>(_self.leaveType, (value) {
    return _then(_self.copyWith(leaveType: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarLeaveModel].
extension CalendarLeaveModelPatterns on CalendarLeaveModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarLeaveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarLeaveModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarLeaveModel value)  $default,){
final _that = this;
switch (_that) {
case _CalendarLeaveModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarLeaveModel value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarLeaveModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  NamedRef leaveType, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  bool isHalfDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarLeaveModel() when $default != null:
return $default(_that.id,_that.leaveType,_that.status,_that.isHalfDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  NamedRef leaveType, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  bool isHalfDay)  $default,) {final _that = this;
switch (_that) {
case _CalendarLeaveModel():
return $default(_that.id,_that.leaveType,_that.status,_that.isHalfDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  NamedRef leaveType, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  bool isHalfDay)?  $default,) {final _that = this;
switch (_that) {
case _CalendarLeaveModel() when $default != null:
return $default(_that.id,_that.leaveType,_that.status,_that.isHalfDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarLeaveModel implements CalendarLeaveModel {
  const _CalendarLeaveModel({@JsonKey(fromJson: idFromJson) required this.id, required this.leaveType, @JsonKey(unknownEnumValue: LeaveStatus.unknown) required this.status, this.isHalfDay = false});
  factory _CalendarLeaveModel.fromJson(Map<String, dynamic> json) => _$CalendarLeaveModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  NamedRef leaveType;
@override@JsonKey(unknownEnumValue: LeaveStatus.unknown) final  LeaveStatus status;
@override@JsonKey() final  bool isHalfDay;

/// Create a copy of CalendarLeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarLeaveModelCopyWith<_CalendarLeaveModel> get copyWith => __$CalendarLeaveModelCopyWithImpl<_CalendarLeaveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarLeaveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarLeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leaveType,status,isHalfDay);

@override
String toString() {
  return 'CalendarLeaveModel(id: $id, leaveType: $leaveType, status: $status, isHalfDay: $isHalfDay)';
}


}

/// @nodoc
abstract mixin class _$CalendarLeaveModelCopyWith<$Res> implements $CalendarLeaveModelCopyWith<$Res> {
  factory _$CalendarLeaveModelCopyWith(_CalendarLeaveModel value, $Res Function(_CalendarLeaveModel) _then) = __$CalendarLeaveModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, NamedRef leaveType,@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus status, bool isHalfDay
});


@override $NamedRefCopyWith<$Res> get leaveType;

}
/// @nodoc
class __$CalendarLeaveModelCopyWithImpl<$Res>
    implements _$CalendarLeaveModelCopyWith<$Res> {
  __$CalendarLeaveModelCopyWithImpl(this._self, this._then);

  final _CalendarLeaveModel _self;
  final $Res Function(_CalendarLeaveModel) _then;

/// Create a copy of CalendarLeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leaveType = null,Object? status = null,Object? isHalfDay = null,}) {
  return _then(_CalendarLeaveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as NamedRef,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CalendarLeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get leaveType {
  
  return $NamedRefCopyWith<$Res>(_self.leaveType, (value) {
    return _then(_self.copyWith(leaveType: value));
  });
}
}


/// @nodoc
mixin _$CalendarSummaryModel {

 int get workingDays; int get present; int get absent; double get leaveDays; int get holidays; int get weekOffs; int get holidayWorked; int get weekOffWorked; int get expectedMinutes; int get workedMinutes; int get overtimeMinutes;
/// Create a copy of CalendarSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarSummaryModelCopyWith<CalendarSummaryModel> get copyWith => _$CalendarSummaryModelCopyWithImpl<CalendarSummaryModel>(this as CalendarSummaryModel, _$identity);

  /// Serializes this CalendarSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarSummaryModel&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.present, present) || other.present == present)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.leaveDays, leaveDays) || other.leaveDays == leaveDays)&&(identical(other.holidays, holidays) || other.holidays == holidays)&&(identical(other.weekOffs, weekOffs) || other.weekOffs == weekOffs)&&(identical(other.holidayWorked, holidayWorked) || other.holidayWorked == holidayWorked)&&(identical(other.weekOffWorked, weekOffWorked) || other.weekOffWorked == weekOffWorked)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workingDays,present,absent,leaveDays,holidays,weekOffs,holidayWorked,weekOffWorked,expectedMinutes,workedMinutes,overtimeMinutes);

@override
String toString() {
  return 'CalendarSummaryModel(workingDays: $workingDays, present: $present, absent: $absent, leaveDays: $leaveDays, holidays: $holidays, weekOffs: $weekOffs, holidayWorked: $holidayWorked, weekOffWorked: $weekOffWorked, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes, overtimeMinutes: $overtimeMinutes)';
}


}

/// @nodoc
abstract mixin class $CalendarSummaryModelCopyWith<$Res>  {
  factory $CalendarSummaryModelCopyWith(CalendarSummaryModel value, $Res Function(CalendarSummaryModel) _then) = _$CalendarSummaryModelCopyWithImpl;
@useResult
$Res call({
 int workingDays, int present, int absent, double leaveDays, int holidays, int weekOffs, int holidayWorked, int weekOffWorked, int expectedMinutes, int workedMinutes, int overtimeMinutes
});




}
/// @nodoc
class _$CalendarSummaryModelCopyWithImpl<$Res>
    implements $CalendarSummaryModelCopyWith<$Res> {
  _$CalendarSummaryModelCopyWithImpl(this._self, this._then);

  final CalendarSummaryModel _self;
  final $Res Function(CalendarSummaryModel) _then;

/// Create a copy of CalendarSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workingDays = null,Object? present = null,Object? absent = null,Object? leaveDays = null,Object? holidays = null,Object? weekOffs = null,Object? holidayWorked = null,Object? weekOffWorked = null,Object? expectedMinutes = null,Object? workedMinutes = null,Object? overtimeMinutes = null,}) {
  return _then(_self.copyWith(
workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as int,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,leaveDays: null == leaveDays ? _self.leaveDays : leaveDays // ignore: cast_nullable_to_non_nullable
as double,holidays: null == holidays ? _self.holidays : holidays // ignore: cast_nullable_to_non_nullable
as int,weekOffs: null == weekOffs ? _self.weekOffs : weekOffs // ignore: cast_nullable_to_non_nullable
as int,holidayWorked: null == holidayWorked ? _self.holidayWorked : holidayWorked // ignore: cast_nullable_to_non_nullable
as int,weekOffWorked: null == weekOffWorked ? _self.weekOffWorked : weekOffWorked // ignore: cast_nullable_to_non_nullable
as int,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,workedMinutes: null == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int,overtimeMinutes: null == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarSummaryModel].
extension CalendarSummaryModelPatterns on CalendarSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _CalendarSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int workingDays,  int present,  int absent,  double leaveDays,  int holidays,  int weekOffs,  int holidayWorked,  int weekOffWorked,  int expectedMinutes,  int workedMinutes,  int overtimeMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarSummaryModel() when $default != null:
return $default(_that.workingDays,_that.present,_that.absent,_that.leaveDays,_that.holidays,_that.weekOffs,_that.holidayWorked,_that.weekOffWorked,_that.expectedMinutes,_that.workedMinutes,_that.overtimeMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int workingDays,  int present,  int absent,  double leaveDays,  int holidays,  int weekOffs,  int holidayWorked,  int weekOffWorked,  int expectedMinutes,  int workedMinutes,  int overtimeMinutes)  $default,) {final _that = this;
switch (_that) {
case _CalendarSummaryModel():
return $default(_that.workingDays,_that.present,_that.absent,_that.leaveDays,_that.holidays,_that.weekOffs,_that.holidayWorked,_that.weekOffWorked,_that.expectedMinutes,_that.workedMinutes,_that.overtimeMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int workingDays,  int present,  int absent,  double leaveDays,  int holidays,  int weekOffs,  int holidayWorked,  int weekOffWorked,  int expectedMinutes,  int workedMinutes,  int overtimeMinutes)?  $default,) {final _that = this;
switch (_that) {
case _CalendarSummaryModel() when $default != null:
return $default(_that.workingDays,_that.present,_that.absent,_that.leaveDays,_that.holidays,_that.weekOffs,_that.holidayWorked,_that.weekOffWorked,_that.expectedMinutes,_that.workedMinutes,_that.overtimeMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarSummaryModel implements CalendarSummaryModel {
  const _CalendarSummaryModel({required this.workingDays, required this.present, required this.absent, required this.leaveDays, required this.holidays, required this.weekOffs, required this.holidayWorked, required this.weekOffWorked, required this.expectedMinutes, required this.workedMinutes, required this.overtimeMinutes});
  factory _CalendarSummaryModel.fromJson(Map<String, dynamic> json) => _$CalendarSummaryModelFromJson(json);

@override final  int workingDays;
@override final  int present;
@override final  int absent;
@override final  double leaveDays;
@override final  int holidays;
@override final  int weekOffs;
@override final  int holidayWorked;
@override final  int weekOffWorked;
@override final  int expectedMinutes;
@override final  int workedMinutes;
@override final  int overtimeMinutes;

/// Create a copy of CalendarSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarSummaryModelCopyWith<_CalendarSummaryModel> get copyWith => __$CalendarSummaryModelCopyWithImpl<_CalendarSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarSummaryModel&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.present, present) || other.present == present)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.leaveDays, leaveDays) || other.leaveDays == leaveDays)&&(identical(other.holidays, holidays) || other.holidays == holidays)&&(identical(other.weekOffs, weekOffs) || other.weekOffs == weekOffs)&&(identical(other.holidayWorked, holidayWorked) || other.holidayWorked == holidayWorked)&&(identical(other.weekOffWorked, weekOffWorked) || other.weekOffWorked == weekOffWorked)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workingDays,present,absent,leaveDays,holidays,weekOffs,holidayWorked,weekOffWorked,expectedMinutes,workedMinutes,overtimeMinutes);

@override
String toString() {
  return 'CalendarSummaryModel(workingDays: $workingDays, present: $present, absent: $absent, leaveDays: $leaveDays, holidays: $holidays, weekOffs: $weekOffs, holidayWorked: $holidayWorked, weekOffWorked: $weekOffWorked, expectedMinutes: $expectedMinutes, workedMinutes: $workedMinutes, overtimeMinutes: $overtimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$CalendarSummaryModelCopyWith<$Res> implements $CalendarSummaryModelCopyWith<$Res> {
  factory _$CalendarSummaryModelCopyWith(_CalendarSummaryModel value, $Res Function(_CalendarSummaryModel) _then) = __$CalendarSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 int workingDays, int present, int absent, double leaveDays, int holidays, int weekOffs, int holidayWorked, int weekOffWorked, int expectedMinutes, int workedMinutes, int overtimeMinutes
});




}
/// @nodoc
class __$CalendarSummaryModelCopyWithImpl<$Res>
    implements _$CalendarSummaryModelCopyWith<$Res> {
  __$CalendarSummaryModelCopyWithImpl(this._self, this._then);

  final _CalendarSummaryModel _self;
  final $Res Function(_CalendarSummaryModel) _then;

/// Create a copy of CalendarSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workingDays = null,Object? present = null,Object? absent = null,Object? leaveDays = null,Object? holidays = null,Object? weekOffs = null,Object? holidayWorked = null,Object? weekOffWorked = null,Object? expectedMinutes = null,Object? workedMinutes = null,Object? overtimeMinutes = null,}) {
  return _then(_CalendarSummaryModel(
workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as int,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,leaveDays: null == leaveDays ? _self.leaveDays : leaveDays // ignore: cast_nullable_to_non_nullable
as double,holidays: null == holidays ? _self.holidays : holidays // ignore: cast_nullable_to_non_nullable
as int,weekOffs: null == weekOffs ? _self.weekOffs : weekOffs // ignore: cast_nullable_to_non_nullable
as int,holidayWorked: null == holidayWorked ? _self.holidayWorked : holidayWorked // ignore: cast_nullable_to_non_nullable
as int,weekOffWorked: null == weekOffWorked ? _self.weekOffWorked : weekOffWorked // ignore: cast_nullable_to_non_nullable
as int,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,workedMinutes: null == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int,overtimeMinutes: null == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CalendarDayDetailModel {

 CalendarDayModel get day;/// Changes to this employee's records on this date, newest first.
 List<AuditEntryModel> get history;
/// Create a copy of CalendarDayDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarDayDetailModelCopyWith<CalendarDayDetailModel> get copyWith => _$CalendarDayDetailModelCopyWithImpl<CalendarDayDetailModel>(this as CalendarDayDetailModel, _$identity);

  /// Serializes this CalendarDayDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarDayDetailModel&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'CalendarDayDetailModel(day: $day, history: $history)';
}


}

/// @nodoc
abstract mixin class $CalendarDayDetailModelCopyWith<$Res>  {
  factory $CalendarDayDetailModelCopyWith(CalendarDayDetailModel value, $Res Function(CalendarDayDetailModel) _then) = _$CalendarDayDetailModelCopyWithImpl;
@useResult
$Res call({
 CalendarDayModel day, List<AuditEntryModel> history
});


$CalendarDayModelCopyWith<$Res> get day;

}
/// @nodoc
class _$CalendarDayDetailModelCopyWithImpl<$Res>
    implements $CalendarDayDetailModelCopyWith<$Res> {
  _$CalendarDayDetailModelCopyWithImpl(this._self, this._then);

  final CalendarDayDetailModel _self;
  final $Res Function(CalendarDayDetailModel) _then;

/// Create a copy of CalendarDayDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? history = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as CalendarDayModel,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<AuditEntryModel>,
  ));
}
/// Create a copy of CalendarDayDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarDayModelCopyWith<$Res> get day {
  
  return $CalendarDayModelCopyWith<$Res>(_self.day, (value) {
    return _then(_self.copyWith(day: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarDayDetailModel].
extension CalendarDayDetailModelPatterns on CalendarDayDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarDayDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarDayDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarDayDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _CalendarDayDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarDayDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarDayDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDayModel day,  List<AuditEntryModel> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarDayDetailModel() when $default != null:
return $default(_that.day,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDayModel day,  List<AuditEntryModel> history)  $default,) {final _that = this;
switch (_that) {
case _CalendarDayDetailModel():
return $default(_that.day,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDayModel day,  List<AuditEntryModel> history)?  $default,) {final _that = this;
switch (_that) {
case _CalendarDayDetailModel() when $default != null:
return $default(_that.day,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarDayDetailModel implements CalendarDayDetailModel {
  const _CalendarDayDetailModel({required this.day, final  List<AuditEntryModel> history = const <AuditEntryModel>[]}): _history = history;
  factory _CalendarDayDetailModel.fromJson(Map<String, dynamic> json) => _$CalendarDayDetailModelFromJson(json);

@override final  CalendarDayModel day;
/// Changes to this employee's records on this date, newest first.
 final  List<AuditEntryModel> _history;
/// Changes to this employee's records on this date, newest first.
@override@JsonKey() List<AuditEntryModel> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of CalendarDayDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarDayDetailModelCopyWith<_CalendarDayDetailModel> get copyWith => __$CalendarDayDetailModelCopyWithImpl<_CalendarDayDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarDayDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarDayDetailModel&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'CalendarDayDetailModel(day: $day, history: $history)';
}


}

/// @nodoc
abstract mixin class _$CalendarDayDetailModelCopyWith<$Res> implements $CalendarDayDetailModelCopyWith<$Res> {
  factory _$CalendarDayDetailModelCopyWith(_CalendarDayDetailModel value, $Res Function(_CalendarDayDetailModel) _then) = __$CalendarDayDetailModelCopyWithImpl;
@override @useResult
$Res call({
 CalendarDayModel day, List<AuditEntryModel> history
});


@override $CalendarDayModelCopyWith<$Res> get day;

}
/// @nodoc
class __$CalendarDayDetailModelCopyWithImpl<$Res>
    implements _$CalendarDayDetailModelCopyWith<$Res> {
  __$CalendarDayDetailModelCopyWithImpl(this._self, this._then);

  final _CalendarDayDetailModel _self;
  final $Res Function(_CalendarDayDetailModel) _then;

/// Create a copy of CalendarDayDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? history = null,}) {
  return _then(_CalendarDayDetailModel(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as CalendarDayModel,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<AuditEntryModel>,
  ));
}

/// Create a copy of CalendarDayDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarDayModelCopyWith<$Res> get day {
  
  return $CalendarDayModelCopyWith<$Res>(_self.day, (value) {
    return _then(_self.copyWith(day: value));
  });
}
}

// dart format on
