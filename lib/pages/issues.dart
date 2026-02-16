import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        FloatingActionButton,
        Icons,
        Text,
        CircularProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:ritt/models/redmine_issue.dart';
import 'package:ritt/models/timer.dart';
import 'package:ritt/providers/redmine_issues.dart';
import 'package:ritt/providers/timers.dart';
import 'package:ritt/theme/theme_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart'
    show BuildContext, Widget, showToast;
import 'package:collection/collection.dart';

part 'issues.g.dart';

@Riverpod(keepAlive: true)
class ExpandedGroups extends _$ExpandedGroups {
  @override
  Map<String, bool> build() => {};

  void set(Map<String, bool> newState) {
    if (DeepCollectionEquality().equals(state, newState)) {
      return;
    }

    state = newState;
  }
}

class IssuesPage extends HookConsumerWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(issuesProvider);
    final issues = issuesAsync.value ?? [];

    final timers = ref.watch(timersProvider);
    final expandedGroups = ref.watch(expandedGroupsProvider);
    final stateManager = useRef<PlutoGridStateManager?>(null);

    if (issuesAsync.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showToast(
          context: context,
          builder: (context, overlay) => Text(issuesAsync.error.toString()),
          // showDuration: Duration(days: 1000),
        );
      });
    }

    useEffect(() {
      if (stateManager.value == null) {
        return;
      }

      final expandedGroupsCtl = ref.read(expandedGroupsProvider.notifier);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        expandedGroupsCtl.set(saveGroupExpandedState(stateManager.value!));

        stateManager.value?.removeAllRows();
        stateManager.value?.appendRows(buildRows(issues, timers));

        restoreGroupExpandedState(stateManager.value!, expandedGroups);
      });

      return null;
    }, [issues, ...timers]);

    return LayoutBuilder(
      builder: (context, contraints) => Stack(
        children: [
          PlutoGrid(
            columns: buildColumns(),
            rows: buildRows(issues, timers),
            configuration: PlutoGridConfiguration(
              style: PlutoGridStyleConfig(
                gridBorderRadius: context.radiusMD,
                gridBorderColor: Colors.transparent,
                gridBackgroundColor: context.colorScheme.surfaceContainerLow,
              ),
            ),
            mode: .select,
            onRowDoubleTap: (e) {
              if (e.row.type.isGroup) {
                return;
              }
              ref
                  .read(timersProvider.notifier)
                  .create(
                    issueId: (e.row.cells['id']!.value as int).toString(),
                    issueProject: e.row.cells['project']!.value,
                    issueSubject: e.row.cells['subject']!.value,
                  );
            },
            onLoaded: (e) {
              stateManager.value = e.stateManager;
              onPlutoLoaded(ref, e.stateManager);
            },
          ),
          if (issuesAsync.isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50.withAlpha(150),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            bottom: context.paddingXXL.left,
            right: context.paddingXXL.left,
            child: FloatingActionButton(
              onPressed: () {
                if (issuesAsync.isLoading) {
                  return;
                }

                ref.invalidate(issuesProvider);
              },
              child: Icon(Icons.refresh_sharp),
            ),
          ),
        ],
      ),
    );
  }

  void onPlutoLoaded(WidgetRef ref, PlutoGridStateManager stateManager) {
    stateManager.setRowGroup(
      PlutoRowGroupByColumnDelegate(
        columns: [stateManager.columns[0]],
        showCount: true,
        enableCompactCount: true,
      ),
    );

    final expandedGroupsCtl = ref.read(expandedGroupsProvider.notifier);

    stateManager.addListener(
      () => expandedGroupsCtl.set(saveGroupExpandedState(stateManager)),
    );
    restoreGroupExpandedState(stateManager, ref.read(expandedGroupsProvider));
  }

  Map<String, bool> saveGroupExpandedState(PlutoGridStateManager stateManager) {
    final expandedState = <String, bool>{};

    for (final row in stateManager.iterateAllRowGroup) {
      if (row.type.isGroup) {
        final rowKey = row.key.toString();
        expandedState[rowKey] = row.type.group.expanded;
      }
    }

    return expandedState;
  }

  void restoreGroupExpandedState(
    PlutoGridStateManager stateManager,
    Map<String, bool> expandedState,
  ) {
    for (final row in stateManager.iterateAllRowGroup.toList()) {
      if (row.type.isGroup) {
        final rowKey = row.key.toString();
        final shouldBeExpanded = expandedState[rowKey] ?? false;

        if (row.type.group.expanded != shouldBeExpanded) {
          stateManager.toggleExpandedRowGroup(rowGroup: row, notify: false);
        }
      }
    }

    stateManager.notifyListeners();
  }

  void onSearch(String query, ValueNotifier<List<RedmineIssue>> issues) {
    issues.value = issues.value.where((i) {
      return i.id.toString().contains(query) ||
          i.project.name.contains(query) ||
          i.subject.contains(query);
    }).toList();
  }

  List<PlutoColumn> buildColumns() {
    return [
      PlutoColumn(title: 'Status', field: 'status', type: .text(), width: 200),
      PlutoColumn(
        title: 'Timer',
        field: '_timer',
        type: .text(),
        width: 95,
        enableContextMenu: true,
      ),
      PlutoColumn(title: 'Issue', field: 'id', type: .text(), width: 75),
      PlutoColumn(
        title: 'Tracker',
        field: 'tracker',
        type: .text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: .text(),
        width: 90,
      ),
      PlutoColumn(
        title: 'Subject',
        field: 'subject',
        type: .text(),
        width: 260,
      ),
      PlutoColumn(
        title: 'Project',
        field: 'project',
        type: .text(),
        width: 200,
      ),
      PlutoColumn(
        title: 'Description',
        field: 'description',
        type: .text(),
        width: 260,
        hide: true,
      ),
      PlutoColumn(
        title: 'Start date',
        field: 'start_date',
        type: .date(format: 'dd.MM.yyyy'),
        width: 100,
        hide: true,
      ),
      PlutoColumn(
        title: 'Due date',
        field: 'due_date',
        type: .date(format: 'dd.MM.yyyy'),
        width: 100,
      ),
      PlutoColumn(
        title: 'Estimated hours',
        field: 'estimated_hours',
        type: .date(),
        width: 90,
        hide: true,
      ),
      PlutoColumn(
        title: 'Author',
        field: 'author',
        type: .text(),
        width: 120,
        hide: true,
      ),
      PlutoColumn(
        title: 'Assigned to',
        field: 'assigned_to',
        type: .text(),
        width: 130,
        hide: true,
      ),
      PlutoColumn(
        title: 'Updated on',
        field: 'updated_on',
        type: .date(format: 'dd.MM.yyyy'),
        width: 120,
        hide: true,
      ),
    ];
  }

  List<PlutoRow> buildRows(List<RedmineIssue> issues, List<Timer> timers) {
    return issues
        .map((i) => PlutoRow(type: .normal(), cells: getRowCells(i, timers)))
        .toList();
  }

  Map<String, PlutoCell> getRowCells(RedmineIssue issue, List<Timer> timers) {
    final timer = timers
        .where((t) => t.issueId == issue.id.toString())
        .firstOrNull;

    final timerTxt = timer == null
        ? '-'
        : timer.isRunning
        ? '▶️ running'
        : '🛑 ${timer.totalTime.toString().split('.')[0]}';

    return {
      '_timer': PlutoCell(value: timerTxt),
      'id': PlutoCell(value: issue.id),
      'status': PlutoCell(value: issue.status.name),
      'tracker': PlutoCell(value: issue.tracker.name),
      'priority': PlutoCell(value: issue.priority.name),
      'subject': PlutoCell(value: issue.subject),
      'project': PlutoCell(value: issue.project.name),
      'description': PlutoCell(value: issue.description),
      'start_date': PlutoCell(value: issue.startDate),
      'due_date': PlutoCell(value: issue.dueDate),
      'estimated_hours': PlutoCell(value: issue.estimatedHours),
      'author': PlutoCell(value: issue.author.name),
      'assigned_to': PlutoCell(value: issue.assignedTo.name),
      'updated_on': PlutoCell(value: issue.updatedOn),
    };
  }
}
