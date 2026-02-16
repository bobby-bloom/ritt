// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redmine_api_key.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RedmineApiKey)
final redmineApiKeyProvider = RedmineApiKeyProvider._();

final class RedmineApiKeyProvider
    extends $NotifierProvider<RedmineApiKey, String?> {
  RedmineApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'redmineApiKeyProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[appStoreProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          RedmineApiKeyProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = appStoreProvider;

  @override
  String debugGetCreateSourceHash() => _$redmineApiKeyHash();

  @$internal
  @override
  RedmineApiKey create() => RedmineApiKey();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$redmineApiKeyHash() => r'5428ecc6a35b0c47ead2e2851616164dcb6d9197';

abstract class _$RedmineApiKey extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
