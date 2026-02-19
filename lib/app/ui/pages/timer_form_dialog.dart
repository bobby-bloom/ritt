import 'package:flutter/material.dart' hide FormField, TextField, Form;
import 'package:ritt/app/theme/theme_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    show FormField, InputKey, TextField, SubmitButton, Form;

import '../../models/timer.dart';

typedef OnTimerFormDialogSubmit =
    void Function(String? issueId, String? project, String? subject);

class TimerFormDialog extends StatelessWidget {
  const TimerFormDialog({super.key, this.timer, this.onSubmit});

  final Timer? timer;

  final OnTimerFormDialogSubmit? onSubmit;

  @override
  Widget build(BuildContext context) {
    final idFormKey = InputKey('issue-id');
    final projectFormKey = InputKey('project');
    final subjectFormKey = InputKey('subject');

    return Dialog(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      child: Container(
        padding: context.paddingXL.copyWith(top: 24, bottom: 12),
        constraints: BoxConstraints(maxWidth: 530),
        child: IntrinsicHeight(
          child: Form(
            onSubmit: (_, form) {
              onSubmit?.call(
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
                    initialValue: timer?.issueId,
                  ),
                ),
                FormField(
                  key: projectFormKey,
                  label: Text('Project'),
                  child: TextField(
                    placeholder: const Text('ritt'),
                    initialValue: timer?.issueProject,
                  ),
                ),
                FormField(
                  key: subjectFormKey,
                  label: Text('Subject'),
                  child: TextField(
                    placeholder: const Text('Task 123'),
                    initialValue: timer?.issueSubject,
                  ),
                ),
                SubmitButton(child: Text(timer == null ? 'Create' : 'Update')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
