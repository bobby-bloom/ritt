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
          json['allowMultipleTimersRunningSimultaneously'] as bool? ?? false,
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      fetchOnlyIssuesAssignedToMe:
          json['fetchOnlyIssuesAssignedToMe'] as bool? ?? true,
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'redmineApiKey': instance.redmineApiKey,
      'redmineHost': instance.redmineHost,
      'allowMultipleTimersRunningSimultaneously':
          instance.allowMultipleTimersRunningSimultaneously,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'fetchOnlyIssuesAssignedToMe': instance.fetchOnlyIssuesAssignedToMe,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
