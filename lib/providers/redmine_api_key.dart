import 'package:ritt/providers/app_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redmine_api_key.g.dart';

@Riverpod(dependencies: [appStore])
class RedmineApiKey extends _$RedmineApiKey {
  static final storeKey = AppKeys.redmineApiKey;

  @override
  String? build() {
    final appStore = ref.watch(appStoreProvider);

    return appStore.read(storeKey);
  }

  Future<void> set(String apiKey) async {
    state = apiKey;

    await ref.read(appStoreProvider).write<String>(storeKey, apiKey);
  }

  Future<void> remove() async {
    state = null;

    await ref.read(appStoreProvider).remove(storeKey);
  }
}
