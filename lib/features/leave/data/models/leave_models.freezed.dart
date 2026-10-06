// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveTypeModel {

@JsonKey(fromJson: idFromJson) String get id; String get name;/// False for types not limited by a balance (Unpaid).
 bool get hasBalance;/// Paid leave (Casual) uses the monthly balance; Unpaid doesn't.
 bool get isPaid;
/// Create a copy of LeaveTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveTypeModelCopyWith<LeaveTypeModel> get copyWith => _$LeaveTypeModelCopyWithImpl<LeaveTypeModel>(this as LeaveTypeModel, _$identity);

  /// Serializes this LeaveTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hasBalance, hasBalance) || other.hasBalance == hasBalance)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hasBalance,isPaid);

@override
String toString() {
  return 'LeaveTypeModel(id: $id, name: $name, hasBalance: $hasBalance, isPaid: $isPaid)';
}


}

/// @nodoc
abstract mixin class $LeaveTypeModelCopyWith<$Res>  {
  factory $LeaveTypeModelCopyWith(LeaveTypeModel value, $Res Function(LeaveTypeModel) _then) = _$LeaveTypeModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, bool hasBalance, bool isPaid
});




}
/// @nodoc
class _$LeaveTypeModelCopyWithImpl<$Res>
    implements $LeaveTypeModelCopyWith<$Res> {
  _$LeaveTypeModelCopyWithImpl(this._self, this._then);

  final LeaveTypeModel _self;
  final $Res Function(LeaveTypeModel) _then;

/// Create a copy of LeaveTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hasBalance = null,Object? isPaid = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hasBalance: null == hasBalance ? _self.hasBalance : hasBalance // ignore: cast_nullable_to_non_nullable
as bool,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveTypeModel].
extension LeaveTypeModelPatterns on LeaveTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  bool hasBalance,  bool isPaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveTypeModel() when $default != null:
return $default(_that.id,_that.name,_that.hasBalance,_that.isPaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  bool hasBalance,  bool isPaid)  $default,) {final _that = this;
switch (_that) {
case _LeaveTypeModel():
return $default(_that.id,_that.name,_that.hasBalance,_that.isPaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  bool hasBalance,  bool isPaid)?  $default,) {final _that = this;
switch (_that) {
case _LeaveTypeModel() when $default != null:
return $default(_that.id,_that.name,_that.hasBalance,_that.isPaid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveTypeModel implements LeaveTypeModel {
  const _LeaveTypeModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name, this.hasBalance = true, this.isPaid = true});
  factory _LeaveTypeModel.fromJson(Map<String, dynamic> json) => _$LeaveTypeModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;
/// False for types not limited by a balance (Unpaid).
@override@JsonKey() final  bool hasBalance;
/// Paid leave (Casual) uses the monthly balance; Unpaid doesn't.
@override@JsonKey() final  bool isPaid;

/// Create a copy of LeaveTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveTypeModelCopyWith<_LeaveTypeModel> get copyWith => __$LeaveTypeModelCopyWithImpl<_LeaveTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hasBalance, hasBalance) || other.hasBalance == hasBalance)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hasBalance,isPaid);

@override
String toString() {
  return 'LeaveTypeModel(id: $id, name: $name, hasBalance: $hasBalance, isPaid: $isPaid)';
}


}

/// @nodoc
abstract mixin class _$LeaveTypeModelCopyWith<$Res> implements $LeaveTypeModelCopyWith<$Res> {
  factory _$LeaveTypeModelCopyWith(_LeaveTypeModel value, $Res Function(_LeaveTypeModel) _then) = __$LeaveTypeModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, bool hasBalance, bool isPaid
});




}
/// @nodoc
class __$LeaveTypeModelCopyWithImpl<$Res>
    implements _$LeaveTypeModelCopyWith<$Res> {
  __$LeaveTypeModelCopyWithImpl(this._self, this._then);

  final _LeaveTypeModel _self;
  final $Res Function(_LeaveTypeModel) _then;

/// Create a copy of LeaveTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hasBalance = null,Object? isPaid = null,}) {
  return _then(_LeaveTypeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hasBalance: null == hasBalance ? _self.hasBalance : hasBalance // ignore: cast_nullable_to_non_nullable
as bool,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LeaveModel {

@JsonKey(fromJson: idFromJson) String get id; EmployeeSummaryModel get employee; NamedRef get leaveType;@DateOnlyConverter() DateTime get startDate;@DateOnlyConverter() DateTime get endDate;/// Counted by the backend (weekly offs and holidays excluded).
 double get days; bool get isHalfDay;@JsonKey(unknownEnumValue: LeaveReason.other) LeaveReason get reason; String? get remarks;@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus get status;/// Who created it, as shown in the design: "Admin" or "Employee request".
 String? get addedBy;/// Paid (Casual) or Unpaid, from the leave type.
 bool get isPaid;/// Casual days left after this leave, counting leave in date order.
/// Only on paid leave that counts (approved or pending).
 double? get balanceAfter;/// When a request was split, the Unpaid leave saved with it.
 String? get unpaidPartId;
/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveModelCopyWith<LeaveModel> get copyWith => _$LeaveModelCopyWithImpl<LeaveModel>(this as LeaveModel, _$identity);

  /// Serializes this LeaveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.status, status) || other.status == status)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.unpaidPartId, unpaidPartId) || other.unpaidPartId == unpaidPartId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employee,leaveType,startDate,endDate,days,isHalfDay,reason,remarks,status,addedBy,isPaid,balanceAfter,unpaidPartId);

@override
String toString() {
  return 'LeaveModel(id: $id, employee: $employee, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, days: $days, isHalfDay: $isHalfDay, reason: $reason, remarks: $remarks, status: $status, addedBy: $addedBy, isPaid: $isPaid, balanceAfter: $balanceAfter, unpaidPartId: $unpaidPartId)';
}


}

/// @nodoc
abstract mixin class $LeaveModelCopyWith<$Res>  {
  factory $LeaveModelCopyWith(LeaveModel value, $Res Function(LeaveModel) _then) = _$LeaveModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, EmployeeSummaryModel employee, NamedRef leaveType,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, double days, bool isHalfDay,@JsonKey(unknownEnumValue: LeaveReason.other) LeaveReason reason, String? remarks,@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus status, String? addedBy, bool isPaid, double? balanceAfter, String? unpaidPartId
});


$EmployeeSummaryModelCopyWith<$Res> get employee;$NamedRefCopyWith<$Res> get leaveType;

}
/// @nodoc
class _$LeaveModelCopyWithImpl<$Res>
    implements $LeaveModelCopyWith<$Res> {
  _$LeaveModelCopyWithImpl(this._self, this._then);

  final LeaveModel _self;
  final $Res Function(LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employee = null,Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? days = null,Object? isHalfDay = null,Object? reason = null,Object? remarks = freezed,Object? status = null,Object? addedBy = freezed,Object? isPaid = null,Object? balanceAfter = freezed,Object? unpaidPartId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as NamedRef,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as LeaveReason,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,balanceAfter: freezed == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as double?,unpaidPartId: freezed == unpaidPartId ? _self.unpaidPartId : unpaidPartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get leaveType {
  
  return $NamedRefCopyWith<$Res>(_self.leaveType, (value) {
    return _then(_self.copyWith(leaveType: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveModel].
extension LeaveModelPatterns on LeaveModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  EmployeeSummaryModel employee,  NamedRef leaveType, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  double days,  bool isHalfDay, @JsonKey(unknownEnumValue: LeaveReason.other)  LeaveReason reason,  String? remarks, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  String? addedBy,  bool isPaid,  double? balanceAfter,  String? unpaidPartId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.employee,_that.leaveType,_that.startDate,_that.endDate,_that.days,_that.isHalfDay,_that.reason,_that.remarks,_that.status,_that.addedBy,_that.isPaid,_that.balanceAfter,_that.unpaidPartId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  EmployeeSummaryModel employee,  NamedRef leaveType, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  double days,  bool isHalfDay, @JsonKey(unknownEnumValue: LeaveReason.other)  LeaveReason reason,  String? remarks, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  String? addedBy,  bool isPaid,  double? balanceAfter,  String? unpaidPartId)  $default,) {final _that = this;
switch (_that) {
case _LeaveModel():
return $default(_that.id,_that.employee,_that.leaveType,_that.startDate,_that.endDate,_that.days,_that.isHalfDay,_that.reason,_that.remarks,_that.status,_that.addedBy,_that.isPaid,_that.balanceAfter,_that.unpaidPartId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  EmployeeSummaryModel employee,  NamedRef leaveType, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  double days,  bool isHalfDay, @JsonKey(unknownEnumValue: LeaveReason.other)  LeaveReason reason,  String? remarks, @JsonKey(unknownEnumValue: LeaveStatus.unknown)  LeaveStatus status,  String? addedBy,  bool isPaid,  double? balanceAfter,  String? unpaidPartId)?  $default,) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.employee,_that.leaveType,_that.startDate,_that.endDate,_that.days,_that.isHalfDay,_that.reason,_that.remarks,_that.status,_that.addedBy,_that.isPaid,_that.balanceAfter,_that.unpaidPartId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveModel extends LeaveModel {
  const _LeaveModel({@JsonKey(fromJson: idFromJson) required this.id, required this.employee, required this.leaveType, @DateOnlyConverter() required this.startDate, @DateOnlyConverter() required this.endDate, required this.days, this.isHalfDay = false, @JsonKey(unknownEnumValue: LeaveReason.other) required this.reason, this.remarks, @JsonKey(unknownEnumValue: LeaveStatus.unknown) required this.status, this.addedBy, this.isPaid = true, this.balanceAfter, this.unpaidPartId}): super._();
  factory _LeaveModel.fromJson(Map<String, dynamic> json) => _$LeaveModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  EmployeeSummaryModel employee;
@override final  NamedRef leaveType;
@override@DateOnlyConverter() final  DateTime startDate;
@override@DateOnlyConverter() final  DateTime endDate;
/// Counted by the backend (weekly offs and holidays excluded).
@override final  double days;
@override@JsonKey() final  bool isHalfDay;
@override@JsonKey(unknownEnumValue: LeaveReason.other) final  LeaveReason reason;
@override final  String? remarks;
@override@JsonKey(unknownEnumValue: LeaveStatus.unknown) final  LeaveStatus status;
/// Who created it, as shown in the design: "Admin" or "Employee request".
@override final  String? addedBy;
/// Paid (Casual) or Unpaid, from the leave type.
@override@JsonKey() final  bool isPaid;
/// Casual days left after this leave, counting leave in date order.
/// Only on paid leave that counts (approved or pending).
@override final  double? balanceAfter;
/// When a request was split, the Unpaid leave saved with it.
@override final  String? unpaidPartId;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveModelCopyWith<_LeaveModel> get copyWith => __$LeaveModelCopyWithImpl<_LeaveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.status, status) || other.status == status)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.unpaidPartId, unpaidPartId) || other.unpaidPartId == unpaidPartId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employee,leaveType,startDate,endDate,days,isHalfDay,reason,remarks,status,addedBy,isPaid,balanceAfter,unpaidPartId);

@override
String toString() {
  return 'LeaveModel(id: $id, employee: $employee, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, days: $days, isHalfDay: $isHalfDay, reason: $reason, remarks: $remarks, status: $status, addedBy: $addedBy, isPaid: $isPaid, balanceAfter: $balanceAfter, unpaidPartId: $unpaidPartId)';
}


}

/// @nodoc
abstract mixin class _$LeaveModelCopyWith<$Res> implements $LeaveModelCopyWith<$Res> {
  factory _$LeaveModelCopyWith(_LeaveModel value, $Res Function(_LeaveModel) _then) = __$LeaveModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, EmployeeSummaryModel employee, NamedRef leaveType,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, double days, bool isHalfDay,@JsonKey(unknownEnumValue: LeaveReason.other) LeaveReason reason, String? remarks,@JsonKey(unknownEnumValue: LeaveStatus.unknown) LeaveStatus status, String? addedBy, bool isPaid, double? balanceAfter, String? unpaidPartId
});


@override $EmployeeSummaryModelCopyWith<$Res> get employee;@override $NamedRefCopyWith<$Res> get leaveType;

}
/// @nodoc
class __$LeaveModelCopyWithImpl<$Res>
    implements _$LeaveModelCopyWith<$Res> {
  __$LeaveModelCopyWithImpl(this._self, this._then);

  final _LeaveModel _self;
  final $Res Function(_LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employee = null,Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? days = null,Object? isHalfDay = null,Object? reason = null,Object? remarks = freezed,Object? status = null,Object? addedBy = freezed,Object? isPaid = null,Object? balanceAfter = freezed,Object? unpaidPartId = freezed,}) {
  return _then(_LeaveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as NamedRef,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as LeaveReason,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,balanceAfter: freezed == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as double?,unpaidPartId: freezed == unpaidPartId ? _self.unpaidPartId : unpaidPartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}/// Create a copy of LeaveModel
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
mixin _$LeaveStatusCounts {

 int get all; int get pending; int get approved; int get rejected; int get cancelled;
/// Create a copy of LeaveStatusCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveStatusCountsCopyWith<LeaveStatusCounts> get copyWith => _$LeaveStatusCountsCopyWithImpl<LeaveStatusCounts>(this as LeaveStatusCounts, _$identity);

  /// Serializes this LeaveStatusCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveStatusCounts&&(identical(other.all, all) || other.all == all)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,pending,approved,rejected,cancelled);

@override
String toString() {
  return 'LeaveStatusCounts(all: $all, pending: $pending, approved: $approved, rejected: $rejected, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class $LeaveStatusCountsCopyWith<$Res>  {
  factory $LeaveStatusCountsCopyWith(LeaveStatusCounts value, $Res Function(LeaveStatusCounts) _then) = _$LeaveStatusCountsCopyWithImpl;
@useResult
$Res call({
 int all, int pending, int approved, int rejected, int cancelled
});




}
/// @nodoc
class _$LeaveStatusCountsCopyWithImpl<$Res>
    implements $LeaveStatusCountsCopyWith<$Res> {
  _$LeaveStatusCountsCopyWithImpl(this._self, this._then);

  final LeaveStatusCounts _self;
  final $Res Function(LeaveStatusCounts) _then;

/// Create a copy of LeaveStatusCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = null,Object? pending = null,Object? approved = null,Object? rejected = null,Object? cancelled = null,}) {
  return _then(_self.copyWith(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveStatusCounts].
extension LeaveStatusCountsPatterns on LeaveStatusCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveStatusCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveStatusCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveStatusCounts value)  $default,){
final _that = this;
switch (_that) {
case _LeaveStatusCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveStatusCounts value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveStatusCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int all,  int pending,  int approved,  int rejected,  int cancelled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveStatusCounts() when $default != null:
return $default(_that.all,_that.pending,_that.approved,_that.rejected,_that.cancelled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int all,  int pending,  int approved,  int rejected,  int cancelled)  $default,) {final _that = this;
switch (_that) {
case _LeaveStatusCounts():
return $default(_that.all,_that.pending,_that.approved,_that.rejected,_that.cancelled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int all,  int pending,  int approved,  int rejected,  int cancelled)?  $default,) {final _that = this;
switch (_that) {
case _LeaveStatusCounts() when $default != null:
return $default(_that.all,_that.pending,_that.approved,_that.rejected,_that.cancelled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveStatusCounts extends LeaveStatusCounts {
  const _LeaveStatusCounts({required this.all, required this.pending, required this.approved, required this.rejected, required this.cancelled}): super._();
  factory _LeaveStatusCounts.fromJson(Map<String, dynamic> json) => _$LeaveStatusCountsFromJson(json);

@override final  int all;
@override final  int pending;
@override final  int approved;
@override final  int rejected;
@override final  int cancelled;

/// Create a copy of LeaveStatusCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveStatusCountsCopyWith<_LeaveStatusCounts> get copyWith => __$LeaveStatusCountsCopyWithImpl<_LeaveStatusCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveStatusCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveStatusCounts&&(identical(other.all, all) || other.all == all)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,pending,approved,rejected,cancelled);

@override
String toString() {
  return 'LeaveStatusCounts(all: $all, pending: $pending, approved: $approved, rejected: $rejected, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class _$LeaveStatusCountsCopyWith<$Res> implements $LeaveStatusCountsCopyWith<$Res> {
  factory _$LeaveStatusCountsCopyWith(_LeaveStatusCounts value, $Res Function(_LeaveStatusCounts) _then) = __$LeaveStatusCountsCopyWithImpl;
@override @useResult
$Res call({
 int all, int pending, int approved, int rejected, int cancelled
});




}
/// @nodoc
class __$LeaveStatusCountsCopyWithImpl<$Res>
    implements _$LeaveStatusCountsCopyWith<$Res> {
  __$LeaveStatusCountsCopyWithImpl(this._self, this._then);

  final _LeaveStatusCounts _self;
  final $Res Function(_LeaveStatusCounts) _then;

/// Create a copy of LeaveStatusCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,Object? pending = null,Object? approved = null,Object? rejected = null,Object? cancelled = null,}) {
  return _then(_LeaveStatusCounts(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LeaveListModel {

 List<LeaveModel> get items; int get total; int get page; int get pageSize; LeaveStatusCounts get counts;
/// Create a copy of LeaveListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveListModelCopyWith<LeaveListModel> get copyWith => _$LeaveListModelCopyWithImpl<LeaveListModel>(this as LeaveListModel, _$identity);

  /// Serializes this LeaveListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveListModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.counts, counts) || other.counts == counts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,pageSize,counts);

@override
String toString() {
  return 'LeaveListModel(items: $items, total: $total, page: $page, pageSize: $pageSize, counts: $counts)';
}


}

/// @nodoc
abstract mixin class $LeaveListModelCopyWith<$Res>  {
  factory $LeaveListModelCopyWith(LeaveListModel value, $Res Function(LeaveListModel) _then) = _$LeaveListModelCopyWithImpl;
@useResult
$Res call({
 List<LeaveModel> items, int total, int page, int pageSize, LeaveStatusCounts counts
});


$LeaveStatusCountsCopyWith<$Res> get counts;

}
/// @nodoc
class _$LeaveListModelCopyWithImpl<$Res>
    implements $LeaveListModelCopyWith<$Res> {
  _$LeaveListModelCopyWithImpl(this._self, this._then);

  final LeaveListModel _self;
  final $Res Function(LeaveListModel) _then;

/// Create a copy of LeaveListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? counts = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LeaveModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as LeaveStatusCounts,
  ));
}
/// Create a copy of LeaveListModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveStatusCountsCopyWith<$Res> get counts {
  
  return $LeaveStatusCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveListModel].
extension LeaveListModelPatterns on LeaveListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveListModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveListModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LeaveModel> items,  int total,  int page,  int pageSize,  LeaveStatusCounts counts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveListModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LeaveModel> items,  int total,  int page,  int pageSize,  LeaveStatusCounts counts)  $default,) {final _that = this;
switch (_that) {
case _LeaveListModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LeaveModel> items,  int total,  int page,  int pageSize,  LeaveStatusCounts counts)?  $default,) {final _that = this;
switch (_that) {
case _LeaveListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.counts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveListModel implements LeaveListModel {
  const _LeaveListModel({required final  List<LeaveModel> items, required this.total, required this.page, required this.pageSize, required this.counts}): _items = items;
  factory _LeaveListModel.fromJson(Map<String, dynamic> json) => _$LeaveListModelFromJson(json);

 final  List<LeaveModel> _items;
@override List<LeaveModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  int page;
@override final  int pageSize;
@override final  LeaveStatusCounts counts;

/// Create a copy of LeaveListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveListModelCopyWith<_LeaveListModel> get copyWith => __$LeaveListModelCopyWithImpl<_LeaveListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveListModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.counts, counts) || other.counts == counts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,pageSize,counts);

@override
String toString() {
  return 'LeaveListModel(items: $items, total: $total, page: $page, pageSize: $pageSize, counts: $counts)';
}


}

/// @nodoc
abstract mixin class _$LeaveListModelCopyWith<$Res> implements $LeaveListModelCopyWith<$Res> {
  factory _$LeaveListModelCopyWith(_LeaveListModel value, $Res Function(_LeaveListModel) _then) = __$LeaveListModelCopyWithImpl;
@override @useResult
$Res call({
 List<LeaveModel> items, int total, int page, int pageSize, LeaveStatusCounts counts
});


@override $LeaveStatusCountsCopyWith<$Res> get counts;

}
/// @nodoc
class __$LeaveListModelCopyWithImpl<$Res>
    implements _$LeaveListModelCopyWith<$Res> {
  __$LeaveListModelCopyWithImpl(this._self, this._then);

  final _LeaveListModel _self;
  final $Res Function(_LeaveListModel) _then;

/// Create a copy of LeaveListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? counts = null,}) {
  return _then(_LeaveListModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LeaveModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as LeaveStatusCounts,
  ));
}

/// Create a copy of LeaveListModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveStatusCountsCopyWith<$Res> get counts {
  
  return $LeaveStatusCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}

/// @nodoc
mixin _$LeaveQuery {

/// `null` = "All" tab.
 LeaveStatus? get status; String get search; DateTime? get from; DateTime? get to; String? get leaveTypeId; String? get department; int get page; int get pageSize;
/// Create a copy of LeaveQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveQueryCopyWith<LeaveQuery> get copyWith => _$LeaveQueryCopyWithImpl<LeaveQuery>(this as LeaveQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveQuery&&(identical(other.status, status) || other.status == status)&&(identical(other.search, search) || other.search == search)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.department, department) || other.department == department)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,status,search,from,to,leaveTypeId,department,page,pageSize);

@override
String toString() {
  return 'LeaveQuery(status: $status, search: $search, from: $from, to: $to, leaveTypeId: $leaveTypeId, department: $department, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $LeaveQueryCopyWith<$Res>  {
  factory $LeaveQueryCopyWith(LeaveQuery value, $Res Function(LeaveQuery) _then) = _$LeaveQueryCopyWithImpl;
@useResult
$Res call({
 LeaveStatus? status, String search, DateTime? from, DateTime? to, String? leaveTypeId, String? department, int page, int pageSize
});




}
/// @nodoc
class _$LeaveQueryCopyWithImpl<$Res>
    implements $LeaveQueryCopyWith<$Res> {
  _$LeaveQueryCopyWithImpl(this._self, this._then);

  final LeaveQuery _self;
  final $Res Function(LeaveQuery) _then;

/// Create a copy of LeaveQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? search = null,Object? from = freezed,Object? to = freezed,Object? leaveTypeId = freezed,Object? department = freezed,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,leaveTypeId: freezed == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveQuery].
extension LeaveQueryPatterns on LeaveQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveQuery value)  $default,){
final _that = this;
switch (_that) {
case _LeaveQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveQuery value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LeaveStatus? status,  String search,  DateTime? from,  DateTime? to,  String? leaveTypeId,  String? department,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveQuery() when $default != null:
return $default(_that.status,_that.search,_that.from,_that.to,_that.leaveTypeId,_that.department,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LeaveStatus? status,  String search,  DateTime? from,  DateTime? to,  String? leaveTypeId,  String? department,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _LeaveQuery():
return $default(_that.status,_that.search,_that.from,_that.to,_that.leaveTypeId,_that.department,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LeaveStatus? status,  String search,  DateTime? from,  DateTime? to,  String? leaveTypeId,  String? department,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _LeaveQuery() when $default != null:
return $default(_that.status,_that.search,_that.from,_that.to,_that.leaveTypeId,_that.department,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _LeaveQuery extends LeaveQuery {
  const _LeaveQuery({this.status, this.search = '', this.from, this.to, this.leaveTypeId, this.department, this.page = 1, this.pageSize = LeaveQuery.defaultPageSize}): super._();
  

/// `null` = "All" tab.
@override final  LeaveStatus? status;
@override@JsonKey() final  String search;
@override final  DateTime? from;
@override final  DateTime? to;
@override final  String? leaveTypeId;
@override final  String? department;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of LeaveQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveQueryCopyWith<_LeaveQuery> get copyWith => __$LeaveQueryCopyWithImpl<_LeaveQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveQuery&&(identical(other.status, status) || other.status == status)&&(identical(other.search, search) || other.search == search)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.department, department) || other.department == department)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,status,search,from,to,leaveTypeId,department,page,pageSize);

@override
String toString() {
  return 'LeaveQuery(status: $status, search: $search, from: $from, to: $to, leaveTypeId: $leaveTypeId, department: $department, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$LeaveQueryCopyWith<$Res> implements $LeaveQueryCopyWith<$Res> {
  factory _$LeaveQueryCopyWith(_LeaveQuery value, $Res Function(_LeaveQuery) _then) = __$LeaveQueryCopyWithImpl;
@override @useResult
$Res call({
 LeaveStatus? status, String search, DateTime? from, DateTime? to, String? leaveTypeId, String? department, int page, int pageSize
});




}
/// @nodoc
class __$LeaveQueryCopyWithImpl<$Res>
    implements _$LeaveQueryCopyWith<$Res> {
  __$LeaveQueryCopyWithImpl(this._self, this._then);

  final _LeaveQuery _self;
  final $Res Function(_LeaveQuery) _then;

/// Create a copy of LeaveQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? search = null,Object? from = freezed,Object? to = freezed,Object? leaveTypeId = freezed,Object? department = freezed,Object? page = null,Object? pageSize = null,}) {
  return _then(_LeaveQuery(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,leaveTypeId: freezed == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LeaveFormData {

 String get employeeId; String get leaveTypeId;@JsonKey(toJson: dateToJson) DateTime get startDate;@JsonKey(toJson: dateToJson) DateTime get endDate; bool get isHalfDay; LeaveReason get reason; String? get remarks;/// The design lets the admin save as Approved or Pending.
 LeaveStatus get status;/// Casual leave beyond the available balance is saved as a separate
/// Unpaid leave (the latest days). Without this, such a request is
/// refused with `INSUFFICIENT_LEAVE_BALANCE`.
@JsonKey(includeIfNull: false) bool? get splitExcessAsUnpaid;
/// Create a copy of LeaveFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveFormDataCopyWith<LeaveFormData> get copyWith => _$LeaveFormDataCopyWithImpl<LeaveFormData>(this as LeaveFormData, _$identity);

  /// Serializes this LeaveFormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveFormData&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.status, status) || other.status == status)&&(identical(other.splitExcessAsUnpaid, splitExcessAsUnpaid) || other.splitExcessAsUnpaid == splitExcessAsUnpaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,leaveTypeId,startDate,endDate,isHalfDay,reason,remarks,status,splitExcessAsUnpaid);

@override
String toString() {
  return 'LeaveFormData(employeeId: $employeeId, leaveTypeId: $leaveTypeId, startDate: $startDate, endDate: $endDate, isHalfDay: $isHalfDay, reason: $reason, remarks: $remarks, status: $status, splitExcessAsUnpaid: $splitExcessAsUnpaid)';
}


}

/// @nodoc
abstract mixin class $LeaveFormDataCopyWith<$Res>  {
  factory $LeaveFormDataCopyWith(LeaveFormData value, $Res Function(LeaveFormData) _then) = _$LeaveFormDataCopyWithImpl;
@useResult
$Res call({
 String employeeId, String leaveTypeId,@JsonKey(toJson: dateToJson) DateTime startDate,@JsonKey(toJson: dateToJson) DateTime endDate, bool isHalfDay, LeaveReason reason, String? remarks, LeaveStatus status,@JsonKey(includeIfNull: false) bool? splitExcessAsUnpaid
});




}
/// @nodoc
class _$LeaveFormDataCopyWithImpl<$Res>
    implements $LeaveFormDataCopyWith<$Res> {
  _$LeaveFormDataCopyWithImpl(this._self, this._then);

  final LeaveFormData _self;
  final $Res Function(LeaveFormData) _then;

/// Create a copy of LeaveFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeId = null,Object? leaveTypeId = null,Object? startDate = null,Object? endDate = null,Object? isHalfDay = null,Object? reason = null,Object? remarks = freezed,Object? status = null,Object? splitExcessAsUnpaid = freezed,}) {
  return _then(_self.copyWith(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as LeaveReason,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,splitExcessAsUnpaid: freezed == splitExcessAsUnpaid ? _self.splitExcessAsUnpaid : splitExcessAsUnpaid // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveFormData].
extension LeaveFormDataPatterns on LeaveFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveFormData value)  $default,){
final _that = this;
switch (_that) {
case _LeaveFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveFormData value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String employeeId,  String leaveTypeId, @JsonKey(toJson: dateToJson)  DateTime startDate, @JsonKey(toJson: dateToJson)  DateTime endDate,  bool isHalfDay,  LeaveReason reason,  String? remarks,  LeaveStatus status, @JsonKey(includeIfNull: false)  bool? splitExcessAsUnpaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveFormData() when $default != null:
return $default(_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.isHalfDay,_that.reason,_that.remarks,_that.status,_that.splitExcessAsUnpaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String employeeId,  String leaveTypeId, @JsonKey(toJson: dateToJson)  DateTime startDate, @JsonKey(toJson: dateToJson)  DateTime endDate,  bool isHalfDay,  LeaveReason reason,  String? remarks,  LeaveStatus status, @JsonKey(includeIfNull: false)  bool? splitExcessAsUnpaid)  $default,) {final _that = this;
switch (_that) {
case _LeaveFormData():
return $default(_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.isHalfDay,_that.reason,_that.remarks,_that.status,_that.splitExcessAsUnpaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String employeeId,  String leaveTypeId, @JsonKey(toJson: dateToJson)  DateTime startDate, @JsonKey(toJson: dateToJson)  DateTime endDate,  bool isHalfDay,  LeaveReason reason,  String? remarks,  LeaveStatus status, @JsonKey(includeIfNull: false)  bool? splitExcessAsUnpaid)?  $default,) {final _that = this;
switch (_that) {
case _LeaveFormData() when $default != null:
return $default(_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.isHalfDay,_that.reason,_that.remarks,_that.status,_that.splitExcessAsUnpaid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveFormData implements LeaveFormData {
  const _LeaveFormData({required this.employeeId, required this.leaveTypeId, @JsonKey(toJson: dateToJson) required this.startDate, @JsonKey(toJson: dateToJson) required this.endDate, required this.isHalfDay, required this.reason, this.remarks, required this.status, @JsonKey(includeIfNull: false) this.splitExcessAsUnpaid});
  factory _LeaveFormData.fromJson(Map<String, dynamic> json) => _$LeaveFormDataFromJson(json);

@override final  String employeeId;
@override final  String leaveTypeId;
@override@JsonKey(toJson: dateToJson) final  DateTime startDate;
@override@JsonKey(toJson: dateToJson) final  DateTime endDate;
@override final  bool isHalfDay;
@override final  LeaveReason reason;
@override final  String? remarks;
/// The design lets the admin save as Approved or Pending.
@override final  LeaveStatus status;
/// Casual leave beyond the available balance is saved as a separate
/// Unpaid leave (the latest days). Without this, such a request is
/// refused with `INSUFFICIENT_LEAVE_BALANCE`.
@override@JsonKey(includeIfNull: false) final  bool? splitExcessAsUnpaid;

/// Create a copy of LeaveFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveFormDataCopyWith<_LeaveFormData> get copyWith => __$LeaveFormDataCopyWithImpl<_LeaveFormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveFormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveFormData&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.status, status) || other.status == status)&&(identical(other.splitExcessAsUnpaid, splitExcessAsUnpaid) || other.splitExcessAsUnpaid == splitExcessAsUnpaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,leaveTypeId,startDate,endDate,isHalfDay,reason,remarks,status,splitExcessAsUnpaid);

@override
String toString() {
  return 'LeaveFormData(employeeId: $employeeId, leaveTypeId: $leaveTypeId, startDate: $startDate, endDate: $endDate, isHalfDay: $isHalfDay, reason: $reason, remarks: $remarks, status: $status, splitExcessAsUnpaid: $splitExcessAsUnpaid)';
}


}

/// @nodoc
abstract mixin class _$LeaveFormDataCopyWith<$Res> implements $LeaveFormDataCopyWith<$Res> {
  factory _$LeaveFormDataCopyWith(_LeaveFormData value, $Res Function(_LeaveFormData) _then) = __$LeaveFormDataCopyWithImpl;
@override @useResult
$Res call({
 String employeeId, String leaveTypeId,@JsonKey(toJson: dateToJson) DateTime startDate,@JsonKey(toJson: dateToJson) DateTime endDate, bool isHalfDay, LeaveReason reason, String? remarks, LeaveStatus status,@JsonKey(includeIfNull: false) bool? splitExcessAsUnpaid
});




}
/// @nodoc
class __$LeaveFormDataCopyWithImpl<$Res>
    implements _$LeaveFormDataCopyWith<$Res> {
  __$LeaveFormDataCopyWithImpl(this._self, this._then);

  final _LeaveFormData _self;
  final $Res Function(_LeaveFormData) _then;

/// Create a copy of LeaveFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeId = null,Object? leaveTypeId = null,Object? startDate = null,Object? endDate = null,Object? isHalfDay = null,Object? reason = null,Object? remarks = freezed,Object? status = null,Object? splitExcessAsUnpaid = freezed,}) {
  return _then(_LeaveFormData(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as LeaveReason,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,splitExcessAsUnpaid: freezed == splitExcessAsUnpaid ? _self.splitExcessAsUnpaid : splitExcessAsUnpaid // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$LeavePreviewRequest {

 String get employeeId; String get leaveTypeId;@JsonKey(toJson: dateToJson) DateTime get startDate;@JsonKey(toJson: dateToJson) DateTime get endDate; bool get isHalfDay;/// When editing, the leave being changed (its days are given back first).
 String? get leaveId;
/// Create a copy of LeavePreviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeavePreviewRequestCopyWith<LeavePreviewRequest> get copyWith => _$LeavePreviewRequestCopyWithImpl<LeavePreviewRequest>(this as LeavePreviewRequest, _$identity);

  /// Serializes this LeavePreviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeavePreviewRequest&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.leaveId, leaveId) || other.leaveId == leaveId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,leaveTypeId,startDate,endDate,isHalfDay,leaveId);

@override
String toString() {
  return 'LeavePreviewRequest(employeeId: $employeeId, leaveTypeId: $leaveTypeId, startDate: $startDate, endDate: $endDate, isHalfDay: $isHalfDay, leaveId: $leaveId)';
}


}

/// @nodoc
abstract mixin class $LeavePreviewRequestCopyWith<$Res>  {
  factory $LeavePreviewRequestCopyWith(LeavePreviewRequest value, $Res Function(LeavePreviewRequest) _then) = _$LeavePreviewRequestCopyWithImpl;
@useResult
$Res call({
 String employeeId, String leaveTypeId,@JsonKey(toJson: dateToJson) DateTime startDate,@JsonKey(toJson: dateToJson) DateTime endDate, bool isHalfDay, String? leaveId
});




}
/// @nodoc
class _$LeavePreviewRequestCopyWithImpl<$Res>
    implements $LeavePreviewRequestCopyWith<$Res> {
  _$LeavePreviewRequestCopyWithImpl(this._self, this._then);

  final LeavePreviewRequest _self;
  final $Res Function(LeavePreviewRequest) _then;

/// Create a copy of LeavePreviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeId = null,Object? leaveTypeId = null,Object? startDate = null,Object? endDate = null,Object? isHalfDay = null,Object? leaveId = freezed,}) {
  return _then(_self.copyWith(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,leaveId: freezed == leaveId ? _self.leaveId : leaveId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeavePreviewRequest].
extension LeavePreviewRequestPatterns on LeavePreviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeavePreviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeavePreviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeavePreviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _LeavePreviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeavePreviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LeavePreviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String employeeId,  String leaveTypeId, @JsonKey(toJson: dateToJson)  DateTime startDate, @JsonKey(toJson: dateToJson)  DateTime endDate,  bool isHalfDay,  String? leaveId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeavePreviewRequest() when $default != null:
return $default(_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.isHalfDay,_that.leaveId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String employeeId,  String leaveTypeId, @JsonKey(toJson: dateToJson)  DateTime startDate, @JsonKey(toJson: dateToJson)  DateTime endDate,  bool isHalfDay,  String? leaveId)  $default,) {final _that = this;
switch (_that) {
case _LeavePreviewRequest():
return $default(_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.isHalfDay,_that.leaveId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String employeeId,  String leaveTypeId, @JsonKey(toJson: dateToJson)  DateTime startDate, @JsonKey(toJson: dateToJson)  DateTime endDate,  bool isHalfDay,  String? leaveId)?  $default,) {final _that = this;
switch (_that) {
case _LeavePreviewRequest() when $default != null:
return $default(_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.isHalfDay,_that.leaveId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeavePreviewRequest implements LeavePreviewRequest {
  const _LeavePreviewRequest({required this.employeeId, required this.leaveTypeId, @JsonKey(toJson: dateToJson) required this.startDate, @JsonKey(toJson: dateToJson) required this.endDate, required this.isHalfDay, this.leaveId});
  factory _LeavePreviewRequest.fromJson(Map<String, dynamic> json) => _$LeavePreviewRequestFromJson(json);

@override final  String employeeId;
@override final  String leaveTypeId;
@override@JsonKey(toJson: dateToJson) final  DateTime startDate;
@override@JsonKey(toJson: dateToJson) final  DateTime endDate;
@override final  bool isHalfDay;
/// When editing, the leave being changed (its days are given back first).
@override final  String? leaveId;

/// Create a copy of LeavePreviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeavePreviewRequestCopyWith<_LeavePreviewRequest> get copyWith => __$LeavePreviewRequestCopyWithImpl<_LeavePreviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeavePreviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeavePreviewRequest&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.leaveId, leaveId) || other.leaveId == leaveId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,leaveTypeId,startDate,endDate,isHalfDay,leaveId);

@override
String toString() {
  return 'LeavePreviewRequest(employeeId: $employeeId, leaveTypeId: $leaveTypeId, startDate: $startDate, endDate: $endDate, isHalfDay: $isHalfDay, leaveId: $leaveId)';
}


}

/// @nodoc
abstract mixin class _$LeavePreviewRequestCopyWith<$Res> implements $LeavePreviewRequestCopyWith<$Res> {
  factory _$LeavePreviewRequestCopyWith(_LeavePreviewRequest value, $Res Function(_LeavePreviewRequest) _then) = __$LeavePreviewRequestCopyWithImpl;
@override @useResult
$Res call({
 String employeeId, String leaveTypeId,@JsonKey(toJson: dateToJson) DateTime startDate,@JsonKey(toJson: dateToJson) DateTime endDate, bool isHalfDay, String? leaveId
});




}
/// @nodoc
class __$LeavePreviewRequestCopyWithImpl<$Res>
    implements _$LeavePreviewRequestCopyWith<$Res> {
  __$LeavePreviewRequestCopyWithImpl(this._self, this._then);

  final _LeavePreviewRequest _self;
  final $Res Function(_LeavePreviewRequest) _then;

/// Create a copy of LeavePreviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeId = null,Object? leaveTypeId = null,Object? startDate = null,Object? endDate = null,Object? isHalfDay = null,Object? leaveId = freezed,}) {
  return _then(_LeavePreviewRequest(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,leaveId: freezed == leaveId ? _self.leaveId : leaveId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeavePreviewModel {

 double get days; double get paidDays; double get unpaidDays;/// Casual days available for these dates; null for Unpaid leave.
 double? get availableCasual;
/// Create a copy of LeavePreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeavePreviewModelCopyWith<LeavePreviewModel> get copyWith => _$LeavePreviewModelCopyWithImpl<LeavePreviewModel>(this as LeavePreviewModel, _$identity);

  /// Serializes this LeavePreviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeavePreviewModel&&(identical(other.days, days) || other.days == days)&&(identical(other.paidDays, paidDays) || other.paidDays == paidDays)&&(identical(other.unpaidDays, unpaidDays) || other.unpaidDays == unpaidDays)&&(identical(other.availableCasual, availableCasual) || other.availableCasual == availableCasual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,days,paidDays,unpaidDays,availableCasual);

@override
String toString() {
  return 'LeavePreviewModel(days: $days, paidDays: $paidDays, unpaidDays: $unpaidDays, availableCasual: $availableCasual)';
}


}

/// @nodoc
abstract mixin class $LeavePreviewModelCopyWith<$Res>  {
  factory $LeavePreviewModelCopyWith(LeavePreviewModel value, $Res Function(LeavePreviewModel) _then) = _$LeavePreviewModelCopyWithImpl;
@useResult
$Res call({
 double days, double paidDays, double unpaidDays, double? availableCasual
});




}
/// @nodoc
class _$LeavePreviewModelCopyWithImpl<$Res>
    implements $LeavePreviewModelCopyWith<$Res> {
  _$LeavePreviewModelCopyWithImpl(this._self, this._then);

  final LeavePreviewModel _self;
  final $Res Function(LeavePreviewModel) _then;

/// Create a copy of LeavePreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,Object? paidDays = null,Object? unpaidDays = null,Object? availableCasual = freezed,}) {
  return _then(_self.copyWith(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,paidDays: null == paidDays ? _self.paidDays : paidDays // ignore: cast_nullable_to_non_nullable
as double,unpaidDays: null == unpaidDays ? _self.unpaidDays : unpaidDays // ignore: cast_nullable_to_non_nullable
as double,availableCasual: freezed == availableCasual ? _self.availableCasual : availableCasual // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeavePreviewModel].
extension LeavePreviewModelPatterns on LeavePreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeavePreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeavePreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeavePreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _LeavePreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeavePreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeavePreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double days,  double paidDays,  double unpaidDays,  double? availableCasual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeavePreviewModel() when $default != null:
return $default(_that.days,_that.paidDays,_that.unpaidDays,_that.availableCasual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double days,  double paidDays,  double unpaidDays,  double? availableCasual)  $default,) {final _that = this;
switch (_that) {
case _LeavePreviewModel():
return $default(_that.days,_that.paidDays,_that.unpaidDays,_that.availableCasual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double days,  double paidDays,  double unpaidDays,  double? availableCasual)?  $default,) {final _that = this;
switch (_that) {
case _LeavePreviewModel() when $default != null:
return $default(_that.days,_that.paidDays,_that.unpaidDays,_that.availableCasual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeavePreviewModel extends LeavePreviewModel {
  const _LeavePreviewModel({required this.days, this.paidDays = 0, this.unpaidDays = 0, this.availableCasual}): super._();
  factory _LeavePreviewModel.fromJson(Map<String, dynamic> json) => _$LeavePreviewModelFromJson(json);

@override final  double days;
@override@JsonKey() final  double paidDays;
@override@JsonKey() final  double unpaidDays;
/// Casual days available for these dates; null for Unpaid leave.
@override final  double? availableCasual;

/// Create a copy of LeavePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeavePreviewModelCopyWith<_LeavePreviewModel> get copyWith => __$LeavePreviewModelCopyWithImpl<_LeavePreviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeavePreviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeavePreviewModel&&(identical(other.days, days) || other.days == days)&&(identical(other.paidDays, paidDays) || other.paidDays == paidDays)&&(identical(other.unpaidDays, unpaidDays) || other.unpaidDays == unpaidDays)&&(identical(other.availableCasual, availableCasual) || other.availableCasual == availableCasual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,days,paidDays,unpaidDays,availableCasual);

@override
String toString() {
  return 'LeavePreviewModel(days: $days, paidDays: $paidDays, unpaidDays: $unpaidDays, availableCasual: $availableCasual)';
}


}

/// @nodoc
abstract mixin class _$LeavePreviewModelCopyWith<$Res> implements $LeavePreviewModelCopyWith<$Res> {
  factory _$LeavePreviewModelCopyWith(_LeavePreviewModel value, $Res Function(_LeavePreviewModel) _then) = __$LeavePreviewModelCopyWithImpl;
@override @useResult
$Res call({
 double days, double paidDays, double unpaidDays, double? availableCasual
});




}
/// @nodoc
class __$LeavePreviewModelCopyWithImpl<$Res>
    implements _$LeavePreviewModelCopyWith<$Res> {
  __$LeavePreviewModelCopyWithImpl(this._self, this._then);

  final _LeavePreviewModel _self;
  final $Res Function(_LeavePreviewModel) _then;

/// Create a copy of LeavePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,Object? paidDays = null,Object? unpaidDays = null,Object? availableCasual = freezed,}) {
  return _then(_LeavePreviewModel(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,paidDays: null == paidDays ? _self.paidDays : paidDays // ignore: cast_nullable_to_non_nullable
as double,unpaidDays: null == unpaidDays ? _self.unpaidDays : unpaidDays // ignore: cast_nullable_to_non_nullable
as double,availableCasual: freezed == availableCasual ? _self.availableCasual : availableCasual // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$LeaveCalendarModel {

@DateOnlyConverter() DateTime get month; List<HolidayModel> get holidays;/// The employee's weekly offs as ISO weekdays (Monday = 1 … Sunday = 7),
/// from the schedule in effect on the 1st. Empty without an employee.
 List<int> get weeklyOffDays;/// The exact weekly-off dates of the month, which also covers a schedule
/// that changes mid-month. Preferred over [weeklyOffDays] when present.
@DateOnlyConverter() List<DateTime> get weekOffDates;
/// Create a copy of LeaveCalendarModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveCalendarModelCopyWith<LeaveCalendarModel> get copyWith => _$LeaveCalendarModelCopyWithImpl<LeaveCalendarModel>(this as LeaveCalendarModel, _$identity);

  /// Serializes this LeaveCalendarModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveCalendarModel&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.holidays, holidays)&&const DeepCollectionEquality().equals(other.weeklyOffDays, weeklyOffDays)&&const DeepCollectionEquality().equals(other.weekOffDates, weekOffDates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,const DeepCollectionEquality().hash(holidays),const DeepCollectionEquality().hash(weeklyOffDays),const DeepCollectionEquality().hash(weekOffDates));

@override
String toString() {
  return 'LeaveCalendarModel(month: $month, holidays: $holidays, weeklyOffDays: $weeklyOffDays, weekOffDates: $weekOffDates)';
}


}

/// @nodoc
abstract mixin class $LeaveCalendarModelCopyWith<$Res>  {
  factory $LeaveCalendarModelCopyWith(LeaveCalendarModel value, $Res Function(LeaveCalendarModel) _then) = _$LeaveCalendarModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime month, List<HolidayModel> holidays, List<int> weeklyOffDays,@DateOnlyConverter() List<DateTime> weekOffDates
});




}
/// @nodoc
class _$LeaveCalendarModelCopyWithImpl<$Res>
    implements $LeaveCalendarModelCopyWith<$Res> {
  _$LeaveCalendarModelCopyWithImpl(this._self, this._then);

  final LeaveCalendarModel _self;
  final $Res Function(LeaveCalendarModel) _then;

/// Create a copy of LeaveCalendarModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? holidays = null,Object? weeklyOffDays = null,Object? weekOffDates = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,holidays: null == holidays ? _self.holidays : holidays // ignore: cast_nullable_to_non_nullable
as List<HolidayModel>,weeklyOffDays: null == weeklyOffDays ? _self.weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,weekOffDates: null == weekOffDates ? _self.weekOffDates : weekOffDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveCalendarModel].
extension LeaveCalendarModelPatterns on LeaveCalendarModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveCalendarModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveCalendarModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveCalendarModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveCalendarModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveCalendarModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveCalendarModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  List<HolidayModel> holidays,  List<int> weeklyOffDays, @DateOnlyConverter()  List<DateTime> weekOffDates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveCalendarModel() when $default != null:
return $default(_that.month,_that.holidays,_that.weeklyOffDays,_that.weekOffDates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  List<HolidayModel> holidays,  List<int> weeklyOffDays, @DateOnlyConverter()  List<DateTime> weekOffDates)  $default,) {final _that = this;
switch (_that) {
case _LeaveCalendarModel():
return $default(_that.month,_that.holidays,_that.weeklyOffDays,_that.weekOffDates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime month,  List<HolidayModel> holidays,  List<int> weeklyOffDays, @DateOnlyConverter()  List<DateTime> weekOffDates)?  $default,) {final _that = this;
switch (_that) {
case _LeaveCalendarModel() when $default != null:
return $default(_that.month,_that.holidays,_that.weeklyOffDays,_that.weekOffDates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveCalendarModel extends LeaveCalendarModel {
  const _LeaveCalendarModel({@DateOnlyConverter() required this.month, final  List<HolidayModel> holidays = const <HolidayModel>[], final  List<int> weeklyOffDays = const <int>[], @DateOnlyConverter() final  List<DateTime> weekOffDates = const <DateTime>[]}): _holidays = holidays,_weeklyOffDays = weeklyOffDays,_weekOffDates = weekOffDates,super._();
  factory _LeaveCalendarModel.fromJson(Map<String, dynamic> json) => _$LeaveCalendarModelFromJson(json);

@override@DateOnlyConverter() final  DateTime month;
 final  List<HolidayModel> _holidays;
@override@JsonKey() List<HolidayModel> get holidays {
  if (_holidays is EqualUnmodifiableListView) return _holidays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_holidays);
}

/// The employee's weekly offs as ISO weekdays (Monday = 1 … Sunday = 7),
/// from the schedule in effect on the 1st. Empty without an employee.
 final  List<int> _weeklyOffDays;
/// The employee's weekly offs as ISO weekdays (Monday = 1 … Sunday = 7),
/// from the schedule in effect on the 1st. Empty without an employee.
@override@JsonKey() List<int> get weeklyOffDays {
  if (_weeklyOffDays is EqualUnmodifiableListView) return _weeklyOffDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyOffDays);
}

/// The exact weekly-off dates of the month, which also covers a schedule
/// that changes mid-month. Preferred over [weeklyOffDays] when present.
 final  List<DateTime> _weekOffDates;
/// The exact weekly-off dates of the month, which also covers a schedule
/// that changes mid-month. Preferred over [weeklyOffDays] when present.
@override@JsonKey()@DateOnlyConverter() List<DateTime> get weekOffDates {
  if (_weekOffDates is EqualUnmodifiableListView) return _weekOffDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekOffDates);
}


/// Create a copy of LeaveCalendarModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveCalendarModelCopyWith<_LeaveCalendarModel> get copyWith => __$LeaveCalendarModelCopyWithImpl<_LeaveCalendarModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveCalendarModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveCalendarModel&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other._holidays, _holidays)&&const DeepCollectionEquality().equals(other._weeklyOffDays, _weeklyOffDays)&&const DeepCollectionEquality().equals(other._weekOffDates, _weekOffDates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,const DeepCollectionEquality().hash(_holidays),const DeepCollectionEquality().hash(_weeklyOffDays),const DeepCollectionEquality().hash(_weekOffDates));

@override
String toString() {
  return 'LeaveCalendarModel(month: $month, holidays: $holidays, weeklyOffDays: $weeklyOffDays, weekOffDates: $weekOffDates)';
}


}

/// @nodoc
abstract mixin class _$LeaveCalendarModelCopyWith<$Res> implements $LeaveCalendarModelCopyWith<$Res> {
  factory _$LeaveCalendarModelCopyWith(_LeaveCalendarModel value, $Res Function(_LeaveCalendarModel) _then) = __$LeaveCalendarModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime month, List<HolidayModel> holidays, List<int> weeklyOffDays,@DateOnlyConverter() List<DateTime> weekOffDates
});




}
/// @nodoc
class __$LeaveCalendarModelCopyWithImpl<$Res>
    implements _$LeaveCalendarModelCopyWith<$Res> {
  __$LeaveCalendarModelCopyWithImpl(this._self, this._then);

  final _LeaveCalendarModel _self;
  final $Res Function(_LeaveCalendarModel) _then;

/// Create a copy of LeaveCalendarModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? holidays = null,Object? weeklyOffDays = null,Object? weekOffDates = null,}) {
  return _then(_LeaveCalendarModel(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,holidays: null == holidays ? _self._holidays : holidays // ignore: cast_nullable_to_non_nullable
as List<HolidayModel>,weeklyOffDays: null == weeklyOffDays ? _self._weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,weekOffDates: null == weekOffDates ? _self._weekOffDates : weekOffDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,
  ));
}


}


/// @nodoc
mixin _$EmployeeLeaveBalanceModel {

 EmployeeSummaryModel get employee; LeaveBalanceModel get balance;
/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeLeaveBalanceModelCopyWith<EmployeeLeaveBalanceModel> get copyWith => _$EmployeeLeaveBalanceModelCopyWithImpl<EmployeeLeaveBalanceModel>(this as EmployeeLeaveBalanceModel, _$identity);

  /// Serializes this EmployeeLeaveBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeLeaveBalanceModel&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employee,balance);

@override
String toString() {
  return 'EmployeeLeaveBalanceModel(employee: $employee, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $EmployeeLeaveBalanceModelCopyWith<$Res>  {
  factory $EmployeeLeaveBalanceModelCopyWith(EmployeeLeaveBalanceModel value, $Res Function(EmployeeLeaveBalanceModel) _then) = _$EmployeeLeaveBalanceModelCopyWithImpl;
@useResult
$Res call({
 EmployeeSummaryModel employee, LeaveBalanceModel balance
});


$EmployeeSummaryModelCopyWith<$Res> get employee;$LeaveBalanceModelCopyWith<$Res> get balance;

}
/// @nodoc
class _$EmployeeLeaveBalanceModelCopyWithImpl<$Res>
    implements $EmployeeLeaveBalanceModelCopyWith<$Res> {
  _$EmployeeLeaveBalanceModelCopyWithImpl(this._self, this._then);

  final EmployeeLeaveBalanceModel _self;
  final $Res Function(EmployeeLeaveBalanceModel) _then;

/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employee = null,Object? balance = null,}) {
  return _then(_self.copyWith(
employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as LeaveBalanceModel,
  ));
}
/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveBalanceModelCopyWith<$Res> get balance {
  
  return $LeaveBalanceModelCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeLeaveBalanceModel].
extension EmployeeLeaveBalanceModelPatterns on EmployeeLeaveBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeLeaveBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeLeaveBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeLeaveBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeLeaveBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeLeaveBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeLeaveBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EmployeeSummaryModel employee,  LeaveBalanceModel balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeLeaveBalanceModel() when $default != null:
return $default(_that.employee,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EmployeeSummaryModel employee,  LeaveBalanceModel balance)  $default,) {final _that = this;
switch (_that) {
case _EmployeeLeaveBalanceModel():
return $default(_that.employee,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EmployeeSummaryModel employee,  LeaveBalanceModel balance)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeLeaveBalanceModel() when $default != null:
return $default(_that.employee,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeLeaveBalanceModel implements EmployeeLeaveBalanceModel {
  const _EmployeeLeaveBalanceModel({required this.employee, required this.balance});
  factory _EmployeeLeaveBalanceModel.fromJson(Map<String, dynamic> json) => _$EmployeeLeaveBalanceModelFromJson(json);

@override final  EmployeeSummaryModel employee;
@override final  LeaveBalanceModel balance;

/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeLeaveBalanceModelCopyWith<_EmployeeLeaveBalanceModel> get copyWith => __$EmployeeLeaveBalanceModelCopyWithImpl<_EmployeeLeaveBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeLeaveBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeLeaveBalanceModel&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employee,balance);

@override
String toString() {
  return 'EmployeeLeaveBalanceModel(employee: $employee, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$EmployeeLeaveBalanceModelCopyWith<$Res> implements $EmployeeLeaveBalanceModelCopyWith<$Res> {
  factory _$EmployeeLeaveBalanceModelCopyWith(_EmployeeLeaveBalanceModel value, $Res Function(_EmployeeLeaveBalanceModel) _then) = __$EmployeeLeaveBalanceModelCopyWithImpl;
@override @useResult
$Res call({
 EmployeeSummaryModel employee, LeaveBalanceModel balance
});


@override $EmployeeSummaryModelCopyWith<$Res> get employee;@override $LeaveBalanceModelCopyWith<$Res> get balance;

}
/// @nodoc
class __$EmployeeLeaveBalanceModelCopyWithImpl<$Res>
    implements _$EmployeeLeaveBalanceModelCopyWith<$Res> {
  __$EmployeeLeaveBalanceModelCopyWithImpl(this._self, this._then);

  final _EmployeeLeaveBalanceModel _self;
  final $Res Function(_EmployeeLeaveBalanceModel) _then;

/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employee = null,Object? balance = null,}) {
  return _then(_EmployeeLeaveBalanceModel(
employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as LeaveBalanceModel,
  ));
}

/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}/// Create a copy of EmployeeLeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveBalanceModelCopyWith<$Res> get balance {
  
  return $LeaveBalanceModelCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}


/// @nodoc
mixin _$LeaveBalanceTotalsModel {

 int get employees; double get accrued; double get used; double get pending; double get remaining; double get unpaidTaken;
/// Create a copy of LeaveBalanceTotalsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceTotalsModelCopyWith<LeaveBalanceTotalsModel> get copyWith => _$LeaveBalanceTotalsModelCopyWithImpl<LeaveBalanceTotalsModel>(this as LeaveBalanceTotalsModel, _$identity);

  /// Serializes this LeaveBalanceTotalsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalanceTotalsModel&&(identical(other.employees, employees) || other.employees == employees)&&(identical(other.accrued, accrued) || other.accrued == accrued)&&(identical(other.used, used) || other.used == used)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.unpaidTaken, unpaidTaken) || other.unpaidTaken == unpaidTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employees,accrued,used,pending,remaining,unpaidTaken);

@override
String toString() {
  return 'LeaveBalanceTotalsModel(employees: $employees, accrued: $accrued, used: $used, pending: $pending, remaining: $remaining, unpaidTaken: $unpaidTaken)';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceTotalsModelCopyWith<$Res>  {
  factory $LeaveBalanceTotalsModelCopyWith(LeaveBalanceTotalsModel value, $Res Function(LeaveBalanceTotalsModel) _then) = _$LeaveBalanceTotalsModelCopyWithImpl;
@useResult
$Res call({
 int employees, double accrued, double used, double pending, double remaining, double unpaidTaken
});




}
/// @nodoc
class _$LeaveBalanceTotalsModelCopyWithImpl<$Res>
    implements $LeaveBalanceTotalsModelCopyWith<$Res> {
  _$LeaveBalanceTotalsModelCopyWithImpl(this._self, this._then);

  final LeaveBalanceTotalsModel _self;
  final $Res Function(LeaveBalanceTotalsModel) _then;

/// Create a copy of LeaveBalanceTotalsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employees = null,Object? accrued = null,Object? used = null,Object? pending = null,Object? remaining = null,Object? unpaidTaken = null,}) {
  return _then(_self.copyWith(
employees: null == employees ? _self.employees : employees // ignore: cast_nullable_to_non_nullable
as int,accrued: null == accrued ? _self.accrued : accrued // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,unpaidTaken: null == unpaidTaken ? _self.unpaidTaken : unpaidTaken // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveBalanceTotalsModel].
extension LeaveBalanceTotalsModelPatterns on LeaveBalanceTotalsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalanceTotalsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalanceTotalsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalanceTotalsModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceTotalsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalanceTotalsModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceTotalsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int employees,  double accrued,  double used,  double pending,  double remaining,  double unpaidTaken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalanceTotalsModel() when $default != null:
return $default(_that.employees,_that.accrued,_that.used,_that.pending,_that.remaining,_that.unpaidTaken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int employees,  double accrued,  double used,  double pending,  double remaining,  double unpaidTaken)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceTotalsModel():
return $default(_that.employees,_that.accrued,_that.used,_that.pending,_that.remaining,_that.unpaidTaken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int employees,  double accrued,  double used,  double pending,  double remaining,  double unpaidTaken)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceTotalsModel() when $default != null:
return $default(_that.employees,_that.accrued,_that.used,_that.pending,_that.remaining,_that.unpaidTaken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveBalanceTotalsModel implements LeaveBalanceTotalsModel {
  const _LeaveBalanceTotalsModel({required this.employees, required this.accrued, required this.used, this.pending = 0, required this.remaining, this.unpaidTaken = 0});
  factory _LeaveBalanceTotalsModel.fromJson(Map<String, dynamic> json) => _$LeaveBalanceTotalsModelFromJson(json);

@override final  int employees;
@override final  double accrued;
@override final  double used;
@override@JsonKey() final  double pending;
@override final  double remaining;
@override@JsonKey() final  double unpaidTaken;

/// Create a copy of LeaveBalanceTotalsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceTotalsModelCopyWith<_LeaveBalanceTotalsModel> get copyWith => __$LeaveBalanceTotalsModelCopyWithImpl<_LeaveBalanceTotalsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceTotalsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalanceTotalsModel&&(identical(other.employees, employees) || other.employees == employees)&&(identical(other.accrued, accrued) || other.accrued == accrued)&&(identical(other.used, used) || other.used == used)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.unpaidTaken, unpaidTaken) || other.unpaidTaken == unpaidTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employees,accrued,used,pending,remaining,unpaidTaken);

@override
String toString() {
  return 'LeaveBalanceTotalsModel(employees: $employees, accrued: $accrued, used: $used, pending: $pending, remaining: $remaining, unpaidTaken: $unpaidTaken)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceTotalsModelCopyWith<$Res> implements $LeaveBalanceTotalsModelCopyWith<$Res> {
  factory _$LeaveBalanceTotalsModelCopyWith(_LeaveBalanceTotalsModel value, $Res Function(_LeaveBalanceTotalsModel) _then) = __$LeaveBalanceTotalsModelCopyWithImpl;
@override @useResult
$Res call({
 int employees, double accrued, double used, double pending, double remaining, double unpaidTaken
});




}
/// @nodoc
class __$LeaveBalanceTotalsModelCopyWithImpl<$Res>
    implements _$LeaveBalanceTotalsModelCopyWith<$Res> {
  __$LeaveBalanceTotalsModelCopyWithImpl(this._self, this._then);

  final _LeaveBalanceTotalsModel _self;
  final $Res Function(_LeaveBalanceTotalsModel) _then;

/// Create a copy of LeaveBalanceTotalsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employees = null,Object? accrued = null,Object? used = null,Object? pending = null,Object? remaining = null,Object? unpaidTaken = null,}) {
  return _then(_LeaveBalanceTotalsModel(
employees: null == employees ? _self.employees : employees // ignore: cast_nullable_to_non_nullable
as int,accrued: null == accrued ? _self.accrued : accrued // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,unpaidTaken: null == unpaidTaken ? _self.unpaidTaken : unpaidTaken // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$LeaveBalanceListModel {

 List<EmployeeLeaveBalanceModel> get items; int get total; int get page; int get pageSize; LeaveBalanceTotalsModel get summary;
/// Create a copy of LeaveBalanceListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceListModelCopyWith<LeaveBalanceListModel> get copyWith => _$LeaveBalanceListModelCopyWithImpl<LeaveBalanceListModel>(this as LeaveBalanceListModel, _$identity);

  /// Serializes this LeaveBalanceListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalanceListModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,pageSize,summary);

@override
String toString() {
  return 'LeaveBalanceListModel(items: $items, total: $total, page: $page, pageSize: $pageSize, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceListModelCopyWith<$Res>  {
  factory $LeaveBalanceListModelCopyWith(LeaveBalanceListModel value, $Res Function(LeaveBalanceListModel) _then) = _$LeaveBalanceListModelCopyWithImpl;
@useResult
$Res call({
 List<EmployeeLeaveBalanceModel> items, int total, int page, int pageSize, LeaveBalanceTotalsModel summary
});


$LeaveBalanceTotalsModelCopyWith<$Res> get summary;

}
/// @nodoc
class _$LeaveBalanceListModelCopyWithImpl<$Res>
    implements $LeaveBalanceListModelCopyWith<$Res> {
  _$LeaveBalanceListModelCopyWithImpl(this._self, this._then);

  final LeaveBalanceListModel _self;
  final $Res Function(LeaveBalanceListModel) _then;

/// Create a copy of LeaveBalanceListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? summary = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EmployeeLeaveBalanceModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LeaveBalanceTotalsModel,
  ));
}
/// Create a copy of LeaveBalanceListModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveBalanceTotalsModelCopyWith<$Res> get summary {
  
  return $LeaveBalanceTotalsModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveBalanceListModel].
extension LeaveBalanceListModelPatterns on LeaveBalanceListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalanceListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalanceListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalanceListModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalanceListModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EmployeeLeaveBalanceModel> items,  int total,  int page,  int pageSize,  LeaveBalanceTotalsModel summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalanceListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EmployeeLeaveBalanceModel> items,  int total,  int page,  int pageSize,  LeaveBalanceTotalsModel summary)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceListModel():
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EmployeeLeaveBalanceModel> items,  int total,  int page,  int pageSize,  LeaveBalanceTotalsModel summary)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveBalanceListModel implements LeaveBalanceListModel {
  const _LeaveBalanceListModel({required final  List<EmployeeLeaveBalanceModel> items, required this.total, required this.page, required this.pageSize, required this.summary}): _items = items;
  factory _LeaveBalanceListModel.fromJson(Map<String, dynamic> json) => _$LeaveBalanceListModelFromJson(json);

 final  List<EmployeeLeaveBalanceModel> _items;
@override List<EmployeeLeaveBalanceModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  int page;
@override final  int pageSize;
@override final  LeaveBalanceTotalsModel summary;

/// Create a copy of LeaveBalanceListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceListModelCopyWith<_LeaveBalanceListModel> get copyWith => __$LeaveBalanceListModelCopyWithImpl<_LeaveBalanceListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalanceListModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,pageSize,summary);

@override
String toString() {
  return 'LeaveBalanceListModel(items: $items, total: $total, page: $page, pageSize: $pageSize, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceListModelCopyWith<$Res> implements $LeaveBalanceListModelCopyWith<$Res> {
  factory _$LeaveBalanceListModelCopyWith(_LeaveBalanceListModel value, $Res Function(_LeaveBalanceListModel) _then) = __$LeaveBalanceListModelCopyWithImpl;
@override @useResult
$Res call({
 List<EmployeeLeaveBalanceModel> items, int total, int page, int pageSize, LeaveBalanceTotalsModel summary
});


@override $LeaveBalanceTotalsModelCopyWith<$Res> get summary;

}
/// @nodoc
class __$LeaveBalanceListModelCopyWithImpl<$Res>
    implements _$LeaveBalanceListModelCopyWith<$Res> {
  __$LeaveBalanceListModelCopyWithImpl(this._self, this._then);

  final _LeaveBalanceListModel _self;
  final $Res Function(_LeaveBalanceListModel) _then;

/// Create a copy of LeaveBalanceListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? summary = null,}) {
  return _then(_LeaveBalanceListModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EmployeeLeaveBalanceModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LeaveBalanceTotalsModel,
  ));
}

/// Create a copy of LeaveBalanceListModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveBalanceTotalsModelCopyWith<$Res> get summary {
  
  return $LeaveBalanceTotalsModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$LeaveBalanceQuery {

 String get search; String? get department; int get page; int get pageSize;
/// Create a copy of LeaveBalanceQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceQueryCopyWith<LeaveBalanceQuery> get copyWith => _$LeaveBalanceQueryCopyWithImpl<LeaveBalanceQuery>(this as LeaveBalanceQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalanceQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.department, department) || other.department == department)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,search,department,page,pageSize);

@override
String toString() {
  return 'LeaveBalanceQuery(search: $search, department: $department, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceQueryCopyWith<$Res>  {
  factory $LeaveBalanceQueryCopyWith(LeaveBalanceQuery value, $Res Function(LeaveBalanceQuery) _then) = _$LeaveBalanceQueryCopyWithImpl;
@useResult
$Res call({
 String search, String? department, int page, int pageSize
});




}
/// @nodoc
class _$LeaveBalanceQueryCopyWithImpl<$Res>
    implements $LeaveBalanceQueryCopyWith<$Res> {
  _$LeaveBalanceQueryCopyWithImpl(this._self, this._then);

  final LeaveBalanceQuery _self;
  final $Res Function(LeaveBalanceQuery) _then;

/// Create a copy of LeaveBalanceQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? department = freezed,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveBalanceQuery].
extension LeaveBalanceQueryPatterns on LeaveBalanceQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalanceQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalanceQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalanceQuery value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalanceQuery value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  String? department,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalanceQuery() when $default != null:
return $default(_that.search,_that.department,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  String? department,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceQuery():
return $default(_that.search,_that.department,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  String? department,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceQuery() when $default != null:
return $default(_that.search,_that.department,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _LeaveBalanceQuery extends LeaveBalanceQuery {
  const _LeaveBalanceQuery({this.search = '', this.department, this.page = 1, this.pageSize = LeaveQuery.defaultPageSize}): super._();
  

@override@JsonKey() final  String search;
@override final  String? department;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of LeaveBalanceQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceQueryCopyWith<_LeaveBalanceQuery> get copyWith => __$LeaveBalanceQueryCopyWithImpl<_LeaveBalanceQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalanceQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.department, department) || other.department == department)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,search,department,page,pageSize);

@override
String toString() {
  return 'LeaveBalanceQuery(search: $search, department: $department, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceQueryCopyWith<$Res> implements $LeaveBalanceQueryCopyWith<$Res> {
  factory _$LeaveBalanceQueryCopyWith(_LeaveBalanceQuery value, $Res Function(_LeaveBalanceQuery) _then) = __$LeaveBalanceQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, String? department, int page, int pageSize
});




}
/// @nodoc
class __$LeaveBalanceQueryCopyWithImpl<$Res>
    implements _$LeaveBalanceQueryCopyWith<$Res> {
  __$LeaveBalanceQueryCopyWithImpl(this._self, this._then);

  final _LeaveBalanceQuery _self;
  final $Res Function(_LeaveBalanceQuery) _then;

/// Create a copy of LeaveBalanceQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? department = freezed,Object? page = null,Object? pageSize = null,}) {
  return _then(_LeaveBalanceQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
