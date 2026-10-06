// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListEntry {

@JsonKey(fromJson: idFromJson) String get id; String get code; String get name; int get employeeCount;
/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListEntryCopyWith<ListEntry> get copyWith => _$ListEntryCopyWithImpl<ListEntry>(this as ListEntry, _$identity);

  /// Serializes this ListEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,employeeCount);

@override
String toString() {
  return 'ListEntry(id: $id, code: $code, name: $name, employeeCount: $employeeCount)';
}


}

/// @nodoc
abstract mixin class $ListEntryCopyWith<$Res>  {
  factory $ListEntryCopyWith(ListEntry value, $Res Function(ListEntry) _then) = _$ListEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String code, String name, int employeeCount
});




}
/// @nodoc
class _$ListEntryCopyWithImpl<$Res>
    implements $ListEntryCopyWith<$Res> {
  _$ListEntryCopyWithImpl(this._self, this._then);

  final ListEntry _self;
  final $Res Function(ListEntry) _then;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? employeeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeCount: null == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ListEntry].
extension ListEntryPatterns on ListEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListEntry value)  $default,){
final _that = this;
switch (_that) {
case _ListEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ListEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String code,  String name,  int employeeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.employeeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String code,  String name,  int employeeCount)  $default,) {final _that = this;
switch (_that) {
case _ListEntry():
return $default(_that.id,_that.code,_that.name,_that.employeeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String code,  String name,  int employeeCount)?  $default,) {final _that = this;
switch (_that) {
case _ListEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.employeeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListEntry extends ListEntry {
  const _ListEntry({@JsonKey(fromJson: idFromJson) required this.id, required this.code, required this.name, this.employeeCount = 0}): super._();
  factory _ListEntry.fromJson(Map<String, dynamic> json) => _$ListEntryFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String code;
@override final  String name;
@override@JsonKey() final  int employeeCount;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListEntryCopyWith<_ListEntry> get copyWith => __$ListEntryCopyWithImpl<_ListEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,employeeCount);

@override
String toString() {
  return 'ListEntry(id: $id, code: $code, name: $name, employeeCount: $employeeCount)';
}


}

/// @nodoc
abstract mixin class _$ListEntryCopyWith<$Res> implements $ListEntryCopyWith<$Res> {
  factory _$ListEntryCopyWith(_ListEntry value, $Res Function(_ListEntry) _then) = __$ListEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String code, String name, int employeeCount
});




}
/// @nodoc
class __$ListEntryCopyWithImpl<$Res>
    implements _$ListEntryCopyWith<$Res> {
  __$ListEntryCopyWithImpl(this._self, this._then);

  final _ListEntry _self;
  final $Res Function(_ListEntry) _then;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? employeeCount = null,}) {
  return _then(_ListEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeCount: null == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
