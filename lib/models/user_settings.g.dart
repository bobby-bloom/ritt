// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      redmineApiKey: json['redmineApiKey'] as String?,
      redmineHost: json['redmineHost'] as String?,
      allowMultipleTimersRunningSimultaneously:
          json['allowMultipleTimersRunningSimultaneously'] as bool? ?? true,
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'redmineApiKey': instance.redmineApiKey,
      'redmineHost': instance.redmineHost,
      'allowMultipleTimersRunningSimultaneously':
          instance.allowMultipleTimersRunningSimultaneously,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
