// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_account_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAccountModel {

@JsonKey(fromJson: idFromJson) String get id; String get name; String get email;/// Permission keys, e.g. `employee.edit`.
 List<String> get permissions; EmployeeSummaryModel? get employee; bool get isActive;@CompanyDateTimeConverter() DateTime? get lastSignInAt;
/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountModelCopyWith<UserAccountModel> get copyWith => _$UserAccountModelCopyWithImpl<UserAccountModel>(this as UserAccountModel, _$identity);

  /// Serializes this UserAccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,const DeepCollectionEquality().hash(permissions),employee,isActive,lastSignInAt);

@override
String toString() {
  return 'UserAccountModel(id: $id, name: $name, email: $email, permissions: $permissions, employee: $employee, isActive: $isActive, lastSignInAt: $lastSignInAt)';
}


}

/// @nodoc
abstract mixin class $UserAccountModelCopyWith<$Res>  {
  factory $UserAccountModelCopyWith(UserAccountModel value, $Res Function(UserAccountModel) _then) = _$UserAccountModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, String email, List<String> permissions, EmployeeSummaryModel? employee, bool isActive,@CompanyDateTimeConverter() DateTime? lastSignInAt
});


$EmployeeSummaryModelCopyWith<$Res>? get employee;

}
/// @nodoc
class _$UserAccountModelCopyWithImpl<$Res>
    implements $UserAccountModelCopyWith<$Res> {
  _$UserAccountModelCopyWithImpl(this._self, this._then);

  final UserAccountModel _self;
  final $Res Function(UserAccountModel) _then;

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? permissions = null,Object? employee = freezed,Object? isActive = null,Object? lastSignInAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,employee: freezed == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res>? get employee {
    if (_self.employee == null) {
    return null;
  }

  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee!, (value) {
    return _then(_self.copyWith(employee: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserAccountModel].
extension UserAccountModelPatterns on UserAccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String email,  List<String> permissions,  EmployeeSummaryModel? employee,  bool isActive, @CompanyDateTimeConverter()  DateTime? lastSignInAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.permissions,_that.employee,_that.isActive,_that.lastSignInAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String email,  List<String> permissions,  EmployeeSummaryModel? employee,  bool isActive, @CompanyDateTimeConverter()  DateTime? lastSignInAt)  $default,) {final _that = this;
switch (_that) {
case _UserAccountModel():
return $default(_that.id,_that.name,_that.email,_that.permissions,_that.employee,_that.isActive,_that.lastSignInAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String name,  String email,  List<String> permissions,  EmployeeSummaryModel? employee,  bool isActive, @CompanyDateTimeConverter()  DateTime? lastSignInAt)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.permissions,_that.employee,_that.isActive,_that.lastSignInAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAccountModel implements UserAccountModel {
  const _UserAccountModel({@JsonKey(fromJson: idFromJson) required this.id, required this.name, required this.email, final  List<String> permissions = const <String>[], this.employee, this.isActive = true, @CompanyDateTimeConverter() this.lastSignInAt}): _permissions = permissions;
  factory _UserAccountModel.fromJson(Map<String, dynamic> json) => _$UserAccountModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String name;
@override final  String email;
/// Permission keys, e.g. `employee.edit`.
 final  List<String> _permissions;
/// Permission keys, e.g. `employee.edit`.
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override final  EmployeeSummaryModel? employee;
@override@JsonKey() final  bool isActive;
@override@CompanyDateTimeConverter() final  DateTime? lastSignInAt;

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountModelCopyWith<_UserAccountModel> get copyWith => __$UserAccountModelCopyWithImpl<_UserAccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,const DeepCollectionEquality().hash(_permissions),employee,isActive,lastSignInAt);

@override
String toString() {
  return 'UserAccountModel(id: $id, name: $name, email: $email, permissions: $permissions, employee: $employee, isActive: $isActive, lastSignInAt: $lastSignInAt)';
}


}

/// @nodoc
abstract mixin class _$UserAccountModelCopyWith<$Res> implements $UserAccountModelCopyWith<$Res> {
  factory _$UserAccountModelCopyWith(_UserAccountModel value, $Res Function(_UserAccountModel) _then) = __$UserAccountModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String name, String email, List<String> permissions, EmployeeSummaryModel? employee, bool isActive,@CompanyDateTimeConverter() DateTime? lastSignInAt
});


@override $EmployeeSummaryModelCopyWith<$Res>? get employee;

}
/// @nodoc
class __$UserAccountModelCopyWithImpl<$Res>
    implements _$UserAccountModelCopyWith<$Res> {
  __$UserAccountModelCopyWithImpl(this._self, this._then);

  final _UserAccountModel _self;
  final $Res Function(_UserAccountModel) _then;

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? permissions = null,Object? employee = freezed,Object? isActive = null,Object? lastSignInAt = freezed,}) {
  return _then(_UserAccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,employee: freezed == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res>? get employee {
    if (_self.employee == null) {
    return null;
  }

  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee!, (value) {
    return _then(_self.copyWith(employee: value));
  });
}
}


/// @nodoc
mixin _$UserAccountListModel {

 List<UserAccountModel> get items; int get total; int get page; int get pageSize;
/// Create a copy of UserAccountListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountListModelCopyWith<UserAccountListModel> get copyWith => _$UserAccountListModelCopyWithImpl<UserAccountListModel>(this as UserAccountListModel, _$identity);

  /// Serializes this UserAccountListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountListModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,pageSize);

@override
String toString() {
  return 'UserAccountListModel(items: $items, total: $total, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $UserAccountListModelCopyWith<$Res>  {
  factory $UserAccountListModelCopyWith(UserAccountListModel value, $Res Function(UserAccountListModel) _then) = _$UserAccountListModelCopyWithImpl;
@useResult
$Res call({
 List<UserAccountModel> items, int total, int page, int pageSize
});




}
/// @nodoc
class _$UserAccountListModelCopyWithImpl<$Res>
    implements $UserAccountListModelCopyWith<$Res> {
  _$UserAccountListModelCopyWithImpl(this._self, this._then);

  final UserAccountListModel _self;
  final $Res Function(UserAccountListModel) _then;

/// Create a copy of UserAccountListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<UserAccountModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccountListModel].
extension UserAccountListModelPatterns on UserAccountListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountListModel value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountListModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserAccountModel> items,  int total,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserAccountModel> items,  int total,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _UserAccountListModel():
return $default(_that.items,_that.total,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserAccountModel> items,  int total,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountListModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAccountListModel implements UserAccountListModel {
  const _UserAccountListModel({required final  List<UserAccountModel> items, required this.total, required this.page, required this.pageSize}): _items = items;
  factory _UserAccountListModel.fromJson(Map<String, dynamic> json) => _$UserAccountListModelFromJson(json);

 final  List<UserAccountModel> _items;
@override List<UserAccountModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  int page;
@override final  int pageSize;

/// Create a copy of UserAccountListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountListModelCopyWith<_UserAccountListModel> get copyWith => __$UserAccountListModelCopyWithImpl<_UserAccountListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAccountListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountListModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,pageSize);

@override
String toString() {
  return 'UserAccountListModel(items: $items, total: $total, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$UserAccountListModelCopyWith<$Res> implements $UserAccountListModelCopyWith<$Res> {
  factory _$UserAccountListModelCopyWith(_UserAccountListModel value, $Res Function(_UserAccountListModel) _then) = __$UserAccountListModelCopyWithImpl;
@override @useResult
$Res call({
 List<UserAccountModel> items, int total, int page, int pageSize
});




}
/// @nodoc
class __$UserAccountListModelCopyWithImpl<$Res>
    implements _$UserAccountListModelCopyWith<$Res> {
  __$UserAccountListModelCopyWithImpl(this._self, this._then);

  final _UserAccountListModel _self;
  final $Res Function(_UserAccountListModel) _then;

/// Create a copy of UserAccountListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_UserAccountListModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<UserAccountModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserAccountInput {

 String get name; String get email;@JsonKey(includeIfNull: false) String? get employeeId; List<String> get permissions;
/// Create a copy of UserAccountInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountInputCopyWith<UserAccountInput> get copyWith => _$UserAccountInputCopyWithImpl<UserAccountInput>(this as UserAccountInput, _$identity);

  /// Serializes this UserAccountInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountInput&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&const DeepCollectionEquality().equals(other.permissions, permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,employeeId,const DeepCollectionEquality().hash(permissions));

@override
String toString() {
  return 'UserAccountInput(name: $name, email: $email, employeeId: $employeeId, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class $UserAccountInputCopyWith<$Res>  {
  factory $UserAccountInputCopyWith(UserAccountInput value, $Res Function(UserAccountInput) _then) = _$UserAccountInputCopyWithImpl;
@useResult
$Res call({
 String name, String email,@JsonKey(includeIfNull: false) String? employeeId, List<String> permissions
});




}
/// @nodoc
class _$UserAccountInputCopyWithImpl<$Res>
    implements $UserAccountInputCopyWith<$Res> {
  _$UserAccountInputCopyWithImpl(this._self, this._then);

  final UserAccountInput _self;
  final $Res Function(UserAccountInput) _then;

/// Create a copy of UserAccountInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? employeeId = freezed,Object? permissions = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccountInput].
extension UserAccountInputPatterns on UserAccountInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountInput value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountInput value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email, @JsonKey(includeIfNull: false)  String? employeeId,  List<String> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountInput() when $default != null:
return $default(_that.name,_that.email,_that.employeeId,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email, @JsonKey(includeIfNull: false)  String? employeeId,  List<String> permissions)  $default,) {final _that = this;
switch (_that) {
case _UserAccountInput():
return $default(_that.name,_that.email,_that.employeeId,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email, @JsonKey(includeIfNull: false)  String? employeeId,  List<String> permissions)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountInput() when $default != null:
return $default(_that.name,_that.email,_that.employeeId,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAccountInput implements UserAccountInput {
  const _UserAccountInput({required this.name, required this.email, @JsonKey(includeIfNull: false) this.employeeId, final  List<String> permissions = const <String>[]}): _permissions = permissions;
  factory _UserAccountInput.fromJson(Map<String, dynamic> json) => _$UserAccountInputFromJson(json);

@override final  String name;
@override final  String email;
@override@JsonKey(includeIfNull: false) final  String? employeeId;
 final  List<String> _permissions;
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}


/// Create a copy of UserAccountInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountInputCopyWith<_UserAccountInput> get copyWith => __$UserAccountInputCopyWithImpl<_UserAccountInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAccountInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountInput&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&const DeepCollectionEquality().equals(other._permissions, _permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,employeeId,const DeepCollectionEquality().hash(_permissions));

@override
String toString() {
  return 'UserAccountInput(name: $name, email: $email, employeeId: $employeeId, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$UserAccountInputCopyWith<$Res> implements $UserAccountInputCopyWith<$Res> {
  factory _$UserAccountInputCopyWith(_UserAccountInput value, $Res Function(_UserAccountInput) _then) = __$UserAccountInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String email,@JsonKey(includeIfNull: false) String? employeeId, List<String> permissions
});




}
/// @nodoc
class __$UserAccountInputCopyWithImpl<$Res>
    implements _$UserAccountInputCopyWith<$Res> {
  __$UserAccountInputCopyWithImpl(this._self, this._then);

  final _UserAccountInput _self;
  final $Res Function(_UserAccountInput) _then;

/// Create a copy of UserAccountInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? employeeId = freezed,Object? permissions = null,}) {
  return _then(_UserAccountInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$UserAccountUpdate {

 String get name; String get email; String? get employeeId;/// Only sent when changing it (deactivate / reactivate).
@JsonKey(includeIfNull: false) bool? get isActive;
/// Create a copy of UserAccountUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountUpdateCopyWith<UserAccountUpdate> get copyWith => _$UserAccountUpdateCopyWithImpl<UserAccountUpdate>(this as UserAccountUpdate, _$identity);

  /// Serializes this UserAccountUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountUpdate&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,employeeId,isActive);

@override
String toString() {
  return 'UserAccountUpdate(name: $name, email: $email, employeeId: $employeeId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UserAccountUpdateCopyWith<$Res>  {
  factory $UserAccountUpdateCopyWith(UserAccountUpdate value, $Res Function(UserAccountUpdate) _then) = _$UserAccountUpdateCopyWithImpl;
@useResult
$Res call({
 String name, String email, String? employeeId,@JsonKey(includeIfNull: false) bool? isActive
});




}
/// @nodoc
class _$UserAccountUpdateCopyWithImpl<$Res>
    implements $UserAccountUpdateCopyWith<$Res> {
  _$UserAccountUpdateCopyWithImpl(this._self, this._then);

  final UserAccountUpdate _self;
  final $Res Function(UserAccountUpdate) _then;

/// Create a copy of UserAccountUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? employeeId = freezed,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccountUpdate].
extension UserAccountUpdatePatterns on UserAccountUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountUpdate value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email,  String? employeeId, @JsonKey(includeIfNull: false)  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountUpdate() when $default != null:
return $default(_that.name,_that.email,_that.employeeId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email,  String? employeeId, @JsonKey(includeIfNull: false)  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _UserAccountUpdate():
return $default(_that.name,_that.email,_that.employeeId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email,  String? employeeId, @JsonKey(includeIfNull: false)  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountUpdate() when $default != null:
return $default(_that.name,_that.email,_that.employeeId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAccountUpdate implements UserAccountUpdate {
  const _UserAccountUpdate({required this.name, required this.email, this.employeeId, @JsonKey(includeIfNull: false) this.isActive});
  factory _UserAccountUpdate.fromJson(Map<String, dynamic> json) => _$UserAccountUpdateFromJson(json);

@override final  String name;
@override final  String email;
@override final  String? employeeId;
/// Only sent when changing it (deactivate / reactivate).
@override@JsonKey(includeIfNull: false) final  bool? isActive;

/// Create a copy of UserAccountUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountUpdateCopyWith<_UserAccountUpdate> get copyWith => __$UserAccountUpdateCopyWithImpl<_UserAccountUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAccountUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountUpdate&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,employeeId,isActive);

@override
String toString() {
  return 'UserAccountUpdate(name: $name, email: $email, employeeId: $employeeId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UserAccountUpdateCopyWith<$Res> implements $UserAccountUpdateCopyWith<$Res> {
  factory _$UserAccountUpdateCopyWith(_UserAccountUpdate value, $Res Function(_UserAccountUpdate) _then) = __$UserAccountUpdateCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String? employeeId,@JsonKey(includeIfNull: false) bool? isActive
});




}
/// @nodoc
class __$UserAccountUpdateCopyWithImpl<$Res>
    implements _$UserAccountUpdateCopyWith<$Res> {
  __$UserAccountUpdateCopyWithImpl(this._self, this._then);

  final _UserAccountUpdate _self;
  final $Res Function(_UserAccountUpdate) _then;

/// Create a copy of UserAccountUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? employeeId = freezed,Object? isActive = freezed,}) {
  return _then(_UserAccountUpdate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
mixin _$UserQuery {

 String get search; int get page; int get pageSize;
/// Create a copy of UserQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserQueryCopyWith<UserQuery> get copyWith => _$UserQueryCopyWithImpl<UserQuery>(this as UserQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,search,page,pageSize);

@override
String toString() {
  return 'UserQuery(search: $search, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $UserQueryCopyWith<$Res>  {
  factory $UserQueryCopyWith(UserQuery value, $Res Function(UserQuery) _then) = _$UserQueryCopyWithImpl;
@useResult
$Res call({
 String search, int page, int pageSize
});




}
/// @nodoc
class _$UserQueryCopyWithImpl<$Res>
    implements $UserQueryCopyWith<$Res> {
  _$UserQueryCopyWithImpl(this._self, this._then);

  final UserQuery _self;
  final $Res Function(UserQuery) _then;

/// Create a copy of UserQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserQuery].
extension UserQueryPatterns on UserQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserQuery value)  $default,){
final _that = this;
switch (_that) {
case _UserQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserQuery value)?  $default,){
final _that = this;
switch (_that) {
case _UserQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserQuery() when $default != null:
return $default(_that.search,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _UserQuery():
return $default(_that.search,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _UserQuery() when $default != null:
return $default(_that.search,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _UserQuery extends UserQuery {
  const _UserQuery({this.search = '', this.page = 1, this.pageSize = UserQuery.defaultPageSize}): super._();
  

@override@JsonKey() final  String search;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of UserQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserQueryCopyWith<_UserQuery> get copyWith => __$UserQueryCopyWithImpl<_UserQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,search,page,pageSize);

@override
String toString() {
  return 'UserQuery(search: $search, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$UserQueryCopyWith<$Res> implements $UserQueryCopyWith<$Res> {
  factory _$UserQueryCopyWith(_UserQuery value, $Res Function(_UserQuery) _then) = __$UserQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, int page, int pageSize
});




}
/// @nodoc
class __$UserQueryCopyWithImpl<$Res>
    implements _$UserQueryCopyWith<$Res> {
  __$UserQueryCopyWithImpl(this._self, this._then);

  final _UserQuery _self;
  final $Res Function(_UserQuery) _then;

/// Create a copy of UserQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_UserQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
