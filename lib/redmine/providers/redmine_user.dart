import 'package:ritt/redmine/models/redmine_user.dart';
import 'package:ritt/app/providers/app_store.dart';
import 'package:ritt/redmine/providers/redmine_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redmine_user.g.dart';

final storeKey = AppKeys.redmineUser;

@Riverpod(dependencies: [redmineService])
Future<RedmineUser?> redmineUser(Ref ref) async {
  final redmineService = ref.watch(redmineServiceProvider);
  final appStore = ref.watch(appStoreProvider);

  if (redmineService.canMakeRequests) {
    final user = await redmineService.getMe();
    await appStore.write(storeKey, user);

    return user;
  }

  return appStore.read(storeKey);
}
