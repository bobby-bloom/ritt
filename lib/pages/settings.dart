import 'package:flutter/material.dart'
    show BuildContext, Widget, Container, Column, Row, SizedBox;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/providers/settings.dart';
import 'package:ritt/theme/theme_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    show
        FormField,
        Text,
        TextField,
        InputKey,
        Form,
        Switch,
        RadioGroup,
        RadioItem,
        SubmitButton,
        ThemeMode;

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final allowMultipleTimersRunningSimultaneously = useState(
      settings.allowMultipleTimersRunningSimultaneously,
    );
    final themeMode = useState(settings.themeMode);

    final apiKeyFormKey = InputKey('apiKey');
    final hostFormKey = InputKey('host');

    return Container(
      padding: context.paddingXL,
      child: Form(
        onSubmit: (_, form) => handleSubmit(
          ref,
          form[apiKeyFormKey],
          form[hostFormKey],
          allowMultipleTimersRunningSimultaneously.value,
          themeMode.value,
        ),
        child: Column(
          spacing: context.paddingXL.left,
          children: [
            FormField(
              key: apiKeyFormKey,
              label: Text('Redmine API Key'),
              child: TextField(
                placeholder: const Text('ebc3f6b781a6f...'),
                initialValue: settings.redmineApiKey,
              ),
            ),
            FormField(
              key: hostFormKey,
              label: Text('Redmine Authority'),
              child: TextField(
                placeholder: const Text('etiscan.redmine.com'),
                initialValue: settings.redmineHost,
              ),
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text('Allow multiple timers running simultaneously'),
                Switch(
                  value: allowMultipleTimersRunningSimultaneously.value,
                  onChanged: (value) {
                    allowMultipleTimersRunningSimultaneously.value = value;
                  },
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: .start,
            //   spacing: context.paddingSM.bottom,
            //   children: [
            //     Text('Theme mode'),
            //     RadioGroup(
            //       value: themeMode.value,
            //       onChanged: (value) => themeMode.value = value,
            //       child: Row(
            //         mainAxisAlignment: .center,
            //         children: [
            //           SizedBox(
            //             width: 400,
            //             child: Row(
            //               mainAxisAlignment: .spaceEvenly,
            //               children: [
            //                 RadioItem(
            //                   value: ThemeMode.light,
            //                   trailing: Text('Light'),
            //                 ),
            //                 RadioItem(
            //                   value: ThemeMode.dark,
            //                   trailing: Text('Dark'),
            //                 ),
            //                 RadioItem(
            //                   value: ThemeMode.system,
            //                   trailing: Text('System'),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            SubmitButton(child: const Text('Update')),
          ],
        ),
      ),
    );
  }

  void handleSubmit(
    WidgetRef ref,
    String? apiKey,
    String? host,
    bool allowMultipleTimersRunningSimultaneously,
    ThemeMode mode,
  ) async {
    final ctl = ref.read(settingsProvider.notifier);

    return ctl.setState(
      (state) => state.copyWith(
        redmineApiKey: apiKey,
        redmineHost: host,
        allowMultipleTimersRunningSimultaneously:
            allowMultipleTimersRunningSimultaneously,
        themeMode: mode,
      ),
    );
  }
}
