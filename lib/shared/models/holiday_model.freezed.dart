// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HolidayModel {

@JsonKey(fromJson: idFromJson) String get id;@DateOnlyConverter() DateTime get date; String get name; String? get description;
/// Create a copy of HolidayModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HolidayModelCopyWith<HolidayModel> get copyWith => _$HolidayModelCopyWithImpl<HolidayModel>(this as HolidayModel, _$identity);

  /// Serializes this HolidayModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HolidayModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,name,description);

@override
String toString() {
  return 'HolidayModel(id: $id, date: $date, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $HolidayModelCopyWith<$Res>  {
  factory $HolidayModelCopyWith(HolidayModel value, $Res Function(HolidayModel) _then) = _$HolidayModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id,@DateOnlyConverter() DateTime date, String name, String? description
});




}
/// @nodoc
class _$HolidayModelCopyWithImpl<$Res>
    implements $HolidayModelCopyWith<$Res> {
  _$HolidayModelCopyWithImpl(this._self, this._then);

  final HolidayModel _self;
  final $Res Function(HolidayModel) _then;

/// Create a copy of HolidayModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HolidayModel].
extension HolidayModelPatterns on HolidayModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HolidayModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HolidayModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HolidayModel value)  $default,){
final _that = this;
switch (_that) {
case _HolidayModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HolidayModel value)?  $default,){
final _that = this;
switch (_that) {
case _HolidayModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime date,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HolidayModel() when $default != null:
return $default(_that.id,_that.date,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime date,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _HolidayModel():
return $default(_that.id,_that.date,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id, @DateOnlyConverter()  DateTime date,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _HolidayModel() when $default != null:
return $default(_that.id,_that.date,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HolidayModel implements HolidayModel {
  const _HolidayModel({@JsonKey(fromJson: idFromJson) required this.id, @DateOnlyConverter() required this.date, required this.name, this.description});
  factory _HolidayModel.fromJson(Map<String, dynamic> json) => _$HolidayModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override@DateOnlyConverter() final  DateTime date;
@override final  String name;
@override final  String? description;

/// Create a copy of HolidayModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HolidayModelCopyWith<_HolidayModel> get copyWith => __$HolidayModelCopyWithImpl<_HolidayModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HolidayModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HolidayModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,name,description);

@override
String toString() {
  return 'HolidayModel(id: $id, date: $date, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$HolidayModelCopyWith<$Res> implements $HolidayModelCopyWith<$Res> {
  factory _$HolidayModelCopyWith(_HolidayModel value, $Res Function(_HolidayModel) _then) = __$HolidayModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id,@DateOnlyConverter() DateTime date, String name, String? description
});




}
/// @nodoc
class __$HolidayModelCopyWithImpl<$Res>
    implements _$HolidayModelCopyWith<$Res> {
  __$HolidayModelCopyWithImpl(this._self, this._then);

  final _HolidayModel _self;
  final $Res Function(_HolidayModel) _then;

/// Create a copy of HolidayModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? name = null,Object? description = freezed,}) {
  return _then(_HolidayModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HolidayInput {

@DateOnlyConverter() DateTime get date; String get name; String? get description;
/// Create a copy of HolidayInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HolidayInputCopyWith<HolidayInput> get copyWith => _$HolidayInputCopyWithImpl<HolidayInput>(this as HolidayInput, _$identity);

  /// Serializes this HolidayInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HolidayInput&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,name,description);

@override
String toString() {
  return 'HolidayInput(date: $date, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $HolidayInputCopyWith<$Res>  {
  factory $HolidayInputCopyWith(HolidayInput value, $Res Function(HolidayInput) _then) = _$HolidayInputCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, String name, String? description
});




}
/// @nodoc
class _$HolidayInputCopyWithImpl<$Res>
    implements $HolidayInputCopyWith<$Res> {
  _$HolidayInputCopyWithImpl(this._self, this._then);

  final HolidayInput _self;
  final $Res Function(HolidayInput) _then;

/// Create a copy of HolidayInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HolidayInput].
extension HolidayInputPatterns on HolidayInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HolidayInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HolidayInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HolidayInput value)  $default,){
final _that = this;
switch (_that) {
case _HolidayInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HolidayInput value)?  $default,){
final _that = this;
switch (_that) {
case _HolidayInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HolidayInput() when $default != null:
return $default(_that.date,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _HolidayInput():
return $default(_that.date,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _HolidayInput() when $default != null:
return $default(_that.date,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HolidayInput implements HolidayInput {
  const _HolidayInput({@DateOnlyConverter() required this.date, required this.name, this.description});
  factory _HolidayInput.fromJson(Map<String, dynamic> json) => _$HolidayInputFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override final  String name;
@override final  String? description;

/// Create a copy of HolidayInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HolidayInputCopyWith<_HolidayInput> get copyWith => __$HolidayInputCopyWithImpl<_HolidayInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HolidayInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HolidayInput&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,name,description);

@override
String toString() {
  return 'HolidayInput(date: $date, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$HolidayInputCopyWith<$Res> implements $HolidayInputCopyWith<$Res> {
  factory _$HolidayInputCopyWith(_HolidayInput value, $Res Function(_HolidayInput) _then) = __$HolidayInputCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, String name, String? description
});




}
/// @nodoc
class __$HolidayInputCopyWithImpl<$Res>
    implements _$HolidayInputCopyWith<$Res> {
  __$HolidayInputCopyWithImpl(this._self, this._then);

  final _HolidayInput _self;
  final $Res Function(_HolidayInput) _then;

/// Create a copy of HolidayInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? name = null,Object? description = freezed,}) {
  return _then(_HolidayInput(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
