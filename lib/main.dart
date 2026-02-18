import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ritt/ui/pages/issues.dart';
import 'package:ritt/ui/pages/settings.dart';
import 'package:ritt/ui/pages/timers.dart';
import 'package:ritt/providers/settings.dart';
import 'package:ritt/providers/shared_preferences.dart';
import 'package:ritt/theme/theme_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart' as shadcn;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
  );

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return shadcn.ShadcnApp(
      title: 'redmine issue time tracker',
      // theme: settings.themeMode.toAppTheme(),
      themeMode: settings.themeMode,
      home: const MainPage(),
    );
  }
}

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabCtl = useTabController(initialLength: 3);

    useListenable(tabCtl);

    return Scaffold(
      body: Padding(
        padding: context.paddingMD,
        child: Column(
          spacing: context.paddingSM.left,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Card(
                  color: context.colorScheme.primary,
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: context.paddingMD,
                    child: Text(
                      'redmine issue time tracker',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: context.colorScheme.surfaceContainerLow,
                  child: Center(
                    heightFactor: 1.65,
                    child: shadcn.Tabs(
                      onChanged: (idx) => tabCtl.animateTo(idx),
                      index: tabCtl.index,
                      children: const [
                        shadcn.TabItem(child: Text('Settings')),
                        shadcn.TabItem(child: Text('Timers')),
                        shadcn.TabItem(child: Text('Issues')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.paddingXS.top),
            Expanded(
              child: Card(
                margin: EdgeInsets.all(0),
                child: TabBarView(
                  controller: tabCtl,
                  children: [SettingsPage(), TimersPage(), IssuesPage()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
