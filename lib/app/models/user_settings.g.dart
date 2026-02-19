// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      redmineApiKey: json['redmineApiKey'] as String?,
      redmineHost: json['redmineHost'] as String?,
      runMultipleTimersSimultaneously:
          json['runMultipleTimersSimultaneously'] as bool? ?? false,
      fetchOnlyIssuesAssignedToMe:
          json['fetchOnlyIssuesAssignedToMe'] as bool? ?? true,
      roundTimeEntryUpToMinute:
          (json['roundTimeEntryUpToMinute'] as num?)?.toInt() ?? 15,
      billableTrackers:
          (json['billableTrackers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserSettingsToJson(
  _UserSettings instance,
) => <String, dynamic>{
  'redmineApiKey': instance.redmineApiKey,
  'redmineHost': instance.redmineHost,
  'runMultipleTimersSimultaneously': instance.runMultipleTimersSimultaneously,
  'fetchOnlyIssuesAssignedToMe': instance.fetchOnlyIssuesAssignedToMe,
  'roundTimeEntryUpToMinute': instance.roundTimeEntryUpToMinute,
  'billableTrackers': instance.billableTrackers,
};
