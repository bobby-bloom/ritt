// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redmine_issues.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(issues)
final issuesProvider = IssuesProvider._();

final class IssuesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RedmineIssue>>,
          List<RedmineIssue>,
          FutureOr<List<RedmineIssue>>
        >
    with
        $FutureModifier<List<RedmineIssue>>,
        $FutureProvider<List<RedmineIssue>> {
  IssuesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'issuesProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[
          redmineServiceProvider,
          appStoreProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          IssuesProvider.$allTransitiveDependencies0,
          IssuesProvider.$allTransitiveDependencies1,
          IssuesProvider.$allTransitiveDependencies2,
          IssuesProvider.$allTransitiveDependencies3,
          IssuesProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = redmineServiceProvider;
  static final $allTransitiveDependencies1 =
      RedmineServiceProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      RedmineServiceProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      RedmineServiceProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies4 =
      RedmineServiceProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$issuesHash();

  @$internal
  @override
  $FutureProviderElement<List<RedmineIssue>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RedmineIssue>> create(Ref ref) {
    return issues(ref);
  }
}

String _$issuesHash() => r'c36c44d75286fea6c01dc2ec650594469b0857da';
