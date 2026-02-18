// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issues.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpandedGroups)
final expandedGroupsProvider = ExpandedGroupsProvider._();

final class ExpandedGroupsProvider
    extends $NotifierProvider<ExpandedGroups, Map<String, bool>> {
  ExpandedGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expandedGroupsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expandedGroupsHash();

  @$internal
  @override
  ExpandedGroups create() => ExpandedGroups();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }
}

String _$expandedGroupsHash() => r'5eead7ea2d083fa913cad5d9a72a8c42e50c7cc5';

abstract class _$ExpandedGroups extends $Notifier<Map<String, bool>> {
  Map<String, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, bool>, Map<String, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, bool>, Map<String, bool>>,
              Map<String, bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
