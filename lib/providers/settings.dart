import 'package:ritt/models/user_settings.dart';
import 'package:ritt/providers/app_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show ThemeMode;

part 'settings.g.dart';

@Riverpod(dependencies: [appStore])
class Settings extends _$Settings {
  static final storeKey = AppKeys.userSettings;

  @override
  UserSettings build() {
    final appStore = ref.watch(appStoreProvider);

    return appStore.read(storeKey) ?? UserSettings();
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);

    _saveState();
  }

  void setAllowMultipleTimersRunningSimultaneously(bool allow) {
    state = state.copyWith(allowMultipleTimersRunningSimultaneously: allow);

    _saveState();
  }

  void setRedmineApiKey(String? apiKey) {
    state = state.copyWith(redmineApiKey: apiKey);

    _saveState();
  }

  void setRedmineHost(String? host) {
    state = state.copyWith(redmineHost: host);

    _saveState();
  }

  void setState(UserSettings Function(UserSettings settings) cb) {
    state = cb(state);

    _saveState();
  }

  void _saveState() {
    ref.read(appStoreProvider).write(storeKey, state);
  }
}
