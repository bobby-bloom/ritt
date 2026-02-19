import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/redmine/models/redmine_issue.dart';
import 'package:ritt/app/models/timer.dart';
import 'package:ritt/redmine/providers/redmine_issues.dart';
import 'package:ritt/app/providers/settings.dart';
import 'package:ritt/app/providers/timers.dart';
import 'package:ritt/app/theme/theme_extensions.dart';
import 'package:ritt/app/ui/pages/post_time_dialog.dart';
import 'package:ritt/app/ui/pages/timer_form_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({
    super.key,
    required this.timer,
    this.onDelete,
    this.onEdit,
  });

  final Timer timer;

  final VoidCallback? onDelete;

  final OnTimerFormDialogSubmit? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issue = (ref.watch(issuesProvider).value ?? [])
        .where((x) => x.id.toString() == timer.issueId)
        .firstOrNull;

    return Container(
      constraints: BoxConstraints(maxHeight: 178),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: context.radiusMD,
          side: timer.isRunning
              ? BorderSide(
                  color: context.colorScheme.primary.withAlpha(125),
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: Padding(
          padding: context.paddingMD.copyWith(top: 10),
          child: Row(
            crossAxisAlignment: .center,
            children: [
              TimerWidgetContent(timer: timer, issue: issue),
              TimerWidgetActions(
                timer: timer,
                onDelete: onDelete,
                onEdit: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerWidgetContentTop extends StatelessWidget {
  const TimerWidgetContentTop({
    super.key,
    required this.timer,
    this.issue,
    this.redmineHost,
  });

  final Timer timer;

  final RedmineIssue? issue;

  final String? redmineHost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          issue?.subject ?? timer.issueSubject ?? 'Manual Timer',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: .bold),
          maxLines: 2,
          overflow: .ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (issue != null || timer.issueProject != null)
              Icon(
                Icons.folder_outlined,
                size: 14,
                color: context.colorScheme.onSurfaceVariant,
              ),
            const SizedBox(width: 4),
            Text(
              issue?.project.name ?? timer.issueProject ?? '',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            if (timer.issueId != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '•',
                  style: TextStyle(color: context.colorScheme.onSurfaceVariant),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '#${timer.issueId}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(
                      Uri.parse('https://$redmineHost/issues/${timer.issueId}'),
                    ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class TimerWidgetContentBottom extends HookConsumerWidget {
  const TimerWidgetContentBottom({
    super.key,
    required this.timer,
    this.issue,
    required this.currentDuration,
  });

  final Timer timer;

  final RedmineIssue? issue;

  final Duration currentDuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final boxShadow = !timer.isRunning
        ? null
        : [
            BoxShadow(
              color: context.colorScheme.primary.withOpacity(
                0.3 * animationController.value,
              ),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ];

    return Row(
      crossAxisAlignment: .end,
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(shape: .circle, boxShadow: boxShadow),
              child: child,
            );
          },
          child: IconButton.filled(
            onPressed: () {
              ref.read(timersProvider.notifier).toggle(timer);
            },
            icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
            iconSize: 32,
            padding: const EdgeInsets.all(12),
            color: context.colorScheme.onSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDuration(currentDuration),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (timer.isRunning)
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Running',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Paused',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: context.paddingSM.copyWith(
            right: context.paddingLG.right,
            bottom: 0,
          ),
          child: FilledButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => PostTimeDialog(timer: timer, issue: issue),
            ),
            child: Row(
              spacing: context.paddingSM.left,
              children: [Text('Post'), Icon(Icons.timer)],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }
}

class TimerWidgetContent extends HookConsumerWidget {
  const TimerWidgetContent({super.key, required this.timer, this.issue});

  final Timer timer;

  final RedmineIssue? issue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final currentDuration = useState(timer.totalTime);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    useEffect(() {
      if (timer.isRunning) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.value = 0;
      }
      return null;
    }, [timer.isRunning]);

    useEffect(() {
      if (!timer.isRunning) {
        currentDuration.value = timer.totalTime;
        return null;
      }

      final startTime = timer.lastStartOn ?? DateTime.timestamp();
      final elapsed = DateTime.timestamp().difference(startTime);
      currentDuration.value = timer.totalTime + elapsed;

      final periodicTimer = Stream.periodic(const Duration(seconds: 1), (_) {
        final now = DateTime.timestamp();
        final newElapsed = now.difference(startTime);
        currentDuration.value = timer.totalTime + newElapsed;
      }).listen((_) {});

      return periodicTimer.cancel;
    }, [timer.isRunning, timer.lastStartOn, timer.totalTime]);

    return Expanded(
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          TimerWidgetContentTop(
            timer: timer,
            issue: issue,
            redmineHost: settings.redmineHost,
          ),
          TimerWidgetContentBottom(
            timer: timer,
            issue: issue,
            currentDuration: currentDuration.value,
          ),
        ],
      ),
    );
  }
}

class TimerWidgetActions extends ConsumerWidget {
  const TimerWidgetActions({
    super.key,
    required this.timer,
    this.onDelete,
    this.onEdit,
  });

  final Timer timer;

  final VoidCallback? onDelete;

  final OnTimerFormDialogSubmit? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: context.paddingSM.bottom,
      children: [
        IconButton.filledTonal(
          onPressed: timer.totalTime.inSeconds > 0
              ? () => ref.read(timersProvider.notifier).reset(timer.id)
              : null,
          icon: const Icon(Icons.refresh),
          tooltip: 'Reset',
        ),
        IconButton.filledTonal(
          onPressed: () => showDialog(
            context: context,
            builder: (context) =>
                TimerFormDialog(timer: timer, onSubmit: onEdit),
          ),
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit',
        ),
        IconButton.filledTonal(
          color: context.colorScheme.error,
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete?.call,
        ),
      ],
    );
  }
}
