import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:ritt/models/redmine_issue.dart';
import 'package:ritt/models/redmine_user.dart';
import 'package:ritt/providers/app_store.dart';
import 'package:ritt/providers/redmine_client.dart';
import 'package:ritt/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redmine_service.g.dart';

class RedmineService {
  const RedmineService(this.client, this.authority);

  final RedmineClient client;

  final String? authority;

  static const currentUserPath = '/users/current.json';
  static const issuesPath = '/issues.json';

  bool get canMakeRequests =>
      client.apiKey != null && client.apiKey!.isNotEmpty && authority != null;

  Future<RedmineUser> get() async {
    final response = await client.get(Uri.https(authority!, currentUserPath));

    handleErrorResponse(response);

    final user = RedmineUser.fromJson(jsonDecode(response.body));

    return user;
  }

  Future<List<RedmineIssue>> getMyIssues() async {
    final response = await client.get(
      Uri.https(authority!, issuesPath, {
        'assigned_to_id': 'me',
        'limit': '1000',
        'status_id': 'open',
      }),
    );

    handleErrorResponse(response);

    final raw = jsonDecode(response.body);
    final issues = AppKeys.redmineIssues.fromJson(raw);

    return issues;
  }

  void handleErrorResponse(Response response) {
    if (response.statusCode > 299) {
      throw Exception('An error occurred while requesting Redmine resources.');
    }
  }
}

@Riverpod(dependencies: [redmineClient, Settings])
RedmineService redmineService(Ref ref) {
  final settings = ref.watch(settingsProvider.select((x) => x.redmineHost));
  final client = ref.watch(redmineClientProvider);

  return RedmineService(client, settings);
}
