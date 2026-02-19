import 'dart:convert';

import 'package:ritt/redmine/models/redmine_thing.dart';

class TimeEntryResponse {
  const TimeEntryResponse({
    required this.id,
    required this.project,
    this.issue,
    required this.user,
    this.priority,
    this.activity,
    this.easyExternalId,
    required this.hours,
    required this.spentOn,
    required this.comments,
    this.easyIsBillable,
    this.easyIsBilled,
    this.customFields,
    this.tagList,
  });

  final String id;
  final RedmineThing project;
  final RedmineThing? issue;
  final RedmineThing user;
  final RedmineThing? priority;
  final RedmineThing? activity;
  final String? easyExternalId;
  final String hours;
  final DateTime spentOn;
  final String comments;
  final String? easyIsBillable;
  final String? easyIsBilled;
  final List<Map<String, dynamic>>? customFields;
  final List<String>? tagList;

  factory TimeEntryResponse.fromJson(Map<String, dynamic> json) {
    return TimeEntryResponse(
      id: json['id'],
      project: RedmineThing.fromJson(json['project']),
      issue: RedmineThing.fromJson(json['issue']),
      user: RedmineThing.fromJson(json['user']),
      priority: RedmineThing.fromJson(json['priority']),
      activity: RedmineThing.fromJson(json['activity']),
      easyExternalId: json['easy_external_id'],
      hours: json['hours'],
      spentOn: json['spent_on'],
      comments: json['comments'],
      easyIsBillable: json['easy_is_billable'],
      easyIsBilled: json['easy_is_billed'],
      customFields: json['custom_fields'],
      tagList: json['tag_list'],
    );
  }

  String toJson() {
    final map = <String, dynamic>{
      'id': id,
      'project': project.toJson(),
      'issue': issue?.toJson(),
      'user': user.toJson(),
      'priority': priority?.toJson(),
      'activity': activity?.toJson(),
      'easy_external_id': easyExternalId,
      'hours': hours,
      'spent_on': spentOn,
      'comments': comments,
      'easy_is_billable': easyIsBillable,
      'easy_is_billed': easyIsBilled,
      'custom_fields': customFields,
      'tag_list': tagList,
    };

    return jsonEncode(map);
  }
}
