// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditEntryModel {

@JsonKey(fromJson: idFromJson) String get id;/// Machine-readable, e.g. `attendance.correct`.
 String get action;/// Display text from the backend, e.g. "Corrected punch in".
 String get summary; NamedRef get actor;@CompanyDateTimeConverter() DateTime get createdAt; List<AuditChangeModel> get changes; String? get reason; String? get remarks;
/// Create a copy of AuditEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryModelCopyWith<AuditEntryModel> get copyWith => _$AuditEntryModelCopyWithImpl<AuditEntryModel>(this as AuditEntryModel, _$identity);

  /// Serializes this AuditEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.changes, changes)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,summary,actor,createdAt,const DeepCollectionEquality().hash(changes),reason,remarks);

@override
String toString() {
  return 'AuditEntryModel(id: $id, action: $action, summary: $summary, actor: $actor, createdAt: $createdAt, changes: $changes, reason: $reason, remarks: $remarks)';
}


}

/// @nodoc
abstract mixin class $AuditEntryModelCopyWith<$Res>  {
  factory $AuditEntryModelCopyWith(AuditEntryModel value, $Res Function(AuditEntryModel) _then) = _$AuditEntryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String action, String summary, NamedRef actor,@CompanyDateTimeConverter() DateTime createdAt, List<AuditChangeModel> changes, String? reason, String? remarks
});


$NamedRefCopyWith<$Res> get actor;

}
/// @nodoc
class _$AuditEntryModelCopyWithImpl<$Res>
    implements $AuditEntryModelCopyWith<$Res> {
  _$AuditEntryModelCopyWithImpl(this._self, this._then);

  final AuditEntryModel _self;
  final $Res Function(AuditEntryModel) _then;

/// Create a copy of AuditEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? summary = null,Object? actor = null,Object? createdAt = null,Object? changes = null,Object? reason = freezed,Object? remarks = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as NamedRef,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<AuditChangeModel>,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AuditEntryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get actor {
  
  return $NamedRefCopyWith<$Res>(_self.actor, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuditEntryModel].
extension AuditEntryModelPatterns on AuditEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String action,  String summary,  NamedRef actor, @CompanyDateTimeConverter()  DateTime createdAt,  List<AuditChangeModel> changes,  String? reason,  String? remarks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntryModel() when $default != null:
return $default(_that.id,_that.action,_that.summary,_that.actor,_that.createdAt,_that.changes,_that.reason,_that.remarks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String action,  String summary,  NamedRef actor, @CompanyDateTimeConverter()  DateTime createdAt,  List<AuditChangeModel> changes,  String? reason,  String? remarks)  $default,) {final _that = this;
switch (_that) {
case _AuditEntryModel():
return $default(_that.id,_that.action,_that.summary,_that.actor,_that.createdAt,_that.changes,_that.reason,_that.remarks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String action,  String summary,  NamedRef actor, @CompanyDateTimeConverter()  DateTime createdAt,  List<AuditChangeModel> changes,  String? reason,  String? remarks)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntryModel() when $default != null:
return $default(_that.id,_that.action,_that.summary,_that.actor,_that.createdAt,_that.changes,_that.reason,_that.remarks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEntryModel implements AuditEntryModel {
  const _AuditEntryModel({@JsonKey(fromJson: idFromJson) required this.id, required this.action, required this.summary, required this.actor, @CompanyDateTimeConverter() required this.createdAt, final  List<AuditChangeModel> changes = const <AuditChangeModel>[], this.reason, this.remarks}): _changes = changes;
  factory _AuditEntryModel.fromJson(Map<String, dynamic> json) => _$AuditEntryModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
/// Machine-readable, e.g. `attendance.correct`.
@override final  String action;
/// Display text from the backend, e.g. "Corrected punch in".
@override final  String summary;
@override final  NamedRef actor;
@override@CompanyDateTimeConverter() final  DateTime createdAt;
 final  List<AuditChangeModel> _changes;
@override@JsonKey() List<AuditChangeModel> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}

@override final  String? reason;
@override final  String? remarks;

/// Create a copy of AuditEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryModelCopyWith<_AuditEntryModel> get copyWith => __$AuditEntryModelCopyWithImpl<_AuditEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._changes, _changes)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.remarks, remarks) || other.remarks == remarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,summary,actor,createdAt,const DeepCollectionEquality().hash(_changes),reason,remarks);

@override
String toString() {
  return 'AuditEntryModel(id: $id, action: $action, summary: $summary, actor: $actor, createdAt: $createdAt, changes: $changes, reason: $reason, remarks: $remarks)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryModelCopyWith<$Res> implements $AuditEntryModelCopyWith<$Res> {
  factory _$AuditEntryModelCopyWith(_AuditEntryModel value, $Res Function(_AuditEntryModel) _then) = __$AuditEntryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String action, String summary, NamedRef actor,@CompanyDateTimeConverter() DateTime createdAt, List<AuditChangeModel> changes, String? reason, String? remarks
});


@override $NamedRefCopyWith<$Res> get actor;

}
/// @nodoc
class __$AuditEntryModelCopyWithImpl<$Res>
    implements _$AuditEntryModelCopyWith<$Res> {
  __$AuditEntryModelCopyWithImpl(this._self, this._then);

  final _AuditEntryModel _self;
  final $Res Function(_AuditEntryModel) _then;

/// Create a copy of AuditEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? summary = null,Object? actor = null,Object? createdAt = null,Object? changes = null,Object? reason = freezed,Object? remarks = freezed,}) {
  return _then(_AuditEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as NamedRef,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<AuditChangeModel>,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AuditEntryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get actor {
  
  return $NamedRefCopyWith<$Res>(_self.actor, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// @nodoc
mixin _$AuditChangeModel {

 String get field; String get label; String? get before; String? get after;
/// Create a copy of AuditChangeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditChangeModelCopyWith<AuditChangeModel> get copyWith => _$AuditChangeModelCopyWithImpl<AuditChangeModel>(this as AuditChangeModel, _$identity);

  /// Serializes this AuditChangeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditChangeModel&&(identical(other.field, field) || other.field == field)&&(identical(other.label, label) || other.label == label)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,label,before,after);

@override
String toString() {
  return 'AuditChangeModel(field: $field, label: $label, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class $AuditChangeModelCopyWith<$Res>  {
  factory $AuditChangeModelCopyWith(AuditChangeModel value, $Res Function(AuditChangeModel) _then) = _$AuditChangeModelCopyWithImpl;
@useResult
$Res call({
 String field, String label, String? before, String? after
});




}
/// @nodoc
class _$AuditChangeModelCopyWithImpl<$Res>
    implements $AuditChangeModelCopyWith<$Res> {
  _$AuditChangeModelCopyWithImpl(this._self, this._then);

  final AuditChangeModel _self;
  final $Res Function(AuditChangeModel) _then;

/// Create a copy of AuditChangeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? label = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditChangeModel].
extension AuditChangeModelPatterns on AuditChangeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditChangeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditChangeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditChangeModel value)  $default,){
final _that = this;
switch (_that) {
case _AuditChangeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditChangeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuditChangeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String label,  String? before,  String? after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditChangeModel() when $default != null:
return $default(_that.field,_that.label,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String label,  String? before,  String? after)  $default,) {final _that = this;
switch (_that) {
case _AuditChangeModel():
return $default(_that.field,_that.label,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String label,  String? before,  String? after)?  $default,) {final _that = this;
switch (_that) {
case _AuditChangeModel() when $default != null:
return $default(_that.field,_that.label,_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditChangeModel implements AuditChangeModel {
  const _AuditChangeModel({required this.field, required this.label, this.before, this.after});
  factory _AuditChangeModel.fromJson(Map<String, dynamic> json) => _$AuditChangeModelFromJson(json);

@override final  String field;
@override final  String label;
@override final  String? before;
@override final  String? after;

/// Create a copy of AuditChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditChangeModelCopyWith<_AuditChangeModel> get copyWith => __$AuditChangeModelCopyWithImpl<_AuditChangeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditChangeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditChangeModel&&(identical(other.field, field) || other.field == field)&&(identical(other.label, label) || other.label == label)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,label,before,after);

@override
String toString() {
  return 'AuditChangeModel(field: $field, label: $label, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$AuditChangeModelCopyWith<$Res> implements $AuditChangeModelCopyWith<$Res> {
  factory _$AuditChangeModelCopyWith(_AuditChangeModel value, $Res Function(_AuditChangeModel) _then) = __$AuditChangeModelCopyWithImpl;
@override @useResult
$Res call({
 String field, String label, String? before, String? after
});




}
/// @nodoc
class __$AuditChangeModelCopyWithImpl<$Res>
    implements _$AuditChangeModelCopyWith<$Res> {
  __$AuditChangeModelCopyWithImpl(this._self, this._then);

  final _AuditChangeModel _self;
  final $Res Function(_AuditChangeModel) _then;

/// Create a copy of AuditChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? label = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_AuditChangeModel(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
