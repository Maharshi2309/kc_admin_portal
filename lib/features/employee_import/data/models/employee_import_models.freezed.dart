// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_import_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImportCountsModel {

 int get valid; int get warnings; int get errors;/// Existing employees left as they are (Skip, or nothing to change).
 int get skipped;
/// Create a copy of ImportCountsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportCountsModelCopyWith<ImportCountsModel> get copyWith => _$ImportCountsModelCopyWithImpl<ImportCountsModel>(this as ImportCountsModel, _$identity);

  /// Serializes this ImportCountsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportCountsModel&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.warnings, warnings) || other.warnings == warnings)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valid,warnings,errors,skipped);

@override
String toString() {
  return 'ImportCountsModel(valid: $valid, warnings: $warnings, errors: $errors, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class $ImportCountsModelCopyWith<$Res>  {
  factory $ImportCountsModelCopyWith(ImportCountsModel value, $Res Function(ImportCountsModel) _then) = _$ImportCountsModelCopyWithImpl;
@useResult
$Res call({
 int valid, int warnings, int errors, int skipped
});




}
/// @nodoc
class _$ImportCountsModelCopyWithImpl<$Res>
    implements $ImportCountsModelCopyWith<$Res> {
  _$ImportCountsModelCopyWithImpl(this._self, this._then);

  final ImportCountsModel _self;
  final $Res Function(ImportCountsModel) _then;

/// Create a copy of ImportCountsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? valid = null,Object? warnings = null,Object? errors = null,Object? skipped = null,}) {
  return _then(_self.copyWith(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportCountsModel].
extension ImportCountsModelPatterns on ImportCountsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportCountsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportCountsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportCountsModel value)  $default,){
final _that = this;
switch (_that) {
case _ImportCountsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportCountsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImportCountsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int valid,  int warnings,  int errors,  int skipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportCountsModel() when $default != null:
return $default(_that.valid,_that.warnings,_that.errors,_that.skipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int valid,  int warnings,  int errors,  int skipped)  $default,) {final _that = this;
switch (_that) {
case _ImportCountsModel():
return $default(_that.valid,_that.warnings,_that.errors,_that.skipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int valid,  int warnings,  int errors,  int skipped)?  $default,) {final _that = this;
switch (_that) {
case _ImportCountsModel() when $default != null:
return $default(_that.valid,_that.warnings,_that.errors,_that.skipped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportCountsModel implements ImportCountsModel {
  const _ImportCountsModel({this.valid = 0, this.warnings = 0, this.errors = 0, this.skipped = 0});
  factory _ImportCountsModel.fromJson(Map<String, dynamic> json) => _$ImportCountsModelFromJson(json);

@override@JsonKey() final  int valid;
@override@JsonKey() final  int warnings;
@override@JsonKey() final  int errors;
/// Existing employees left as they are (Skip, or nothing to change).
@override@JsonKey() final  int skipped;

/// Create a copy of ImportCountsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportCountsModelCopyWith<_ImportCountsModel> get copyWith => __$ImportCountsModelCopyWithImpl<_ImportCountsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportCountsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportCountsModel&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.warnings, warnings) || other.warnings == warnings)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valid,warnings,errors,skipped);

@override
String toString() {
  return 'ImportCountsModel(valid: $valid, warnings: $warnings, errors: $errors, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class _$ImportCountsModelCopyWith<$Res> implements $ImportCountsModelCopyWith<$Res> {
  factory _$ImportCountsModelCopyWith(_ImportCountsModel value, $Res Function(_ImportCountsModel) _then) = __$ImportCountsModelCopyWithImpl;
@override @useResult
$Res call({
 int valid, int warnings, int errors, int skipped
});




}
/// @nodoc
class __$ImportCountsModelCopyWithImpl<$Res>
    implements _$ImportCountsModelCopyWith<$Res> {
  __$ImportCountsModelCopyWithImpl(this._self, this._then);

  final _ImportCountsModel _self;
  final $Res Function(_ImportCountsModel) _then;

/// Create a copy of ImportCountsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? valid = null,Object? warnings = null,Object? errors = null,Object? skipped = null,}) {
  return _then(_ImportCountsModel(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ImportResultModel {

 int get imported; int get updated; int get skipped; int get failed;
/// Create a copy of ImportResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportResultModelCopyWith<ImportResultModel> get copyWith => _$ImportResultModelCopyWithImpl<ImportResultModel>(this as ImportResultModel, _$identity);

  /// Serializes this ImportResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportResultModel&&(identical(other.imported, imported) || other.imported == imported)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.failed, failed) || other.failed == failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imported,updated,skipped,failed);

@override
String toString() {
  return 'ImportResultModel(imported: $imported, updated: $updated, skipped: $skipped, failed: $failed)';
}


}

/// @nodoc
abstract mixin class $ImportResultModelCopyWith<$Res>  {
  factory $ImportResultModelCopyWith(ImportResultModel value, $Res Function(ImportResultModel) _then) = _$ImportResultModelCopyWithImpl;
@useResult
$Res call({
 int imported, int updated, int skipped, int failed
});




}
/// @nodoc
class _$ImportResultModelCopyWithImpl<$Res>
    implements $ImportResultModelCopyWith<$Res> {
  _$ImportResultModelCopyWithImpl(this._self, this._then);

  final ImportResultModel _self;
  final $Res Function(ImportResultModel) _then;

/// Create a copy of ImportResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imported = null,Object? updated = null,Object? skipped = null,Object? failed = null,}) {
  return _then(_self.copyWith(
imported: null == imported ? _self.imported : imported // ignore: cast_nullable_to_non_nullable
as int,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportResultModel].
extension ImportResultModelPatterns on ImportResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportResultModel value)  $default,){
final _that = this;
switch (_that) {
case _ImportResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImportResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int imported,  int updated,  int skipped,  int failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportResultModel() when $default != null:
return $default(_that.imported,_that.updated,_that.skipped,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int imported,  int updated,  int skipped,  int failed)  $default,) {final _that = this;
switch (_that) {
case _ImportResultModel():
return $default(_that.imported,_that.updated,_that.skipped,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int imported,  int updated,  int skipped,  int failed)?  $default,) {final _that = this;
switch (_that) {
case _ImportResultModel() when $default != null:
return $default(_that.imported,_that.updated,_that.skipped,_that.failed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportResultModel implements ImportResultModel {
  const _ImportResultModel({this.imported = 0, this.updated = 0, this.skipped = 0, this.failed = 0});
  factory _ImportResultModel.fromJson(Map<String, dynamic> json) => _$ImportResultModelFromJson(json);

@override@JsonKey() final  int imported;
@override@JsonKey() final  int updated;
@override@JsonKey() final  int skipped;
@override@JsonKey() final  int failed;

/// Create a copy of ImportResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportResultModelCopyWith<_ImportResultModel> get copyWith => __$ImportResultModelCopyWithImpl<_ImportResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportResultModel&&(identical(other.imported, imported) || other.imported == imported)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.failed, failed) || other.failed == failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imported,updated,skipped,failed);

@override
String toString() {
  return 'ImportResultModel(imported: $imported, updated: $updated, skipped: $skipped, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$ImportResultModelCopyWith<$Res> implements $ImportResultModelCopyWith<$Res> {
  factory _$ImportResultModelCopyWith(_ImportResultModel value, $Res Function(_ImportResultModel) _then) = __$ImportResultModelCopyWithImpl;
@override @useResult
$Res call({
 int imported, int updated, int skipped, int failed
});




}
/// @nodoc
class __$ImportResultModelCopyWithImpl<$Res>
    implements _$ImportResultModelCopyWith<$Res> {
  __$ImportResultModelCopyWithImpl(this._self, this._then);

  final _ImportResultModel _self;
  final $Res Function(_ImportResultModel) _then;

/// Create a copy of ImportResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imported = null,Object? updated = null,Object? skipped = null,Object? failed = null,}) {
  return _then(_ImportResultModel(
imported: null == imported ? _self.imported : imported // ignore: cast_nullable_to_non_nullable
as int,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EmployeeImportModel {

@JsonKey(fromJson: idFromJson) String get id; String get fileName;@JsonKey(unknownEnumValue: ImportStatus.unknown) ImportStatus get status;/// The file's column headers, in order.
 List<String> get headers;/// The first few rows, as text, for the mapping screen.
 List<List<String>> get sampleRows; int get rowCount;/// Header → field key, guessed from the header names.
 Map<String, String?> get suggestedMapping;/// What was last checked with (after `validated`).
 Map<String, String?>? get mapping;@JsonKey(unknownEnumValue: DuplicateStrategy.skip) DuplicateStrategy? get duplicateStrategy; bool get createMissing; bool get assignEcNumbers; ImportCountsModel? get counts;/// While importing: rows done so far.
 int get processed; ImportResultModel? get result;
/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeImportModelCopyWith<EmployeeImportModel> get copyWith => _$EmployeeImportModelCopyWithImpl<EmployeeImportModel>(this as EmployeeImportModel, _$identity);

  /// Serializes this EmployeeImportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeImportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.sampleRows, sampleRows)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&const DeepCollectionEquality().equals(other.suggestedMapping, suggestedMapping)&&const DeepCollectionEquality().equals(other.mapping, mapping)&&(identical(other.duplicateStrategy, duplicateStrategy) || other.duplicateStrategy == duplicateStrategy)&&(identical(other.createMissing, createMissing) || other.createMissing == createMissing)&&(identical(other.assignEcNumbers, assignEcNumbers) || other.assignEcNumbers == assignEcNumbers)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileName,status,const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(sampleRows),rowCount,const DeepCollectionEquality().hash(suggestedMapping),const DeepCollectionEquality().hash(mapping),duplicateStrategy,createMissing,assignEcNumbers,counts,processed,result);

@override
String toString() {
  return 'EmployeeImportModel(id: $id, fileName: $fileName, status: $status, headers: $headers, sampleRows: $sampleRows, rowCount: $rowCount, suggestedMapping: $suggestedMapping, mapping: $mapping, duplicateStrategy: $duplicateStrategy, createMissing: $createMissing, assignEcNumbers: $assignEcNumbers, counts: $counts, processed: $processed, result: $result)';
}


}

/// @nodoc
abstract mixin class $EmployeeImportModelCopyWith<$Res>  {
  factory $EmployeeImportModelCopyWith(EmployeeImportModel value, $Res Function(EmployeeImportModel) _then) = _$EmployeeImportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String fileName,@JsonKey(unknownEnumValue: ImportStatus.unknown) ImportStatus status, List<String> headers, List<List<String>> sampleRows, int rowCount, Map<String, String?> suggestedMapping, Map<String, String?>? mapping,@JsonKey(unknownEnumValue: DuplicateStrategy.skip) DuplicateStrategy? duplicateStrategy, bool createMissing, bool assignEcNumbers, ImportCountsModel? counts, int processed, ImportResultModel? result
});


$ImportCountsModelCopyWith<$Res>? get counts;$ImportResultModelCopyWith<$Res>? get result;

}
/// @nodoc
class _$EmployeeImportModelCopyWithImpl<$Res>
    implements $EmployeeImportModelCopyWith<$Res> {
  _$EmployeeImportModelCopyWithImpl(this._self, this._then);

  final EmployeeImportModel _self;
  final $Res Function(EmployeeImportModel) _then;

/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fileName = null,Object? status = null,Object? headers = null,Object? sampleRows = null,Object? rowCount = null,Object? suggestedMapping = null,Object? mapping = freezed,Object? duplicateStrategy = freezed,Object? createMissing = null,Object? assignEcNumbers = null,Object? counts = freezed,Object? processed = null,Object? result = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportStatus,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as List<String>,sampleRows: null == sampleRows ? _self.sampleRows : sampleRows // ignore: cast_nullable_to_non_nullable
as List<List<String>>,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,suggestedMapping: null == suggestedMapping ? _self.suggestedMapping : suggestedMapping // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,mapping: freezed == mapping ? _self.mapping : mapping // ignore: cast_nullable_to_non_nullable
as Map<String, String?>?,duplicateStrategy: freezed == duplicateStrategy ? _self.duplicateStrategy : duplicateStrategy // ignore: cast_nullable_to_non_nullable
as DuplicateStrategy?,createMissing: null == createMissing ? _self.createMissing : createMissing // ignore: cast_nullable_to_non_nullable
as bool,assignEcNumbers: null == assignEcNumbers ? _self.assignEcNumbers : assignEcNumbers // ignore: cast_nullable_to_non_nullable
as bool,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as ImportCountsModel?,processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResultModel?,
  ));
}
/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportCountsModelCopyWith<$Res>? get counts {
    if (_self.counts == null) {
    return null;
  }

  return $ImportCountsModelCopyWith<$Res>(_self.counts!, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportResultModelCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $ImportResultModelCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmployeeImportModel].
extension EmployeeImportModelPatterns on EmployeeImportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeImportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeImportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeImportModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeImportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeImportModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeImportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String fileName, @JsonKey(unknownEnumValue: ImportStatus.unknown)  ImportStatus status,  List<String> headers,  List<List<String>> sampleRows,  int rowCount,  Map<String, String?> suggestedMapping,  Map<String, String?>? mapping, @JsonKey(unknownEnumValue: DuplicateStrategy.skip)  DuplicateStrategy? duplicateStrategy,  bool createMissing,  bool assignEcNumbers,  ImportCountsModel? counts,  int processed,  ImportResultModel? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeImportModel() when $default != null:
return $default(_that.id,_that.fileName,_that.status,_that.headers,_that.sampleRows,_that.rowCount,_that.suggestedMapping,_that.mapping,_that.duplicateStrategy,_that.createMissing,_that.assignEcNumbers,_that.counts,_that.processed,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String id,  String fileName, @JsonKey(unknownEnumValue: ImportStatus.unknown)  ImportStatus status,  List<String> headers,  List<List<String>> sampleRows,  int rowCount,  Map<String, String?> suggestedMapping,  Map<String, String?>? mapping, @JsonKey(unknownEnumValue: DuplicateStrategy.skip)  DuplicateStrategy? duplicateStrategy,  bool createMissing,  bool assignEcNumbers,  ImportCountsModel? counts,  int processed,  ImportResultModel? result)  $default,) {final _that = this;
switch (_that) {
case _EmployeeImportModel():
return $default(_that.id,_that.fileName,_that.status,_that.headers,_that.sampleRows,_that.rowCount,_that.suggestedMapping,_that.mapping,_that.duplicateStrategy,_that.createMissing,_that.assignEcNumbers,_that.counts,_that.processed,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String id,  String fileName, @JsonKey(unknownEnumValue: ImportStatus.unknown)  ImportStatus status,  List<String> headers,  List<List<String>> sampleRows,  int rowCount,  Map<String, String?> suggestedMapping,  Map<String, String?>? mapping, @JsonKey(unknownEnumValue: DuplicateStrategy.skip)  DuplicateStrategy? duplicateStrategy,  bool createMissing,  bool assignEcNumbers,  ImportCountsModel? counts,  int processed,  ImportResultModel? result)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeImportModel() when $default != null:
return $default(_that.id,_that.fileName,_that.status,_that.headers,_that.sampleRows,_that.rowCount,_that.suggestedMapping,_that.mapping,_that.duplicateStrategy,_that.createMissing,_that.assignEcNumbers,_that.counts,_that.processed,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeImportModel extends EmployeeImportModel {
  const _EmployeeImportModel({@JsonKey(fromJson: idFromJson) required this.id, required this.fileName, @JsonKey(unknownEnumValue: ImportStatus.unknown) required this.status, required final  List<String> headers, final  List<List<String>> sampleRows = const <List<String>>[], required this.rowCount, final  Map<String, String?> suggestedMapping = const <String, String?>{}, final  Map<String, String?>? mapping, @JsonKey(unknownEnumValue: DuplicateStrategy.skip) this.duplicateStrategy, this.createMissing = false, this.assignEcNumbers = false, this.counts, this.processed = 0, this.result}): _headers = headers,_sampleRows = sampleRows,_suggestedMapping = suggestedMapping,_mapping = mapping,super._();
  factory _EmployeeImportModel.fromJson(Map<String, dynamic> json) => _$EmployeeImportModelFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String id;
@override final  String fileName;
@override@JsonKey(unknownEnumValue: ImportStatus.unknown) final  ImportStatus status;
/// The file's column headers, in order.
 final  List<String> _headers;
/// The file's column headers, in order.
@override List<String> get headers {
  if (_headers is EqualUnmodifiableListView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_headers);
}

/// The first few rows, as text, for the mapping screen.
 final  List<List<String>> _sampleRows;
/// The first few rows, as text, for the mapping screen.
@override@JsonKey() List<List<String>> get sampleRows {
  if (_sampleRows is EqualUnmodifiableListView) return _sampleRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sampleRows);
}

@override final  int rowCount;
/// Header → field key, guessed from the header names.
 final  Map<String, String?> _suggestedMapping;
/// Header → field key, guessed from the header names.
@override@JsonKey() Map<String, String?> get suggestedMapping {
  if (_suggestedMapping is EqualUnmodifiableMapView) return _suggestedMapping;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_suggestedMapping);
}

/// What was last checked with (after `validated`).
 final  Map<String, String?>? _mapping;
/// What was last checked with (after `validated`).
@override Map<String, String?>? get mapping {
  final value = _mapping;
  if (value == null) return null;
  if (_mapping is EqualUnmodifiableMapView) return _mapping;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(unknownEnumValue: DuplicateStrategy.skip) final  DuplicateStrategy? duplicateStrategy;
@override@JsonKey() final  bool createMissing;
@override@JsonKey() final  bool assignEcNumbers;
@override final  ImportCountsModel? counts;
/// While importing: rows done so far.
@override@JsonKey() final  int processed;
@override final  ImportResultModel? result;

/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeImportModelCopyWith<_EmployeeImportModel> get copyWith => __$EmployeeImportModelCopyWithImpl<_EmployeeImportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeImportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeImportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other._sampleRows, _sampleRows)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&const DeepCollectionEquality().equals(other._suggestedMapping, _suggestedMapping)&&const DeepCollectionEquality().equals(other._mapping, _mapping)&&(identical(other.duplicateStrategy, duplicateStrategy) || other.duplicateStrategy == duplicateStrategy)&&(identical(other.createMissing, createMissing) || other.createMissing == createMissing)&&(identical(other.assignEcNumbers, assignEcNumbers) || other.assignEcNumbers == assignEcNumbers)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileName,status,const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(_sampleRows),rowCount,const DeepCollectionEquality().hash(_suggestedMapping),const DeepCollectionEquality().hash(_mapping),duplicateStrategy,createMissing,assignEcNumbers,counts,processed,result);

@override
String toString() {
  return 'EmployeeImportModel(id: $id, fileName: $fileName, status: $status, headers: $headers, sampleRows: $sampleRows, rowCount: $rowCount, suggestedMapping: $suggestedMapping, mapping: $mapping, duplicateStrategy: $duplicateStrategy, createMissing: $createMissing, assignEcNumbers: $assignEcNumbers, counts: $counts, processed: $processed, result: $result)';
}


}

/// @nodoc
abstract mixin class _$EmployeeImportModelCopyWith<$Res> implements $EmployeeImportModelCopyWith<$Res> {
  factory _$EmployeeImportModelCopyWith(_EmployeeImportModel value, $Res Function(_EmployeeImportModel) _then) = __$EmployeeImportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String id, String fileName,@JsonKey(unknownEnumValue: ImportStatus.unknown) ImportStatus status, List<String> headers, List<List<String>> sampleRows, int rowCount, Map<String, String?> suggestedMapping, Map<String, String?>? mapping,@JsonKey(unknownEnumValue: DuplicateStrategy.skip) DuplicateStrategy? duplicateStrategy, bool createMissing, bool assignEcNumbers, ImportCountsModel? counts, int processed, ImportResultModel? result
});


@override $ImportCountsModelCopyWith<$Res>? get counts;@override $ImportResultModelCopyWith<$Res>? get result;

}
/// @nodoc
class __$EmployeeImportModelCopyWithImpl<$Res>
    implements _$EmployeeImportModelCopyWith<$Res> {
  __$EmployeeImportModelCopyWithImpl(this._self, this._then);

  final _EmployeeImportModel _self;
  final $Res Function(_EmployeeImportModel) _then;

/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fileName = null,Object? status = null,Object? headers = null,Object? sampleRows = null,Object? rowCount = null,Object? suggestedMapping = null,Object? mapping = freezed,Object? duplicateStrategy = freezed,Object? createMissing = null,Object? assignEcNumbers = null,Object? counts = freezed,Object? processed = null,Object? result = freezed,}) {
  return _then(_EmployeeImportModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportStatus,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as List<String>,sampleRows: null == sampleRows ? _self._sampleRows : sampleRows // ignore: cast_nullable_to_non_nullable
as List<List<String>>,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,suggestedMapping: null == suggestedMapping ? _self._suggestedMapping : suggestedMapping // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,mapping: freezed == mapping ? _self._mapping : mapping // ignore: cast_nullable_to_non_nullable
as Map<String, String?>?,duplicateStrategy: freezed == duplicateStrategy ? _self.duplicateStrategy : duplicateStrategy // ignore: cast_nullable_to_non_nullable
as DuplicateStrategy?,createMissing: null == createMissing ? _self.createMissing : createMissing // ignore: cast_nullable_to_non_nullable
as bool,assignEcNumbers: null == assignEcNumbers ? _self.assignEcNumbers : assignEcNumbers // ignore: cast_nullable_to_non_nullable
as bool,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as ImportCountsModel?,processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResultModel?,
  ));
}

/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportCountsModelCopyWith<$Res>? get counts {
    if (_self.counts == null) {
    return null;
  }

  return $ImportCountsModelCopyWith<$Res>(_self.counts!, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of EmployeeImportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportResultModelCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $ImportResultModelCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// @nodoc
mixin _$ImportOptionsModel {

/// Header → field key; null or absent ignores the column.
 Map<String, String?> get mapping; DuplicateStrategy get duplicateStrategy;/// Create departments and positions the organization doesn't have yet.
 bool get createMissing;/// Give rows without an EC number the next free one.
 bool get assignEcNumbers;
/// Create a copy of ImportOptionsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportOptionsModelCopyWith<ImportOptionsModel> get copyWith => _$ImportOptionsModelCopyWithImpl<ImportOptionsModel>(this as ImportOptionsModel, _$identity);

  /// Serializes this ImportOptionsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportOptionsModel&&const DeepCollectionEquality().equals(other.mapping, mapping)&&(identical(other.duplicateStrategy, duplicateStrategy) || other.duplicateStrategy == duplicateStrategy)&&(identical(other.createMissing, createMissing) || other.createMissing == createMissing)&&(identical(other.assignEcNumbers, assignEcNumbers) || other.assignEcNumbers == assignEcNumbers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mapping),duplicateStrategy,createMissing,assignEcNumbers);

@override
String toString() {
  return 'ImportOptionsModel(mapping: $mapping, duplicateStrategy: $duplicateStrategy, createMissing: $createMissing, assignEcNumbers: $assignEcNumbers)';
}


}

/// @nodoc
abstract mixin class $ImportOptionsModelCopyWith<$Res>  {
  factory $ImportOptionsModelCopyWith(ImportOptionsModel value, $Res Function(ImportOptionsModel) _then) = _$ImportOptionsModelCopyWithImpl;
@useResult
$Res call({
 Map<String, String?> mapping, DuplicateStrategy duplicateStrategy, bool createMissing, bool assignEcNumbers
});




}
/// @nodoc
class _$ImportOptionsModelCopyWithImpl<$Res>
    implements $ImportOptionsModelCopyWith<$Res> {
  _$ImportOptionsModelCopyWithImpl(this._self, this._then);

  final ImportOptionsModel _self;
  final $Res Function(ImportOptionsModel) _then;

/// Create a copy of ImportOptionsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mapping = null,Object? duplicateStrategy = null,Object? createMissing = null,Object? assignEcNumbers = null,}) {
  return _then(_self.copyWith(
mapping: null == mapping ? _self.mapping : mapping // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,duplicateStrategy: null == duplicateStrategy ? _self.duplicateStrategy : duplicateStrategy // ignore: cast_nullable_to_non_nullable
as DuplicateStrategy,createMissing: null == createMissing ? _self.createMissing : createMissing // ignore: cast_nullable_to_non_nullable
as bool,assignEcNumbers: null == assignEcNumbers ? _self.assignEcNumbers : assignEcNumbers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportOptionsModel].
extension ImportOptionsModelPatterns on ImportOptionsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportOptionsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportOptionsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportOptionsModel value)  $default,){
final _that = this;
switch (_that) {
case _ImportOptionsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportOptionsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImportOptionsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String?> mapping,  DuplicateStrategy duplicateStrategy,  bool createMissing,  bool assignEcNumbers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportOptionsModel() when $default != null:
return $default(_that.mapping,_that.duplicateStrategy,_that.createMissing,_that.assignEcNumbers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String?> mapping,  DuplicateStrategy duplicateStrategy,  bool createMissing,  bool assignEcNumbers)  $default,) {final _that = this;
switch (_that) {
case _ImportOptionsModel():
return $default(_that.mapping,_that.duplicateStrategy,_that.createMissing,_that.assignEcNumbers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String?> mapping,  DuplicateStrategy duplicateStrategy,  bool createMissing,  bool assignEcNumbers)?  $default,) {final _that = this;
switch (_that) {
case _ImportOptionsModel() when $default != null:
return $default(_that.mapping,_that.duplicateStrategy,_that.createMissing,_that.assignEcNumbers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportOptionsModel implements ImportOptionsModel {
  const _ImportOptionsModel({required final  Map<String, String?> mapping, required this.duplicateStrategy, this.createMissing = false, this.assignEcNumbers = false}): _mapping = mapping;
  factory _ImportOptionsModel.fromJson(Map<String, dynamic> json) => _$ImportOptionsModelFromJson(json);

/// Header → field key; null or absent ignores the column.
 final  Map<String, String?> _mapping;
/// Header → field key; null or absent ignores the column.
@override Map<String, String?> get mapping {
  if (_mapping is EqualUnmodifiableMapView) return _mapping;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_mapping);
}

@override final  DuplicateStrategy duplicateStrategy;
/// Create departments and positions the organization doesn't have yet.
@override@JsonKey() final  bool createMissing;
/// Give rows without an EC number the next free one.
@override@JsonKey() final  bool assignEcNumbers;

/// Create a copy of ImportOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportOptionsModelCopyWith<_ImportOptionsModel> get copyWith => __$ImportOptionsModelCopyWithImpl<_ImportOptionsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportOptionsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportOptionsModel&&const DeepCollectionEquality().equals(other._mapping, _mapping)&&(identical(other.duplicateStrategy, duplicateStrategy) || other.duplicateStrategy == duplicateStrategy)&&(identical(other.createMissing, createMissing) || other.createMissing == createMissing)&&(identical(other.assignEcNumbers, assignEcNumbers) || other.assignEcNumbers == assignEcNumbers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mapping),duplicateStrategy,createMissing,assignEcNumbers);

@override
String toString() {
  return 'ImportOptionsModel(mapping: $mapping, duplicateStrategy: $duplicateStrategy, createMissing: $createMissing, assignEcNumbers: $assignEcNumbers)';
}


}

/// @nodoc
abstract mixin class _$ImportOptionsModelCopyWith<$Res> implements $ImportOptionsModelCopyWith<$Res> {
  factory _$ImportOptionsModelCopyWith(_ImportOptionsModel value, $Res Function(_ImportOptionsModel) _then) = __$ImportOptionsModelCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String?> mapping, DuplicateStrategy duplicateStrategy, bool createMissing, bool assignEcNumbers
});




}
/// @nodoc
class __$ImportOptionsModelCopyWithImpl<$Res>
    implements _$ImportOptionsModelCopyWith<$Res> {
  __$ImportOptionsModelCopyWithImpl(this._self, this._then);

  final _ImportOptionsModel _self;
  final $Res Function(_ImportOptionsModel) _then;

/// Create a copy of ImportOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mapping = null,Object? duplicateStrategy = null,Object? createMissing = null,Object? assignEcNumbers = null,}) {
  return _then(_ImportOptionsModel(
mapping: null == mapping ? _self._mapping : mapping // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,duplicateStrategy: null == duplicateStrategy ? _self.duplicateStrategy : duplicateStrategy // ignore: cast_nullable_to_non_nullable
as DuplicateStrategy,createMissing: null == createMissing ? _self.createMissing : createMissing // ignore: cast_nullable_to_non_nullable
as bool,assignEcNumbers: null == assignEcNumbers ? _self.assignEcNumbers : assignEcNumbers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ImportChangeModel {

 String get field; String? get before; String? get after;
/// Create a copy of ImportChangeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportChangeModelCopyWith<ImportChangeModel> get copyWith => _$ImportChangeModelCopyWithImpl<ImportChangeModel>(this as ImportChangeModel, _$identity);

  /// Serializes this ImportChangeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportChangeModel&&(identical(other.field, field) || other.field == field)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,before,after);

@override
String toString() {
  return 'ImportChangeModel(field: $field, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class $ImportChangeModelCopyWith<$Res>  {
  factory $ImportChangeModelCopyWith(ImportChangeModel value, $Res Function(ImportChangeModel) _then) = _$ImportChangeModelCopyWithImpl;
@useResult
$Res call({
 String field, String? before, String? after
});




}
/// @nodoc
class _$ImportChangeModelCopyWithImpl<$Res>
    implements $ImportChangeModelCopyWith<$Res> {
  _$ImportChangeModelCopyWithImpl(this._self, this._then);

  final ImportChangeModel _self;
  final $Res Function(ImportChangeModel) _then;

/// Create a copy of ImportChangeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportChangeModel].
extension ImportChangeModelPatterns on ImportChangeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportChangeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportChangeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportChangeModel value)  $default,){
final _that = this;
switch (_that) {
case _ImportChangeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportChangeModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImportChangeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String? before,  String? after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportChangeModel() when $default != null:
return $default(_that.field,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String? before,  String? after)  $default,) {final _that = this;
switch (_that) {
case _ImportChangeModel():
return $default(_that.field,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String? before,  String? after)?  $default,) {final _that = this;
switch (_that) {
case _ImportChangeModel() when $default != null:
return $default(_that.field,_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportChangeModel implements ImportChangeModel {
  const _ImportChangeModel({required this.field, this.before, this.after});
  factory _ImportChangeModel.fromJson(Map<String, dynamic> json) => _$ImportChangeModelFromJson(json);

@override final  String field;
@override final  String? before;
@override final  String? after;

/// Create a copy of ImportChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportChangeModelCopyWith<_ImportChangeModel> get copyWith => __$ImportChangeModelCopyWithImpl<_ImportChangeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportChangeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportChangeModel&&(identical(other.field, field) || other.field == field)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,before,after);

@override
String toString() {
  return 'ImportChangeModel(field: $field, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$ImportChangeModelCopyWith<$Res> implements $ImportChangeModelCopyWith<$Res> {
  factory _$ImportChangeModelCopyWith(_ImportChangeModel value, $Res Function(_ImportChangeModel) _then) = __$ImportChangeModelCopyWithImpl;
@override @useResult
$Res call({
 String field, String? before, String? after
});




}
/// @nodoc
class __$ImportChangeModelCopyWithImpl<$Res>
    implements _$ImportChangeModelCopyWith<$Res> {
  __$ImportChangeModelCopyWithImpl(this._self, this._then);

  final _ImportChangeModel _self;
  final $Res Function(_ImportChangeModel) _then;

/// Create a copy of ImportChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_ImportChangeModel(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ImportRowModel {

/// The row number in the Excel file (the header is row 1).
 int get rowNumber;@JsonKey(unknownEnumValue: ImportRowStatus.unknown) ImportRowStatus get status; String? get ecNumber; String? get name; List<String> get messages; List<ImportChangeModel> get changes;
/// Create a copy of ImportRowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportRowModelCopyWith<ImportRowModel> get copyWith => _$ImportRowModelCopyWithImpl<ImportRowModel>(this as ImportRowModel, _$identity);

  /// Serializes this ImportRowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportRowModel&&(identical(other.rowNumber, rowNumber) || other.rowNumber == rowNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.messages, messages)&&const DeepCollectionEquality().equals(other.changes, changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rowNumber,status,ecNumber,name,const DeepCollectionEquality().hash(messages),const DeepCollectionEquality().hash(changes));

@override
String toString() {
  return 'ImportRowModel(rowNumber: $rowNumber, status: $status, ecNumber: $ecNumber, name: $name, messages: $messages, changes: $changes)';
}


}

/// @nodoc
abstract mixin class $ImportRowModelCopyWith<$Res>  {
  factory $ImportRowModelCopyWith(ImportRowModel value, $Res Function(ImportRowModel) _then) = _$ImportRowModelCopyWithImpl;
@useResult
$Res call({
 int rowNumber,@JsonKey(unknownEnumValue: ImportRowStatus.unknown) ImportRowStatus status, String? ecNumber, String? name, List<String> messages, List<ImportChangeModel> changes
});




}
/// @nodoc
class _$ImportRowModelCopyWithImpl<$Res>
    implements $ImportRowModelCopyWith<$Res> {
  _$ImportRowModelCopyWithImpl(this._self, this._then);

  final ImportRowModel _self;
  final $Res Function(ImportRowModel) _then;

/// Create a copy of ImportRowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowNumber = null,Object? status = null,Object? ecNumber = freezed,Object? name = freezed,Object? messages = null,Object? changes = null,}) {
  return _then(_self.copyWith(
rowNumber: null == rowNumber ? _self.rowNumber : rowNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportRowStatus,ecNumber: freezed == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<String>,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<ImportChangeModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportRowModel].
extension ImportRowModelPatterns on ImportRowModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportRowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportRowModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportRowModel value)  $default,){
final _that = this;
switch (_that) {
case _ImportRowModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportRowModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImportRowModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rowNumber, @JsonKey(unknownEnumValue: ImportRowStatus.unknown)  ImportRowStatus status,  String? ecNumber,  String? name,  List<String> messages,  List<ImportChangeModel> changes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportRowModel() when $default != null:
return $default(_that.rowNumber,_that.status,_that.ecNumber,_that.name,_that.messages,_that.changes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rowNumber, @JsonKey(unknownEnumValue: ImportRowStatus.unknown)  ImportRowStatus status,  String? ecNumber,  String? name,  List<String> messages,  List<ImportChangeModel> changes)  $default,) {final _that = this;
switch (_that) {
case _ImportRowModel():
return $default(_that.rowNumber,_that.status,_that.ecNumber,_that.name,_that.messages,_that.changes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rowNumber, @JsonKey(unknownEnumValue: ImportRowStatus.unknown)  ImportRowStatus status,  String? ecNumber,  String? name,  List<String> messages,  List<ImportChangeModel> changes)?  $default,) {final _that = this;
switch (_that) {
case _ImportRowModel() when $default != null:
return $default(_that.rowNumber,_that.status,_that.ecNumber,_that.name,_that.messages,_that.changes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportRowModel implements ImportRowModel {
  const _ImportRowModel({required this.rowNumber, @JsonKey(unknownEnumValue: ImportRowStatus.unknown) required this.status, this.ecNumber, this.name, final  List<String> messages = const <String>[], final  List<ImportChangeModel> changes = const <ImportChangeModel>[]}): _messages = messages,_changes = changes;
  factory _ImportRowModel.fromJson(Map<String, dynamic> json) => _$ImportRowModelFromJson(json);

/// The row number in the Excel file (the header is row 1).
@override final  int rowNumber;
@override@JsonKey(unknownEnumValue: ImportRowStatus.unknown) final  ImportRowStatus status;
@override final  String? ecNumber;
@override final  String? name;
 final  List<String> _messages;
@override@JsonKey() List<String> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  List<ImportChangeModel> _changes;
@override@JsonKey() List<ImportChangeModel> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}


/// Create a copy of ImportRowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportRowModelCopyWith<_ImportRowModel> get copyWith => __$ImportRowModelCopyWithImpl<_ImportRowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportRowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportRowModel&&(identical(other.rowNumber, rowNumber) || other.rowNumber == rowNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.ecNumber, ecNumber) || other.ecNumber == ecNumber)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._messages, _messages)&&const DeepCollectionEquality().equals(other._changes, _changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rowNumber,status,ecNumber,name,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_changes));

@override
String toString() {
  return 'ImportRowModel(rowNumber: $rowNumber, status: $status, ecNumber: $ecNumber, name: $name, messages: $messages, changes: $changes)';
}


}

/// @nodoc
abstract mixin class _$ImportRowModelCopyWith<$Res> implements $ImportRowModelCopyWith<$Res> {
  factory _$ImportRowModelCopyWith(_ImportRowModel value, $Res Function(_ImportRowModel) _then) = __$ImportRowModelCopyWithImpl;
@override @useResult
$Res call({
 int rowNumber,@JsonKey(unknownEnumValue: ImportRowStatus.unknown) ImportRowStatus status, String? ecNumber, String? name, List<String> messages, List<ImportChangeModel> changes
});




}
/// @nodoc
class __$ImportRowModelCopyWithImpl<$Res>
    implements _$ImportRowModelCopyWith<$Res> {
  __$ImportRowModelCopyWithImpl(this._self, this._then);

  final _ImportRowModel _self;
  final $Res Function(_ImportRowModel) _then;

/// Create a copy of ImportRowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowNumber = null,Object? status = null,Object? ecNumber = freezed,Object? name = freezed,Object? messages = null,Object? changes = null,}) {
  return _then(_ImportRowModel(
rowNumber: null == rowNumber ? _self.rowNumber : rowNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportRowStatus,ecNumber: freezed == ecNumber ? _self.ecNumber : ecNumber // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<String>,changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<ImportChangeModel>,
  ));
}


}


/// @nodoc
mixin _$ImportRowsPageModel {

 List<ImportRowModel> get items; int get total; int get page; int get pageSize;
/// Create a copy of ImportRowsPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportRowsPageModelCopyWith<ImportRowsPageModel> get copyWith => _$ImportRowsPageModelCopyWithImpl<ImportRowsPageModel>(this as ImportRowsPageModel, _$identity);

  /// Serializes this ImportRowsPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportRowsPageModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,pageSize);

@override
String toString() {
  return 'ImportRowsPageModel(items: $items, total: $total, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $ImportRowsPageModelCopyWith<$Res>  {
  factory $ImportRowsPageModelCopyWith(ImportRowsPageModel value, $Res Function(ImportRowsPageModel) _then) = _$ImportRowsPageModelCopyWithImpl;
@useResult
$Res call({
 List<ImportRowModel> items, int total, int page, int pageSize
});




}
/// @nodoc
class _$ImportRowsPageModelCopyWithImpl<$Res>
    implements $ImportRowsPageModelCopyWith<$Res> {
  _$ImportRowsPageModelCopyWithImpl(this._self, this._then);

  final ImportRowsPageModel _self;
  final $Res Function(ImportRowsPageModel) _then;

/// Create a copy of ImportRowsPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ImportRowModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportRowsPageModel].
extension ImportRowsPageModelPatterns on ImportRowsPageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportRowsPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportRowsPageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportRowsPageModel value)  $default,){
final _that = this;
switch (_that) {
case _ImportRowsPageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportRowsPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImportRowsPageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ImportRowModel> items,  int total,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportRowsPageModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ImportRowModel> items,  int total,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _ImportRowsPageModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ImportRowModel> items,  int total,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _ImportRowsPageModel() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportRowsPageModel implements ImportRowsPageModel {
  const _ImportRowsPageModel({required final  List<ImportRowModel> items, required this.total, required this.page, required this.pageSize}): _items = items;
  factory _ImportRowsPageModel.fromJson(Map<String, dynamic> json) => _$ImportRowsPageModelFromJson(json);

 final  List<ImportRowModel> _items;
@override List<ImportRowModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  int page;
@override final  int pageSize;

/// Create a copy of ImportRowsPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportRowsPageModelCopyWith<_ImportRowsPageModel> get copyWith => __$ImportRowsPageModelCopyWithImpl<_ImportRowsPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportRowsPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportRowsPageModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,pageSize);

@override
String toString() {
  return 'ImportRowsPageModel(items: $items, total: $total, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$ImportRowsPageModelCopyWith<$Res> implements $ImportRowsPageModelCopyWith<$Res> {
  factory _$ImportRowsPageModelCopyWith(_ImportRowsPageModel value, $Res Function(_ImportRowsPageModel) _then) = __$ImportRowsPageModelCopyWithImpl;
@override @useResult
$Res call({
 List<ImportRowModel> items, int total, int page, int pageSize
});




}
/// @nodoc
class __$ImportRowsPageModelCopyWithImpl<$Res>
    implements _$ImportRowsPageModelCopyWith<$Res> {
  __$ImportRowsPageModelCopyWithImpl(this._self, this._then);

  final _ImportRowsPageModel _self;
  final $Res Function(_ImportRowsPageModel) _then;

/// Create a copy of ImportRowsPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_ImportRowsPageModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ImportRowModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
