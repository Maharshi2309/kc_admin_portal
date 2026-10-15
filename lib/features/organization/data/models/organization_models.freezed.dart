// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogItemModel {

@JsonKey(fromJson: idFromJson) String get id; String get name; bool get isActive;/// Employees who have it, active or not; shown before deactivating.
 int get employeeCount;
/// Create a copy of CatalogItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogItemModelCopyWith<CatalogItemModel> get copyWith => _$CatalogItemModelCopyWithImpl<CatalogItemModel>(this as CatalogItemModel, _$identity);

  /// Serializes this CatalogItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,employeeCount);

@override
String toString() {
  return 'CatalogItemModel(id: $id, name: $name, isActive: $isActive, employeeCount: $employeeCount)';
}


}

/// @nodoc
abstract mixin class $CatalogItemModelCopyWith<$Res>  {
  factory $CatalogItemModelCopyWith(CatalogItemModel value, $Res Function(CatalogItemModel) _then) = _$CatalogItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, bool isActive, int employeeCount
});




}
/// @nodoc
class _$CatalogItemModelCopyWithImpl<$Res>
    implements $CatalogItemModelCopyWith<$Res> {
  _$CatalogItemModelCopyWithImpl(this._self, this._then);

  final CatalogItemModel _self;
  final $Res Function(CatalogItemModel) _then;

/// Create a copy of CatalogItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? employeeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,employeeCount: null == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogItemModel].
extension CatalogItemModelPatterns on CatalogItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogItemModel value)  $default,){
final _that = this;
switch (_that) {
case _CatalogItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  bool isActive,  int employeeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogItemModel() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.employeeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  bool isActive,  int employeeCount)  $default,) {final _that = this;
switch (_that) {
case _CatalogItemModel():
return $default(_that.id,_that.name,_that.isActive,_that.employeeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  bool isActive,  int employeeCount)?  $default,) {final _that = this;
switch (_that) {
case _CatalogItemModel() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.employeeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogItemModel implements CatalogItemModel {
  const _CatalogItemModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name, this.isActive = true, this.employeeCount = 0});
  factory _CatalogItemModel.fromJson(Map<String, dynamic> json) => _$CatalogItemModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;
@override@JsonKey() final  bool isActive;
/// Employees who have it, active or not; shown before deactivating.
@override@JsonKey() final  int employeeCount;

/// Create a copy of CatalogItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogItemModelCopyWith<_CatalogItemModel> get copyWith => __$CatalogItemModelCopyWithImpl<_CatalogItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,employeeCount);

@override
String toString() {
  return 'CatalogItemModel(id: $id, name: $name, isActive: $isActive, employeeCount: $employeeCount)';
}


}

/// @nodoc
abstract mixin class _$CatalogItemModelCopyWith<$Res> implements $CatalogItemModelCopyWith<$Res> {
  factory _$CatalogItemModelCopyWith(_CatalogItemModel value, $Res Function(_CatalogItemModel) _then) = __$CatalogItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, bool isActive, int employeeCount
});




}
/// @nodoc
class __$CatalogItemModelCopyWithImpl<$Res>
    implements _$CatalogItemModelCopyWith<$Res> {
  __$CatalogItemModelCopyWithImpl(this._self, this._then);

  final _CatalogItemModel _self;
  final $Res Function(_CatalogItemModel) _then;

/// Create a copy of CatalogItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? employeeCount = null,}) {
  return _then(_CatalogItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,employeeCount: null == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrganizationSettingsModel {

/// Letters every EC number starts with, e.g. `KC` for `KC1001`.
 String get ecNumberPrefix;/// Minutes after the scheduled start before a punch-in counts as late.
 int get lateGraceMinutes;/// Starting values for a new employee's working schedule.
 DefaultScheduleModel get defaultSchedule;/// ISO country code (e.g. `IN`) for mobile numbers written without a
/// country code, and the one the mobile field starts on (2026-10-13).
/// Missing (older server): India.
 String get defaultCountry;
/// Create a copy of OrganizationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationSettingsModelCopyWith<OrganizationSettingsModel> get copyWith => _$OrganizationSettingsModelCopyWithImpl<OrganizationSettingsModel>(this as OrganizationSettingsModel, _$identity);

  /// Serializes this OrganizationSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationSettingsModel&&(identical(other.ecNumberPrefix, ecNumberPrefix) || other.ecNumberPrefix == ecNumberPrefix)&&(identical(other.lateGraceMinutes, lateGraceMinutes) || other.lateGraceMinutes == lateGraceMinutes)&&(identical(other.defaultSchedule, defaultSchedule) || other.defaultSchedule == defaultSchedule)&&(identical(other.defaultCountry, defaultCountry) || other.defaultCountry == defaultCountry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ecNumberPrefix,lateGraceMinutes,defaultSchedule,defaultCountry);

@override
String toString() {
  return 'OrganizationSettingsModel(ecNumberPrefix: $ecNumberPrefix, lateGraceMinutes: $lateGraceMinutes, defaultSchedule: $defaultSchedule, defaultCountry: $defaultCountry)';
}


}

/// @nodoc
abstract mixin class $OrganizationSettingsModelCopyWith<$Res>  {
  factory $OrganizationSettingsModelCopyWith(OrganizationSettingsModel value, $Res Function(OrganizationSettingsModel) _then) = _$OrganizationSettingsModelCopyWithImpl;
@useResult
$Res call({
 String ecNumberPrefix, int lateGraceMinutes, DefaultScheduleModel defaultSchedule, String defaultCountry
});


$DefaultScheduleModelCopyWith<$Res> get defaultSchedule;

}
/// @nodoc
class _$OrganizationSettingsModelCopyWithImpl<$Res>
    implements $OrganizationSettingsModelCopyWith<$Res> {
  _$OrganizationSettingsModelCopyWithImpl(this._self, this._then);

  final OrganizationSettingsModel _self;
  final $Res Function(OrganizationSettingsModel) _then;

/// Create a copy of OrganizationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ecNumberPrefix = null,Object? lateGraceMinutes = null,Object? defaultSchedule = null,Object? defaultCountry = null,}) {
  return _then(_self.copyWith(
ecNumberPrefix: null == ecNumberPrefix ? _self.ecNumberPrefix : ecNumberPrefix // ignore: cast_nullable_to_non_nullable
as String,lateGraceMinutes: null == lateGraceMinutes ? _self.lateGraceMinutes : lateGraceMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultSchedule: null == defaultSchedule ? _self.defaultSchedule : defaultSchedule // ignore: cast_nullable_to_non_nullable
as DefaultScheduleModel,defaultCountry: null == defaultCountry ? _self.defaultCountry : defaultCountry // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of OrganizationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DefaultScheduleModelCopyWith<$Res> get defaultSchedule {
  
  return $DefaultScheduleModelCopyWith<$Res>(_self.defaultSchedule, (value) {
    return _then(_self.copyWith(defaultSchedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrganizationSettingsModel].
extension OrganizationSettingsModelPatterns on OrganizationSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ecNumberPrefix,  int lateGraceMinutes,  DefaultScheduleModel defaultSchedule,  String defaultCountry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationSettingsModel() when $default != null:
return $default(_that.ecNumberPrefix,_that.lateGraceMinutes,_that.defaultSchedule,_that.defaultCountry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ecNumberPrefix,  int lateGraceMinutes,  DefaultScheduleModel defaultSchedule,  String defaultCountry)  $default,) {final _that = this;
switch (_that) {
case _OrganizationSettingsModel():
return $default(_that.ecNumberPrefix,_that.lateGraceMinutes,_that.defaultSchedule,_that.defaultCountry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ecNumberPrefix,  int lateGraceMinutes,  DefaultScheduleModel defaultSchedule,  String defaultCountry)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationSettingsModel() when $default != null:
return $default(_that.ecNumberPrefix,_that.lateGraceMinutes,_that.defaultSchedule,_that.defaultCountry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationSettingsModel implements OrganizationSettingsModel {
  const _OrganizationSettingsModel({required this.ecNumberPrefix, required this.lateGraceMinutes, required this.defaultSchedule, this.defaultCountry = PhoneUtils.defaultCountry});
  factory _OrganizationSettingsModel.fromJson(Map<String, dynamic> json) => _$OrganizationSettingsModelFromJson(json);

/// Letters every EC number starts with, e.g. `KC` for `KC1001`.
@override final  String ecNumberPrefix;
/// Minutes after the scheduled start before a punch-in counts as late.
@override final  int lateGraceMinutes;
/// Starting values for a new employee's working schedule.
@override final  DefaultScheduleModel defaultSchedule;
/// ISO country code (e.g. `IN`) for mobile numbers written without a
/// country code, and the one the mobile field starts on (2026-10-13).
/// Missing (older server): India.
@override@JsonKey() final  String defaultCountry;

/// Create a copy of OrganizationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationSettingsModelCopyWith<_OrganizationSettingsModel> get copyWith => __$OrganizationSettingsModelCopyWithImpl<_OrganizationSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationSettingsModel&&(identical(other.ecNumberPrefix, ecNumberPrefix) || other.ecNumberPrefix == ecNumberPrefix)&&(identical(other.lateGraceMinutes, lateGraceMinutes) || other.lateGraceMinutes == lateGraceMinutes)&&(identical(other.defaultSchedule, defaultSchedule) || other.defaultSchedule == defaultSchedule)&&(identical(other.defaultCountry, defaultCountry) || other.defaultCountry == defaultCountry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ecNumberPrefix,lateGraceMinutes,defaultSchedule,defaultCountry);

@override
String toString() {
  return 'OrganizationSettingsModel(ecNumberPrefix: $ecNumberPrefix, lateGraceMinutes: $lateGraceMinutes, defaultSchedule: $defaultSchedule, defaultCountry: $defaultCountry)';
}


}

/// @nodoc
abstract mixin class _$OrganizationSettingsModelCopyWith<$Res> implements $OrganizationSettingsModelCopyWith<$Res> {
  factory _$OrganizationSettingsModelCopyWith(_OrganizationSettingsModel value, $Res Function(_OrganizationSettingsModel) _then) = __$OrganizationSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String ecNumberPrefix, int lateGraceMinutes, DefaultScheduleModel defaultSchedule, String defaultCountry
});


@override $DefaultScheduleModelCopyWith<$Res> get defaultSchedule;

}
/// @nodoc
class __$OrganizationSettingsModelCopyWithImpl<$Res>
    implements _$OrganizationSettingsModelCopyWith<$Res> {
  __$OrganizationSettingsModelCopyWithImpl(this._self, this._then);

  final _OrganizationSettingsModel _self;
  final $Res Function(_OrganizationSettingsModel) _then;

/// Create a copy of OrganizationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ecNumberPrefix = null,Object? lateGraceMinutes = null,Object? defaultSchedule = null,Object? defaultCountry = null,}) {
  return _then(_OrganizationSettingsModel(
ecNumberPrefix: null == ecNumberPrefix ? _self.ecNumberPrefix : ecNumberPrefix // ignore: cast_nullable_to_non_nullable
as String,lateGraceMinutes: null == lateGraceMinutes ? _self.lateGraceMinutes : lateGraceMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultSchedule: null == defaultSchedule ? _self.defaultSchedule : defaultSchedule // ignore: cast_nullable_to_non_nullable
as DefaultScheduleModel,defaultCountry: null == defaultCountry ? _self.defaultCountry : defaultCountry // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of OrganizationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DefaultScheduleModelCopyWith<$Res> get defaultSchedule {
  
  return $DefaultScheduleModelCopyWith<$Res>(_self.defaultSchedule, (value) {
    return _then(_self.copyWith(defaultSchedule: value));
  });
}
}


/// @nodoc
mixin _$DefaultScheduleModel {

@ClockTimeConverter() ClockTime get startTime;@ClockTimeConverter() ClockTime get endTime; int get breakMinutes;@ClockTimeConverter() ClockTime? get breakStart;/// ISO weekdays (1 = Monday … 7 = Sunday).
 List<int> get weeklyOffDays;
/// Create a copy of DefaultScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultScheduleModelCopyWith<DefaultScheduleModel> get copyWith => _$DefaultScheduleModelCopyWithImpl<DefaultScheduleModel>(this as DefaultScheduleModel, _$identity);

  /// Serializes this DefaultScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultScheduleModel&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&const DeepCollectionEquality().equals(other.weeklyOffDays, weeklyOffDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,breakMinutes,breakStart,const DeepCollectionEquality().hash(weeklyOffDays));

@override
String toString() {
  return 'DefaultScheduleModel(startTime: $startTime, endTime: $endTime, breakMinutes: $breakMinutes, breakStart: $breakStart, weeklyOffDays: $weeklyOffDays)';
}


}

/// @nodoc
abstract mixin class $DefaultScheduleModelCopyWith<$Res>  {
  factory $DefaultScheduleModelCopyWith(DefaultScheduleModel value, $Res Function(DefaultScheduleModel) _then) = _$DefaultScheduleModelCopyWithImpl;
@useResult
$Res call({
@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int breakMinutes,@ClockTimeConverter() ClockTime? breakStart, List<int> weeklyOffDays
});




}
/// @nodoc
class _$DefaultScheduleModelCopyWithImpl<$Res>
    implements $DefaultScheduleModelCopyWith<$Res> {
  _$DefaultScheduleModelCopyWithImpl(this._self, this._then);

  final DefaultScheduleModel _self;
  final $Res Function(DefaultScheduleModel) _then;

/// Create a copy of DefaultScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,Object? breakMinutes = null,Object? breakStart = freezed,Object? weeklyOffDays = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as ClockTime?,weeklyOffDays: null == weeklyOffDays ? _self.weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [DefaultScheduleModel].
extension DefaultScheduleModelPatterns on DefaultScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DefaultScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DefaultScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DefaultScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _DefaultScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DefaultScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _DefaultScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart,  List<int> weeklyOffDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DefaultScheduleModel() when $default != null:
return $default(_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.weeklyOffDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart,  List<int> weeklyOffDays)  $default,) {final _that = this;
switch (_that) {
case _DefaultScheduleModel():
return $default(_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.weeklyOffDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ClockTimeConverter()  ClockTime startTime, @ClockTimeConverter()  ClockTime endTime,  int breakMinutes, @ClockTimeConverter()  ClockTime? breakStart,  List<int> weeklyOffDays)?  $default,) {final _that = this;
switch (_that) {
case _DefaultScheduleModel() when $default != null:
return $default(_that.startTime,_that.endTime,_that.breakMinutes,_that.breakStart,_that.weeklyOffDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DefaultScheduleModel implements DefaultScheduleModel {
  const _DefaultScheduleModel({@ClockTimeConverter() required this.startTime, @ClockTimeConverter() required this.endTime, required this.breakMinutes, @ClockTimeConverter() this.breakStart, required final  List<int> weeklyOffDays}): _weeklyOffDays = weeklyOffDays;
  factory _DefaultScheduleModel.fromJson(Map<String, dynamic> json) => _$DefaultScheduleModelFromJson(json);

@override@ClockTimeConverter() final  ClockTime startTime;
@override@ClockTimeConverter() final  ClockTime endTime;
@override final  int breakMinutes;
@override@ClockTimeConverter() final  ClockTime? breakStart;
/// ISO weekdays (1 = Monday … 7 = Sunday).
 final  List<int> _weeklyOffDays;
/// ISO weekdays (1 = Monday … 7 = Sunday).
@override List<int> get weeklyOffDays {
  if (_weeklyOffDays is EqualUnmodifiableListView) return _weeklyOffDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyOffDays);
}


/// Create a copy of DefaultScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultScheduleModelCopyWith<_DefaultScheduleModel> get copyWith => __$DefaultScheduleModelCopyWithImpl<_DefaultScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DefaultScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultScheduleModel&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&const DeepCollectionEquality().equals(other._weeklyOffDays, _weeklyOffDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,breakMinutes,breakStart,const DeepCollectionEquality().hash(_weeklyOffDays));

@override
String toString() {
  return 'DefaultScheduleModel(startTime: $startTime, endTime: $endTime, breakMinutes: $breakMinutes, breakStart: $breakStart, weeklyOffDays: $weeklyOffDays)';
}


}

/// @nodoc
abstract mixin class _$DefaultScheduleModelCopyWith<$Res> implements $DefaultScheduleModelCopyWith<$Res> {
  factory _$DefaultScheduleModelCopyWith(_DefaultScheduleModel value, $Res Function(_DefaultScheduleModel) _then) = __$DefaultScheduleModelCopyWithImpl;
@override @useResult
$Res call({
@ClockTimeConverter() ClockTime startTime,@ClockTimeConverter() ClockTime endTime, int breakMinutes,@ClockTimeConverter() ClockTime? breakStart, List<int> weeklyOffDays
});




}
/// @nodoc
class __$DefaultScheduleModelCopyWithImpl<$Res>
    implements _$DefaultScheduleModelCopyWith<$Res> {
  __$DefaultScheduleModelCopyWithImpl(this._self, this._then);

  final _DefaultScheduleModel _self;
  final $Res Function(_DefaultScheduleModel) _then;

/// Create a copy of DefaultScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,Object? breakMinutes = null,Object? breakStart = freezed,Object? weeklyOffDays = null,}) {
  return _then(_DefaultScheduleModel(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as ClockTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as ClockTime,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as ClockTime?,weeklyOffDays: null == weeklyOffDays ? _self._weeklyOffDays : weeklyOffDays // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$LeavePolicyModel {

/// Off: the organization only has unpaid leave.
 bool get paidLeaveEnabled; String get paidLeaveName; String get unpaidLeaveName;/// Paid days earned each month (0.5 steps).
 double get daysPerMonth;/// The most days the balance can hold; null for no limit.
 double? get carryForwardCap;/// The first month that earns days (employees who join later start in
/// their joining month).
@DateOnlyConverter() DateTime get accrualStartMonth;
/// Create a copy of LeavePolicyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeavePolicyModelCopyWith<LeavePolicyModel> get copyWith => _$LeavePolicyModelCopyWithImpl<LeavePolicyModel>(this as LeavePolicyModel, _$identity);

  /// Serializes this LeavePolicyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeavePolicyModel&&(identical(other.paidLeaveEnabled, paidLeaveEnabled) || other.paidLeaveEnabled == paidLeaveEnabled)&&(identical(other.paidLeaveName, paidLeaveName) || other.paidLeaveName == paidLeaveName)&&(identical(other.unpaidLeaveName, unpaidLeaveName) || other.unpaidLeaveName == unpaidLeaveName)&&(identical(other.daysPerMonth, daysPerMonth) || other.daysPerMonth == daysPerMonth)&&(identical(other.carryForwardCap, carryForwardCap) || other.carryForwardCap == carryForwardCap)&&(identical(other.accrualStartMonth, accrualStartMonth) || other.accrualStartMonth == accrualStartMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paidLeaveEnabled,paidLeaveName,unpaidLeaveName,daysPerMonth,carryForwardCap,accrualStartMonth);

@override
String toString() {
  return 'LeavePolicyModel(paidLeaveEnabled: $paidLeaveEnabled, paidLeaveName: $paidLeaveName, unpaidLeaveName: $unpaidLeaveName, daysPerMonth: $daysPerMonth, carryForwardCap: $carryForwardCap, accrualStartMonth: $accrualStartMonth)';
}


}

/// @nodoc
abstract mixin class $LeavePolicyModelCopyWith<$Res>  {
  factory $LeavePolicyModelCopyWith(LeavePolicyModel value, $Res Function(LeavePolicyModel) _then) = _$LeavePolicyModelCopyWithImpl;
@useResult
$Res call({
 bool paidLeaveEnabled, String paidLeaveName, String unpaidLeaveName, double daysPerMonth, double? carryForwardCap,@DateOnlyConverter() DateTime accrualStartMonth
});




}
/// @nodoc
class _$LeavePolicyModelCopyWithImpl<$Res>
    implements $LeavePolicyModelCopyWith<$Res> {
  _$LeavePolicyModelCopyWithImpl(this._self, this._then);

  final LeavePolicyModel _self;
  final $Res Function(LeavePolicyModel) _then;

/// Create a copy of LeavePolicyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paidLeaveEnabled = null,Object? paidLeaveName = null,Object? unpaidLeaveName = null,Object? daysPerMonth = null,Object? carryForwardCap = freezed,Object? accrualStartMonth = null,}) {
  return _then(_self.copyWith(
paidLeaveEnabled: null == paidLeaveEnabled ? _self.paidLeaveEnabled : paidLeaveEnabled // ignore: cast_nullable_to_non_nullable
as bool,paidLeaveName: null == paidLeaveName ? _self.paidLeaveName : paidLeaveName // ignore: cast_nullable_to_non_nullable
as String,unpaidLeaveName: null == unpaidLeaveName ? _self.unpaidLeaveName : unpaidLeaveName // ignore: cast_nullable_to_non_nullable
as String,daysPerMonth: null == daysPerMonth ? _self.daysPerMonth : daysPerMonth // ignore: cast_nullable_to_non_nullable
as double,carryForwardCap: freezed == carryForwardCap ? _self.carryForwardCap : carryForwardCap // ignore: cast_nullable_to_non_nullable
as double?,accrualStartMonth: null == accrualStartMonth ? _self.accrualStartMonth : accrualStartMonth // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LeavePolicyModel].
extension LeavePolicyModelPatterns on LeavePolicyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeavePolicyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeavePolicyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeavePolicyModel value)  $default,){
final _that = this;
switch (_that) {
case _LeavePolicyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeavePolicyModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeavePolicyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool paidLeaveEnabled,  String paidLeaveName,  String unpaidLeaveName,  double daysPerMonth,  double? carryForwardCap, @DateOnlyConverter()  DateTime accrualStartMonth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeavePolicyModel() when $default != null:
return $default(_that.paidLeaveEnabled,_that.paidLeaveName,_that.unpaidLeaveName,_that.daysPerMonth,_that.carryForwardCap,_that.accrualStartMonth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool paidLeaveEnabled,  String paidLeaveName,  String unpaidLeaveName,  double daysPerMonth,  double? carryForwardCap, @DateOnlyConverter()  DateTime accrualStartMonth)  $default,) {final _that = this;
switch (_that) {
case _LeavePolicyModel():
return $default(_that.paidLeaveEnabled,_that.paidLeaveName,_that.unpaidLeaveName,_that.daysPerMonth,_that.carryForwardCap,_that.accrualStartMonth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool paidLeaveEnabled,  String paidLeaveName,  String unpaidLeaveName,  double daysPerMonth,  double? carryForwardCap, @DateOnlyConverter()  DateTime accrualStartMonth)?  $default,) {final _that = this;
switch (_that) {
case _LeavePolicyModel() when $default != null:
return $default(_that.paidLeaveEnabled,_that.paidLeaveName,_that.unpaidLeaveName,_that.daysPerMonth,_that.carryForwardCap,_that.accrualStartMonth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeavePolicyModel implements LeavePolicyModel {
  const _LeavePolicyModel({required this.paidLeaveEnabled, required this.paidLeaveName, required this.unpaidLeaveName, required this.daysPerMonth, this.carryForwardCap, @DateOnlyConverter() required this.accrualStartMonth});
  factory _LeavePolicyModel.fromJson(Map<String, dynamic> json) => _$LeavePolicyModelFromJson(json);

/// Off: the organization only has unpaid leave.
@override final  bool paidLeaveEnabled;
@override final  String paidLeaveName;
@override final  String unpaidLeaveName;
/// Paid days earned each month (0.5 steps).
@override final  double daysPerMonth;
/// The most days the balance can hold; null for no limit.
@override final  double? carryForwardCap;
/// The first month that earns days (employees who join later start in
/// their joining month).
@override@DateOnlyConverter() final  DateTime accrualStartMonth;

/// Create a copy of LeavePolicyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeavePolicyModelCopyWith<_LeavePolicyModel> get copyWith => __$LeavePolicyModelCopyWithImpl<_LeavePolicyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeavePolicyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeavePolicyModel&&(identical(other.paidLeaveEnabled, paidLeaveEnabled) || other.paidLeaveEnabled == paidLeaveEnabled)&&(identical(other.paidLeaveName, paidLeaveName) || other.paidLeaveName == paidLeaveName)&&(identical(other.unpaidLeaveName, unpaidLeaveName) || other.unpaidLeaveName == unpaidLeaveName)&&(identical(other.daysPerMonth, daysPerMonth) || other.daysPerMonth == daysPerMonth)&&(identical(other.carryForwardCap, carryForwardCap) || other.carryForwardCap == carryForwardCap)&&(identical(other.accrualStartMonth, accrualStartMonth) || other.accrualStartMonth == accrualStartMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paidLeaveEnabled,paidLeaveName,unpaidLeaveName,daysPerMonth,carryForwardCap,accrualStartMonth);

@override
String toString() {
  return 'LeavePolicyModel(paidLeaveEnabled: $paidLeaveEnabled, paidLeaveName: $paidLeaveName, unpaidLeaveName: $unpaidLeaveName, daysPerMonth: $daysPerMonth, carryForwardCap: $carryForwardCap, accrualStartMonth: $accrualStartMonth)';
}


}

/// @nodoc
abstract mixin class _$LeavePolicyModelCopyWith<$Res> implements $LeavePolicyModelCopyWith<$Res> {
  factory _$LeavePolicyModelCopyWith(_LeavePolicyModel value, $Res Function(_LeavePolicyModel) _then) = __$LeavePolicyModelCopyWithImpl;
@override @useResult
$Res call({
 bool paidLeaveEnabled, String paidLeaveName, String unpaidLeaveName, double daysPerMonth, double? carryForwardCap,@DateOnlyConverter() DateTime accrualStartMonth
});




}
/// @nodoc
class __$LeavePolicyModelCopyWithImpl<$Res>
    implements _$LeavePolicyModelCopyWith<$Res> {
  __$LeavePolicyModelCopyWithImpl(this._self, this._then);

  final _LeavePolicyModel _self;
  final $Res Function(_LeavePolicyModel) _then;

/// Create a copy of LeavePolicyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paidLeaveEnabled = null,Object? paidLeaveName = null,Object? unpaidLeaveName = null,Object? daysPerMonth = null,Object? carryForwardCap = freezed,Object? accrualStartMonth = null,}) {
  return _then(_LeavePolicyModel(
paidLeaveEnabled: null == paidLeaveEnabled ? _self.paidLeaveEnabled : paidLeaveEnabled // ignore: cast_nullable_to_non_nullable
as bool,paidLeaveName: null == paidLeaveName ? _self.paidLeaveName : paidLeaveName // ignore: cast_nullable_to_non_nullable
as String,unpaidLeaveName: null == unpaidLeaveName ? _self.unpaidLeaveName : unpaidLeaveName // ignore: cast_nullable_to_non_nullable
as String,daysPerMonth: null == daysPerMonth ? _self.daysPerMonth : daysPerMonth // ignore: cast_nullable_to_non_nullable
as double,carryForwardCap: freezed == carryForwardCap ? _self.carryForwardCap : carryForwardCap // ignore: cast_nullable_to_non_nullable
as double?,accrualStartMonth: null == accrualStartMonth ? _self.accrualStartMonth : accrualStartMonth // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
