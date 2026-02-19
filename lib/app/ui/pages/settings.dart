import 'package:flutter/material.dart'
    show BuildContext, Column, Container, Row, SizedBox, Widget;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/app/providers/settings.dart';
import 'package:ritt/app/theme/theme_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    as shadcn
    show FormField, Text, TextField, InputKey, Form, Switch, SubmitButton;
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart' as shadcnExp;

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final apiKeyFormKey = shadcn.InputKey('apiKey');
    final hostFormKey = shadcn.InputKey('host');

    final runMultipleTimersSimultaneously = useState(
      settings.runMultipleTimersSimultaneously,
    );
    final fetchOnlyMyIssues = useState(settings.fetchOnlyIssuesAssignedToMe);

    final roundTimeEntryUpToMinute = useState(
      settings.roundTimeEntryUpToMinute,
    );
    final roundTimeEntryUpToMinuteCtl = useTextEditingController(
      text: settings.roundTimeEntryUpToMinute.toString(),
    );

    useEffect(() {
      roundTimeEntryUpToMinuteCtl.text = roundTimeEntryUpToMinute.value
          .toString();
      return null;
    }, [roundTimeEntryUpToMinute.value]);

    return Container(
      padding: context.paddingXL,
      child: shadcn.Form(
        onSubmit: (_, form) => handleSubmit(
          ref,
          form[apiKeyFormKey],
          form[hostFormKey],
          runMultipleTimersSimultaneously.value,
          fetchOnlyMyIssues.value,
          roundTimeEntryUpToMinute.value,
        ),
        child: Column(
          spacing: context.paddingXL.left,
          children: [
            shadcn.FormField(
              key: apiKeyFormKey,
              label: shadcn.Text('Redmine API Key'),
              child: shadcn.TextField(
                placeholder: const shadcn.Text('ebc3f6b781a6f...'),
                initialValue: settings.redmineApiKey,
              ),
            ),
            shadcn.FormField(
              key: hostFormKey,
              label: shadcn.Text('Redmine Host'),
              child: shadcn.TextField(
                placeholder: const shadcn.Text('example.com'),
                initialValue: settings.redmineHost,
              ),
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                shadcn.Text('Run multiple timers simultaneously'),
                shadcn.Switch(
                  value: runMultipleTimersSimultaneously.value,
                  onChanged: (value) {
                    runMultipleTimersSimultaneously.value = value;
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                shadcn.Text('Fetch only issues assigned to me'),
                shadcn.Switch(
                  value: fetchOnlyMyIssues.value,
                  onChanged: (value) => fetchOnlyMyIssues.value = value,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                shadcn.Text('Rounding interval for time spent (minutes)'),
                SizedBox(
                  width: 115,
                  height: 36,
                  child: shadcnExp.TextField(
                    initialValue: (settings.roundTimeEntryUpToMinute)
                        .toString(),
                    controller: roundTimeEntryUpToMinuteCtl,
                    onChanged: (value) {
                      final intVal = int.tryParse(value);
                      if (intVal == null) {
                        return;
                      }

                      final clamped = intVal.clamp(0, 60);
                      if (clamped != intVal) {
                        roundTimeEntryUpToMinuteCtl.text = clamped.toString();
                        roundTimeEntryUpToMinuteCtl.selection = .collapsed(
                          offset: roundTimeEntryUpToMinuteCtl.text.length,
                        );
                      }

                      roundTimeEntryUpToMinute.value = clamped;
                    },
                    features: [
                      .decrementButton(step: -5, position: .leading),
                      .incrementButton(step: 5),
                    ],
                  ),
                ),
              ],
            ),
            shadcn.SubmitButton(child: const shadcn.Text('Update')),
          ],
        ),
      ),
    );
  }

  void handleSubmit(
    WidgetRef ref,
    String? apiKey,
    String? host,
    bool runMultipleTimersSimultaneously,
    bool fetchOnlyMyIssues,
    int roundTimeEntryUpToMinute,
  ) async {
    final ctl = ref.read(settingsProvider.notifier);

    return ctl.setState(
      (state) => state.copyWith(
        redmineApiKey: apiKey,
        redmineHost: host,
        runMultipleTimersSimultaneously: runMultipleTimersSimultaneously,
        fetchOnlyIssuesAssignedToMe: fetchOnlyMyIssues,
        roundTimeEntryUpToMinute: roundTimeEntryUpToMinute,
      ),
    );
  }
}
