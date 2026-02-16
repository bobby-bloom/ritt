// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Timer _$TimerFromJson(Map<String, dynamic> json) => _Timer(
  id: json['id'] as String,
  totalTime: Duration(microseconds: (json['totalTime'] as num).toInt()),
  isRunning: json['isRunning'] as bool,
  lastStartOn: json['lastStartOn'] == null
      ? null
      : DateTime.parse(json['lastStartOn'] as String),
  issueId: json['issueId'] as String?,
  issueProject: json['issueProject'] as String?,
  issueSubject: json['issueSubject'] as String?,
);

Map<String, dynamic> _$TimerToJson(_Timer instance) => <String, dynamic>{
  'id': instance.id,
  'totalTime': instance.totalTime.inMicroseconds,
  'isRunning': instance.isRunning,
  'lastStartOn': instance.lastStartOn?.toIso8601String(),
  'issueId': instance.issueId,
  'issueProject': instance.issueProject,
  'issueSubject': instance.issueSubject,
};
