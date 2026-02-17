import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show ThemeMode;

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    String? redmineApiKey,
    String? redmineHost,
    @Default(false) bool allowMultipleTimersRunningSimultaneously,
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
