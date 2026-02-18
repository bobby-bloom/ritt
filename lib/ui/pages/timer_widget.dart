import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide FormField, TextField, Form;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/models/redmine_issue.dart';
import 'package:ritt/models/timer.dart';
import 'package:ritt/providers/redmine_issues.dart';
import 'package:ritt/providers/settings.dart';
import 'package:ritt/providers/timers.dart';
import 'package:ritt/theme/theme_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    show FormField, InputKey, TextField, SubmitButton, Form;
import 'package:url_launcher/url_launcher.dart';

class TimerWidget extends ConsumerWidget {
  final Timer timer;
  final VoidCallback? onDelete;
  final void Function(String? issueId, String? project, String? subject)?
  onEdit;

  const TimerWidget({
    super.key,
    required this.timer,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issue = (ref.watch(issuesProvider).value ?? [])
        .where((x) => x.id.toString() == timer.issueId)
        .firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: context.radiusMD,
        side: timer.isRunning
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary.withAlpha(125),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: context.paddingMD.copyWith(top: 10),
        child: Row(
          children: [
            Expanded(
              child: TimerWidgetContent(timer: timer, issue: issue),
            ),
            TimerWidgetActions(
              timer: timer,
              onDelete: onDelete,
              onEdit: onEdit,
            ),
          ],
        ),
      ),
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: .min,
      children: [
        if (timer.issueSubject != null) ...[
          Text(
            issue?.subject ?? timer.issueSubject!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
        ],
        if (timer.issueProject != null || timer.issueId != null)
          Row(
            children: [
              if (timer.issueProject != null) ...[
                Icon(
                  Icons.folder_outlined,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  issue?.project.name ?? timer.issueProject!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (timer.issueId != null) ...[
                if (timer.issueProject != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '•',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                RichText(
                  text: TextSpan(
                    text: '#${timer.issueId}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(
                        Uri.parse(
                          'https://${settings.redmineHost}/issues/${timer.issueId}',
                        ),
                      ),
                  ),
                ),
              ],
            ],
          ),
        if (timer.issueId == null)
          Text(
            'Manual Timer',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: timer.isRunning
                        ? [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary
                                  .withOpacity(0.3 * animationController.value),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: child,
                );
              },
              child: IconButton.filled(
                onPressed: () {
                  ref.read(timersProvider.notifier).toggle(timer.id);
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
                    _formatDuration(currentDuration.value),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Running',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Paused',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
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

class TimerWidgetActions extends ConsumerWidget {
  const TimerWidgetActions({
    super.key,
    required this.timer,
    this.onDelete,
    this.onEdit,
  });

  final Timer timer;

  final VoidCallback? onDelete;

  final void Function(String? issueId, String? project, String? subject)?
  onEdit;

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
            builder: (context) => TimerEditDialog(timer: timer, onEdit: onEdit),
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

class TimerEditDialog extends StatelessWidget {
  const TimerEditDialog({super.key, required this.timer, this.onEdit});

  final Timer timer;

  final void Function(String? issueId, String? project, String? subject)?
  onEdit;

  @override
  Widget build(BuildContext context) {
    final idFormKey = InputKey('issue-id');
    final projectFormKey = InputKey('project');
    final subjectFormKey = InputKey('subject');

    return Dialog(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      child: Container(
        padding: context.paddingXL.copyWith(top: 24),
        constraints: BoxConstraints.loose(Size(500, 400)),
        child: Form(
          onSubmit: (_, form) {
            onEdit?.call(
              form[idFormKey],
              form[projectFormKey],
              form[subjectFormKey],
            );
            Navigator.of(context).pop();
          },
          child: Column(
            spacing: context.paddingMD.bottom,
            children: [
              Row(
                mainAxisAlignment: .end,
                children: [
                  IconButton.filled(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
              FormField(
                key: idFormKey,
                label: Text('Issue id'),
                child: TextField(
                  placeholder: const Text('12345'),
                  initialValue: timer.issueId,
                ),
              ),
              FormField(
                key: projectFormKey,
                label: Text('Project'),
                child: TextField(
                  placeholder: const Text('Intern'),
                  initialValue: timer.issueProject,
                ),
              ),
              FormField(
                key: subjectFormKey,
                label: Text('Subject'),
                child: TextField(
                  placeholder: const Text('Task 123'),
                  initialValue: timer.issueSubject,
                ),
              ),
              SubmitButton(child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
