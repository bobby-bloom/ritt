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
import 'package:pluto_grid/pluto_grid.dart' hide PlutoGridState;
import 'package:ritt/redmine/models/redmine_issue.dart';
import 'package:ritt/app/models/timer.dart';
import 'package:ritt/pluto_grid/providers/pluto_grid_state.dart';
import 'package:ritt/redmine/providers/redmine_issues.dart';
import 'package:ritt/app/providers/timers.dart';
import 'package:ritt/app/theme/theme_extensions.dart';
import 'package:ritt/pluto_grid/utils/pluto_grid_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart'
    show BuildContext, Widget, showToast;
import 'package:collection/collection.dart';

import '../../../pluto_grid/models/pluto_grid_state.dart';

class IssuesPage extends HookConsumerWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(issuesProvider);
    final issues = issuesAsync.value ?? [];

    final timers = ref.watch(timersProvider);

    final gridState = ref.watch(gridStateProvider);
    final stateManager = useRef<PlutoGridStateManager?>(null);
    final resetKey = useState(0);

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
        return null;
      }

      final gridStateCtl = ref.read(gridStateProvider.notifier);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        gridStateCtl.setRowGroupExpandend(
          PlutoGridUtils.saveRowGroupExpandedState(stateManager.value!),
        );

        stateManager.value?.removeAllRows();
        stateManager.value?.appendRows(buildRows(issues, timers));

        PlutoGridUtils.restoreRowGroupExpandedState(
          stateManager.value!,
          gridState.expandedRowGroups,
        );
      });

      return null;
    }, [issues, ...timers]);

    useEffect(() {
      final gridStateCtl = ref.read(gridStateProvider.notifier);

      return () {
        if (stateManager.value == null) {
          return;
        }

        gridStateCtl.setColumnsState(
          PlutoGridUtils.saveColumnsState(stateManager.value!),
        );
        gridStateCtl.setRowGroupExpandend(
          PlutoGridUtils.saveRowGroupExpandedState(stateManager.value!),
        );
      };
    }, []);

    return LayoutBuilder(
      builder: (context, contraints) => Stack(
        children: [
          PlutoGrid(
            key: ValueKey(resetKey.value),
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
            onRowDoubleTap: (e) => onRowDoubleTap(ref, e.row),
            onLoaded: (e) {
              stateManager.value = e.stateManager;
              onPlutoLoaded(ref, e.stateManager, gridState);
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
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: Text('Reset grid'),
                  onPressed: () {
                    ref.read(gridStateProvider.notifier).resetState();
                    resetKey.value++;
                  },
                  child: Icon(Icons.restart_alt),
                ),
                context.gapMD,
                FloatingActionButton(
                  heroTag: Text('Fetch issues'),
                  onPressed: () {
                    if (issuesAsync.isLoading) {
                      return;
                    }

                    ref.invalidate(issuesProvider);
                  },
                  child: Icon(Icons.download),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onRowDoubleTap(WidgetRef ref, PlutoRow row) {
    if (row.type.isGroup) {
      return;
    }

    final timers = ref.read(timersProvider.notifier);

    timers.create(
      issueId: (row.cells['id']!.value as int).toString(),
      issueProject: row.cells['project']!.value,
      issueSubject: row.cells['subject']!.value,
    );
  }

  void onPlutoLoaded(
    WidgetRef ref,
    PlutoGridStateManager stateManager,
    PlutoGridState gridState,
  ) {
    stateManager.setRowGroup(
      PlutoRowGroupByColumnDelegate(
        columns: [stateManager.columns[0]],
        showCount: true,
        enableCompactCount: true,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PlutoGridUtils.restoreColumnState(stateManager, gridState.columnState);
      PlutoGridUtils.restoreRowGroupExpandedState(
        stateManager,
        gridState.expandedRowGroups,
      );
    });
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
