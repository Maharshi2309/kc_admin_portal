// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceRecordModel {

/// `null` when nothing is recorded yet (not punched in).
@JsonKey(fromJson: _optionalId) String? get id; EmployeeSummaryModel get employee;@DateOnlyConverter() DateTime get date;@CompanyDateTimeConverter() DateTime? get punchIn;@CompanyDateTimeConverter() DateTime? get punchOut; int? get workedMinutes;/// Share of the shift worked, 0–100, for the progress bar.
 double? get workedPercent;@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus get status;/// Short explanation from the backend, e.g. "Leave 2nd half". Never a
/// duration: those come as numbers (e.g. [lateMinutes]) and are
/// formatted by the app.
 String? get note;/// How late the punch-in was, after the grace period's start time; null
/// when on time.
 int? get lateMinutes; String? get correctedBy;@CompanyDateTimeConverter() DateTime? get correctedAt;/// Work on a holiday or weekly off is recorded as its own kind.
@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind get dayKind;/// The employee's schedule on [date]; null on holidays and weekly offs.
 ScheduleSnapshotModel? get schedule;/// 0 on holidays and weekly offs; halved on half-day leave.
 int? get expectedMinutes; int? get overtimeMinutes;
/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordModelCopyWith<AttendanceRecordModel> get copyWith => _$AttendanceRecordModelCopyWithImpl<AttendanceRecordModel>(this as AttendanceRecordModel, _$identity);

  /// Serializes this AttendanceRecordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.date, date) || other.date == date)&&(identical(other.punchIn, punchIn) || other.punchIn == punchIn)&&(identical(other.punchOut, punchOut) || other.punchOut == punchOut)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.workedPercent, workedPercent) || other.workedPercent == workedPercent)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.lateMinutes, lateMinutes) || other.lateMinutes == lateMinutes)&&(identical(other.correctedBy, correctedBy) || other.correctedBy == correctedBy)&&(identical(other.correctedAt, correctedAt) || other.correctedAt == correctedAt)&&(identical(other.dayKind, dayKind) || other.dayKind == dayKind)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employee,date,punchIn,punchOut,workedMinutes,workedPercent,status,note,lateMinutes,correctedBy,correctedAt,dayKind,schedule,expectedMinutes,overtimeMinutes);

@override
String toString() {
  return 'AttendanceRecordModel(id: $id, employee: $employee, date: $date, punchIn: $punchIn, punchOut: $punchOut, workedMinutes: $workedMinutes, workedPercent: $workedPercent, status: $status, note: $note, lateMinutes: $lateMinutes, correctedBy: $correctedBy, correctedAt: $correctedAt, dayKind: $dayKind, schedule: $schedule, expectedMinutes: $expectedMinutes, overtimeMinutes: $overtimeMinutes)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordModelCopyWith<$Res>  {
  factory $AttendanceRecordModelCopyWith(AttendanceRecordModel value, $Res Function(AttendanceRecordModel) _then) = _$AttendanceRecordModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _optionalId) String? id, EmployeeSummaryModel employee,@DateOnlyConverter() DateTime date,@CompanyDateTimeConverter() DateTime? punchIn,@CompanyDateTimeConverter() DateTime? punchOut, int? workedMinutes, double? workedPercent,@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus status, String? note, int? lateMinutes, String? correctedBy,@CompanyDateTimeConverter() DateTime? correctedAt,@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind dayKind, ScheduleSnapshotModel? schedule, int? expectedMinutes, int? overtimeMinutes
});


$EmployeeSummaryModelCopyWith<$Res> get employee;$ScheduleSnapshotModelCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$AttendanceRecordModelCopyWithImpl<$Res>
    implements $AttendanceRecordModelCopyWith<$Res> {
  _$AttendanceRecordModelCopyWithImpl(this._self, this._then);

  final AttendanceRecordModel _self;
  final $Res Function(AttendanceRecordModel) _then;

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? employee = null,Object? date = null,Object? punchIn = freezed,Object? punchOut = freezed,Object? workedMinutes = freezed,Object? workedPercent = freezed,Object? status = null,Object? note = freezed,Object? lateMinutes = freezed,Object? correctedBy = freezed,Object? correctedAt = freezed,Object? dayKind = null,Object? schedule = freezed,Object? expectedMinutes = freezed,Object? overtimeMinutes = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,punchIn: freezed == punchIn ? _self.punchIn : punchIn // ignore: cast_nullable_to_non_nullable
as DateTime?,punchOut: freezed == punchOut ? _self.punchOut : punchOut // ignore: cast_nullable_to_non_nullable
as DateTime?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,workedPercent: freezed == workedPercent ? _self.workedPercent : workedPercent // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceDayStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lateMinutes: freezed == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int?,correctedBy: freezed == correctedBy ? _self.correctedBy : correctedBy // ignore: cast_nullable_to_non_nullable
as String?,correctedAt: freezed == correctedAt ? _self.correctedAt : correctedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dayKind: null == dayKind ? _self.dayKind : dayKind // ignore: cast_nullable_to_non_nullable
as AttendanceDayKind,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleSnapshotModel?,expectedMinutes: freezed == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int?,overtimeMinutes: freezed == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}/// Create a copy of AttendanceRecordModel
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
}
}


/// Adds pattern-matching-related methods to [AttendanceRecordModel].
extension AttendanceRecordModelPatterns on AttendanceRecordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecordModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecordModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _optionalId)  String? id,  EmployeeSummaryModel employee, @DateOnlyConverter()  DateTime date, @CompanyDateTimeConverter()  DateTime? punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  int? workedMinutes,  double? workedPercent, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus status,  String? note,  int? lateMinutes,  String? correctedBy, @CompanyDateTimeConverter()  DateTime? correctedAt, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind,  ScheduleSnapshotModel? schedule,  int? expectedMinutes,  int? overtimeMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
return $default(_that.id,_that.employee,_that.date,_that.punchIn,_that.punchOut,_that.workedMinutes,_that.workedPercent,_that.status,_that.note,_that.lateMinutes,_that.correctedBy,_that.correctedAt,_that.dayKind,_that.schedule,_that.expectedMinutes,_that.overtimeMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _optionalId)  String? id,  EmployeeSummaryModel employee, @DateOnlyConverter()  DateTime date, @CompanyDateTimeConverter()  DateTime? punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  int? workedMinutes,  double? workedPercent, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus status,  String? note,  int? lateMinutes,  String? correctedBy, @CompanyDateTimeConverter()  DateTime? correctedAt, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind,  ScheduleSnapshotModel? schedule,  int? expectedMinutes,  int? overtimeMinutes)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecordModel():
return $default(_that.id,_that.employee,_that.date,_that.punchIn,_that.punchOut,_that.workedMinutes,_that.workedPercent,_that.status,_that.note,_that.lateMinutes,_that.correctedBy,_that.correctedAt,_that.dayKind,_that.schedule,_that.expectedMinutes,_that.overtimeMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _optionalId)  String? id,  EmployeeSummaryModel employee, @DateOnlyConverter()  DateTime date, @CompanyDateTimeConverter()  DateTime? punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  int? workedMinutes,  double? workedPercent, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus status,  String? note,  int? lateMinutes,  String? correctedBy, @CompanyDateTimeConverter()  DateTime? correctedAt, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)  AttendanceDayKind dayKind,  ScheduleSnapshotModel? schedule,  int? expectedMinutes,  int? overtimeMinutes)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
return $default(_that.id,_that.employee,_that.date,_that.punchIn,_that.punchOut,_that.workedMinutes,_that.workedPercent,_that.status,_that.note,_that.lateMinutes,_that.correctedBy,_that.correctedAt,_that.dayKind,_that.schedule,_that.expectedMinutes,_that.overtimeMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceRecordModel extends AttendanceRecordModel {
  const _AttendanceRecordModel({@JsonKey(fromJson: _optionalId) this.id, required this.employee, @DateOnlyConverter() required this.date, @CompanyDateTimeConverter() this.punchIn, @CompanyDateTimeConverter() this.punchOut, this.workedMinutes, this.workedPercent, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) required this.status, this.note, this.lateMinutes, this.correctedBy, @CompanyDateTimeConverter() this.correctedAt, @JsonKey(unknownEnumValue: AttendanceDayKind.unknown) this.dayKind = AttendanceDayKind.working, this.schedule, this.expectedMinutes, this.overtimeMinutes}): super._();
  factory _AttendanceRecordModel.fromJson(Map<String, dynamic> json) => _$AttendanceRecordModelFromJson(json);

/// `null` when nothing is recorded yet (not punched in).
@override@JsonKey(fromJson: _optionalId) final  String? id;
@override final  EmployeeSummaryModel employee;
@override@DateOnlyConverter() final  DateTime date;
@override@CompanyDateTimeConverter() final  DateTime? punchIn;
@override@CompanyDateTimeConverter() final  DateTime? punchOut;
@override final  int? workedMinutes;
/// Share of the shift worked, 0–100, for the progress bar.
@override final  double? workedPercent;
@override@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) final  AttendanceDayStatus status;
/// Short explanation from the backend, e.g. "Leave 2nd half". Never a
/// duration: those come as numbers (e.g. [lateMinutes]) and are
/// formatted by the app.
@override final  String? note;
/// How late the punch-in was, after the grace period's start time; null
/// when on time.
@override final  int? lateMinutes;
@override final  String? correctedBy;
@override@CompanyDateTimeConverter() final  DateTime? correctedAt;
/// Work on a holiday or weekly off is recorded as its own kind.
@override@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) final  AttendanceDayKind dayKind;
/// The employee's schedule on [date]; null on holidays and weekly offs.
@override final  ScheduleSnapshotModel? schedule;
/// 0 on holidays and weekly offs; halved on half-day leave.
@override final  int? expectedMinutes;
@override final  int? overtimeMinutes;

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordModelCopyWith<_AttendanceRecordModel> get copyWith => __$AttendanceRecordModelCopyWithImpl<_AttendanceRecordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceRecordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.date, date) || other.date == date)&&(identical(other.punchIn, punchIn) || other.punchIn == punchIn)&&(identical(other.punchOut, punchOut) || other.punchOut == punchOut)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.workedPercent, workedPercent) || other.workedPercent == workedPercent)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.lateMinutes, lateMinutes) || other.lateMinutes == lateMinutes)&&(identical(other.correctedBy, correctedBy) || other.correctedBy == correctedBy)&&(identical(other.correctedAt, correctedAt) || other.correctedAt == correctedAt)&&(identical(other.dayKind, dayKind) || other.dayKind == dayKind)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.overtimeMinutes, overtimeMinutes) || other.overtimeMinutes == overtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employee,date,punchIn,punchOut,workedMinutes,workedPercent,status,note,lateMinutes,correctedBy,correctedAt,dayKind,schedule,expectedMinutes,overtimeMinutes);

@override
String toString() {
  return 'AttendanceRecordModel(id: $id, employee: $employee, date: $date, punchIn: $punchIn, punchOut: $punchOut, workedMinutes: $workedMinutes, workedPercent: $workedPercent, status: $status, note: $note, lateMinutes: $lateMinutes, correctedBy: $correctedBy, correctedAt: $correctedAt, dayKind: $dayKind, schedule: $schedule, expectedMinutes: $expectedMinutes, overtimeMinutes: $overtimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordModelCopyWith<$Res> implements $AttendanceRecordModelCopyWith<$Res> {
  factory _$AttendanceRecordModelCopyWith(_AttendanceRecordModel value, $Res Function(_AttendanceRecordModel) _then) = __$AttendanceRecordModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _optionalId) String? id, EmployeeSummaryModel employee,@DateOnlyConverter() DateTime date,@CompanyDateTimeConverter() DateTime? punchIn,@CompanyDateTimeConverter() DateTime? punchOut, int? workedMinutes, double? workedPercent,@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus status, String? note, int? lateMinutes, String? correctedBy,@CompanyDateTimeConverter() DateTime? correctedAt,@JsonKey(unknownEnumValue: AttendanceDayKind.unknown) AttendanceDayKind dayKind, ScheduleSnapshotModel? schedule, int? expectedMinutes, int? overtimeMinutes
});


@override $EmployeeSummaryModelCopyWith<$Res> get employee;@override $ScheduleSnapshotModelCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$AttendanceRecordModelCopyWithImpl<$Res>
    implements _$AttendanceRecordModelCopyWith<$Res> {
  __$AttendanceRecordModelCopyWithImpl(this._self, this._then);

  final _AttendanceRecordModel _self;
  final $Res Function(_AttendanceRecordModel) _then;

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? employee = null,Object? date = null,Object? punchIn = freezed,Object? punchOut = freezed,Object? workedMinutes = freezed,Object? workedPercent = freezed,Object? status = null,Object? note = freezed,Object? lateMinutes = freezed,Object? correctedBy = freezed,Object? correctedAt = freezed,Object? dayKind = null,Object? schedule = freezed,Object? expectedMinutes = freezed,Object? overtimeMinutes = freezed,}) {
  return _then(_AttendanceRecordModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,punchIn: freezed == punchIn ? _self.punchIn : punchIn // ignore: cast_nullable_to_non_nullable
as DateTime?,punchOut: freezed == punchOut ? _self.punchOut : punchOut // ignore: cast_nullable_to_non_nullable
as DateTime?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,workedPercent: freezed == workedPercent ? _self.workedPercent : workedPercent // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceDayStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lateMinutes: freezed == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int?,correctedBy: freezed == correctedBy ? _self.correctedBy : correctedBy // ignore: cast_nullable_to_non_nullable
as String?,correctedAt: freezed == correctedAt ? _self.correctedAt : correctedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dayKind: null == dayKind ? _self.dayKind : dayKind // ignore: cast_nullable_to_non_nullable
as AttendanceDayKind,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleSnapshotModel?,expectedMinutes: freezed == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int?,overtimeMinutes: freezed == overtimeMinutes ? _self.overtimeMinutes : overtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}/// Create a copy of AttendanceRecordModel
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
}
}


/// @nodoc
mixin _$AttendanceDaySummaryModel {

@DateOnlyConverter() DateTime get date;/// "09:30"; shown only when the backend sends it.
 String? get shiftStart; String? get shiftEnd; int get totalEmployees; int get present; int get late; int get onLeave; int get absent;/// Active employees with no punch-in yet (for the reminder banner).
 int get notPunchedIn;
/// Create a copy of AttendanceDaySummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDaySummaryModelCopyWith<AttendanceDaySummaryModel> get copyWith => _$AttendanceDaySummaryModelCopyWithImpl<AttendanceDaySummaryModel>(this as AttendanceDaySummaryModel, _$identity);

  /// Serializes this AttendanceDaySummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDaySummaryModel&&(identical(other.date, date) || other.date == date)&&(identical(other.shiftStart, shiftStart) || other.shiftStart == shiftStart)&&(identical(other.shiftEnd, shiftEnd) || other.shiftEnd == shiftEnd)&&(identical(other.totalEmployees, totalEmployees) || other.totalEmployees == totalEmployees)&&(identical(other.present, present) || other.present == present)&&(identical(other.late, late) || other.late == late)&&(identical(other.onLeave, onLeave) || other.onLeave == onLeave)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.notPunchedIn, notPunchedIn) || other.notPunchedIn == notPunchedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,shiftStart,shiftEnd,totalEmployees,present,late,onLeave,absent,notPunchedIn);

@override
String toString() {
  return 'AttendanceDaySummaryModel(date: $date, shiftStart: $shiftStart, shiftEnd: $shiftEnd, totalEmployees: $totalEmployees, present: $present, late: $late, onLeave: $onLeave, absent: $absent, notPunchedIn: $notPunchedIn)';
}


}

/// @nodoc
abstract mixin class $AttendanceDaySummaryModelCopyWith<$Res>  {
  factory $AttendanceDaySummaryModelCopyWith(AttendanceDaySummaryModel value, $Res Function(AttendanceDaySummaryModel) _then) = _$AttendanceDaySummaryModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, String? shiftStart, String? shiftEnd, int totalEmployees, int present, int late, int onLeave, int absent, int notPunchedIn
});




}
/// @nodoc
class _$AttendanceDaySummaryModelCopyWithImpl<$Res>
    implements $AttendanceDaySummaryModelCopyWith<$Res> {
  _$AttendanceDaySummaryModelCopyWithImpl(this._self, this._then);

  final AttendanceDaySummaryModel _self;
  final $Res Function(AttendanceDaySummaryModel) _then;

/// Create a copy of AttendanceDaySummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? shiftStart = freezed,Object? shiftEnd = freezed,Object? totalEmployees = null,Object? present = null,Object? late = null,Object? onLeave = null,Object? absent = null,Object? notPunchedIn = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,shiftStart: freezed == shiftStart ? _self.shiftStart : shiftStart // ignore: cast_nullable_to_non_nullable
as String?,shiftEnd: freezed == shiftEnd ? _self.shiftEnd : shiftEnd // ignore: cast_nullable_to_non_nullable
as String?,totalEmployees: null == totalEmployees ? _self.totalEmployees : totalEmployees // ignore: cast_nullable_to_non_nullable
as int,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,onLeave: null == onLeave ? _self.onLeave : onLeave // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,notPunchedIn: null == notPunchedIn ? _self.notPunchedIn : notPunchedIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceDaySummaryModel].
extension AttendanceDaySummaryModelPatterns on AttendanceDaySummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDaySummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDaySummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDaySummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDaySummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDaySummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDaySummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  String? shiftStart,  String? shiftEnd,  int totalEmployees,  int present,  int late,  int onLeave,  int absent,  int notPunchedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDaySummaryModel() when $default != null:
return $default(_that.date,_that.shiftStart,_that.shiftEnd,_that.totalEmployees,_that.present,_that.late,_that.onLeave,_that.absent,_that.notPunchedIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  String? shiftStart,  String? shiftEnd,  int totalEmployees,  int present,  int late,  int onLeave,  int absent,  int notPunchedIn)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDaySummaryModel():
return $default(_that.date,_that.shiftStart,_that.shiftEnd,_that.totalEmployees,_that.present,_that.late,_that.onLeave,_that.absent,_that.notPunchedIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  String? shiftStart,  String? shiftEnd,  int totalEmployees,  int present,  int late,  int onLeave,  int absent,  int notPunchedIn)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDaySummaryModel() when $default != null:
return $default(_that.date,_that.shiftStart,_that.shiftEnd,_that.totalEmployees,_that.present,_that.late,_that.onLeave,_that.absent,_that.notPunchedIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceDaySummaryModel implements AttendanceDaySummaryModel {
  const _AttendanceDaySummaryModel({@DateOnlyConverter() required this.date, this.shiftStart, this.shiftEnd, required this.totalEmployees, required this.present, required this.late, required this.onLeave, required this.absent, required this.notPunchedIn});
  factory _AttendanceDaySummaryModel.fromJson(Map<String, dynamic> json) => _$AttendanceDaySummaryModelFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
/// "09:30"; shown only when the backend sends it.
@override final  String? shiftStart;
@override final  String? shiftEnd;
@override final  int totalEmployees;
@override final  int present;
@override final  int late;
@override final  int onLeave;
@override final  int absent;
/// Active employees with no punch-in yet (for the reminder banner).
@override final  int notPunchedIn;

/// Create a copy of AttendanceDaySummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDaySummaryModelCopyWith<_AttendanceDaySummaryModel> get copyWith => __$AttendanceDaySummaryModelCopyWithImpl<_AttendanceDaySummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceDaySummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDaySummaryModel&&(identical(other.date, date) || other.date == date)&&(identical(other.shiftStart, shiftStart) || other.shiftStart == shiftStart)&&(identical(other.shiftEnd, shiftEnd) || other.shiftEnd == shiftEnd)&&(identical(other.totalEmployees, totalEmployees) || other.totalEmployees == totalEmployees)&&(identical(other.present, present) || other.present == present)&&(identical(other.late, late) || other.late == late)&&(identical(other.onLeave, onLeave) || other.onLeave == onLeave)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.notPunchedIn, notPunchedIn) || other.notPunchedIn == notPunchedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,shiftStart,shiftEnd,totalEmployees,present,late,onLeave,absent,notPunchedIn);

@override
String toString() {
  return 'AttendanceDaySummaryModel(date: $date, shiftStart: $shiftStart, shiftEnd: $shiftEnd, totalEmployees: $totalEmployees, present: $present, late: $late, onLeave: $onLeave, absent: $absent, notPunchedIn: $notPunchedIn)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDaySummaryModelCopyWith<$Res> implements $AttendanceDaySummaryModelCopyWith<$Res> {
  factory _$AttendanceDaySummaryModelCopyWith(_AttendanceDaySummaryModel value, $Res Function(_AttendanceDaySummaryModel) _then) = __$AttendanceDaySummaryModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, String? shiftStart, String? shiftEnd, int totalEmployees, int present, int late, int onLeave, int absent, int notPunchedIn
});




}
/// @nodoc
class __$AttendanceDaySummaryModelCopyWithImpl<$Res>
    implements _$AttendanceDaySummaryModelCopyWith<$Res> {
  __$AttendanceDaySummaryModelCopyWithImpl(this._self, this._then);

  final _AttendanceDaySummaryModel _self;
  final $Res Function(_AttendanceDaySummaryModel) _then;

/// Create a copy of AttendanceDaySummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? shiftStart = freezed,Object? shiftEnd = freezed,Object? totalEmployees = null,Object? present = null,Object? late = null,Object? onLeave = null,Object? absent = null,Object? notPunchedIn = null,}) {
  return _then(_AttendanceDaySummaryModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,shiftStart: freezed == shiftStart ? _self.shiftStart : shiftStart // ignore: cast_nullable_to_non_nullable
as String?,shiftEnd: freezed == shiftEnd ? _self.shiftEnd : shiftEnd // ignore: cast_nullable_to_non_nullable
as String?,totalEmployees: null == totalEmployees ? _self.totalEmployees : totalEmployees // ignore: cast_nullable_to_non_nullable
as int,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,onLeave: null == onLeave ? _self.onLeave : onLeave // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,notPunchedIn: null == notPunchedIn ? _self.notPunchedIn : notPunchedIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AttendanceDayModel {

 AttendanceDaySummaryModel get summary; List<AttendanceRecordModel> get items; int get total; int get page; int get pageSize;
/// Create a copy of AttendanceDayModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDayModelCopyWith<AttendanceDayModel> get copyWith => _$AttendanceDayModelCopyWithImpl<AttendanceDayModel>(this as AttendanceDayModel, _$identity);

  /// Serializes this AttendanceDayModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDayModel&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(items),total,page,pageSize);

@override
String toString() {
  return 'AttendanceDayModel(summary: $summary, items: $items, total: $total, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $AttendanceDayModelCopyWith<$Res>  {
  factory $AttendanceDayModelCopyWith(AttendanceDayModel value, $Res Function(AttendanceDayModel) _then) = _$AttendanceDayModelCopyWithImpl;
@useResult
$Res call({
 AttendanceDaySummaryModel summary, List<AttendanceRecordModel> items, int total, int page, int pageSize
});


$AttendanceDaySummaryModelCopyWith<$Res> get summary;

}
/// @nodoc
class _$AttendanceDayModelCopyWithImpl<$Res>
    implements $AttendanceDayModelCopyWith<$Res> {
  _$AttendanceDayModelCopyWithImpl(this._self, this._then);

  final AttendanceDayModel _self;
  final $Res Function(AttendanceDayModel) _then;

/// Create a copy of AttendanceDayModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AttendanceDaySummaryModel,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecordModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AttendanceDayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceDaySummaryModelCopyWith<$Res> get summary {
  
  return $AttendanceDaySummaryModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendanceDayModel].
extension AttendanceDayModelPatterns on AttendanceDayModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDayModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDayModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDayModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDayModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDayModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDayModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttendanceDaySummaryModel summary,  List<AttendanceRecordModel> items,  int total,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDayModel() when $default != null:
return $default(_that.summary,_that.items,_that.total,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttendanceDaySummaryModel summary,  List<AttendanceRecordModel> items,  int total,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDayModel():
return $default(_that.summary,_that.items,_that.total,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttendanceDaySummaryModel summary,  List<AttendanceRecordModel> items,  int total,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDayModel() when $default != null:
return $default(_that.summary,_that.items,_that.total,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceDayModel extends AttendanceDayModel {
  const _AttendanceDayModel({required this.summary, required final  List<AttendanceRecordModel> items, required this.total, required this.page, required this.pageSize}): _items = items,super._();
  factory _AttendanceDayModel.fromJson(Map<String, dynamic> json) => _$AttendanceDayModelFromJson(json);

@override final  AttendanceDaySummaryModel summary;
 final  List<AttendanceRecordModel> _items;
@override List<AttendanceRecordModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  int page;
@override final  int pageSize;

/// Create a copy of AttendanceDayModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDayModelCopyWith<_AttendanceDayModel> get copyWith => __$AttendanceDayModelCopyWithImpl<_AttendanceDayModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceDayModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDayModel&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_items),total,page,pageSize);

@override
String toString() {
  return 'AttendanceDayModel(summary: $summary, items: $items, total: $total, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDayModelCopyWith<$Res> implements $AttendanceDayModelCopyWith<$Res> {
  factory _$AttendanceDayModelCopyWith(_AttendanceDayModel value, $Res Function(_AttendanceDayModel) _then) = __$AttendanceDayModelCopyWithImpl;
@override @useResult
$Res call({
 AttendanceDaySummaryModel summary, List<AttendanceRecordModel> items, int total, int page, int pageSize
});


@override $AttendanceDaySummaryModelCopyWith<$Res> get summary;

}
/// @nodoc
class __$AttendanceDayModelCopyWithImpl<$Res>
    implements _$AttendanceDayModelCopyWith<$Res> {
  __$AttendanceDayModelCopyWithImpl(this._self, this._then);

  final _AttendanceDayModel _self;
  final $Res Function(_AttendanceDayModel) _then;

/// Create a copy of AttendanceDayModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_AttendanceDayModel(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AttendanceDaySummaryModel,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecordModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AttendanceDayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceDaySummaryModelCopyWith<$Res> get summary {
  
  return $AttendanceDaySummaryModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$AttendanceQuery {

@DateOnlyConverter() DateTime get date; AttendanceFilter get filter; String get search; JobRole? get department;
/// Create a copy of AttendanceQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceQueryCopyWith<AttendanceQuery> get copyWith => _$AttendanceQueryCopyWithImpl<AttendanceQuery>(this as AttendanceQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceQuery&&(identical(other.date, date) || other.date == date)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.search, search) || other.search == search)&&(identical(other.department, department) || other.department == department));
}


@override
int get hashCode => Object.hash(runtimeType,date,filter,search,department);

@override
String toString() {
  return 'AttendanceQuery(date: $date, filter: $filter, search: $search, department: $department)';
}


}

/// @nodoc
abstract mixin class $AttendanceQueryCopyWith<$Res>  {
  factory $AttendanceQueryCopyWith(AttendanceQuery value, $Res Function(AttendanceQuery) _then) = _$AttendanceQueryCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, AttendanceFilter filter, String search, JobRole? department
});




}
/// @nodoc
class _$AttendanceQueryCopyWithImpl<$Res>
    implements $AttendanceQueryCopyWith<$Res> {
  _$AttendanceQueryCopyWithImpl(this._self, this._then);

  final AttendanceQuery _self;
  final $Res Function(AttendanceQuery) _then;

/// Create a copy of AttendanceQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? filter = null,Object? search = null,Object? department = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as AttendanceFilter,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as JobRole?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceQuery].
extension AttendanceQueryPatterns on AttendanceQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceQuery value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceQuery value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  AttendanceFilter filter,  String search,  JobRole? department)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceQuery() when $default != null:
return $default(_that.date,_that.filter,_that.search,_that.department);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  AttendanceFilter filter,  String search,  JobRole? department)  $default,) {final _that = this;
switch (_that) {
case _AttendanceQuery():
return $default(_that.date,_that.filter,_that.search,_that.department);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  AttendanceFilter filter,  String search,  JobRole? department)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceQuery() when $default != null:
return $default(_that.date,_that.filter,_that.search,_that.department);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceQuery extends AttendanceQuery {
  const _AttendanceQuery({@DateOnlyConverter() required this.date, this.filter = AttendanceFilter.all, this.search = '', this.department}): super._();
  

@override@DateOnlyConverter() final  DateTime date;
@override@JsonKey() final  AttendanceFilter filter;
@override@JsonKey() final  String search;
@override final  JobRole? department;

/// Create a copy of AttendanceQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceQueryCopyWith<_AttendanceQuery> get copyWith => __$AttendanceQueryCopyWithImpl<_AttendanceQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceQuery&&(identical(other.date, date) || other.date == date)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.search, search) || other.search == search)&&(identical(other.department, department) || other.department == department));
}


@override
int get hashCode => Object.hash(runtimeType,date,filter,search,department);

@override
String toString() {
  return 'AttendanceQuery(date: $date, filter: $filter, search: $search, department: $department)';
}


}

/// @nodoc
abstract mixin class _$AttendanceQueryCopyWith<$Res> implements $AttendanceQueryCopyWith<$Res> {
  factory _$AttendanceQueryCopyWith(_AttendanceQuery value, $Res Function(_AttendanceQuery) _then) = __$AttendanceQueryCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, AttendanceFilter filter, String search, JobRole? department
});




}
/// @nodoc
class __$AttendanceQueryCopyWithImpl<$Res>
    implements _$AttendanceQueryCopyWith<$Res> {
  __$AttendanceQueryCopyWithImpl(this._self, this._then);

  final _AttendanceQuery _self;
  final $Res Function(_AttendanceQuery) _then;

/// Create a copy of AttendanceQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? filter = null,Object? search = null,Object? department = freezed,}) {
  return _then(_AttendanceQuery(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as AttendanceFilter,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as JobRole?,
  ));
}


}


/// @nodoc
mixin _$AttendanceCorrectionData {

/// Only for a new record.
 String? get employeeId;@JsonKey(toJson: dateToJson)@DateOnlyConverter() DateTime get date;@CompanyDateTimeConverter() DateTime get punchIn;@CompanyDateTimeConverter() DateTime? get punchOut; CorrectionReason get reason; String? get remarks;
/// Create a copy of AttendanceCorrectionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceCorrectionDataCopyWith<AttendanceCorrectionData> get copyWith => _$AttendanceCorrectionDataCopyWithImpl<AttendanceCorrectionData>(this as AttendanceCorrectionData, _$identity);

  /// Serializes this AttendanceCorrectionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceCorrectionData&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.date, date) || other.date == date)&&(identical(other.punchIn, punchIn) || other.punchIn == punchIn)&&(identical(other.punchOut, punchOut) || other.punchOut == punchOut)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,date,punchIn,punchOut,reason,remarks);

@override
String toString() {
  return 'AttendanceCorrectionData(employeeId: $employeeId, date: $date, punchIn: $punchIn, punchOut: $punchOut, reason: $reason, remarks: $remarks)';
}


}

/// @nodoc
abstract mixin class $AttendanceCorrectionDataCopyWith<$Res>  {
  factory $AttendanceCorrectionDataCopyWith(AttendanceCorrectionData value, $Res Function(AttendanceCorrectionData) _then) = _$AttendanceCorrectionDataCopyWithImpl;
@useResult
$Res call({
 String? employeeId,@JsonKey(toJson: dateToJson)@DateOnlyConverter() DateTime date,@CompanyDateTimeConverter() DateTime punchIn,@CompanyDateTimeConverter() DateTime? punchOut, CorrectionReason reason, String? remarks
});




}
/// @nodoc
class _$AttendanceCorrectionDataCopyWithImpl<$Res>
    implements $AttendanceCorrectionDataCopyWith<$Res> {
  _$AttendanceCorrectionDataCopyWithImpl(this._self, this._then);

  final AttendanceCorrectionData _self;
  final $Res Function(AttendanceCorrectionData) _then;

/// Create a copy of AttendanceCorrectionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeId = freezed,Object? date = null,Object? punchIn = null,Object? punchOut = freezed,Object? reason = null,Object? remarks = freezed,}) {
  return _then(_self.copyWith(
employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,punchIn: null == punchIn ? _self.punchIn : punchIn // ignore: cast_nullable_to_non_nullable
as DateTime,punchOut: freezed == punchOut ? _self.punchOut : punchOut // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as CorrectionReason,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceCorrectionData].
extension AttendanceCorrectionDataPatterns on AttendanceCorrectionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceCorrectionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceCorrectionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceCorrectionData value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceCorrectionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceCorrectionData value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceCorrectionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? employeeId, @JsonKey(toJson: dateToJson)@DateOnlyConverter()  DateTime date, @CompanyDateTimeConverter()  DateTime punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  CorrectionReason reason,  String? remarks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceCorrectionData() when $default != null:
return $default(_that.employeeId,_that.date,_that.punchIn,_that.punchOut,_that.reason,_that.remarks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? employeeId, @JsonKey(toJson: dateToJson)@DateOnlyConverter()  DateTime date, @CompanyDateTimeConverter()  DateTime punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  CorrectionReason reason,  String? remarks)  $default,) {final _that = this;
switch (_that) {
case _AttendanceCorrectionData():
return $default(_that.employeeId,_that.date,_that.punchIn,_that.punchOut,_that.reason,_that.remarks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? employeeId, @JsonKey(toJson: dateToJson)@DateOnlyConverter()  DateTime date, @CompanyDateTimeConverter()  DateTime punchIn, @CompanyDateTimeConverter()  DateTime? punchOut,  CorrectionReason reason,  String? remarks)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceCorrectionData() when $default != null:
return $default(_that.employeeId,_that.date,_that.punchIn,_that.punchOut,_that.reason,_that.remarks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceCorrectionData implements AttendanceCorrectionData {
  const _AttendanceCorrectionData({this.employeeId, @JsonKey(toJson: dateToJson)@DateOnlyConverter() required this.date, @CompanyDateTimeConverter() required this.punchIn, @CompanyDateTimeConverter() this.punchOut, required this.reason, this.remarks});
  factory _AttendanceCorrectionData.fromJson(Map<String, dynamic> json) => _$AttendanceCorrectionDataFromJson(json);

/// Only for a new record.
@override final  String? employeeId;
@override@JsonKey(toJson: dateToJson)@DateOnlyConverter() final  DateTime date;
@override@CompanyDateTimeConverter() final  DateTime punchIn;
@override@CompanyDateTimeConverter() final  DateTime? punchOut;
@override final  CorrectionReason reason;
@override final  String? remarks;

/// Create a copy of AttendanceCorrectionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceCorrectionDataCopyWith<_AttendanceCorrectionData> get copyWith => __$AttendanceCorrectionDataCopyWithImpl<_AttendanceCorrectionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceCorrectionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceCorrectionData&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.date, date) || other.date == date)&&(identical(other.punchIn, punchIn) || other.punchIn == punchIn)&&(identical(other.punchOut, punchOut) || other.punchOut == punchOut)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,date,punchIn,punchOut,reason,remarks);

@override
String toString() {
  return 'AttendanceCorrectionData(employeeId: $employeeId, date: $date, punchIn: $punchIn, punchOut: $punchOut, reason: $reason, remarks: $remarks)';
}


}

/// @nodoc
abstract mixin class _$AttendanceCorrectionDataCopyWith<$Res> implements $AttendanceCorrectionDataCopyWith<$Res> {
  factory _$AttendanceCorrectionDataCopyWith(_AttendanceCorrectionData value, $Res Function(_AttendanceCorrectionData) _then) = __$AttendanceCorrectionDataCopyWithImpl;
@override @useResult
$Res call({
 String? employeeId,@JsonKey(toJson: dateToJson)@DateOnlyConverter() DateTime date,@CompanyDateTimeConverter() DateTime punchIn,@CompanyDateTimeConverter() DateTime? punchOut, CorrectionReason reason, String? remarks
});




}
/// @nodoc
class __$AttendanceCorrectionDataCopyWithImpl<$Res>
    implements _$AttendanceCorrectionDataCopyWith<$Res> {
  __$AttendanceCorrectionDataCopyWithImpl(this._self, this._then);

  final _AttendanceCorrectionData _self;
  final $Res Function(_AttendanceCorrectionData) _then;

/// Create a copy of AttendanceCorrectionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeId = freezed,Object? date = null,Object? punchIn = null,Object? punchOut = freezed,Object? reason = null,Object? remarks = freezed,}) {
  return _then(_AttendanceCorrectionData(
employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,punchIn: null == punchIn ? _self.punchIn : punchIn // ignore: cast_nullable_to_non_nullable
as DateTime,punchOut: freezed == punchOut ? _self.punchOut : punchOut // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as CorrectionReason,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
