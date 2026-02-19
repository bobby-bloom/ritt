import 'dart:async';

import 'package:ritt/redmine/models/redmine_issue.dart';
import 'package:ritt/app/providers/app_store.dart';
import 'package:ritt/redmine/providers/redmine_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redmine_issues.g.dart';

final storeKey = AppKeys.redmineIssues;

@Riverpod(keepAlive: true, dependencies: [redmineService, appStore])
Future<List<RedmineIssue>> issues(Ref ref) async {
  final redmineService = ref.watch(redmineServiceProvider);
  final appStore = ref.watch(appStoreProvider);

  if (redmineService.canMakeRequests) {
    final issues = await redmineService.getIssues();

    unawaited(appStore.write(storeKey, issues));

    return await Future.delayed(Duration(seconds: 30), () => issues);
  }

  return appStore.read(storeKey) ?? [];
}
