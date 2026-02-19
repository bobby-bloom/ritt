import 'package:ritt/app/models/timer.dart';
import 'package:ritt/app/providers/app_store.dart';
import 'package:ritt/app/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timers.g.dart';

@Riverpod(dependencies: [appStore, Settings])
class Timers extends _$Timers {
  final storeKey = AppKeys.timers;

  @override
  List<Timer> build() {
    final appStore = ref.watch(appStoreProvider);
    ref.watch(settingsProvider);

    return appStore.read(storeKey) ?? [];
  }

  void reset(String id) {
    state = state.map((timer) {
      if (timer.id == id) {
        return timer.copyWith(
          totalTime: Duration.zero,
          isRunning: false,
          lastStartOn: null,
        );
      }
      return timer;
    }).toList();

    _writeState();
  }

  Timer toggle(Timer timer) {
    if (timer.isRunning) {
      timer = _stop(timer);
    } else {
      timer = _start(timer);
    }

    state = state.map((x) {
      if (x.id == timer.id) {
        return timer;
      }

      return x;
    }).toList();

    _writeState();

    return timer;
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();

    _writeState();
  }

  void create({String? issueId, String? issueProject, String? issueSubject}) {
    final newTimer = Timer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      totalTime: Duration.zero,
      isRunning: false,
      issueId: issueId,
      issueProject: issueProject,
      issueSubject: issueSubject,
    );

    state = [...state, newTimer];

    _writeState();
  }

  void update(
    String id, {
    String? issueId,
    String? issueProject,
    String? issueSubject,
  }) {
    state = state.map((timer) {
      if (timer.id == id) {
        return timer.copyWith(
          issueId: issueId,
          issueProject: issueProject,
          issueSubject: issueSubject,
        );
      }
      return timer;
    }).toList();

    _writeState();
  }

  // void reorder(int oldIndex, int newIndex) {
  //   final list = [...state];
  //   final item = list.removeAt(oldIndex);
  //   list.insert(newIndex, item);
  //   state = list;
  // }

  void set(List<Timer> timers) {
    state = timers;

    _writeState();
  }

  Timer _stop(Timer timer) {
    if (!timer.isRunning) {
      return timer;
    }

    final elapsed = DateTime.timestamp().difference(timer.lastStartOn!);

    return timer.copyWith(
      isRunning: false,
      totalTime: timer.totalTime + elapsed,
      lastStartOn: null,
    );
  }

  Timer _start(Timer timer) {
    final allowTimesRunningSimultaneously = ref
        .read(settingsProvider)
        .runMultipleTimersSimultaneously;

    if (!allowTimesRunningSimultaneously) {
      state = state.map((x) => _stop(x)).toList();
    }

    return timer.copyWith(isRunning: true, lastStartOn: DateTime.timestamp());
  }

  void _writeState() {
    ref.read(appStoreProvider).write(storeKey, state);
  }
}
