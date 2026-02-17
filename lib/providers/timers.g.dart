// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Timers)
final timersProvider = TimersProvider._();

final class TimersProvider extends $NotifierProvider<Timers, List<Timer>> {
  TimersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timersProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[appStoreProvider, settingsProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          TimersProvider.$allTransitiveDependencies0,
          TimersProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = appStoreProvider;
  static final $allTransitiveDependencies1 = settingsProvider;

  @override
  String debugGetCreateSourceHash() => _$timersHash();

  @$internal
  @override
  Timers create() => Timers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Timer> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Timer>>(value),
    );
  }
}

String _$timersHash() => r'cf1bc47e3779fc265a0cc8fca0511b34eda7d969';

abstract class _$Timers extends $Notifier<List<Timer>> {
  List<Timer> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Timer>, List<Timer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Timer>, List<Timer>>,
              List<Timer>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
