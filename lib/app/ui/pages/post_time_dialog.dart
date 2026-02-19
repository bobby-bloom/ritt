import 'package:flutter/material.dart' hide FormField, TextField, Form;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/app/providers/settings.dart';
import 'package:ritt/app/utils/duration_utils.dart';
import 'package:ritt/redmine/models/redmine_issue.dart';
import 'package:ritt/redmine/providers/redmine_service.dart';
import 'package:ritt/redmine/providers/redmine_user.dart';
import 'package:ritt/app/providers/timers.dart';
import 'package:ritt/app/theme/theme_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    show
        ComponentValueController,
        DurationInput,
        Form,
        FormField,
        InputKey,
        NotEmptyValidator,
        SubmitButton,
        TextField;

import '../../models/timer.dart';

class PostTimeDialog extends HookConsumerWidget {
  const PostTimeDialog({super.key, required this.timer, this.issue});

  final Timer timer;

  final RedmineIssue? issue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdFormKey = InputKey('user-id');
    final issueIdFormKey = InputKey('issue-id');
    final projectIdFormKey = InputKey('project-id');
    final commentsFormKey = InputKey('comments');

    final tTimer = useState(timer);
    final settings = ref.watch(settingsProvider);

    final isBillable = useState(false);
    final hoursCtl = useRef(
      ComponentValueController<Duration>(
        DurationUtils.roundUpToMinuteInterval(
          tTimer.value.totalTime,
          settings.roundTimeEntryUpToMinute,
        ),
      ),
    );

    final user = ref.watch(redmineUserProvider).value;
    ref.watch(timersProvider);
    ref.watch(redmineServiceProvider);

    useEffect(() {
      if (!tTimer.value.isRunning) {
        return null;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        tTimer.value = ref.read(timersProvider.notifier).toggle(timer);

        hoursCtl.value.value = DurationUtils.roundUpToMinuteInterval(
          tTimer.value.totalTime,
          settings.roundTimeEntryUpToMinute,
        );
      });

      return null;
    }, []);

    return Dialog(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      child: Container(
        padding: context.paddingXL.copyWith(top: 24, bottom: 12),
        constraints: BoxConstraints(maxWidth: 530),
        child: IntrinsicHeight(
          child: Form(
            onSubmit: (_, form) {
              final service = ref.read(redmineServiceProvider);

              service.postTimeEntry(
                userId: form[userIdFormKey],
                projectId: form[projectIdFormKey],
                issueId: form[issueIdFormKey],
                comments: form[commentsFormKey],
                hours: hoursCtl.value.value,
                spentOn: .now(),
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
                  key: userIdFormKey,
                  label: Text('User id'),
                  validator: NotEmptyValidator(),
                  child: TextField(
                    placeholder: const Text(''),
                    initialValue: user?.id.toString(),
                  ),
                ),
                FormField(
                  key: projectIdFormKey,
                  label: Text('Project id'),
                  validator: NotEmptyValidator(),
                  child: TextField(
                    placeholder: const Text(''),
                    initialValue: issue?.project.id.toString(),
                  ),
                ),
                FormField(
                  key: issueIdFormKey,
                  label: Text('Issue id'),
                  child: TextField(
                    placeholder: const Text(''),
                    initialValue: issue?.id.toString(),
                  ),
                ),
                FormField(
                  key: commentsFormKey,
                  label: Text('Comment'),
                  validator: NotEmptyValidator(),
                  child: TextField(placeholder: const Text('')),
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Time spent'),
                    DurationInput(
                      initialValue: hoursCtl.value.value,
                      controller: hoursCtl.value,
                      onChanged: (duration) => duration == null
                          ? null
                          : hoursCtl.value.value = duration,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Is billable'),
                    Switch(
                      value: isBillable.value,
                      onChanged: (value) => isBillable.value = value,
                    ),
                  ],
                ),
                SubmitButton(child: Text('Post')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
