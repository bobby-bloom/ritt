import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/models/timer.dart';
import 'package:ritt/providers/redmine_issues.dart';
import 'package:ritt/providers/settings.dart';
import 'package:ritt/providers/timers.dart';
import 'package:ritt/theme/theme_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class TimerWidget extends HookConsumerWidget {
  final Timer timer;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TimerWidget({
    super.key,
    required this.timer,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final issue = (ref.watch(issuesProvider).value ?? [])
        .where((x) => x.id.toString() == timer.issueId)
        .firstOrNull;

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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: timer.isRunning
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary.withAlpha(125),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (timer.issueSubject != null) ...[
                        Text(
                          issue?.subject ?? timer.issueSubject!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                issue?.project.name ?? timer.issueProject!,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                            if (timer.issueId != null) ...[
                              if (timer.issueProject != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '•',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              RichText(
                                text: TextSpan(
                                  text: '#${timer.issueId}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launchUrl(
                                      Uri.parse(
                                        'https://${settings.redmineHost}?issue=${timer.issueId}',
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: timer.totalTime.inSeconds > 0
                      ? () => ref.read(timersProvider.notifier).reset(timer.id)
                      : null,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
                // PopupMenuButton<String>(
                //   icon: const Icon(Icons.more_vert),
                //   onSelected: (value) {
                //     if (value == 'edit' && onEdit != null) {
                //       onEdit!();
                //     } else if (value == 'delete' && onDelete != null) {
                //       onDelete!();
                //     }
                //   },
                //   itemBuilder: (context) => [
                //     // const PopupMenuItem(
                //     //   value: 'edit',
                //     //   child: Row(
                //     //     children: [
                //     //       Icon(Icons.edit_outlined),
                //     //       SizedBox(width: 12),
                //     //       Text('Edit'),
                //     //     ],
                //     //   ),
                //     // ),
                //     const PopupMenuItem(
                //       value: 'delete',
                //       child: Row(
                //         children: [
                //           Icon(Icons.delete_outlined),
                //           SizedBox(width: 12),
                //           Text('Delete'),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
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
                                      .withOpacity(
                                        0.3 * animationController.value,
                                      ),
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
                    icon: Icon(
                      timer.isRunning ? Icons.pause : Icons.play_arrow,
                    ),
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
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                ),

                IconButton.filledTonal(
                  color: context.colorScheme.error,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete?.call,
                ),
              ],
            ),
          ],
        ),
      ),
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
