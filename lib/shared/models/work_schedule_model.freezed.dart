// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkScheduleModel {

@JsonKey(fromJson: idFromJson) String get id;@DateOnlyConverter() DateTime get effectiveFrom;/// Null while this version is current.
@DateOnlyConverter() DateTime? get effectiveTo;@ClockTimeConverter() ClockTime get startTime;@ClockTimeConverter() ClockTime get endTime; int get breakMinutes;@ClockTimeConverter() ClockTime? get breakStart;@ClockTimeConverter() ClockTime? get breakEnd;/// ISO weekdays: 1 = Monday … 7 = Sunday.
 List<int> get weeklyOffDays; int get expectedMinutes; NamedRef? get createdBy;@CompanyDateTimeConverter() DateTime? get createdAt;
/// Create a copy of WorkScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkScheduleModelCopyWith<WorkScheduleModel> get copyWith => _$WorkScheduleModelCopyWithImpl<WorkScheduleModel>(this as WorkScheduleModel, _$identity);

  /// Serializes this WorkScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&const DeepCollectionEquality().equals(other.weeklyOffDays, weeklyOffDays)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,effectiveFrom,effectiveTo,startTime,endTime,breakMinutes,breakStart,breakEnd,const DeepCollectionEquality().hash(weeklyOffDays),expectedMinutes,createdBy,createdAt);

@override
String toString() {
  return 'WorkScheduleModel(id: $id, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, startTime: $startTime, endTime: $endTime, breakMinutes: $breakMinutes, breakStart: $breakStart, breakEnd: $breakEnd, weeklyOffDays: $weeklyOffDays, expectedMinutes: $expectedMinutes, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WorkScheduleModelCopyWith<$Res>  {
  factory $WorkScheduleModelCopyWith(WorkScheduleModel value, $Res Function(WorkScheduleModel) _then) = _$WorkScheduleModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id,@DateOnlyConverter() DateTime effectiveFrom,@DateOnlyConverter() DateTime? effectiveTo,@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int breakMinutes,@ClockTimeConverter() ClockTime? breakStart,@ClockTimeConverter() ClockTime? breakEnd, List<int> weeklyOffDays, int expectedMinutes, NamedRef? createdBy,@CompanyDateTimeConverter() DateTime? createdAt
});


$NamedRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class _$WorkScheduleModelCopyWithImpl<$Res>
    implements $WorkScheduleModelCopyWith<$Res> {
  _$WorkScheduleModelCopyWithImpl(this._self, this._then);

  final WorkScheduleModel _self;
  final $Res Function(WorkScheduleModel) _then;

/// Create a copy of WorkScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? startTime = null,Object? endTime = null,Object? breakMinutes = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? weeklyOffDays = null,Object? expectedMinutes = null,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as ClockTime?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as ClockTime?,weeklyOffDays: null == weeklyOffDays ? _self.weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as NamedRef?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of WorkScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.createdBy!, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkScheduleModel].
extension WorkScheduleModelPatterns on WorkScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime effectiveFrom, @DateOnlyConverter()  DateTime? effectiveTo, @ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart, @ClockTimeConverter()  ClockTime? breakEnd,  List<int> weeklyOffDays,  int expectedMinutes,  NamedRef? createdBy, @CompanyDateTimeConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkScheduleModel() when $default != null:
return $default(_that.id,_that.effectiveFrom,_that.effectiveTo,_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.breakEnd,_that.weeklyOffDays,_that.expectedMinutes,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime effectiveFrom, @DateOnlyConverter()  DateTime? effectiveTo, @ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart, @ClockTimeConverter()  ClockTime? breakEnd,  List<int> weeklyOffDays,  int expectedMinutes,  NamedRef? createdBy, @CompanyDateTimeConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _WorkScheduleModel():
return $default(_that.id,_that.effectiveFrom,_that.effectiveTo,_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.breakEnd,_that.weeklyOffDays,_that.expectedMinutes,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime effectiveFrom, @DateOnlyConverter()  DateTime? effectiveTo, @ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart, @ClockTimeConverter()  ClockTime? breakEnd,  List<int> weeklyOffDays,  int expectedMinutes,  NamedRef? createdBy, @CompanyDateTimeConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkScheduleModel() when $default != null:
return $default(_that.id,_that.effectiveFrom,_that.effectiveTo,_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.breakEnd,_that.weeklyOffDays,_that.expectedMinutes,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkScheduleModel implements WorkScheduleModel {
  const _WorkScheduleModel({@JsonKey(fromJson: idFromJson) required this.id, @DateOnlyConverter() required this.effectiveFrom, @DateOnlyConverter() this.effectiveTo, @ClockTimeConverter() required this.startTime, @ClockTimeConverter() required this.endTime, required this.breakMinutes, @ClockTimeConverter() this.breakStart, @ClockTimeConverter() this.breakEnd, required final  List<int> weeklyOffDays, required this.expectedMinutes, this.createdBy, @CompanyDateTimeConverter() this.createdAt}): _weeklyOffDays = weeklyOffDays;
  factory _WorkScheduleModel.fromJson(Map<String, dynamic> json) => _$WorkScheduleModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override@DateOnlyConverter() final  DateTime effectiveFrom;
/// Null while this version is current.
@override@DateOnlyConverter() final  DateTime? effectiveTo;
@override@ClockTimeConverter() final  ClockTime startTime;
@override@ClockTimeConverter() final  ClockTime endTime;
@override final  int breakMinutes;
@override@ClockTimeConverter() final  ClockTime? breakStart;
@override@ClockTimeConverter() final  ClockTime? breakEnd;
/// ISO weekdays: 1 = Monday … 7 = Sunday.
 final  List<int> _weeklyOffDays;
/// ISO weekdays: 1 = Monday … 7 = Sunday.
@override List<int> get weeklyOffDays {
  if (_weeklyOffDays is EqualUnmodifiableListView) return _weeklyOffDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyOffDays);
}

@override final  int expectedMinutes;
@override final  NamedRef? createdBy;
@override@CompanyDateTimeConverter() final  DateTime? createdAt;

/// Create a copy of WorkScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkScheduleModelCopyWith<_WorkScheduleModel> get copyWith => __$WorkScheduleModelCopyWithImpl<_WorkScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&const DeepCollectionEquality().equals(other._weeklyOffDays, _weeklyOffDays)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,effectiveFrom,effectiveTo,startTime,endTime,breakMinutes,breakStart,breakEnd,const DeepCollectionEquality().hash(_weeklyOffDays),expectedMinutes,createdBy,createdAt);

@override
String toString() {
  return 'WorkScheduleModel(id: $id, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, startTime: $startTime, endTime: $endTime, breakMinutes: $breakMinutes, breakStart: $breakStart, breakEnd: $breakEnd, weeklyOffDays: $weeklyOffDays, expectedMinutes: $expectedMinutes, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WorkScheduleModelCopyWith<$Res> implements $WorkScheduleModelCopyWith<$Res> {
  factory _$WorkScheduleModelCopyWith(_WorkScheduleModel value, $Res Function(_WorkScheduleModel) _then) = __$WorkScheduleModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id,@DateOnlyConverter() DateTime effectiveFrom,@DateOnlyConverter() DateTime? effectiveTo,@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int breakMinutes,@ClockTimeConverter() ClockTime? breakStart,@ClockTimeConverter() ClockTime? breakEnd, List<int> weeklyOffDays, int expectedMinutes, NamedRef? createdBy,@CompanyDateTimeConverter() DateTime? createdAt
});


@override $NamedRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class __$WorkScheduleModelCopyWithImpl<$Res>
    implements _$WorkScheduleModelCopyWith<$Res> {
  __$WorkScheduleModelCopyWithImpl(this._self, this._then);

  final _WorkScheduleModel _self;
  final $Res Function(_WorkScheduleModel) _then;

/// Create a copy of WorkScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? startTime = null,Object? endTime = null,Object? breakMinutes = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? weeklyOffDays = null,Object? expectedMinutes = null,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_WorkScheduleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as ClockTime?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as ClockTime?,weeklyOffDays: null == weeklyOffDays ? _self._weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as NamedRef?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of WorkScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.createdBy!, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// @nodoc
mixin _$ScheduleSnapshotModel {

@ClockTimeConverter() ClockTime get startTime;@ClockTimeConverter() ClockTime get endTime; int get expectedMinutes;
/// Create a copy of ScheduleSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleSnapshotModelCopyWith<ScheduleSnapshotModel> get copyWith => _$ScheduleSnapshotModelCopyWithImpl<ScheduleSnapshotModel>(this as ScheduleSnapshotModel, _$identity);

  /// Serializes this ScheduleSnapshotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleSnapshotModel&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,expectedMinutes);

@override
String toString() {
  return 'ScheduleSnapshotModel(startTime: $startTime, endTime: $endTime, expectedMinutes: $expectedMinutes)';
}


}

/// @nodoc
abstract mixin class $ScheduleSnapshotModelCopyWith<$Res>  {
  factory $ScheduleSnapshotModelCopyWith(ScheduleSnapshotModel value, $Res Function(ScheduleSnapshotModel) _then) = _$ScheduleSnapshotModelCopyWithImpl;
@useResult
$Res call({
@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int expectedMinutes
});




}
/// @nodoc
class _$ScheduleSnapshotModelCopyWithImpl<$Res>
    implements $ScheduleSnapshotModelCopyWith<$Res> {
  _$ScheduleSnapshotModelCopyWithImpl(this._self, this._then);

  final ScheduleSnapshotModel _self;
  final $Res Function(ScheduleSnapshotModel) _then;

/// Create a copy of ScheduleSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,Object? expectedMinutes = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleSnapshotModel].
extension ScheduleSnapshotModelPatterns on ScheduleSnapshotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleSnapshotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleSnapshotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleSnapshotModel value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleSnapshotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleSnapshotModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleSnapshotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int expectedMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleSnapshotModel() when $default != null:
return $default(_that.startTime,_that.endTime,_that.expectedMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int expectedMinutes)  $default,) {final _that = this;
switch (_that) {
case _ScheduleSnapshotModel():
return $default(_that.startTime,_that.endTime,_that.expectedMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int expectedMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleSnapshotModel() when $default != null:
return $default(_that.startTime,_that.endTime,_that.expectedMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleSnapshotModel implements ScheduleSnapshotModel {
  const _ScheduleSnapshotModel({@ClockTimeConverter() required this.startTime, @ClockTimeConverter() required this.endTime, required this.expectedMinutes});
  factory _ScheduleSnapshotModel.fromJson(Map<String, dynamic> json) => _$ScheduleSnapshotModelFromJson(json);

@override@ClockTimeConverter() final  ClockTime startTime;
@override@ClockTimeConverter() final  ClockTime endTime;
@override final  int expectedMinutes;

/// Create a copy of ScheduleSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleSnapshotModelCopyWith<_ScheduleSnapshotModel> get copyWith => __$ScheduleSnapshotModelCopyWithImpl<_ScheduleSnapshotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleSnapshotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleSnapshotModel&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.expectedMinutes, expectedMinutes) || other.expectedMinutes == expectedMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,expectedMinutes);

@override
String toString() {
  return 'ScheduleSnapshotModel(startTime: $startTime, endTime: $endTime, expectedMinutes: $expectedMinutes)';
}


}

/// @nodoc
abstract mixin class _$ScheduleSnapshotModelCopyWith<$Res> implements $ScheduleSnapshotModelCopyWith<$Res> {
  factory _$ScheduleSnapshotModelCopyWith(_ScheduleSnapshotModel value, $Res Function(_ScheduleSnapshotModel) _then) = __$ScheduleSnapshotModelCopyWithImpl;
@override @useResult
$Res call({
@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int expectedMinutes
});




}
/// @nodoc
class __$ScheduleSnapshotModelCopyWithImpl<$Res>
    implements _$ScheduleSnapshotModelCopyWith<$Res> {
  __$ScheduleSnapshotModelCopyWithImpl(this._self, this._then);

  final _ScheduleSnapshotModel _self;
  final $Res Function(_ScheduleSnapshotModel) _then;

/// Create a copy of ScheduleSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,Object? expectedMinutes = null,}) {
  return _then(_ScheduleSnapshotModel(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,expectedMinutes: null == expectedMinutes ? _self.expectedMinutes : expectedMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkScheduleInput {

@DateOnlyConverter() DateTime get effectiveFrom;@ClockTimeConverter() ClockTime get startTime;@ClockTimeConverter() ClockTime get endTime; int get breakMinutes;@ClockTimeConverter() ClockTime? get breakStart;@ClockTimeConverter() ClockTime? get breakEnd; List<int> get weeklyOffDays;
/// Create a copy of WorkScheduleInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkScheduleInputCopyWith<WorkScheduleInput> get copyWith => _$WorkScheduleInputCopyWithImpl<WorkScheduleInput>(this as WorkScheduleInput, _$identity);

  /// Serializes this WorkScheduleInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkScheduleInput&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&const DeepCollectionEquality().equals(other.weeklyOffDays, weeklyOffDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveFrom,startTime,endTime,breakMinutes,breakStart,breakEnd,const DeepCollectionEquality().hash(weeklyOffDays));

@override
String toString() {
  return 'WorkScheduleInput(effectiveFrom: $effectiveFrom, startTime: $startTime, endTime: $endTime, breakMinutes: $breakMinutes, breakStart: $breakStart, breakEnd: $breakEnd, weeklyOffDays: $weeklyOffDays)';
}


}

/// @nodoc
abstract mixin class $WorkScheduleInputCopyWith<$Res>  {
  factory $WorkScheduleInputCopyWith(WorkScheduleInput value, $Res Function(WorkScheduleInput) _then) = _$WorkScheduleInputCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime effectiveFrom,@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int breakMinutes,@ClockTimeConverter() ClockTime? breakStart,@ClockTimeConverter() ClockTime? breakEnd, List<int> weeklyOffDays
});




}
/// @nodoc
class _$WorkScheduleInputCopyWithImpl<$Res>
    implements $WorkScheduleInputCopyWith<$Res> {
  _$WorkScheduleInputCopyWithImpl(this._self, this._then);

  final WorkScheduleInput _self;
  final $Res Function(WorkScheduleInput) _then;

/// Create a copy of WorkScheduleInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? effectiveFrom = null,Object? startTime = null,Object? endTime = null,Object? breakMinutes = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? weeklyOffDays = null,}) {
  return _then(_self.copyWith(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as ClockTime?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as ClockTime?,weeklyOffDays: null == weeklyOffDays ? _self.weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkScheduleInput].
extension WorkScheduleInputPatterns on WorkScheduleInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkScheduleInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkScheduleInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkScheduleInput value)  $default,){
final _that = this;
switch (_that) {
case _WorkScheduleInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkScheduleInput value)?  $default,){
final _that = this;
switch (_that) {
case _WorkScheduleInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime effectiveFrom, @ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart, @ClockTimeConverter()  ClockTime? breakEnd,  List<int> weeklyOffDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkScheduleInput() when $default != null:
return $default(_that.effectiveFrom,_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.breakEnd,_that.weeklyOffDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime effectiveFrom, @ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart, @ClockTimeConverter()  ClockTime? breakEnd,  List<int> weeklyOffDays)  $default,) {final _that = this;
switch (_that) {
case _WorkScheduleInput():
return $default(_that.effectiveFrom,_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.breakEnd,_that.weeklyOffDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime effectiveFrom, @ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart, @ClockTimeConverter()  ClockTime? breakEnd,  List<int> weeklyOffDays)?  $default,) {final _that = this;
switch (_that) {
case _WorkScheduleInput() when $default != null:
return $default(_that.effectiveFrom,_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.breakEnd,_that.weeklyOffDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkScheduleInput implements WorkScheduleInput {
  const _WorkScheduleInput({@DateOnlyConverter() required this.effectiveFrom, @ClockTimeConverter() required this.startTime, @ClockTimeConverter() required this.endTime, required this.breakMinutes, @ClockTimeConverter() this.breakStart, @ClockTimeConverter() this.breakEnd, required final  List<int> weeklyOffDays}): _weeklyOffDays = weeklyOffDays;
  factory _WorkScheduleInput.fromJson(Map<String, dynamic> json) => _$WorkScheduleInputFromJson(json);

@override@DateOnlyConverter() final  DateTime effectiveFrom;
@override@ClockTimeConverter() final  ClockTime startTime;
@override@ClockTimeConverter() final  ClockTime endTime;
@override final  int breakMinutes;
@override@ClockTimeConverter() final  ClockTime? breakStart;
@override@ClockTimeConverter() final  ClockTime? breakEnd;
 final  List<int> _weeklyOffDays;
@override List<int> get weeklyOffDays {
  if (_weeklyOffDays is EqualUnmodifiableListView) return _weeklyOffDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyOffDays);
}


/// Create a copy of WorkScheduleInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkScheduleInputCopyWith<_WorkScheduleInput> get copyWith => __$WorkScheduleInputCopyWithImpl<_WorkScheduleInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkScheduleInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkScheduleInput&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&const DeepCollectionEquality().equals(other._weeklyOffDays, _weeklyOffDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveFrom,startTime,endTime,breakMinutes,breakStart,breakEnd,const DeepCollectionEquality().hash(_weeklyOffDays));

@override
String toString() {
  return 'WorkScheduleInput(effectiveFrom: $effectiveFrom, startTime: $startTime, endTime: $endTime, breakMinutes: $breakMinutes, breakStart: $breakStart, breakEnd: $breakEnd, weeklyOffDays: $weeklyOffDays)';
}


}

/// @nodoc
abstract mixin class _$WorkScheduleInputCopyWith<$Res> implements $WorkScheduleInputCopyWith<$Res> {
  factory _$WorkScheduleInputCopyWith(_WorkScheduleInput value, $Res Function(_WorkScheduleInput) _then) = __$WorkScheduleInputCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime effectiveFrom,@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int breakMinutes,@ClockTimeConverter() ClockTime? breakStart,@ClockTimeConverter() ClockTime? breakEnd, List<int> weeklyOffDays
});




}
/// @nodoc
class __$WorkScheduleInputCopyWithImpl<$Res>
    implements _$WorkScheduleInputCopyWith<$Res> {
  __$WorkScheduleInputCopyWithImpl(this._self, this._then);

  final _WorkScheduleInput _self;
  final $Res Function(_WorkScheduleInput) _then;

/// Create a copy of WorkScheduleInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? effectiveFrom = null,Object? startTime = null,Object? endTime = null,Object? breakMinutes = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? weeklyOffDays = null,}) {
  return _then(_WorkScheduleInput(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as ClockTime?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as ClockTime?,weeklyOffDays: null == weeklyOffDays ? _self._weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
