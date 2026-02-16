import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer.freezed.dart';
part 'timer.g.dart';

@freezed
abstract class Timer with _$Timer {
  const factory Timer({
    required String id,
    required Duration totalTime,
    required bool isRunning,
    DateTime? lastStartOn,
    String? issueId,
    String? issueProject,
    String? issueSubject,
  }) = _Timer;

  factory Timer.fromJson(Map<String, dynamic> json) => _$TimerFromJson(json);
}
