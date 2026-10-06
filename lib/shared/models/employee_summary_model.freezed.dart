// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployeeSummaryModel {

@JsonKey(fromJson: idFromJson) String get id; String get name; String get ecNumber; NamedRef? get department; NamedRef? get position;
/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<EmployeeSummaryModel> get copyWith => _$EmployeeSummaryModelCopyWithImpl<EmployeeSummaryModel>(this as EmployeeSummaryModel, _$identity);

  /// Serializes this EmployeeSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.department, department) || other.department == department)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ecNumber,department,position);

@override
String toString() {
  return 'EmployeeSummaryModel(id: $id, name: $name, ecNumber: $ecNumber, department: $department, position: $position)';
}


}

/// @nodoc
abstract mixin class $EmployeeSummaryModelCopyWith<$Res>  {
  factory $EmployeeSummaryModelCopyWith(EmployeeSummaryModel value, $Res Function(EmployeeSummaryModel) _then) = _$EmployeeSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, String ecNumber, NamedRef? department, NamedRef? position
});


$NamedRefCopyWith<$Res>? get department;$NamedRefCopyWith<$Res>? get position;

}
/// @nodoc
class _$EmployeeSummaryModelCopyWithImpl<$Res>
    implements $EmployeeSummaryModelCopyWith<$Res> {
  _$EmployeeSummaryModelCopyWithImpl(this._self, this._then);

  final EmployeeSummaryModel _self;
  final $Res Function(EmployeeSummaryModel) _then;

/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ecNumber = null,Object? department = freezed,Object? position = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ecNumber: null == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as NamedRef?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as NamedRef?,
  ));
}
/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get department {
    if (_self.department == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.department!, (value) {
    return _then(_self.copyWith(department: value));
  });
}/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeSummaryModel].
extension EmployeeSummaryModelPatterns on EmployeeSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String ecNumber,  NamedRef? department,  NamedRef? position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeSummaryModel() when $default != null:
return $default(_that.id,_that.name,_that.ecNumber,_that.department,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String ecNumber,  NamedRef? department,  NamedRef? position)  $default,) {final _that = this;
switch (_that) {
case _EmployeeSummaryModel():
return $default(_that.id,_that.name,_that.ecNumber,_that.department,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String ecNumber,  NamedRef? department,  NamedRef? position)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeSummaryModel() when $default != null:
return $default(_that.id,_that.name,_that.ecNumber,_that.department,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeSummaryModel implements EmployeeSummaryModel {
  const _EmployeeSummaryModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name, required this.ecNumber, this.department, this.position});
  factory _EmployeeSummaryModel.fromJson(Map<String, dynamic> json) => _$EmployeeSummaryModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;
@override final  String ecNumber;
@override final  NamedRef? department;
@override final  NamedRef? position;

/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeSummaryModelCopyWith<_EmployeeSummaryModel> get copyWith => __$EmployeeSummaryModelCopyWithImpl<_EmployeeSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.department, department) || other.department == department)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ecNumber,department,position);

@override
String toString() {
  return 'EmployeeSummaryModel(id: $id, name: $name, ecNumber: $ecNumber, department: $department, position: $position)';
}


}

/// @nodoc
abstract mixin class _$EmployeeSummaryModelCopyWith<$Res> implements $EmployeeSummaryModelCopyWith<$Res> {
  factory _$EmployeeSummaryModelCopyWith(_EmployeeSummaryModel value, $Res Function(_EmployeeSummaryModel) _then) = __$EmployeeSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, String ecNumber, NamedRef? department, NamedRef? position
});


@override $NamedRefCopyWith<$Res>? get department;@override $NamedRefCopyWith<$Res>? get position;

}
/// @nodoc
class __$EmployeeSummaryModelCopyWithImpl<$Res>
    implements _$EmployeeSummaryModelCopyWith<$Res> {
  __$EmployeeSummaryModelCopyWithImpl(this._self, this._then);

  final _EmployeeSummaryModel _self;
  final $Res Function(_EmployeeSummaryModel) _then;

/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ecNumber = null,Object? department = freezed,Object? position = freezed,}) {
  return _then(_EmployeeSummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ecNumber: null == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as NamedRef?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as NamedRef?,
  ));
}

/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get department {
    if (_self.department == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.department!, (value) {
    return _then(_self.copyWith(department: value));
  });
}/// Create a copy of EmployeeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

// dart format on
