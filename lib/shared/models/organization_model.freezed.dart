// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizationModel {

@JsonKey(fromJson: idFromJson) String get id; String get name; String? get logoUrl;/// IANA time zone, e.g. `Asia/Kolkata`: "today" and month boundaries
/// follow it.
 String? get timezone;
/// Create a copy of OrganizationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationModelCopyWith<OrganizationModel> get copyWith => _$OrganizationModelCopyWithImpl<OrganizationModel>(this as OrganizationModel, _$identity);

  /// Serializes this OrganizationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logoUrl,timezone);

@override
String toString() {
  return 'OrganizationModel(id: $id, name: $name, logoUrl: $logoUrl, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $OrganizationModelCopyWith<$Res>  {
  factory $OrganizationModelCopyWith(OrganizationModel value, $Res Function(OrganizationModel) _then) = _$OrganizationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, String? logoUrl, String? timezone
});




}
/// @nodoc
class _$OrganizationModelCopyWithImpl<$Res>
    implements $OrganizationModelCopyWith<$Res> {
  _$OrganizationModelCopyWithImpl(this._self, this._then);

  final OrganizationModel _self;
  final $Res Function(OrganizationModel) _then;

/// Create a copy of OrganizationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? logoUrl = freezed,Object? timezone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationModel].
extension OrganizationModelPatterns on OrganizationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationModel value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String? logoUrl,  String? timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationModel() when $default != null:
return $default(_that.id,_that.name,_that.logoUrl,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String? logoUrl,  String? timezone)  $default,) {final _that = this;
switch (_that) {
case _OrganizationModel():
return $default(_that.id,_that.name,_that.logoUrl,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String? logoUrl,  String? timezone)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationModel() when $default != null:
return $default(_that.id,_that.name,_that.logoUrl,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationModel implements OrganizationModel {
  const _OrganizationModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name, this.logoUrl, this.timezone});
  factory _OrganizationModel.fromJson(Map<String, dynamic> json) => _$OrganizationModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;
@override final  String? logoUrl;
/// IANA time zone, e.g. `Asia/Kolkata`: "today" and month boundaries
/// follow it.
@override final  String? timezone;

/// Create a copy of OrganizationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationModelCopyWith<_OrganizationModel> get copyWith => __$OrganizationModelCopyWithImpl<_OrganizationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logoUrl,timezone);

@override
String toString() {
  return 'OrganizationModel(id: $id, name: $name, logoUrl: $logoUrl, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$OrganizationModelCopyWith<$Res> implements $OrganizationModelCopyWith<$Res> {
  factory _$OrganizationModelCopyWith(_OrganizationModel value, $Res Function(_OrganizationModel) _then) = __$OrganizationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, String? logoUrl, String? timezone
});




}
/// @nodoc
class __$OrganizationModelCopyWithImpl<$Res>
    implements _$OrganizationModelCopyWith<$Res> {
  __$OrganizationModelCopyWithImpl(this._self, this._then);

  final _OrganizationModel _self;
  final $Res Function(_OrganizationModel) _then;

/// Create a copy of OrganizationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? logoUrl = freezed,Object? timezone = freezed,}) {
  return _then(_OrganizationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MembershipModel {

@JsonKey(fromJson: idFromJson) String get organizationId; String get name; String? get logoUrl;
/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipModelCopyWith<MembershipModel> get copyWith => _$MembershipModelCopyWithImpl<MembershipModel>(this as MembershipModel, _$identity);

  /// Serializes this MembershipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipModel&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,name,logoUrl);

@override
String toString() {
  return 'MembershipModel(organizationId: $organizationId, name: $name, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $MembershipModelCopyWith<$Res>  {
  factory $MembershipModelCopyWith(MembershipModel value, $Res Function(MembershipModel) _then) = _$MembershipModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String organizationId, String name, String? logoUrl
});




}
/// @nodoc
class _$MembershipModelCopyWithImpl<$Res>
    implements $MembershipModelCopyWith<$Res> {
  _$MembershipModelCopyWithImpl(this._self, this._then);

  final MembershipModel _self;
  final $Res Function(MembershipModel) _then;

/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizationId = null,Object? name = null,Object? logoUrl = freezed,}) {
  return _then(_self.copyWith(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipModel].
extension MembershipModelPatterns on MembershipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipModel value)  $default,){
final _that = this;
switch (_that) {
case _MembershipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipModel value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String organizationId,  String name,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipModel() when $default != null:
return $default(_that.organizationId,_that.name,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String organizationId,  String name,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _MembershipModel():
return $default(_that.organizationId,_that.name,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String organizationId,  String name,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _MembershipModel() when $default != null:
return $default(_that.organizationId,_that.name,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembershipModel implements MembershipModel {
  const _MembershipModel({@JsonKey(fromJson: idFromJson) required this.organizationId, required this.name, this.logoUrl});
  factory _MembershipModel.fromJson(Map<String, dynamic> json) => _$MembershipModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String organizationId;
@override final  String name;
@override final  String? logoUrl;

/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipModelCopyWith<_MembershipModel> get copyWith => __$MembershipModelCopyWithImpl<_MembershipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipModel&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,name,logoUrl);

@override
String toString() {
  return 'MembershipModel(organizationId: $organizationId, name: $name, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$MembershipModelCopyWith<$Res> implements $MembershipModelCopyWith<$Res> {
  factory _$MembershipModelCopyWith(_MembershipModel value, $Res Function(_MembershipModel) _then) = __$MembershipModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String organizationId, String name, String? logoUrl
});




}
/// @nodoc
class __$MembershipModelCopyWithImpl<$Res>
    implements _$MembershipModelCopyWith<$Res> {
  __$MembershipModelCopyWithImpl(this._self, this._then);

  final _MembershipModel _self;
  final $Res Function(_MembershipModel) _then;

/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizationId = null,Object? name = null,Object? logoUrl = freezed,}) {
  return _then(_MembershipModel(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InvitationModel {

@JsonKey(fromJson: idFromJson) String get id; OrganizationModel get organization;/// Who sent it, e.g. "Ravi Mehta".
 String? get invitedBy;
/// Create a copy of InvitationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationModelCopyWith<InvitationModel> get copyWith => _$InvitationModelCopyWithImpl<InvitationModel>(this as InvitationModel, _$identity);

  /// Serializes this InvitationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organization,invitedBy);

@override
String toString() {
  return 'InvitationModel(id: $id, organization: $organization, invitedBy: $invitedBy)';
}


}

/// @nodoc
abstract mixin class $InvitationModelCopyWith<$Res>  {
  factory $InvitationModelCopyWith(InvitationModel value, $Res Function(InvitationModel) _then) = _$InvitationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, OrganizationModel organization, String? invitedBy
});


$OrganizationModelCopyWith<$Res> get organization;

}
/// @nodoc
class _$InvitationModelCopyWithImpl<$Res>
    implements $InvitationModelCopyWith<$Res> {
  _$InvitationModelCopyWithImpl(this._self, this._then);

  final InvitationModel _self;
  final $Res Function(InvitationModel) _then;

/// Create a copy of InvitationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organization = null,Object? invitedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as OrganizationModel,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of InvitationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationModelCopyWith<$Res> get organization {
  
  return $OrganizationModelCopyWith<$Res>(_self.organization, (value) {
    return _then(_self.copyWith(organization: value));
  });
}
}


/// Adds pattern-matching-related methods to [InvitationModel].
extension InvitationModelPatterns on InvitationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitationModel value)  $default,){
final _that = this;
switch (_that) {
case _InvitationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitationModel value)?  $default,){
final _that = this;
switch (_that) {
case _InvitationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  OrganizationModel organization,  String? invitedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitationModel() when $default != null:
return $default(_that.id,_that.organization,_that.invitedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  OrganizationModel organization,  String? invitedBy)  $default,) {final _that = this;
switch (_that) {
case _InvitationModel():
return $default(_that.id,_that.organization,_that.invitedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  OrganizationModel organization,  String? invitedBy)?  $default,) {final _that = this;
switch (_that) {
case _InvitationModel() when $default != null:
return $default(_that.id,_that.organization,_that.invitedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitationModel implements InvitationModel {
  const _InvitationModel({@JsonKey(fromJson: idFromJson) required this.id, required this.organization, this.invitedBy});
  factory _InvitationModel.fromJson(Map<String, dynamic> json) => _$InvitationModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  OrganizationModel organization;
/// Who sent it, e.g. "Ravi Mehta".
@override final  String? invitedBy;

/// Create a copy of InvitationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationModelCopyWith<_InvitationModel> get copyWith => __$InvitationModelCopyWithImpl<_InvitationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organization,invitedBy);

@override
String toString() {
  return 'InvitationModel(id: $id, organization: $organization, invitedBy: $invitedBy)';
}


}

/// @nodoc
abstract mixin class _$InvitationModelCopyWith<$Res> implements $InvitationModelCopyWith<$Res> {
  factory _$InvitationModelCopyWith(_InvitationModel value, $Res Function(_InvitationModel) _then) = __$InvitationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, OrganizationModel organization, String? invitedBy
});


@override $OrganizationModelCopyWith<$Res> get organization;

}
/// @nodoc
class __$InvitationModelCopyWithImpl<$Res>
    implements _$InvitationModelCopyWith<$Res> {
  __$InvitationModelCopyWithImpl(this._self, this._then);

  final _InvitationModel _self;
  final $Res Function(_InvitationModel) _then;

/// Create a copy of InvitationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organization = null,Object? invitedBy = freezed,}) {
  return _then(_InvitationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as OrganizationModel,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of InvitationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationModelCopyWith<$Res> get organization {
  
  return $OrganizationModelCopyWith<$Res>(_self.organization, (value) {
    return _then(_self.copyWith(organization: value));
  });
}
}

// dart format on
