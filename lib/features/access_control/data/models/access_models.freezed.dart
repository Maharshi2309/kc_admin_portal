// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermissionModuleModel {

/// e.g. `employee`.
 String get module;/// e.g. "Employees".
 String get label; List<PermissionModel> get permissions;
/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionModuleModelCopyWith<PermissionModuleModel> get copyWith => _$PermissionModuleModelCopyWithImpl<PermissionModuleModel>(this as PermissionModuleModel, _$identity);

  /// Serializes this PermissionModuleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionModuleModel&&(identical(other.module, module) || other.module == module)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.permissions, permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,module,label,const DeepCollectionEquality().hash(permissions));

@override
String toString() {
  return 'PermissionModuleModel(module: $module, label: $label, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class $PermissionModuleModelCopyWith<$Res>  {
  factory $PermissionModuleModelCopyWith(PermissionModuleModel value, $Res Function(PermissionModuleModel) _then) = _$PermissionModuleModelCopyWithImpl;
@useResult
$Res call({
 String module, String label, List<PermissionModel> permissions
});




}
/// @nodoc
class _$PermissionModuleModelCopyWithImpl<$Res>
    implements $PermissionModuleModelCopyWith<$Res> {
  _$PermissionModuleModelCopyWithImpl(this._self, this._then);

  final PermissionModuleModel _self;
  final $Res Function(PermissionModuleModel) _then;

/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? module = null,Object? label = null,Object? permissions = null,}) {
  return _then(_self.copyWith(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<PermissionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionModuleModel].
extension PermissionModuleModelPatterns on PermissionModuleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionModuleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionModuleModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionModuleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionModuleModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String module,  String label,  List<PermissionModel> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
return $default(_that.module,_that.label,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String module,  String label,  List<PermissionModel> permissions)  $default,) {final _that = this;
switch (_that) {
case _PermissionModuleModel():
return $default(_that.module,_that.label,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String module,  String label,  List<PermissionModel> permissions)?  $default,) {final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
return $default(_that.module,_that.label,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionModuleModel implements PermissionModuleModel {
  const _PermissionModuleModel({required this.module, required this.label, required final  List<PermissionModel> permissions}): _permissions = permissions;
  factory _PermissionModuleModel.fromJson(Map<String, dynamic> json) => _$PermissionModuleModelFromJson(json);

/// e.g. `employee`.
@override final  String module;
/// e.g. "Employees".
@override final  String label;
 final  List<PermissionModel> _permissions;
@override List<PermissionModel> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}


/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionModuleModelCopyWith<_PermissionModuleModel> get copyWith => __$PermissionModuleModelCopyWithImpl<_PermissionModuleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionModuleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionModuleModel&&(identical(other.module, module) || other.module == module)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._permissions, _permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,module,label,const DeepCollectionEquality().hash(_permissions));

@override
String toString() {
  return 'PermissionModuleModel(module: $module, label: $label, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$PermissionModuleModelCopyWith<$Res> implements $PermissionModuleModelCopyWith<$Res> {
  factory _$PermissionModuleModelCopyWith(_PermissionModuleModel value, $Res Function(_PermissionModuleModel) _then) = __$PermissionModuleModelCopyWithImpl;
@override @useResult
$Res call({
 String module, String label, List<PermissionModel> permissions
});




}
/// @nodoc
class __$PermissionModuleModelCopyWithImpl<$Res>
    implements _$PermissionModuleModelCopyWith<$Res> {
  __$PermissionModuleModelCopyWithImpl(this._self, this._then);

  final _PermissionModuleModel _self;
  final $Res Function(_PermissionModuleModel) _then;

/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? module = null,Object? label = null,Object? permissions = null,}) {
  return _then(_PermissionModuleModel(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<PermissionModel>,
  ));
}


}


/// @nodoc
mixin _$PermissionModel {

/// e.g. `employee.edit`.
 String get key;/// The matrix column, e.g. `edit` (view, create, edit, delete, …).
 String get action;/// e.g. "Edit employees".
 String get label; String? get description;
/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionModelCopyWith<PermissionModel> get copyWith => _$PermissionModelCopyWithImpl<PermissionModel>(this as PermissionModel, _$identity);

  /// Serializes this PermissionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionModel&&(identical(other.key, key) || other.key == key)&&(identical(other.action, action) || other.action == action)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,action,label,description);

@override
String toString() {
  return 'PermissionModel(key: $key, action: $action, label: $label, description: $description)';
}


}

/// @nodoc
abstract mixin class $PermissionModelCopyWith<$Res>  {
  factory $PermissionModelCopyWith(PermissionModel value, $Res Function(PermissionModel) _then) = _$PermissionModelCopyWithImpl;
@useResult
$Res call({
 String key, String action, String label, String? description
});




}
/// @nodoc
class _$PermissionModelCopyWithImpl<$Res>
    implements $PermissionModelCopyWith<$Res> {
  _$PermissionModelCopyWithImpl(this._self, this._then);

  final PermissionModel _self;
  final $Res Function(PermissionModel) _then;

/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? action = null,Object? label = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionModel].
extension PermissionModelPatterns on PermissionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String action,  String label,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
return $default(_that.key,_that.action,_that.label,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String action,  String label,  String? description)  $default,) {final _that = this;
switch (_that) {
case _PermissionModel():
return $default(_that.key,_that.action,_that.label,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String action,  String label,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
return $default(_that.key,_that.action,_that.label,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionModel implements PermissionModel {
  const _PermissionModel({required this.key, required this.action, required this.label, this.description});
  factory _PermissionModel.fromJson(Map<String, dynamic> json) => _$PermissionModelFromJson(json);

/// e.g. `employee.edit`.
@override final  String key;
/// The matrix column, e.g. `edit` (view, create, edit, delete, …).
@override final  String action;
/// e.g. "Edit employees".
@override final  String label;
@override final  String? description;

/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionModelCopyWith<_PermissionModel> get copyWith => __$PermissionModelCopyWithImpl<_PermissionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionModel&&(identical(other.key, key) || other.key == key)&&(identical(other.action, action) || other.action == action)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,action,label,description);

@override
String toString() {
  return 'PermissionModel(key: $key, action: $action, label: $label, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PermissionModelCopyWith<$Res> implements $PermissionModelCopyWith<$Res> {
  factory _$PermissionModelCopyWith(_PermissionModel value, $Res Function(_PermissionModel) _then) = __$PermissionModelCopyWithImpl;
@override @useResult
$Res call({
 String key, String action, String label, String? description
});




}
/// @nodoc
class __$PermissionModelCopyWithImpl<$Res>
    implements _$PermissionModelCopyWith<$Res> {
  __$PermissionModelCopyWithImpl(this._self, this._then);

  final _PermissionModel _self;
  final $Res Function(_PermissionModel) _then;

/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? action = null,Object? label = null,Object? description = freezed,}) {
  return _then(_PermissionModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
