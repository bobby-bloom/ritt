import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:ritt/redmine/models/time_entry.dart';
import 'package:ritt/redmine/models/time_entry_request.dart';
import 'package:ritt/redmine/models/redmine_issue.dart';
import 'package:ritt/redmine/models/redmine_user.dart';
import 'package:ritt/app/providers/app_store.dart';
import 'package:ritt/redmine/providers/redmine_client.dart';
import 'package:ritt/app/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redmine_service.g.dart';

class RedmineService {
  const RedmineService(
    this.client,
    this.authority,
    this.fetchOnlyIssuesAssignedToMe,
  );

  final RedmineClient client;

  final String? authority;

  final bool fetchOnlyIssuesAssignedToMe;

  static const format = 'json';
  static const currentUserPath = '/users/current.$format';
  static const issuesPath = '/issues.$format';
  static const timeEntriesPath = '/time_entries.$format';

  bool get canMakeRequests =>
      client.apiKey != null && client.apiKey!.isNotEmpty && authority != null;

  Future<RedmineUser> getMe() async {
    final response = await client.get(Uri.https(authority!, currentUserPath));

    handleErrorResponse(response);

    final user = RedmineUser.fromJson(jsonDecode(response.body));

    return user;
  }

  Future<List<RedmineIssue>> getIssues({
    int limit = 1000,
    String statusId = 'open',
  }) async {
    final queryParams = {'limit': limit, 'status_id': statusId};

    if (fetchOnlyIssuesAssignedToMe) {
      queryParams['assigned_to'] = 'me';
    }

    final uri = Uri.https(authority!, issuesPath, queryParams);
    final response = await client.get(uri);

    handleErrorResponse(response);

    final raw = jsonDecode(response.body);
    final issues = AppKeys.redmineIssues.fromJson(raw);

    return issues;
  }

  Future<TimeEntryResponse> postTimeEntry({
    required int userId,
    required int projectId,
    int? issueId,
    required String comments,
    required Duration hours,
    required DateTime spentOn,
    bool? easyIsBillable,
  }) async {
    final body = TimeEntryRequest(
      projectId: projectId,
      issueId: issueId,
      userId: userId,
      comments: comments,
      hours: '${hours.inHours}h${hours.inMinutes % 60}m',
      spentOn: spentOn,
      easyIsBillable: easyIsBillable,
    );

    final uri = Uri.https(authority!, timeEntriesPath);
    final response = await client.post(uri, body: body);

    handleErrorResponse(response);

    final raw = jsonDecode(response.body);
    final timeEntry = TimeEntryResponse.fromJson(raw);

    return timeEntry;
  }

  void handleErrorResponse(Response response) {
    if (response.statusCode > 299) {
      throw Exception('An error occurred while requesting Redmine resources.');
    }
  }
}

@Riverpod(dependencies: [redmineClient, Settings])
RedmineService redmineService(Ref ref) {
  final (redmineHost, fetchOnlyIssuesAssignedToMe) = ref.watch(
    settingsProvider.select(
      (x) => (x.redmineHost, x.fetchOnlyIssuesAssignedToMe),
    ),
  );
  final client = ref.watch(redmineClientProvider);

  return RedmineService(client, redmineHost, fetchOnlyIssuesAssignedToMe);
}
