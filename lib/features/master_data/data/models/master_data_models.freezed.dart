// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'master_data_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentModel {

@JsonKey(fromJson: idFromJson) String get id; String get name;/// Shown as "18 people" in the department picker when sent.
 int? get employeeCount;
/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentModelCopyWith<DepartmentModel> get copyWith => _$DepartmentModelCopyWithImpl<DepartmentModel>(this as DepartmentModel, _$identity);

  /// Serializes this DepartmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,employeeCount);

@override
String toString() {
  return 'DepartmentModel(id: $id, name: $name, employeeCount: $employeeCount)';
}


}

/// @nodoc
abstract mixin class $DepartmentModelCopyWith<$Res>  {
  factory $DepartmentModelCopyWith(DepartmentModel value, $Res Function(DepartmentModel) _then) = _$DepartmentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, int? employeeCount
});




}
/// @nodoc
class _$DepartmentModelCopyWithImpl<$Res>
    implements $DepartmentModelCopyWith<$Res> {
  _$DepartmentModelCopyWithImpl(this._self, this._then);

  final DepartmentModel _self;
  final $Res Function(DepartmentModel) _then;

/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? employeeCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeCount: freezed == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentModel].
extension DepartmentModelPatterns on DepartmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentModel value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  int? employeeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
return $default(_that.id,_that.name,_that.employeeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  int? employeeCount)  $default,) {final _that = this;
switch (_that) {
case _DepartmentModel():
return $default(_that.id,_that.name,_that.employeeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  int? employeeCount)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
return $default(_that.id,_that.name,_that.employeeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentModel implements DepartmentModel {
  const _DepartmentModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name, this.employeeCount});
  factory _DepartmentModel.fromJson(Map<String, dynamic> json) => _$DepartmentModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;
/// Shown as "18 people" in the department picker when sent.
@override final  int? employeeCount;

/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentModelCopyWith<_DepartmentModel> get copyWith => __$DepartmentModelCopyWithImpl<_DepartmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,employeeCount);

@override
String toString() {
  return 'DepartmentModel(id: $id, name: $name, employeeCount: $employeeCount)';
}


}

/// @nodoc
abstract mixin class _$DepartmentModelCopyWith<$Res> implements $DepartmentModelCopyWith<$Res> {
  factory _$DepartmentModelCopyWith(_DepartmentModel value, $Res Function(_DepartmentModel) _then) = __$DepartmentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, int? employeeCount
});




}
/// @nodoc
class __$DepartmentModelCopyWithImpl<$Res>
    implements _$DepartmentModelCopyWith<$Res> {
  __$DepartmentModelCopyWithImpl(this._self, this._then);

  final _DepartmentModel _self;
  final $Res Function(_DepartmentModel) _then;

/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? employeeCount = freezed,}) {
  return _then(_DepartmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeCount: freezed == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DesignationModel {

@JsonKey(fromJson: idFromJson) String get id; String get name;
/// Create a copy of DesignationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesignationModelCopyWith<DesignationModel> get copyWith => _$DesignationModelCopyWithImpl<DesignationModel>(this as DesignationModel, _$identity);

  /// Serializes this DesignationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesignationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'DesignationModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $DesignationModelCopyWith<$Res>  {
  factory $DesignationModelCopyWith(DesignationModel value, $Res Function(DesignationModel) _then) = _$DesignationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name
});




}
/// @nodoc
class _$DesignationModelCopyWithImpl<$Res>
    implements $DesignationModelCopyWith<$Res> {
  _$DesignationModelCopyWithImpl(this._self, this._then);

  final DesignationModel _self;
  final $Res Function(DesignationModel) _then;

/// Create a copy of DesignationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DesignationModel].
extension DesignationModelPatterns on DesignationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DesignationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DesignationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DesignationModel value)  $default,){
final _that = this;
switch (_that) {
case _DesignationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DesignationModel value)?  $default,){
final _that = this;
switch (_that) {
case _DesignationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DesignationModel() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _DesignationModel():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _DesignationModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DesignationModel implements DesignationModel {
  const _DesignationModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name});
  factory _DesignationModel.fromJson(Map<String, dynamic> json) => _$DesignationModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;

/// Create a copy of DesignationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DesignationModelCopyWith<_DesignationModel> get copyWith => __$DesignationModelCopyWithImpl<_DesignationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DesignationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DesignationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'DesignationModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$DesignationModelCopyWith<$Res> implements $DesignationModelCopyWith<$Res> {
  factory _$DesignationModelCopyWith(_DesignationModel value, $Res Function(_DesignationModel) _then) = __$DesignationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name
});




}
/// @nodoc
class __$DesignationModelCopyWithImpl<$Res>
    implements _$DesignationModelCopyWith<$Res> {
  __$DesignationModelCopyWithImpl(this._self, this._then);

  final _DesignationModel _self;
  final $Res Function(_DesignationModel) _then;

/// Create a copy of DesignationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_DesignationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
