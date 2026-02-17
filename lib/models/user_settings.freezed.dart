// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {

 String? get redmineApiKey; String? get redmineHost; bool get allowMultipleTimersRunningSimultaneously; ThemeMode get themeMode;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.redmineApiKey, redmineApiKey) || other.redmineApiKey == redmineApiKey)&&(identical(other.redmineHost, redmineHost) || other.redmineHost == redmineHost)&&(identical(other.allowMultipleTimersRunningSimultaneously, allowMultipleTimersRunningSimultaneously) || other.allowMultipleTimersRunningSimultaneously == allowMultipleTimersRunningSimultaneously)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,redmineApiKey,redmineHost,allowMultipleTimersRunningSimultaneously,themeMode);

@override
String toString() {
  return 'UserSettings(redmineApiKey: $redmineApiKey, redmineHost: $redmineHost, allowMultipleTimersRunningSimultaneously: $allowMultipleTimersRunningSimultaneously, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 String? redmineApiKey, String? redmineHost, bool allowMultipleTimersRunningSimultaneously, ThemeMode themeMode
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? redmineApiKey = freezed,Object? redmineHost = freezed,Object? allowMultipleTimersRunningSimultaneously = null,Object? themeMode = null,}) {
  return _then(_self.copyWith(
redmineApiKey: freezed == redmineApiKey ? _self.redmineApiKey : redmineApiKey // ignore: cast_nullable_to_non_nullable
as String?,redmineHost: freezed == redmineHost ? _self.redmineHost : redmineHost // ignore: cast_nullable_to_non_nullable
as String?,allowMultipleTimersRunningSimultaneously: null == allowMultipleTimersRunningSimultaneously ? _self.allowMultipleTimersRunningSimultaneously : allowMultipleTimersRunningSimultaneously // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? redmineApiKey,  String? redmineHost,  bool allowMultipleTimersRunningSimultaneously,  ThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.redmineApiKey,_that.redmineHost,_that.allowMultipleTimersRunningSimultaneously,_that.themeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? redmineApiKey,  String? redmineHost,  bool allowMultipleTimersRunningSimultaneously,  ThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.redmineApiKey,_that.redmineHost,_that.allowMultipleTimersRunningSimultaneously,_that.themeMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? redmineApiKey,  String? redmineHost,  bool allowMultipleTimersRunningSimultaneously,  ThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.redmineApiKey,_that.redmineHost,_that.allowMultipleTimersRunningSimultaneously,_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettings implements UserSettings {
  const _UserSettings({this.redmineApiKey, this.redmineHost, this.allowMultipleTimersRunningSimultaneously = false, this.themeMode = ThemeMode.system});
  factory _UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

@override final  String? redmineApiKey;
@override final  String? redmineHost;
@override@JsonKey() final  bool allowMultipleTimersRunningSimultaneously;
@override@JsonKey() final  ThemeMode themeMode;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.redmineApiKey, redmineApiKey) || other.redmineApiKey == redmineApiKey)&&(identical(other.redmineHost, redmineHost) || other.redmineHost == redmineHost)&&(identical(other.allowMultipleTimersRunningSimultaneously, allowMultipleTimersRunningSimultaneously) || other.allowMultipleTimersRunningSimultaneously == allowMultipleTimersRunningSimultaneously)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,redmineApiKey,redmineHost,allowMultipleTimersRunningSimultaneously,themeMode);

@override
String toString() {
  return 'UserSettings(redmineApiKey: $redmineApiKey, redmineHost: $redmineHost, allowMultipleTimersRunningSimultaneously: $allowMultipleTimersRunningSimultaneously, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? redmineApiKey, String? redmineHost, bool allowMultipleTimersRunningSimultaneously, ThemeMode themeMode
});




}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? redmineApiKey = freezed,Object? redmineHost = freezed,Object? allowMultipleTimersRunningSimultaneously = null,Object? themeMode = null,}) {
  return _then(_UserSettings(
redmineApiKey: freezed == redmineApiKey ? _self.redmineApiKey : redmineApiKey // ignore: cast_nullable_to_non_nullable
as String?,redmineHost: freezed == redmineHost ? _self.redmineHost : redmineHost // ignore: cast_nullable_to_non_nullable
as String?,allowMultipleTimersRunningSimultaneously: null == allowMultipleTimersRunningSimultaneously ? _self.allowMultipleTimersRunningSimultaneously : allowMultipleTimersRunningSimultaneously // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

// dart format on
