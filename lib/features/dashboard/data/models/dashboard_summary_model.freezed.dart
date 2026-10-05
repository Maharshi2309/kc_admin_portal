// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardSummaryModel {

@DateOnlyConverter() DateTime get date; int get totalEmployees;/// Active employees expected at work today (V2): today is a working day
/// on their schedule, not a company holiday or their weekly off. Present,
/// on leave and absent are counted among them only, and the percentages
/// are shares of this number. Null from an older backend.
 int? get scheduledToday; int get presentToday; int get onLeaveToday; int get absentToday; double? get presentPercent; double? get onLeavePercent; double? get absentPercent;/// Today's company holiday, if any (V2): nobody is absent on it.
 HolidayModel? get holiday;/// Active employees whose weekly off is today, working or not (V2).
 int get weekOffToday;/// Employees working today on a company holiday or on their weekly off
/// (V2). Their hours count as overtime.
 int get holidayWorkedToday; int get weekOffWorkedToday;/// Overtime of all employees from the 1st of the month to [date], in
/// minutes (V2). Null when the caller lacks `overtime.view`.
 int? get overtimeMinutesThisMonth;/// How many employees have any overtime this month (V2).
 int? get overtimeEmployeesThisMonth; List<AttentionItemModel> get attention;/// A short preview; [notPunchedInTotal] is the full count.
 List<EmployeeSummaryModel> get notPunchedIn; int get notPunchedInTotal;/// A short preview; [onLeaveToday] is the full count.
 List<LeaveTodayModel> get onLeave; LeaveUsageModel? get leaveUsage;
/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryModelCopyWith<DashboardSummaryModel> get copyWith => _$DashboardSummaryModelCopyWithImpl<DashboardSummaryModel>(this as DashboardSummaryModel, _$identity);

  /// Serializes this DashboardSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummaryModel&&(identical(other.date, date) || other.date == date)&&(identical(other.totalEmployees, totalEmployees) || other.totalEmployees == totalEmployees)&&(identical(other.scheduledToday, scheduledToday) || other.scheduledToday == scheduledToday)&&(identical(other.presentToday, presentToday) || other.presentToday == presentToday)&&(identical(other.onLeaveToday, onLeaveToday) || other.onLeaveToday == onLeaveToday)&&(identical(other.absentToday, absentToday) || other.absentToday == absentToday)&&(identical(other.presentPercent, presentPercent) || other.presentPercent == presentPercent)&&(identical(other.onLeavePercent, onLeavePercent) || other.onLeavePercent == onLeavePercent)&&(identical(other.absentPercent, absentPercent) || other.absentPercent == absentPercent)&&(identical(other.holiday, holiday) || other.holiday == holiday)&&(identical(other.weekOffToday, weekOffToday) || other.weekOffToday == weekOffToday)&&(identical(other.holidayWorkedToday, holidayWorkedToday) || other.holidayWorkedToday == holidayWorkedToday)&&(identical(other.weekOffWorkedToday, weekOffWorkedToday) || other.weekOffWorkedToday == weekOffWorkedToday)&&(identical(other.overtimeMinutesThisMonth, overtimeMinutesThisMonth) || other.overtimeMinutesThisMonth == overtimeMinutesThisMonth)&&(identical(other.overtimeEmployeesThisMonth, overtimeEmployeesThisMonth) || other.overtimeEmployeesThisMonth == overtimeEmployeesThisMonth)&&const DeepCollectionEquality().equals(other.attention, attention)&&const DeepCollectionEquality().equals(other.notPunchedIn, notPunchedIn)&&(identical(other.notPunchedInTotal, notPunchedInTotal) || other.notPunchedInTotal == notPunchedInTotal)&&const DeepCollectionEquality().equals(other.onLeave, onLeave)&&(identical(other.leaveUsage, leaveUsage) || other.leaveUsage == leaveUsage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,date,totalEmployees,scheduledToday,presentToday,onLeaveToday,absentToday,presentPercent,onLeavePercent,absentPercent,holiday,weekOffToday,holidayWorkedToday,weekOffWorkedToday,overtimeMinutesThisMonth,overtimeEmployeesThisMonth,const DeepCollectionEquality().hash(attention),const DeepCollectionEquality().hash(notPunchedIn),notPunchedInTotal,const DeepCollectionEquality().hash(onLeave),leaveUsage]);

@override
String toString() {
  return 'DashboardSummaryModel(date: $date, totalEmployees: $totalEmployees, scheduledToday: $scheduledToday, presentToday: $presentToday, onLeaveToday: $onLeaveToday, absentToday: $absentToday, presentPercent: $presentPercent, onLeavePercent: $onLeavePercent, absentPercent: $absentPercent, holiday: $holiday, weekOffToday: $weekOffToday, holidayWorkedToday: $holidayWorkedToday, weekOffWorkedToday: $weekOffWorkedToday, overtimeMinutesThisMonth: $overtimeMinutesThisMonth, overtimeEmployeesThisMonth: $overtimeEmployeesThisMonth, attention: $attention, notPunchedIn: $notPunchedIn, notPunchedInTotal: $notPunchedInTotal, onLeave: $onLeave, leaveUsage: $leaveUsage)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryModelCopyWith<$Res>  {
  factory $DashboardSummaryModelCopyWith(DashboardSummaryModel value, $Res Function(DashboardSummaryModel) _then) = _$DashboardSummaryModelCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, int totalEmployees, int? scheduledToday, int presentToday, int onLeaveToday, int absentToday, double? presentPercent, double? onLeavePercent, double? absentPercent, HolidayModel? holiday, int weekOffToday, int holidayWorkedToday, int weekOffWorkedToday, int? overtimeMinutesThisMonth, int? overtimeEmployeesThisMonth, List<AttentionItemModel> attention, List<EmployeeSummaryModel> notPunchedIn, int notPunchedInTotal, List<LeaveTodayModel> onLeave, LeaveUsageModel? leaveUsage
});


$HolidayModelCopyWith<$Res>? get holiday;$LeaveUsageModelCopyWith<$Res>? get leaveUsage;

}
/// @nodoc
class _$DashboardSummaryModelCopyWithImpl<$Res>
    implements $DashboardSummaryModelCopyWith<$Res> {
  _$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final DashboardSummaryModel _self;
  final $Res Function(DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalEmployees = null,Object? scheduledToday = freezed,Object? presentToday = null,Object? onLeaveToday = null,Object? absentToday = null,Object? presentPercent = freezed,Object? onLeavePercent = freezed,Object? absentPercent = freezed,Object? holiday = freezed,Object? weekOffToday = null,Object? holidayWorkedToday = null,Object? weekOffWorkedToday = null,Object? overtimeMinutesThisMonth = freezed,Object? overtimeEmployeesThisMonth = freezed,Object? attention = null,Object? notPunchedIn = null,Object? notPunchedInTotal = null,Object? onLeave = null,Object? leaveUsage = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalEmployees: null == totalEmployees ? _self.totalEmployees : totalEmployees // ignore: cast_nullable_to_non_nullable
as int,scheduledToday: freezed == scheduledToday ? _self.scheduledToday : scheduledToday // ignore: cast_nullable_to_non_nullable
as int?,presentToday: null == presentToday ? _self.presentToday : presentToday // ignore: cast_nullable_to_non_nullable
as int,onLeaveToday: null == onLeaveToday ? _self.onLeaveToday : onLeaveToday // ignore: cast_nullable_to_non_nullable
as int,absentToday: null == absentToday ? _self.absentToday : absentToday // ignore: cast_nullable_to_non_nullable
as int,presentPercent: freezed == presentPercent ? _self.presentPercent : presentPercent // ignore: cast_nullable_to_non_nullable
as double?,onLeavePercent: freezed == onLeavePercent ? _self.onLeavePercent : onLeavePercent // ignore: cast_nullable_to_non_nullable
as double?,absentPercent: freezed == absentPercent ? _self.absentPercent : absentPercent // ignore: cast_nullable_to_non_nullable
as double?,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as HolidayModel?,weekOffToday: null == weekOffToday ? _self.weekOffToday : weekOffToday // ignore: cast_nullable_to_non_nullable
as int,holidayWorkedToday: null == holidayWorkedToday ? _self.holidayWorkedToday : holidayWorkedToday // ignore: cast_nullable_to_non_nullable
as int,weekOffWorkedToday: null == weekOffWorkedToday ? _self.weekOffWorkedToday : weekOffWorkedToday // ignore: cast_nullable_to_non_nullable
as int,overtimeMinutesThisMonth: freezed == overtimeMinutesThisMonth ? _self.overtimeMinutesThisMonth : overtimeMinutesThisMonth // ignore: cast_nullable_to_non_nullable
as int?,overtimeEmployeesThisMonth: freezed == overtimeEmployeesThisMonth ? _self.overtimeEmployeesThisMonth : overtimeEmployeesThisMonth // ignore: cast_nullable_to_non_nullable
as int?,attention: null == attention ? _self.attention : attention // ignore: cast_nullable_to_non_nullable
as List<AttentionItemModel>,notPunchedIn: null == notPunchedIn ? _self.notPunchedIn : notPunchedIn // ignore: cast_nullable_to_non_nullable
as List<EmployeeSummaryModel>,notPunchedInTotal: null == notPunchedInTotal ? _self.notPunchedInTotal : notPunchedInTotal // ignore: cast_nullable_to_non_nullable
as int,onLeave: null == onLeave ? _self.onLeave : onLeave // ignore: cast_nullable_to_non_nullable
as List<LeaveTodayModel>,leaveUsage: freezed == leaveUsage ? _self.leaveUsage : leaveUsage // ignore: cast_nullable_to_non_nullable
as LeaveUsageModel?,
  ));
}
/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HolidayModelCopyWith<$Res>? get holiday {
    if (_self.holiday == null) {
    return null;
  }

  return $HolidayModelCopyWith<$Res>(_self.holiday!, (value) {
    return _then(_self.copyWith(holiday: value));
  });
}/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveUsageModelCopyWith<$Res>? get leaveUsage {
    if (_self.leaveUsage == null) {
    return null;
  }

  return $LeaveUsageModelCopyWith<$Res>(_self.leaveUsage!, (value) {
    return _then(_self.copyWith(leaveUsage: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardSummaryModel].
extension DashboardSummaryModelPatterns on DashboardSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  int totalEmployees,  int? scheduledToday,  int presentToday,  int onLeaveToday,  int absentToday,  double? presentPercent,  double? onLeavePercent,  double? absentPercent,  HolidayModel? holiday,  int weekOffToday,  int holidayWorkedToday,  int weekOffWorkedToday,  int? overtimeMinutesThisMonth,  int? overtimeEmployeesThisMonth,  List<AttentionItemModel> attention,  List<EmployeeSummaryModel> notPunchedIn,  int notPunchedInTotal,  List<LeaveTodayModel> onLeave,  LeaveUsageModel? leaveUsage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.date,_that.totalEmployees,_that.scheduledToday,_that.presentToday,_that.onLeaveToday,_that.absentToday,_that.presentPercent,_that.onLeavePercent,_that.absentPercent,_that.holiday,_that.weekOffToday,_that.holidayWorkedToday,_that.weekOffWorkedToday,_that.overtimeMinutesThisMonth,_that.overtimeEmployeesThisMonth,_that.attention,_that.notPunchedIn,_that.notPunchedInTotal,_that.onLeave,_that.leaveUsage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  int totalEmployees,  int? scheduledToday,  int presentToday,  int onLeaveToday,  int absentToday,  double? presentPercent,  double? onLeavePercent,  double? absentPercent,  HolidayModel? holiday,  int weekOffToday,  int holidayWorkedToday,  int weekOffWorkedToday,  int? overtimeMinutesThisMonth,  int? overtimeEmployeesThisMonth,  List<AttentionItemModel> attention,  List<EmployeeSummaryModel> notPunchedIn,  int notPunchedInTotal,  List<LeaveTodayModel> onLeave,  LeaveUsageModel? leaveUsage)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel():
return $default(_that.date,_that.totalEmployees,_that.scheduledToday,_that.presentToday,_that.onLeaveToday,_that.absentToday,_that.presentPercent,_that.onLeavePercent,_that.absentPercent,_that.holiday,_that.weekOffToday,_that.holidayWorkedToday,_that.weekOffWorkedToday,_that.overtimeMinutesThisMonth,_that.overtimeEmployeesThisMonth,_that.attention,_that.notPunchedIn,_that.notPunchedInTotal,_that.onLeave,_that.leaveUsage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  int totalEmployees,  int? scheduledToday,  int presentToday,  int onLeaveToday,  int absentToday,  double? presentPercent,  double? onLeavePercent,  double? absentPercent,  HolidayModel? holiday,  int weekOffToday,  int holidayWorkedToday,  int weekOffWorkedToday,  int? overtimeMinutesThisMonth,  int? overtimeEmployeesThisMonth,  List<AttentionItemModel> attention,  List<EmployeeSummaryModel> notPunchedIn,  int notPunchedInTotal,  List<LeaveTodayModel> onLeave,  LeaveUsageModel? leaveUsage)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.date,_that.totalEmployees,_that.scheduledToday,_that.presentToday,_that.onLeaveToday,_that.absentToday,_that.presentPercent,_that.onLeavePercent,_that.absentPercent,_that.holiday,_that.weekOffToday,_that.holidayWorkedToday,_that.weekOffWorkedToday,_that.overtimeMinutesThisMonth,_that.overtimeEmployeesThisMonth,_that.attention,_that.notPunchedIn,_that.notPunchedInTotal,_that.onLeave,_that.leaveUsage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummaryModel implements DashboardSummaryModel {
  const _DashboardSummaryModel({@DateOnlyConverter() required this.date, required this.totalEmployees, this.scheduledToday, required this.presentToday, required this.onLeaveToday, required this.absentToday, this.presentPercent, this.onLeavePercent, this.absentPercent, this.holiday, this.weekOffToday = 0, this.holidayWorkedToday = 0, this.weekOffWorkedToday = 0, this.overtimeMinutesThisMonth, this.overtimeEmployeesThisMonth, final  List<AttentionItemModel> attention = const <AttentionItemModel>[], final  List<EmployeeSummaryModel> notPunchedIn = const <EmployeeSummaryModel>[], this.notPunchedInTotal = 0, final  List<LeaveTodayModel> onLeave = const <LeaveTodayModel>[], this.leaveUsage}): _attention = attention,_notPunchedIn = notPunchedIn,_onLeave = onLeave;
  factory _DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override final  int totalEmployees;
/// Active employees expected at work today (V2): today is a working day
/// on their schedule, not a company holiday or their weekly off. Present,
/// on leave and absent are counted among them only, and the percentages
/// are shares of this number. Null from an older backend.
@override final  int? scheduledToday;
@override final  int presentToday;
@override final  int onLeaveToday;
@override final  int absentToday;
@override final  double? presentPercent;
@override final  double? onLeavePercent;
@override final  double? absentPercent;
/// Today's company holiday, if any (V2): nobody is absent on it.
@override final  HolidayModel? holiday;
/// Active employees whose weekly off is today, working or not (V2).
@override@JsonKey() final  int weekOffToday;
/// Employees working today on a company holiday or on their weekly off
/// (V2). Their hours count as overtime.
@override@JsonKey() final  int holidayWorkedToday;
@override@JsonKey() final  int weekOffWorkedToday;
/// Overtime of all employees from the 1st of the month to [date], in
/// minutes (V2). Null when the caller lacks `overtime.view`.
@override final  int? overtimeMinutesThisMonth;
/// How many employees have any overtime this month (V2).
@override final  int? overtimeEmployeesThisMonth;
 final  List<AttentionItemModel> _attention;
@override@JsonKey() List<AttentionItemModel> get attention {
  if (_attention is EqualUnmodifiableListView) return _attention;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attention);
}

/// A short preview; [notPunchedInTotal] is the full count.
 final  List<EmployeeSummaryModel> _notPunchedIn;
/// A short preview; [notPunchedInTotal] is the full count.
@override@JsonKey() List<EmployeeSummaryModel> get notPunchedIn {
  if (_notPunchedIn is EqualUnmodifiableListView) return _notPunchedIn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notPunchedIn);
}

@override@JsonKey() final  int notPunchedInTotal;
/// A short preview; [onLeaveToday] is the full count.
 final  List<LeaveTodayModel> _onLeave;
/// A short preview; [onLeaveToday] is the full count.
@override@JsonKey() List<LeaveTodayModel> get onLeave {
  if (_onLeave is EqualUnmodifiableListView) return _onLeave;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_onLeave);
}

@override final  LeaveUsageModel? leaveUsage;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryModelCopyWith<_DashboardSummaryModel> get copyWith => __$DashboardSummaryModelCopyWithImpl<_DashboardSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummaryModel&&(identical(other.date, date) || other.date == date)&&(identical(other.totalEmployees, totalEmployees) || other.totalEmployees == totalEmployees)&&(identical(other.scheduledToday, scheduledToday) || other.scheduledToday == scheduledToday)&&(identical(other.presentToday, presentToday) || other.presentToday == presentToday)&&(identical(other.onLeaveToday, onLeaveToday) || other.onLeaveToday == onLeaveToday)&&(identical(other.absentToday, absentToday) || other.absentToday == absentToday)&&(identical(other.presentPercent, presentPercent) || other.presentPercent == presentPercent)&&(identical(other.onLeavePercent, onLeavePercent) || other.onLeavePercent == onLeavePercent)&&(identical(other.absentPercent, absentPercent) || other.absentPercent == absentPercent)&&(identical(other.holiday, holiday) || other.holiday == holiday)&&(identical(other.weekOffToday, weekOffToday) || other.weekOffToday == weekOffToday)&&(identical(other.holidayWorkedToday, holidayWorkedToday) || other.holidayWorkedToday == holidayWorkedToday)&&(identical(other.weekOffWorkedToday, weekOffWorkedToday) || other.weekOffWorkedToday == weekOffWorkedToday)&&(identical(other.overtimeMinutesThisMonth, overtimeMinutesThisMonth) || other.overtimeMinutesThisMonth == overtimeMinutesThisMonth)&&(identical(other.overtimeEmployeesThisMonth, overtimeEmployeesThisMonth) || other.overtimeEmployeesThisMonth == overtimeEmployeesThisMonth)&&const DeepCollectionEquality().equals(other._attention, _attention)&&const DeepCollectionEquality().equals(other._notPunchedIn, _notPunchedIn)&&(identical(other.notPunchedInTotal, notPunchedInTotal) || other.notPunchedInTotal == notPunchedInTotal)&&const DeepCollectionEquality().equals(other._onLeave, _onLeave)&&(identical(other.leaveUsage, leaveUsage) || other.leaveUsage == leaveUsage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,date,totalEmployees,scheduledToday,presentToday,onLeaveToday,absentToday,presentPercent,onLeavePercent,absentPercent,holiday,weekOffToday,holidayWorkedToday,weekOffWorkedToday,overtimeMinutesThisMonth,overtimeEmployeesThisMonth,const DeepCollectionEquality().hash(_attention),const DeepCollectionEquality().hash(_notPunchedIn),notPunchedInTotal,const DeepCollectionEquality().hash(_onLeave),leaveUsage]);

@override
String toString() {
  return 'DashboardSummaryModel(date: $date, totalEmployees: $totalEmployees, scheduledToday: $scheduledToday, presentToday: $presentToday, onLeaveToday: $onLeaveToday, absentToday: $absentToday, presentPercent: $presentPercent, onLeavePercent: $onLeavePercent, absentPercent: $absentPercent, holiday: $holiday, weekOffToday: $weekOffToday, holidayWorkedToday: $holidayWorkedToday, weekOffWorkedToday: $weekOffWorkedToday, overtimeMinutesThisMonth: $overtimeMinutesThisMonth, overtimeEmployeesThisMonth: $overtimeEmployeesThisMonth, attention: $attention, notPunchedIn: $notPunchedIn, notPunchedInTotal: $notPunchedInTotal, onLeave: $onLeave, leaveUsage: $leaveUsage)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryModelCopyWith<$Res> implements $DashboardSummaryModelCopyWith<$Res> {
  factory _$DashboardSummaryModelCopyWith(_DashboardSummaryModel value, $Res Function(_DashboardSummaryModel) _then) = __$DashboardSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, int totalEmployees, int? scheduledToday, int presentToday, int onLeaveToday, int absentToday, double? presentPercent, double? onLeavePercent, double? absentPercent, HolidayModel? holiday, int weekOffToday, int holidayWorkedToday, int weekOffWorkedToday, int? overtimeMinutesThisMonth, int? overtimeEmployeesThisMonth, List<AttentionItemModel> attention, List<EmployeeSummaryModel> notPunchedIn, int notPunchedInTotal, List<LeaveTodayModel> onLeave, LeaveUsageModel? leaveUsage
});


@override $HolidayModelCopyWith<$Res>? get holiday;@override $LeaveUsageModelCopyWith<$Res>? get leaveUsage;

}
/// @nodoc
class __$DashboardSummaryModelCopyWithImpl<$Res>
    implements _$DashboardSummaryModelCopyWith<$Res> {
  __$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final _DashboardSummaryModel _self;
  final $Res Function(_DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalEmployees = null,Object? scheduledToday = freezed,Object? presentToday = null,Object? onLeaveToday = null,Object? absentToday = null,Object? presentPercent = freezed,Object? onLeavePercent = freezed,Object? absentPercent = freezed,Object? holiday = freezed,Object? weekOffToday = null,Object? holidayWorkedToday = null,Object? weekOffWorkedToday = null,Object? overtimeMinutesThisMonth = freezed,Object? overtimeEmployeesThisMonth = freezed,Object? attention = null,Object? notPunchedIn = null,Object? notPunchedInTotal = null,Object? onLeave = null,Object? leaveUsage = freezed,}) {
  return _then(_DashboardSummaryModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalEmployees: null == totalEmployees ? _self.totalEmployees : totalEmployees // ignore: cast_nullable_to_non_nullable
as int,scheduledToday: freezed == scheduledToday ? _self.scheduledToday : scheduledToday // ignore: cast_nullable_to_non_nullable
as int?,presentToday: null == presentToday ? _self.presentToday : presentToday // ignore: cast_nullable_to_non_nullable
as int,onLeaveToday: null == onLeaveToday ? _self.onLeaveToday : onLeaveToday // ignore: cast_nullable_to_non_nullable
as int,absentToday: null == absentToday ? _self.absentToday : absentToday // ignore: cast_nullable_to_non_nullable
as int,presentPercent: freezed == presentPercent ? _self.presentPercent : presentPercent // ignore: cast_nullable_to_non_nullable
as double?,onLeavePercent: freezed == onLeavePercent ? _self.onLeavePercent : onLeavePercent // ignore: cast_nullable_to_non_nullable
as double?,absentPercent: freezed == absentPercent ? _self.absentPercent : absentPercent // ignore: cast_nullable_to_non_nullable
as double?,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as HolidayModel?,weekOffToday: null == weekOffToday ? _self.weekOffToday : weekOffToday // ignore: cast_nullable_to_non_nullable
as int,holidayWorkedToday: null == holidayWorkedToday ? _self.holidayWorkedToday : holidayWorkedToday // ignore: cast_nullable_to_non_nullable
as int,weekOffWorkedToday: null == weekOffWorkedToday ? _self.weekOffWorkedToday : weekOffWorkedToday // ignore: cast_nullable_to_non_nullable
as int,overtimeMinutesThisMonth: freezed == overtimeMinutesThisMonth ? _self.overtimeMinutesThisMonth : overtimeMinutesThisMonth // ignore: cast_nullable_to_non_nullable
as int?,overtimeEmployeesThisMonth: freezed == overtimeEmployeesThisMonth ? _self.overtimeEmployeesThisMonth : overtimeEmployeesThisMonth // ignore: cast_nullable_to_non_nullable
as int?,attention: null == attention ? _self._attention : attention // ignore: cast_nullable_to_non_nullable
as List<AttentionItemModel>,notPunchedIn: null == notPunchedIn ? _self._notPunchedIn : notPunchedIn // ignore: cast_nullable_to_non_nullable
as List<EmployeeSummaryModel>,notPunchedInTotal: null == notPunchedInTotal ? _self.notPunchedInTotal : notPunchedInTotal // ignore: cast_nullable_to_non_nullable
as int,onLeave: null == onLeave ? _self._onLeave : onLeave // ignore: cast_nullable_to_non_nullable
as List<LeaveTodayModel>,leaveUsage: freezed == leaveUsage ? _self.leaveUsage : leaveUsage // ignore: cast_nullable_to_non_nullable
as LeaveUsageModel?,
  ));
}

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HolidayModelCopyWith<$Res>? get holiday {
    if (_self.holiday == null) {
    return null;
  }

  return $HolidayModelCopyWith<$Res>(_self.holiday!, (value) {
    return _then(_self.copyWith(holiday: value));
  });
}/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveUsageModelCopyWith<$Res>? get leaveUsage {
    if (_self.leaveUsage == null) {
    return null;
  }

  return $LeaveUsageModelCopyWith<$Res>(_self.leaveUsage!, (value) {
    return _then(_self.copyWith(leaveUsage: value));
  });
}
}


/// @nodoc
mixin _$AttentionItemModel {

@JsonKey(unknownEnumValue: AttentionKind.unknown) AttentionKind get kind; int get count;
/// Create a copy of AttentionItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttentionItemModelCopyWith<AttentionItemModel> get copyWith => _$AttentionItemModelCopyWithImpl<AttentionItemModel>(this as AttentionItemModel, _$identity);

  /// Serializes this AttentionItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttentionItemModel&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,count);

@override
String toString() {
  return 'AttentionItemModel(kind: $kind, count: $count)';
}


}

/// @nodoc
abstract mixin class $AttentionItemModelCopyWith<$Res>  {
  factory $AttentionItemModelCopyWith(AttentionItemModel value, $Res Function(AttentionItemModel) _then) = _$AttentionItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: AttentionKind.unknown) AttentionKind kind, int count
});




}
/// @nodoc
class _$AttentionItemModelCopyWithImpl<$Res>
    implements $AttentionItemModelCopyWith<$Res> {
  _$AttentionItemModelCopyWithImpl(this._self, this._then);

  final AttentionItemModel _self;
  final $Res Function(AttentionItemModel) _then;

/// Create a copy of AttentionItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? count = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttentionKind,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttentionItemModel].
extension AttentionItemModelPatterns on AttentionItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttentionItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttentionItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttentionItemModel value)  $default,){
final _that = this;
switch (_that) {
case _AttentionItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttentionItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttentionItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: AttentionKind.unknown)  AttentionKind kind,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttentionItemModel() when $default != null:
return $default(_that.kind,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: AttentionKind.unknown)  AttentionKind kind,  int count)  $default,) {final _that = this;
switch (_that) {
case _AttentionItemModel():
return $default(_that.kind,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: AttentionKind.unknown)  AttentionKind kind,  int count)?  $default,) {final _that = this;
switch (_that) {
case _AttentionItemModel() when $default != null:
return $default(_that.kind,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttentionItemModel implements AttentionItemModel {
  const _AttentionItemModel({@JsonKey(unknownEnumValue: AttentionKind.unknown) required this.kind, required this.count});
  factory _AttentionItemModel.fromJson(Map<String, dynamic> json) => _$AttentionItemModelFromJson(json);

@override@JsonKey(unknownEnumValue: AttentionKind.unknown) final  AttentionKind kind;
@override final  int count;

/// Create a copy of AttentionItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttentionItemModelCopyWith<_AttentionItemModel> get copyWith => __$AttentionItemModelCopyWithImpl<_AttentionItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttentionItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttentionItemModel&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,count);

@override
String toString() {
  return 'AttentionItemModel(kind: $kind, count: $count)';
}


}

/// @nodoc
abstract mixin class _$AttentionItemModelCopyWith<$Res> implements $AttentionItemModelCopyWith<$Res> {
  factory _$AttentionItemModelCopyWith(_AttentionItemModel value, $Res Function(_AttentionItemModel) _then) = __$AttentionItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: AttentionKind.unknown) AttentionKind kind, int count
});




}
/// @nodoc
class __$AttentionItemModelCopyWithImpl<$Res>
    implements _$AttentionItemModelCopyWith<$Res> {
  __$AttentionItemModelCopyWithImpl(this._self, this._then);

  final _AttentionItemModel _self;
  final $Res Function(_AttentionItemModel) _then;

/// Create a copy of AttentionItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? count = null,}) {
  return _then(_AttentionItemModel(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttentionKind,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LeaveTodayModel {

 EmployeeSummaryModel get employee;/// Display name of the leave type, as defined on the backend.
 String get leaveType;@DateOnlyConverter() DateTime get endDate;/// Leave length in days as counted by the backend (may be fractional).
 double get days; bool get isHalfDay;
/// Create a copy of LeaveTodayModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveTodayModelCopyWith<LeaveTodayModel> get copyWith => _$LeaveTodayModelCopyWithImpl<LeaveTodayModel>(this as LeaveTodayModel, _$identity);

  /// Serializes this LeaveTodayModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveTodayModel&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employee,leaveType,endDate,days,isHalfDay);

@override
String toString() {
  return 'LeaveTodayModel(employee: $employee, leaveType: $leaveType, endDate: $endDate, days: $days, isHalfDay: $isHalfDay)';
}


}

/// @nodoc
abstract mixin class $LeaveTodayModelCopyWith<$Res>  {
  factory $LeaveTodayModelCopyWith(LeaveTodayModel value, $Res Function(LeaveTodayModel) _then) = _$LeaveTodayModelCopyWithImpl;
@useResult
$Res call({
 EmployeeSummaryModel employee, String leaveType,@DateOnlyConverter() DateTime endDate, double days, bool isHalfDay
});


$EmployeeSummaryModelCopyWith<$Res> get employee;

}
/// @nodoc
class _$LeaveTodayModelCopyWithImpl<$Res>
    implements $LeaveTodayModelCopyWith<$Res> {
  _$LeaveTodayModelCopyWithImpl(this._self, this._then);

  final LeaveTodayModel _self;
  final $Res Function(LeaveTodayModel) _then;

/// Create a copy of LeaveTodayModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employee = null,Object? leaveType = null,Object? endDate = null,Object? days = null,Object? isHalfDay = null,}) {
  return _then(_self.copyWith(
employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LeaveTodayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveTodayModel].
extension LeaveTodayModelPatterns on LeaveTodayModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveTodayModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveTodayModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveTodayModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveTodayModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveTodayModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveTodayModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EmployeeSummaryModel employee,  String leaveType, @DateOnlyConverter()  DateTime endDate,  double days,  bool isHalfDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveTodayModel() when $default != null:
return $default(_that.employee,_that.leaveType,_that.endDate,_that.days,_that.isHalfDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EmployeeSummaryModel employee,  String leaveType, @DateOnlyConverter()  DateTime endDate,  double days,  bool isHalfDay)  $default,) {final _that = this;
switch (_that) {
case _LeaveTodayModel():
return $default(_that.employee,_that.leaveType,_that.endDate,_that.days,_that.isHalfDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EmployeeSummaryModel employee,  String leaveType, @DateOnlyConverter()  DateTime endDate,  double days,  bool isHalfDay)?  $default,) {final _that = this;
switch (_that) {
case _LeaveTodayModel() when $default != null:
return $default(_that.employee,_that.leaveType,_that.endDate,_that.days,_that.isHalfDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveTodayModel implements LeaveTodayModel {
  const _LeaveTodayModel({required this.employee, required this.leaveType, @DateOnlyConverter() required this.endDate, required this.days, this.isHalfDay = false});
  factory _LeaveTodayModel.fromJson(Map<String, dynamic> json) => _$LeaveTodayModelFromJson(json);

@override final  EmployeeSummaryModel employee;
/// Display name of the leave type, as defined on the backend.
@override final  String leaveType;
@override@DateOnlyConverter() final  DateTime endDate;
/// Leave length in days as counted by the backend (may be fractional).
@override final  double days;
@override@JsonKey() final  bool isHalfDay;

/// Create a copy of LeaveTodayModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveTodayModelCopyWith<_LeaveTodayModel> get copyWith => __$LeaveTodayModelCopyWithImpl<_LeaveTodayModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveTodayModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveTodayModel&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employee,leaveType,endDate,days,isHalfDay);

@override
String toString() {
  return 'LeaveTodayModel(employee: $employee, leaveType: $leaveType, endDate: $endDate, days: $days, isHalfDay: $isHalfDay)';
}


}

/// @nodoc
abstract mixin class _$LeaveTodayModelCopyWith<$Res> implements $LeaveTodayModelCopyWith<$Res> {
  factory _$LeaveTodayModelCopyWith(_LeaveTodayModel value, $Res Function(_LeaveTodayModel) _then) = __$LeaveTodayModelCopyWithImpl;
@override @useResult
$Res call({
 EmployeeSummaryModel employee, String leaveType,@DateOnlyConverter() DateTime endDate, double days, bool isHalfDay
});


@override $EmployeeSummaryModelCopyWith<$Res> get employee;

}
/// @nodoc
class __$LeaveTodayModelCopyWithImpl<$Res>
    implements _$LeaveTodayModelCopyWith<$Res> {
  __$LeaveTodayModelCopyWithImpl(this._self, this._then);

  final _LeaveTodayModel _self;
  final $Res Function(_LeaveTodayModel) _then;

/// Create a copy of LeaveTodayModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employee = null,Object? leaveType = null,Object? endDate = null,Object? days = null,Object? isHalfDay = null,}) {
  return _then(_LeaveTodayModel(
employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummaryModel,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,isHalfDay: null == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LeaveTodayModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmployeeSummaryModelCopyWith<$Res> get employee {
  
  return $EmployeeSummaryModelCopyWith<$Res>(_self.employee, (value) {
    return _then(_self.copyWith(employee: value));
  });
}
}


/// @nodoc
mixin _$LeaveUsageModel {

 int get year;/// Casual days left today, summed over active employees.
 double get casualRemainingDays;/// Approved Casual days dated in [year].
 double get casualTakenDays;/// Approved Unpaid days dated in [year].
 double get unpaidTakenDays;/// Leave requests whose dates overlap the current month, by status.
 int get approvedThisMonth; int get pendingThisMonth; int get rejectedThisMonth;
/// Create a copy of LeaveUsageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveUsageModelCopyWith<LeaveUsageModel> get copyWith => _$LeaveUsageModelCopyWithImpl<LeaveUsageModel>(this as LeaveUsageModel, _$identity);

  /// Serializes this LeaveUsageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveUsageModel&&(identical(other.year, year) || other.year == year)&&(identical(other.casualRemainingDays, casualRemainingDays) || other.casualRemainingDays == casualRemainingDays)&&(identical(other.casualTakenDays, casualTakenDays) || other.casualTakenDays == casualTakenDays)&&(identical(other.unpaidTakenDays, unpaidTakenDays) || other.unpaidTakenDays == unpaidTakenDays)&&(identical(other.approvedThisMonth, approvedThisMonth) || other.approvedThisMonth == approvedThisMonth)&&(identical(other.pendingThisMonth, pendingThisMonth) || other.pendingThisMonth == pendingThisMonth)&&(identical(other.rejectedThisMonth, rejectedThisMonth) || other.rejectedThisMonth == rejectedThisMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,casualRemainingDays,casualTakenDays,unpaidTakenDays,approvedThisMonth,pendingThisMonth,rejectedThisMonth);

@override
String toString() {
  return 'LeaveUsageModel(year: $year, casualRemainingDays: $casualRemainingDays, casualTakenDays: $casualTakenDays, unpaidTakenDays: $unpaidTakenDays, approvedThisMonth: $approvedThisMonth, pendingThisMonth: $pendingThisMonth, rejectedThisMonth: $rejectedThisMonth)';
}


}

/// @nodoc
abstract mixin class $LeaveUsageModelCopyWith<$Res>  {
  factory $LeaveUsageModelCopyWith(LeaveUsageModel value, $Res Function(LeaveUsageModel) _then) = _$LeaveUsageModelCopyWithImpl;
@useResult
$Res call({
 int year, double casualRemainingDays, double casualTakenDays, double unpaidTakenDays, int approvedThisMonth, int pendingThisMonth, int rejectedThisMonth
});




}
/// @nodoc
class _$LeaveUsageModelCopyWithImpl<$Res>
    implements $LeaveUsageModelCopyWith<$Res> {
  _$LeaveUsageModelCopyWithImpl(this._self, this._then);

  final LeaveUsageModel _self;
  final $Res Function(LeaveUsageModel) _then;

/// Create a copy of LeaveUsageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? casualRemainingDays = null,Object? casualTakenDays = null,Object? unpaidTakenDays = null,Object? approvedThisMonth = null,Object? pendingThisMonth = null,Object? rejectedThisMonth = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,casualRemainingDays: null == casualRemainingDays ? _self.casualRemainingDays : casualRemainingDays // ignore: cast_nullable_to_non_nullable
as double,casualTakenDays: null == casualTakenDays ? _self.casualTakenDays : casualTakenDays // ignore: cast_nullable_to_non_nullable
as double,unpaidTakenDays: null == unpaidTakenDays ? _self.unpaidTakenDays : unpaidTakenDays // ignore: cast_nullable_to_non_nullable
as double,approvedThisMonth: null == approvedThisMonth ? _self.approvedThisMonth : approvedThisMonth // ignore: cast_nullable_to_non_nullable
as int,pendingThisMonth: null == pendingThisMonth ? _self.pendingThisMonth : pendingThisMonth // ignore: cast_nullable_to_non_nullable
as int,rejectedThisMonth: null == rejectedThisMonth ? _self.rejectedThisMonth : rejectedThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveUsageModel].
extension LeaveUsageModelPatterns on LeaveUsageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveUsageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveUsageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveUsageModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveUsageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveUsageModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveUsageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  double casualRemainingDays,  double casualTakenDays,  double unpaidTakenDays,  int approvedThisMonth,  int pendingThisMonth,  int rejectedThisMonth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveUsageModel() when $default != null:
return $default(_that.year,_that.casualRemainingDays,_that.casualTakenDays,_that.unpaidTakenDays,_that.approvedThisMonth,_that.pendingThisMonth,_that.rejectedThisMonth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  double casualRemainingDays,  double casualTakenDays,  double unpaidTakenDays,  int approvedThisMonth,  int pendingThisMonth,  int rejectedThisMonth)  $default,) {final _that = this;
switch (_that) {
case _LeaveUsageModel():
return $default(_that.year,_that.casualRemainingDays,_that.casualTakenDays,_that.unpaidTakenDays,_that.approvedThisMonth,_that.pendingThisMonth,_that.rejectedThisMonth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  double casualRemainingDays,  double casualTakenDays,  double unpaidTakenDays,  int approvedThisMonth,  int pendingThisMonth,  int rejectedThisMonth)?  $default,) {final _that = this;
switch (_that) {
case _LeaveUsageModel() when $default != null:
return $default(_that.year,_that.casualRemainingDays,_that.casualTakenDays,_that.unpaidTakenDays,_that.approvedThisMonth,_that.pendingThisMonth,_that.rejectedThisMonth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveUsageModel implements LeaveUsageModel {
  const _LeaveUsageModel({required this.year, required this.casualRemainingDays, required this.casualTakenDays, required this.unpaidTakenDays, this.approvedThisMonth = 0, this.pendingThisMonth = 0, this.rejectedThisMonth = 0});
  factory _LeaveUsageModel.fromJson(Map<String, dynamic> json) => _$LeaveUsageModelFromJson(json);

@override final  int year;
/// Casual days left today, summed over active employees.
@override final  double casualRemainingDays;
/// Approved Casual days dated in [year].
@override final  double casualTakenDays;
/// Approved Unpaid days dated in [year].
@override final  double unpaidTakenDays;
/// Leave requests whose dates overlap the current month, by status.
@override@JsonKey() final  int approvedThisMonth;
@override@JsonKey() final  int pendingThisMonth;
@override@JsonKey() final  int rejectedThisMonth;

/// Create a copy of LeaveUsageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveUsageModelCopyWith<_LeaveUsageModel> get copyWith => __$LeaveUsageModelCopyWithImpl<_LeaveUsageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveUsageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveUsageModel&&(identical(other.year, year) || other.year == year)&&(identical(other.casualRemainingDays, casualRemainingDays) || other.casualRemainingDays == casualRemainingDays)&&(identical(other.casualTakenDays, casualTakenDays) || other.casualTakenDays == casualTakenDays)&&(identical(other.unpaidTakenDays, unpaidTakenDays) || other.unpaidTakenDays == unpaidTakenDays)&&(identical(other.approvedThisMonth, approvedThisMonth) || other.approvedThisMonth == approvedThisMonth)&&(identical(other.pendingThisMonth, pendingThisMonth) || other.pendingThisMonth == pendingThisMonth)&&(identical(other.rejectedThisMonth, rejectedThisMonth) || other.rejectedThisMonth == rejectedThisMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,casualRemainingDays,casualTakenDays,unpaidTakenDays,approvedThisMonth,pendingThisMonth,rejectedThisMonth);

@override
String toString() {
  return 'LeaveUsageModel(year: $year, casualRemainingDays: $casualRemainingDays, casualTakenDays: $casualTakenDays, unpaidTakenDays: $unpaidTakenDays, approvedThisMonth: $approvedThisMonth, pendingThisMonth: $pendingThisMonth, rejectedThisMonth: $rejectedThisMonth)';
}


}

/// @nodoc
abstract mixin class _$LeaveUsageModelCopyWith<$Res> implements $LeaveUsageModelCopyWith<$Res> {
  factory _$LeaveUsageModelCopyWith(_LeaveUsageModel value, $Res Function(_LeaveUsageModel) _then) = __$LeaveUsageModelCopyWithImpl;
@override @useResult
$Res call({
 int year, double casualRemainingDays, double casualTakenDays, double unpaidTakenDays, int approvedThisMonth, int pendingThisMonth, int rejectedThisMonth
});




}
/// @nodoc
class __$LeaveUsageModelCopyWithImpl<$Res>
    implements _$LeaveUsageModelCopyWith<$Res> {
  __$LeaveUsageModelCopyWithImpl(this._self, this._then);

  final _LeaveUsageModel _self;
  final $Res Function(_LeaveUsageModel) _then;

/// Create a copy of LeaveUsageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? casualRemainingDays = null,Object? casualTakenDays = null,Object? unpaidTakenDays = null,Object? approvedThisMonth = null,Object? pendingThisMonth = null,Object? rejectedThisMonth = null,}) {
  return _then(_LeaveUsageModel(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,casualRemainingDays: null == casualRemainingDays ? _self.casualRemainingDays : casualRemainingDays // ignore: cast_nullable_to_non_nullable
as double,casualTakenDays: null == casualTakenDays ? _self.casualTakenDays : casualTakenDays // ignore: cast_nullable_to_non_nullable
as double,unpaidTakenDays: null == unpaidTakenDays ? _self.unpaidTakenDays : unpaidTakenDays // ignore: cast_nullable_to_non_nullable
as double,approvedThisMonth: null == approvedThisMonth ? _self.approvedThisMonth : approvedThisMonth // ignore: cast_nullable_to_non_nullable
as int,pendingThisMonth: null == pendingThisMonth ? _self.pendingThisMonth : pendingThisMonth // ignore: cast_nullable_to_non_nullable
as int,rejectedThisMonth: null == rejectedThisMonth ? _self.rejectedThisMonth : rejectedThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
