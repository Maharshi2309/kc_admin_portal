// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployeeModel {

@JsonKey(fromJson: idFromJson) String get id;/// The organization's prefix followed by digits, e.g. "KC1001".
 String get ecNumber; String get name;/// 10 digits without the country code, e.g. "9825011234".
 String get mobile;/// The organization's own department and position (2026-10-06).
 NamedRef get department; NamedRef get position;@DateOnlyConverter() DateTime get joiningDate;@JsonKey(unknownEnumValue: EmployeeStatus.unknown) EmployeeStatus get status;/// Today's attendance, when the list endpoint includes it.
@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus? get todayStatus;@CompanyDateTimeConverter() DateTime? get updatedAt; String? get updatedBy;/// The schedule in effect today (history: `GET /employees/{id}/schedules`).
 WorkScheduleModel? get schedule;/// Overtime from 1 January of the current year (company time) to today,
/// in minutes, calculated by the backend from the attendance records.
/// Null when the caller lacks `overtime.view`, or from an older backend.
 int? get overtimeMinutesThisYear;
/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeModelCopyWith<EmployeeModel> get copyWith => _$EmployeeModelCopyWithImpl<EmployeeModel>(this as EmployeeModel, _$identity);

  /// Serializes this EmployeeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.department, department) || other.department == department)&&(identical(other.position, position) || other.position == position)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.todayStatus, todayStatus) || other.todayStatus == todayStatus)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.overtimeMinutesThisYear, overtimeMinutesThisYear) || other.overtimeMinutesThisYear == overtimeMinutesThisYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ecNumber,name,mobile,department,position,joiningDate,status,todayStatus,updatedAt,updatedBy,schedule,overtimeMinutesThisYear);

@override
String toString() {
  return 'EmployeeModel(id: $id, ecNumber: $ecNumber, name: $name, mobile: $mobile, department: $department, position: $position, joiningDate: $joiningDate, status: $status, todayStatus: $todayStatus, updatedAt: $updatedAt, updatedBy: $updatedBy, schedule: $schedule, overtimeMinutesThisYear: $overtimeMinutesThisYear)';
}


}

/// @nodoc
abstract mixin class $EmployeeModelCopyWith<$Res>  {
  factory $EmployeeModelCopyWith(EmployeeModel value, $Res Function(EmployeeModel) _then) = _$EmployeeModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String ecNumber, String name, String mobile, NamedRef department, NamedRef position,@DateOnlyConverter() DateTime joiningDate,@JsonKey(unknownEnumValue: EmployeeStatus.unknown) EmployeeStatus status,@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus? todayStatus,@CompanyDateTimeConverter() DateTime? updatedAt, String? updatedBy, WorkScheduleModel? schedule, int? overtimeMinutesThisYear
});


$NamedRefCopyWith<$Res> get department;$NamedRefCopyWith<$Res> get position;$WorkScheduleModelCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$EmployeeModelCopyWithImpl<$Res>
    implements $EmployeeModelCopyWith<$Res> {
  _$EmployeeModelCopyWithImpl(this._self, this._then);

  final EmployeeModel _self;
  final $Res Function(EmployeeModel) _then;

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ecNumber = null,Object? name = null,Object? mobile = null,Object? department = null,Object? position = null,Object? joiningDate = null,Object? status = null,Object? todayStatus = freezed,Object? updatedAt = freezed,Object? updatedBy = freezed,Object? schedule = freezed,Object? overtimeMinutesThisYear = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ecNumber: null == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as NamedRef,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as NamedRef,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmployeeStatus,todayStatus: freezed == todayStatus ? _self.todayStatus : todayStatus // ignore: cast_nullable_to_non_nullable
as AttendanceDayStatus?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as WorkScheduleModel?,overtimeMinutesThisYear: freezed == overtimeMinutesThisYear ? _self.overtimeMinutesThisYear : overtimeMinutesThisYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get department {
  
  return $NamedRefCopyWith<$Res>(_self.department, (value) {
    return _then(_self.copyWith(department: value));
  });
}/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get position {
  
  return $NamedRefCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkScheduleModelCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $WorkScheduleModelCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeModel].
extension EmployeeModelPatterns on EmployeeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String ecNumber,  String name,  String mobile,  NamedRef department,  NamedRef position, @DateOnlyConverter()  DateTime joiningDate, @JsonKey(unknownEnumValue: EmployeeStatus.unknown)  EmployeeStatus status, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus? todayStatus, @CompanyDateTimeConverter()  DateTime? updatedAt,  String? updatedBy,  WorkScheduleModel? schedule,  int? overtimeMinutesThisYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
return $default(_that.id,_that.ecNumber,_that.name,_that.mobile,_that.department,_that.position,_that.joiningDate,_that.status,_that.todayStatus,_that.updatedAt,_that.updatedBy,_that.schedule,_that.overtimeMinutesThisYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String ecNumber,  String name,  String mobile,  NamedRef department,  NamedRef position, @DateOnlyConverter()  DateTime joiningDate, @JsonKey(unknownEnumValue: EmployeeStatus.unknown)  EmployeeStatus status, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus? todayStatus, @CompanyDateTimeConverter()  DateTime? updatedAt,  String? updatedBy,  WorkScheduleModel? schedule,  int? overtimeMinutesThisYear)  $default,) {final _that = this;
switch (_that) {
case _EmployeeModel():
return $default(_that.id,_that.ecNumber,_that.name,_that.mobile,_that.department,_that.position,_that.joiningDate,_that.status,_that.todayStatus,_that.updatedAt,_that.updatedBy,_that.schedule,_that.overtimeMinutesThisYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String ecNumber,  String name,  String mobile,  NamedRef department,  NamedRef position, @DateOnlyConverter()  DateTime joiningDate, @JsonKey(unknownEnumValue: EmployeeStatus.unknown)  EmployeeStatus status, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)  AttendanceDayStatus? todayStatus, @CompanyDateTimeConverter()  DateTime? updatedAt,  String? updatedBy,  WorkScheduleModel? schedule,  int? overtimeMinutesThisYear)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
return $default(_that.id,_that.ecNumber,_that.name,_that.mobile,_that.department,_that.position,_that.joiningDate,_that.status,_that.todayStatus,_that.updatedAt,_that.updatedBy,_that.schedule,_that.overtimeMinutesThisYear);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeModel implements EmployeeModel {
  const _EmployeeModel({@JsonKey(fromJson: idFromJson) required this.id, required this.ecNumber, required this.name, required this.mobile, required this.department, required this.position, @DateOnlyConverter() required this.joiningDate, @JsonKey(unknownEnumValue: EmployeeStatus.unknown) required this.status, @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) this.todayStatus, @CompanyDateTimeConverter() this.updatedAt, this.updatedBy, this.schedule, this.overtimeMinutesThisYear});
  factory _EmployeeModel.fromJson(Map<String, dynamic> json) => _$EmployeeModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
/// The organization's prefix followed by digits, e.g. "KC1001".
@override final  String ecNumber;
@override final  String name;
/// 10 digits without the country code, e.g. "9825011234".
@override final  String mobile;
/// The organization's own department and position (2026-10-06).
@override final  NamedRef department;
@override final  NamedRef position;
@override@DateOnlyConverter() final  DateTime joiningDate;
@override@JsonKey(unknownEnumValue: EmployeeStatus.unknown) final  EmployeeStatus status;
/// Today's attendance, when the list endpoint includes it.
@override@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) final  AttendanceDayStatus? todayStatus;
@override@CompanyDateTimeConverter() final  DateTime? updatedAt;
@override final  String? updatedBy;
/// The schedule in effect today (history: `GET /employees/{id}/schedules`).
@override final  WorkScheduleModel? schedule;
/// Overtime from 1 January of the current year (company time) to today,
/// in minutes, calculated by the backend from the attendance records.
/// Null when the caller lacks `overtime.view`, or from an older backend.
@override final  int? overtimeMinutesThisYear;

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeModelCopyWith<_EmployeeModel> get copyWith => __$EmployeeModelCopyWithImpl<_EmployeeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.department, department) || other.department == department)&&(identical(other.position, position) || other.position == position)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.todayStatus, todayStatus) || other.todayStatus == todayStatus)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.overtimeMinutesThisYear, overtimeMinutesThisYear) || other.overtimeMinutesThisYear == overtimeMinutesThisYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ecNumber,name,mobile,department,position,joiningDate,status,todayStatus,updatedAt,updatedBy,schedule,overtimeMinutesThisYear);

@override
String toString() {
  return 'EmployeeModel(id: $id, ecNumber: $ecNumber, name: $name, mobile: $mobile, department: $department, position: $position, joiningDate: $joiningDate, status: $status, todayStatus: $todayStatus, updatedAt: $updatedAt, updatedBy: $updatedBy, schedule: $schedule, overtimeMinutesThisYear: $overtimeMinutesThisYear)';
}


}

/// @nodoc
abstract mixin class _$EmployeeModelCopyWith<$Res> implements $EmployeeModelCopyWith<$Res> {
  factory _$EmployeeModelCopyWith(_EmployeeModel value, $Res Function(_EmployeeModel) _then) = __$EmployeeModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String ecNumber, String name, String mobile, NamedRef department, NamedRef position,@DateOnlyConverter() DateTime joiningDate,@JsonKey(unknownEnumValue: EmployeeStatus.unknown) EmployeeStatus status,@JsonKey(unknownEnumValue: AttendanceDayStatus.unknown) AttendanceDayStatus? todayStatus,@CompanyDateTimeConverter() DateTime? updatedAt, String? updatedBy, WorkScheduleModel? schedule, int? overtimeMinutesThisYear
});


@override $NamedRefCopyWith<$Res> get department;@override $NamedRefCopyWith<$Res> get position;@override $WorkScheduleModelCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$EmployeeModelCopyWithImpl<$Res>
    implements _$EmployeeModelCopyWith<$Res> {
  __$EmployeeModelCopyWithImpl(this._self, this._then);

  final _EmployeeModel _self;
  final $Res Function(_EmployeeModel) _then;

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ecNumber = null,Object? name = null,Object? mobile = null,Object? department = null,Object? position = null,Object? joiningDate = null,Object? status = null,Object? todayStatus = freezed,Object? updatedAt = freezed,Object? updatedBy = freezed,Object? schedule = freezed,Object? overtimeMinutesThisYear = freezed,}) {
  return _then(_EmployeeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ecNumber: null == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as NamedRef,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as NamedRef,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmployeeStatus,todayStatus: freezed == todayStatus ? _self.todayStatus : todayStatus // ignore: cast_nullable_to_non_nullable
as AttendanceDayStatus?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as WorkScheduleModel?,overtimeMinutesThisYear: freezed == overtimeMinutesThisYear ? _self.overtimeMinutesThisYear : overtimeMinutesThisYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get department {
  
  return $NamedRefCopyWith<$Res>(_self.department, (value) {
    return _then(_self.copyWith(department: value));
  });
}/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get position {
  
  return $NamedRefCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkScheduleModelCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $WorkScheduleModelCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// @nodoc
mixin _$EmployeeFormData {

 String get ecNumber; String get name; String get mobile;/// Ids from the organization's lists (`GET /departments`,
/// `GET /positions`).
 String get departmentId; String get positionId;@JsonKey(toJson: dateToJson) DateTime get joiningDate; EmployeeStatus get status;/// Only when creating; later changes add a schedule version instead.
@JsonKey(includeIfNull: false) WorkScheduleInput? get schedule;
/// Create a copy of EmployeeFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeFormDataCopyWith<EmployeeFormData> get copyWith => _$EmployeeFormDataCopyWithImpl<EmployeeFormData>(this as EmployeeFormData, _$identity);

  /// Serializes this EmployeeFormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeFormData&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.positionId, positionId) || other.positionId == positionId)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ecNumber,name,mobile,departmentId,positionId,joiningDate,status,schedule);

@override
String toString() {
  return 'EmployeeFormData(ecNumber: $ecNumber, name: $name, mobile: $mobile, departmentId: $departmentId, positionId: $positionId, joiningDate: $joiningDate, status: $status, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $EmployeeFormDataCopyWith<$Res>  {
  factory $EmployeeFormDataCopyWith(EmployeeFormData value, $Res Function(EmployeeFormData) _then) = _$EmployeeFormDataCopyWithImpl;
@useResult
$Res call({
 String ecNumber, String name, String mobile, String departmentId, String positionId,@JsonKey(toJson: dateToJson) DateTime joiningDate, EmployeeStatus status,@JsonKey(includeIfNull: false) WorkScheduleInput? schedule
});


$WorkScheduleInputCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$EmployeeFormDataCopyWithImpl<$Res>
    implements $EmployeeFormDataCopyWith<$Res> {
  _$EmployeeFormDataCopyWithImpl(this._self, this._then);

  final EmployeeFormData _self;
  final $Res Function(EmployeeFormData) _then;

/// Create a copy of EmployeeFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ecNumber = null,Object? name = null,Object? mobile = null,Object? departmentId = null,Object? positionId = null,Object? joiningDate = null,Object? status = null,Object? schedule = freezed,}) {
  return _then(_self.copyWith(
ecNumber: null == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,positionId: null == positionId ? _self.positionId : positionId // ignore: cast_nullable_to_non_nullable
as String,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmployeeStatus,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as WorkScheduleInput?,
  ));
}
/// Create a copy of EmployeeFormData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkScheduleInputCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $WorkScheduleInputCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeFormData].
extension EmployeeFormDataPatterns on EmployeeFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeFormData value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeFormData value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ecNumber,  String name,  String mobile,  String departmentId,  String positionId, @JsonKey(toJson: dateToJson)  DateTime joiningDate,  EmployeeStatus status, @JsonKey(includeIfNull: false)  WorkScheduleInput? schedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeFormData() when $default != null:
return $default(_that.ecNumber,_that.name,_that.mobile,_that.departmentId,_that.positionId,_that.joiningDate,_that.status,_that.schedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ecNumber,  String name,  String mobile,  String departmentId,  String positionId, @JsonKey(toJson: dateToJson)  DateTime joiningDate,  EmployeeStatus status, @JsonKey(includeIfNull: false)  WorkScheduleInput? schedule)  $default,) {final _that = this;
switch (_that) {
case _EmployeeFormData():
return $default(_that.ecNumber,_that.name,_that.mobile,_that.departmentId,_that.positionId,_that.joiningDate,_that.status,_that.schedule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ecNumber,  String name,  String mobile,  String departmentId,  String positionId, @JsonKey(toJson: dateToJson)  DateTime joiningDate,  EmployeeStatus status, @JsonKey(includeIfNull: false)  WorkScheduleInput? schedule)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeFormData() when $default != null:
return $default(_that.ecNumber,_that.name,_that.mobile,_that.departmentId,_that.positionId,_that.joiningDate,_that.status,_that.schedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeFormData implements EmployeeFormData {
  const _EmployeeFormData({required this.ecNumber, required this.name, required this.mobile, required this.departmentId, required this.positionId, @JsonKey(toJson: dateToJson) required this.joiningDate, required this.status, @JsonKey(includeIfNull: false) this.schedule});
  factory _EmployeeFormData.fromJson(Map<String, dynamic> json) => _$EmployeeFormDataFromJson(json);

@override final  String ecNumber;
@override final  String name;
@override final  String mobile;
/// Ids from the organization's lists (`GET /departments`,
/// `GET /positions`).
@override final  String departmentId;
@override final  String positionId;
@override@JsonKey(toJson: dateToJson) final  DateTime joiningDate;
@override final  EmployeeStatus status;
/// Only when creating; later changes add a schedule version instead.
@override@JsonKey(includeIfNull: false) final  WorkScheduleInput? schedule;

/// Create a copy of EmployeeFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeFormDataCopyWith<_EmployeeFormData> get copyWith => __$EmployeeFormDataCopyWithImpl<_EmployeeFormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeFormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeFormData&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.positionId, positionId) || other.positionId == positionId)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ecNumber,name,mobile,departmentId,positionId,joiningDate,status,schedule);

@override
String toString() {
  return 'EmployeeFormData(ecNumber: $ecNumber, name: $name, mobile: $mobile, departmentId: $departmentId, positionId: $positionId, joiningDate: $joiningDate, status: $status, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class _$EmployeeFormDataCopyWith<$Res> implements $EmployeeFormDataCopyWith<$Res> {
  factory _$EmployeeFormDataCopyWith(_EmployeeFormData value, $Res Function(_EmployeeFormData) _then) = __$EmployeeFormDataCopyWithImpl;
@override @useResult
$Res call({
 String ecNumber, String name, String mobile, String departmentId, String positionId,@JsonKey(toJson: dateToJson) DateTime joiningDate, EmployeeStatus status,@JsonKey(includeIfNull: false) WorkScheduleInput? schedule
});


@override $WorkScheduleInputCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$EmployeeFormDataCopyWithImpl<$Res>
    implements _$EmployeeFormDataCopyWith<$Res> {
  __$EmployeeFormDataCopyWithImpl(this._self, this._then);

  final _EmployeeFormData _self;
  final $Res Function(_EmployeeFormData) _then;

/// Create a copy of EmployeeFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ecNumber = null,Object? name = null,Object? mobile = null,Object? departmentId = null,Object? positionId = null,Object? joiningDate = null,Object? status = null,Object? schedule = freezed,}) {
  return _then(_EmployeeFormData(
ecNumber: null == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,positionId: null == positionId ? _self.positionId : positionId // ignore: cast_nullable_to_non_nullable
as String,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmployeeStatus,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as WorkScheduleInput?,
  ));
}

/// Create a copy of EmployeeFormData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkScheduleInputCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $WorkScheduleInputCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// @nodoc
mixin _$EmployeeListModel {

 List<EmployeeModel> get items; int get total; int get page; int get pageSize;/// Totals for the current search and filters, ignoring the status
/// filter. Optional: the subtitle falls back to [total] without it.
 EmployeeStatusCounts? get counts;
/// Create a copy of EmployeeListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeListModelCopyWith<EmployeeListModel> get copyWith => _$EmployeeListModelCopyWithImpl<EmployeeListModel>(this as EmployeeListModel, _$identity);

  /// Serializes this EmployeeListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeListModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.counts, counts) || other.counts == counts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,pageSize,counts);

@override
String toString() {
  return 'EmployeeListModel(items: $items, total: $total, page: $page, pageSize: $pageSize, counts: $counts)';
}


}

/// @nodoc
abstract mixin class $EmployeeListModelCopyWith<$Res>  {
  factory $EmployeeListModelCopyWith(EmployeeListModel value, $Res Function(EmployeeListModel) _then) = _$EmployeeListModelCopyWithImpl;
@useResult
$Res call({
 List<EmployeeModel> items, int total, int page, int pageSize, EmployeeStatusCounts? counts
});


$EmployeeStatusCountsCopyWith<$Res>? get counts;

}
/// @nodoc
class _$EmployeeListModelCopyWithImpl<$Res>
    implements $EmployeeListModelCopyWith<$Res> {
  _$EmployeeListModelCopyWithImpl(this._self, this._then);

  final EmployeeListModel _self;
  final $Res Function(EmployeeListModel) _then;

/// Create a copy of EmployeeListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? counts = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EmployeeModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as EmployeeStatusCounts?,
  ));
}
/// Create a copy of EmployeeListModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeStatusCountsCopyWith<$Res>? get counts {
    if (_self.counts == null) {
    return null;
  }

  return $EmployeeStatusCountsCopyWith<$Res>(_self.counts!, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeListModel].
extension EmployeeListModelPatterns on EmployeeListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeListModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeListModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EmployeeModel> items,  int total,  int page,  int pageSize,  EmployeeStatusCounts? counts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.counts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EmployeeModel> items,  int total,  int page,  int pageSize,  EmployeeStatusCounts? counts)  $default,) {final _that = this;
switch (_that) {
case _EmployeeListModel():
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.counts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EmployeeModel> items,  int total,  int page,  int pageSize,  EmployeeStatusCounts? counts)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.counts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeListModel implements EmployeeListModel {
  const _EmployeeListModel({required final  List<EmployeeModel> items, required this.total, required this.page, required this.pageSize, this.counts}): _items = items;
  factory _EmployeeListModel.fromJson(Map<String, dynamic> json) => _$EmployeeListModelFromJson(json);

 final  List<EmployeeModel> _items;
@override List<EmployeeModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  int page;
@override final  int pageSize;
/// Totals for the current search and filters, ignoring the status
/// filter. Optional: the subtitle falls back to [total] without it.
@override final  EmployeeStatusCounts? counts;

/// Create a copy of EmployeeListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeListModelCopyWith<_EmployeeListModel> get copyWith => __$EmployeeListModelCopyWithImpl<_EmployeeListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeListModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.counts, counts) || other.counts == counts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,pageSize,counts);

@override
String toString() {
  return 'EmployeeListModel(items: $items, total: $total, page: $page, pageSize: $pageSize, counts: $counts)';
}


}

/// @nodoc
abstract mixin class _$EmployeeListModelCopyWith<$Res> implements $EmployeeListModelCopyWith<$Res> {
  factory _$EmployeeListModelCopyWith(_EmployeeListModel value, $Res Function(_EmployeeListModel) _then) = __$EmployeeListModelCopyWithImpl;
@override @useResult
$Res call({
 List<EmployeeModel> items, int total, int page, int pageSize, EmployeeStatusCounts? counts
});


@override $EmployeeStatusCountsCopyWith<$Res>? get counts;

}
/// @nodoc
class __$EmployeeListModelCopyWithImpl<$Res>
    implements _$EmployeeListModelCopyWith<$Res> {
  __$EmployeeListModelCopyWithImpl(this._self, this._then);

  final _EmployeeListModel _self;
  final $Res Function(_EmployeeListModel) _then;

/// Create a copy of EmployeeListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? counts = freezed,}) {
  return _then(_EmployeeListModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EmployeeModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as EmployeeStatusCounts?,
  ));
}

/// Create a copy of EmployeeListModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeStatusCountsCopyWith<$Res>? get counts {
    if (_self.counts == null) {
    return null;
  }

  return $EmployeeStatusCountsCopyWith<$Res>(_self.counts!, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// @nodoc
mixin _$EmployeeStatusCounts {

 int get active; int get inactive;
/// Create a copy of EmployeeStatusCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeStatusCountsCopyWith<EmployeeStatusCounts> get copyWith => _$EmployeeStatusCountsCopyWithImpl<EmployeeStatusCounts>(this as EmployeeStatusCounts, _$identity);

  /// Serializes this EmployeeStatusCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeStatusCounts&&(identical(other.active, active) || other.active == active)&&(identical(other.inactive, inactive) || other.inactive == inactive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,active,inactive);

@override
String toString() {
  return 'EmployeeStatusCounts(active: $active, inactive: $inactive)';
}


}

/// @nodoc
abstract mixin class $EmployeeStatusCountsCopyWith<$Res>  {
  factory $EmployeeStatusCountsCopyWith(EmployeeStatusCounts value, $Res Function(EmployeeStatusCounts) _then) = _$EmployeeStatusCountsCopyWithImpl;
@useResult
$Res call({
 int active, int inactive
});




}
/// @nodoc
class _$EmployeeStatusCountsCopyWithImpl<$Res>
    implements $EmployeeStatusCountsCopyWith<$Res> {
  _$EmployeeStatusCountsCopyWithImpl(this._self, this._then);

  final EmployeeStatusCounts _self;
  final $Res Function(EmployeeStatusCounts) _then;

/// Create a copy of EmployeeStatusCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = null,Object? inactive = null,}) {
  return _then(_self.copyWith(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,inactive: null == inactive ? _self.inactive : inactive // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeStatusCounts].
extension EmployeeStatusCountsPatterns on EmployeeStatusCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeStatusCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeStatusCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeStatusCounts value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeStatusCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeStatusCounts value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeStatusCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int active,  int inactive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeStatusCounts() when $default != null:
return $default(_that.active,_that.inactive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int active,  int inactive)  $default,) {final _that = this;
switch (_that) {
case _EmployeeStatusCounts():
return $default(_that.active,_that.inactive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int active,  int inactive)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeStatusCounts() when $default != null:
return $default(_that.active,_that.inactive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeStatusCounts implements EmployeeStatusCounts {
  const _EmployeeStatusCounts({required this.active, required this.inactive});
  factory _EmployeeStatusCounts.fromJson(Map<String, dynamic> json) => _$EmployeeStatusCountsFromJson(json);

@override final  int active;
@override final  int inactive;

/// Create a copy of EmployeeStatusCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeStatusCountsCopyWith<_EmployeeStatusCounts> get copyWith => __$EmployeeStatusCountsCopyWithImpl<_EmployeeStatusCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeStatusCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeStatusCounts&&(identical(other.active, active) || other.active == active)&&(identical(other.inactive, inactive) || other.inactive == inactive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,active,inactive);

@override
String toString() {
  return 'EmployeeStatusCounts(active: $active, inactive: $inactive)';
}


}

/// @nodoc
abstract mixin class _$EmployeeStatusCountsCopyWith<$Res> implements $EmployeeStatusCountsCopyWith<$Res> {
  factory _$EmployeeStatusCountsCopyWith(_EmployeeStatusCounts value, $Res Function(_EmployeeStatusCounts) _then) = __$EmployeeStatusCountsCopyWithImpl;
@override @useResult
$Res call({
 int active, int inactive
});




}
/// @nodoc
class __$EmployeeStatusCountsCopyWithImpl<$Res>
    implements _$EmployeeStatusCountsCopyWith<$Res> {
  __$EmployeeStatusCountsCopyWithImpl(this._self, this._then);

  final _EmployeeStatusCounts _self;
  final $Res Function(_EmployeeStatusCounts) _then;

/// Create a copy of EmployeeStatusCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? active = null,Object? inactive = null,}) {
  return _then(_EmployeeStatusCounts(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,inactive: null == inactive ? _self.inactive : inactive // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$EmployeeQuery {

 String get search; String? get departmentId; String? get positionId;/// "Joined" filter (design board 03): joining date within this range.
@DateOnlyConverter() DateTime? get joinedFrom;@DateOnlyConverter() DateTime? get joinedTo;/// The design opens the list filtered to active employees.
 EmployeeStatus? get status; int get page; int get pageSize;
/// Create a copy of EmployeeQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeQueryCopyWith<EmployeeQuery> get copyWith => _$EmployeeQueryCopyWithImpl<EmployeeQuery>(this as EmployeeQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.positionId, positionId) || other.positionId == positionId)&&(identical(other.joinedFrom, joinedFrom) || other.joinedFrom == joinedFrom)&&(identical(other.joinedTo, joinedTo) || other.joinedTo == joinedTo)&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,search,departmentId,positionId,joinedFrom,joinedTo,status,page,pageSize);

@override
String toString() {
  return 'EmployeeQuery(search: $search, departmentId: $departmentId, positionId: $positionId, joinedFrom: $joinedFrom, joinedTo: $joinedTo, status: $status, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $EmployeeQueryCopyWith<$Res>  {
  factory $EmployeeQueryCopyWith(EmployeeQuery value, $Res Function(EmployeeQuery) _then) = _$EmployeeQueryCopyWithImpl;
@useResult
$Res call({
 String search, String? departmentId, String? positionId,@DateOnlyConverter() DateTime? joinedFrom,@DateOnlyConverter() DateTime? joinedTo, EmployeeStatus? status, int page, int pageSize
});




}
/// @nodoc
class _$EmployeeQueryCopyWithImpl<$Res>
    implements $EmployeeQueryCopyWith<$Res> {
  _$EmployeeQueryCopyWithImpl(this._self, this._then);

  final EmployeeQuery _self;
  final $Res Function(EmployeeQuery) _then;

/// Create a copy of EmployeeQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? departmentId = freezed,Object? positionId = freezed,Object? joinedFrom = freezed,Object? joinedTo = freezed,Object? status = freezed,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,positionId: freezed == positionId ? _self.positionId : positionId // ignore: cast_nullable_to_non_nullable
as String?,joinedFrom: freezed == joinedFrom ? _self.joinedFrom : joinedFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,joinedTo: freezed == joinedTo ? _self.joinedTo : joinedTo // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmployeeStatus?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeQuery].
extension EmployeeQueryPatterns on EmployeeQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeQuery value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeQuery value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  String? departmentId,  String? positionId, @DateOnlyConverter()  DateTime? joinedFrom, @DateOnlyConverter()  DateTime? joinedTo,  EmployeeStatus? status,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeQuery() when $default != null:
return $default(_that.search,_that.departmentId,_that.positionId,_that.joinedFrom,_that.joinedTo,_that.status,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  String? departmentId,  String? positionId, @DateOnlyConverter()  DateTime? joinedFrom, @DateOnlyConverter()  DateTime? joinedTo,  EmployeeStatus? status,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _EmployeeQuery():
return $default(_that.search,_that.departmentId,_that.positionId,_that.joinedFrom,_that.joinedTo,_that.status,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  String? departmentId,  String? positionId, @DateOnlyConverter()  DateTime? joinedFrom, @DateOnlyConverter()  DateTime? joinedTo,  EmployeeStatus? status,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeQuery() when $default != null:
return $default(_that.search,_that.departmentId,_that.positionId,_that.joinedFrom,_that.joinedTo,_that.status,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _EmployeeQuery extends EmployeeQuery {
  const _EmployeeQuery({this.search = '', this.departmentId, this.positionId, @DateOnlyConverter() this.joinedFrom, @DateOnlyConverter() this.joinedTo, this.status = EmployeeStatus.active, this.page = 1, this.pageSize = EmployeeQuery.defaultPageSize}): super._();
  

@override@JsonKey() final  String search;
@override final  String? departmentId;
@override final  String? positionId;
/// "Joined" filter (design board 03): joining date within this range.
@override@DateOnlyConverter() final  DateTime? joinedFrom;
@override@DateOnlyConverter() final  DateTime? joinedTo;
/// The design opens the list filtered to active employees.
@override@JsonKey() final  EmployeeStatus? status;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of EmployeeQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeQueryCopyWith<_EmployeeQuery> get copyWith => __$EmployeeQueryCopyWithImpl<_EmployeeQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.positionId, positionId) || other.positionId == positionId)&&(identical(other.joinedFrom, joinedFrom) || other.joinedFrom == joinedFrom)&&(identical(other.joinedTo, joinedTo) || other.joinedTo == joinedTo)&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,search,departmentId,positionId,joinedFrom,joinedTo,status,page,pageSize);

@override
String toString() {
  return 'EmployeeQuery(search: $search, departmentId: $departmentId, positionId: $positionId, joinedFrom: $joinedFrom, joinedTo: $joinedTo, status: $status, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$EmployeeQueryCopyWith<$Res> implements $EmployeeQueryCopyWith<$Res> {
  factory _$EmployeeQueryCopyWith(_EmployeeQuery value, $Res Function(_EmployeeQuery) _then) = __$EmployeeQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, String? departmentId, String? positionId,@DateOnlyConverter() DateTime? joinedFrom,@DateOnlyConverter() DateTime? joinedTo, EmployeeStatus? status, int page, int pageSize
});




}
/// @nodoc
class __$EmployeeQueryCopyWithImpl<$Res>
    implements _$EmployeeQueryCopyWith<$Res> {
  __$EmployeeQueryCopyWithImpl(this._self, this._then);

  final _EmployeeQuery _self;
  final $Res Function(_EmployeeQuery) _then;

/// Create a copy of EmployeeQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? departmentId = freezed,Object? positionId = freezed,Object? joinedFrom = freezed,Object? joinedTo = freezed,Object? status = freezed,Object? page = null,Object? pageSize = null,}) {
  return _then(_EmployeeQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,positionId: freezed == positionId ? _self.positionId : positionId // ignore: cast_nullable_to_non_nullable
as String?,joinedFrom: freezed == joinedFrom ? _self.joinedFrom : joinedFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,joinedTo: freezed == joinedTo ? _self.joinedTo : joinedTo // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmployeeStatus?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LeaveHistoryItemModel {

@JsonKey(fromJson: idFromJson) String get id;@DateOnlyConverter() DateTime get startDate;@DateOnlyConverter() DateTime get endDate; String get leaveType; double get days; String? get reason;@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus get status;/// Paid (Casual) or Unpaid.
 bool get isPaid;/// Casual days left after this leave (date order); null for unpaid or
/// rejected / cancelled leave.
 double? get balanceAfter;
/// Create a copy of LeaveHistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveHistoryItemModelCopyWith<LeaveHistoryItemModel> get copyWith => _$LeaveHistoryItemModelCopyWithImpl<LeaveHistoryItemModel>(this as LeaveHistoryItemModel, _$identity);

  /// Serializes this LeaveHistoryItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveHistoryItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.days, days) || other.days == days)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startDate,endDate,leaveType,days,reason,status,isPaid,balanceAfter);

@override
String toString() {
  return 'LeaveHistoryItemModel(id: $id, startDate: $startDate, endDate: $endDate, leaveType: $leaveType, days: $days, reason: $reason, status: $status, isPaid: $isPaid, balanceAfter: $balanceAfter)';
}


}

/// @nodoc
abstract mixin class $LeaveHistoryItemModelCopyWith<$Res>  {
  factory $LeaveHistoryItemModelCopyWith(LeaveHistoryItemModel value, $Res Function(LeaveHistoryItemModel) _then) = _$LeaveHistoryItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, String leaveType, double days, String? reason,@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus status, bool isPaid, double? balanceAfter
});




}
/// @nodoc
class _$LeaveHistoryItemModelCopyWithImpl<$Res>
    implements $LeaveHistoryItemModelCopyWith<$Res> {
  _$LeaveHistoryItemModelCopyWithImpl(this._self, this._then);

  final LeaveHistoryItemModel _self;
  final $Res Function(LeaveHistoryItemModel) _then;

/// Create a copy of LeaveHistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startDate = null,Object? endDate = null,Object? leaveType = null,Object? days = null,Object? reason = freezed,Object? status = null,Object? isPaid = null,Object? balanceAfter = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,balanceAfter: freezed == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveHistoryItemModel].
extension LeaveHistoryItemModelPatterns on LeaveHistoryItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveHistoryItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveHistoryItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveHistoryItemModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveHistoryItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveHistoryItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveHistoryItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  String leaveType,  double days,  String? reason, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  bool isPaid,  double? balanceAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveHistoryItemModel() when $default != null:
return $default(_that.id,_that.startDate,_that.endDate,_that.leaveType,_that.days,_that.reason,_that.status,_that.isPaid,_that.balanceAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  String leaveType,  double days,  String? reason, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  bool isPaid,  double? balanceAfter)  $default,) {final _that = this;
switch (_that) {
case _LeaveHistoryItemModel():
return $default(_that.id,_that.startDate,_that.endDate,_that.leaveType,_that.days,_that.reason,_that.status,_that.isPaid,_that.balanceAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  String leaveType,  double days,  String? reason, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  bool isPaid,  double? balanceAfter)?  $default,) {final _that = this;
switch (_that) {
case _LeaveHistoryItemModel() when $default != null:
return $default(_that.id,_that.startDate,_that.endDate,_that.leaveType,_that.days,_that.reason,_that.status,_that.isPaid,_that.balanceAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveHistoryItemModel implements LeaveHistoryItemModel {
  const _LeaveHistoryItemModel({@JsonKey(fromJson: idFromJson) required this.id, @DateOnlyConverter() required this.startDate, @DateOnlyConverter() required this.endDate, required this.leaveType, required this.days, this.reason, @JsonKey(unknownEnumValue: LeaveStatus.unknown) required this.status, this.isPaid = true, this.balanceAfter});
  factory _LeaveHistoryItemModel.fromJson(Map<String, dynamic> json) => _$LeaveHistoryItemModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override@DateOnlyConverter() final  DateTime startDate;
@override@DateOnlyConverter() final  DateTime endDate;
@override final  String leaveType;
@override final  double days;
@override final  String? reason;
@override@JsonKey(unknownEnumValue: LeaveStatus.unknown) final  LeaveStatus status;
/// Paid (Casual) or Unpaid.
@override@JsonKey() final  bool isPaid;
/// Casual days left after this leave (date order); null for unpaid or
/// rejected / cancelled leave.
@override final  double? balanceAfter;

/// Create a copy of LeaveHistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveHistoryItemModelCopyWith<_LeaveHistoryItemModel> get copyWith => __$LeaveHistoryItemModelCopyWithImpl<_LeaveHistoryItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveHistoryItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveHistoryItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.days, days) || other.days == days)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startDate,endDate,leaveType,days,reason,status,isPaid,balanceAfter);

@override
String toString() {
  return 'LeaveHistoryItemModel(id: $id, startDate: $startDate, endDate: $endDate, leaveType: $leaveType, days: $days, reason: $reason, status: $status, isPaid: $isPaid, balanceAfter: $balanceAfter)';
}


}

/// @nodoc
abstract mixin class _$LeaveHistoryItemModelCopyWith<$Res> implements $LeaveHistoryItemModelCopyWith<$Res> {
  factory _$LeaveHistoryItemModelCopyWith(_LeaveHistoryItemModel value, $Res Function(_LeaveHistoryItemModel) _then) = __$LeaveHistoryItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, String leaveType, double days, String? reason,@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus status, bool isPaid, double? balanceAfter
});




}
/// @nodoc
class __$LeaveHistoryItemModelCopyWithImpl<$Res>
    implements _$LeaveHistoryItemModelCopyWith<$Res> {
  __$LeaveHistoryItemModelCopyWithImpl(this._self, this._then);

  final _LeaveHistoryItemModel _self;
  final $Res Function(_LeaveHistoryItemModel) _then;

/// Create a copy of LeaveHistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startDate = null,Object? endDate = null,Object? leaveType = null,Object? days = null,Object? reason = freezed,Object? status = null,Object? isPaid = null,Object? balanceAfter = freezed,}) {
  return _then(_LeaveHistoryItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,balanceAfter: freezed == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
