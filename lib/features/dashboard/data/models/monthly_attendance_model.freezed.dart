// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyAttendanceModel {

@DateOnlyConverter() DateTime get month; double? get averagePercent; List<DailyAttendanceModel> get days;
/// Create a copy of MonthlyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyAttendanceModelCopyWith<MonthlyAttendanceModel> get copyWith => _$MonthlyAttendanceModelCopyWithImpl<MonthlyAttendanceModel>(this as MonthlyAttendanceModel, _$identity);

  /// Serializes this MonthlyAttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyAttendanceModel&&(identical(other.month, month) || other.month == month)&&(identical(other.averagePercent, averagePercent) || other.averagePercent == averagePercent)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,averagePercent,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'MonthlyAttendanceModel(month: $month, averagePercent: $averagePercent, days: $days)';
}


}

/// @nodoc
abstract mixin class $MonthlyAttendanceModelCopyWith<$Res>  {
  factory $MonthlyAttendanceModelCopyWith(MonthlyAttendanceModel value, $Res Function(MonthlyAttendanceModel) _then) = _$MonthlyAttendanceModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime month, double? averagePercent, List<DailyAttendanceModel> days
});




}
/// @nodoc
class _$MonthlyAttendanceModelCopyWithImpl<$Res>
    implements $MonthlyAttendanceModelCopyWith<$Res> {
  _$MonthlyAttendanceModelCopyWithImpl(this._self, this._then);

  final MonthlyAttendanceModel _self;
  final $Res Function(MonthlyAttendanceModel) _then;

/// Create a copy of MonthlyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? averagePercent = freezed,Object? days = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,averagePercent: freezed == averagePercent ? _self.averagePercent : averagePercent // ignore: cast_nullable_to_non_nullable
as double?,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DailyAttendanceModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyAttendanceModel].
extension MonthlyAttendanceModelPatterns on MonthlyAttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyAttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyAttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyAttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyAttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  double? averagePercent,  List<DailyAttendanceModel> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyAttendanceModel() when $default != null:
return $default(_that.month,_that.averagePercent,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime month,  double? averagePercent,  List<DailyAttendanceModel> days)  $default,) {final _that = this;
switch (_that) {
case _MonthlyAttendanceModel():
return $default(_that.month,_that.averagePercent,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime month,  double? averagePercent,  List<DailyAttendanceModel> days)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyAttendanceModel() when $default != null:
return $default(_that.month,_that.averagePercent,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyAttendanceModel implements MonthlyAttendanceModel {
  const _MonthlyAttendanceModel({@DateOnlyConverter() required this.month, this.averagePercent, final  List<DailyAttendanceModel> days = const <DailyAttendanceModel>[]}): _days = days;
  factory _MonthlyAttendanceModel.fromJson(Map<String, dynamic> json) => _$MonthlyAttendanceModelFromJson(json);

@override@DateOnlyConverter() final  DateTime month;
@override final  double? averagePercent;
 final  List<DailyAttendanceModel> _days;
@override@JsonKey() List<DailyAttendanceModel> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of MonthlyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyAttendanceModelCopyWith<_MonthlyAttendanceModel> get copyWith => __$MonthlyAttendanceModelCopyWithImpl<_MonthlyAttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyAttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyAttendanceModel&&(identical(other.month, month) || other.month == month)&&(identical(other.averagePercent, averagePercent) || other.averagePercent == averagePercent)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,averagePercent,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'MonthlyAttendanceModel(month: $month, averagePercent: $averagePercent, days: $days)';
}


}

/// @nodoc
abstract mixin class _$MonthlyAttendanceModelCopyWith<$Res> implements $MonthlyAttendanceModelCopyWith<$Res> {
  factory _$MonthlyAttendanceModelCopyWith(_MonthlyAttendanceModel value, $Res Function(_MonthlyAttendanceModel) _then) = __$MonthlyAttendanceModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime month, double? averagePercent, List<DailyAttendanceModel> days
});




}
/// @nodoc
class __$MonthlyAttendanceModelCopyWithImpl<$Res>
    implements _$MonthlyAttendanceModelCopyWith<$Res> {
  __$MonthlyAttendanceModelCopyWithImpl(this._self, this._then);

  final _MonthlyAttendanceModel _self;
  final $Res Function(_MonthlyAttendanceModel) _then;

/// Create a copy of MonthlyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? averagePercent = freezed,Object? days = null,}) {
  return _then(_MonthlyAttendanceModel(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,averagePercent: freezed == averagePercent ? _self.averagePercent : averagePercent // ignore: cast_nullable_to_non_nullable
as double?,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DailyAttendanceModel>,
  ));
}


}


/// @nodoc
mixin _$DailyAttendanceModel {

@DateOnlyConverter() DateTime get date;/// 0–100, calculated by the backend: employees present as a share of
/// those scheduled to work that day (V2). Days nobody was scheduled
/// (company holidays, everyone's weekly off) are left out of [days].
 double get percent;
/// Create a copy of DailyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyAttendanceModelCopyWith<DailyAttendanceModel> get copyWith => _$DailyAttendanceModelCopyWithImpl<DailyAttendanceModel>(this as DailyAttendanceModel, _$identity);

  /// Serializes this DailyAttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyAttendanceModel&&(identical(other.date, date) || other.date == date)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,percent);

@override
String toString() {
  return 'DailyAttendanceModel(date: $date, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $DailyAttendanceModelCopyWith<$Res>  {
  factory $DailyAttendanceModelCopyWith(DailyAttendanceModel value, $Res Function(DailyAttendanceModel) _then) = _$DailyAttendanceModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, double percent
});




}
/// @nodoc
class _$DailyAttendanceModelCopyWithImpl<$Res>
    implements $DailyAttendanceModelCopyWith<$Res> {
  _$DailyAttendanceModelCopyWithImpl(this._self, this._then);

  final DailyAttendanceModel _self;
  final $Res Function(DailyAttendanceModel) _then;

/// Create a copy of DailyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? percent = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyAttendanceModel].
extension DailyAttendanceModelPatterns on DailyAttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyAttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyAttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _DailyAttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyAttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _DailyAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  double percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyAttendanceModel() when $default != null:
return $default(_that.date,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  double percent)  $default,) {final _that = this;
switch (_that) {
case _DailyAttendanceModel():
return $default(_that.date,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  double percent)?  $default,) {final _that = this;
switch (_that) {
case _DailyAttendanceModel() when $default != null:
return $default(_that.date,_that.percent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyAttendanceModel implements DailyAttendanceModel {
  const _DailyAttendanceModel({@DateOnlyConverter() required this.date, required this.percent});
  factory _DailyAttendanceModel.fromJson(Map<String, dynamic> json) => _$DailyAttendanceModelFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
/// 0–100, calculated by the backend: employees present as a share of
/// those scheduled to work that day (V2). Days nobody was scheduled
/// (company holidays, everyone's weekly off) are left out of [days].
@override final  double percent;

/// Create a copy of DailyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyAttendanceModelCopyWith<_DailyAttendanceModel> get copyWith => __$DailyAttendanceModelCopyWithImpl<_DailyAttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyAttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyAttendanceModel&&(identical(other.date, date) || other.date == date)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,percent);

@override
String toString() {
  return 'DailyAttendanceModel(date: $date, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$DailyAttendanceModelCopyWith<$Res> implements $DailyAttendanceModelCopyWith<$Res> {
  factory _$DailyAttendanceModelCopyWith(_DailyAttendanceModel value, $Res Function(_DailyAttendanceModel) _then) = __$DailyAttendanceModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, double percent
});




}
/// @nodoc
class __$DailyAttendanceModelCopyWithImpl<$Res>
    implements _$DailyAttendanceModelCopyWith<$Res> {
  __$DailyAttendanceModelCopyWithImpl(this._self, this._then);

  final _DailyAttendanceModel _self;
  final $Res Function(_DailyAttendanceModel) _then;

/// Create a copy of DailyAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? percent = null,}) {
  return _then(_DailyAttendanceModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
