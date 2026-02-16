import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reorderable_staggered_grid_view/reorderable_staggered_grid_view.dart';
import 'package:ritt/pages/timer_widget.dart';
import 'package:ritt/providers/timers.dart';
import 'package:ritt/theme/theme_extensions.dart';

class TimersPage extends HookConsumerWidget {
  const TimersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(timersProvider);

    return Stack(
      children: [
        Container(
          padding: context.paddingXL.copyWith(
            bottom: context.paddingXL.bottom * 2,
          ),
          width: double.infinity,
          height: double.infinity,
          child: timers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No timers yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first timer',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;

                    int crossAxisCount;
                    if (availableWidth <= 999) {
                      crossAxisCount = 1;
                    } else {
                      crossAxisCount = (availableWidth / 500).floor();
                    }

                    return MasonryGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: timers.length,
                      itemBuilder: (context, index) {
                        final timer = timers[index];
                        return TimerWidget(
                          timer: timer,
                          onDelete: () => ref
                              .read(timersProvider.notifier)
                              .remove(timer.id),
                          onEdit: () {},
                        );
                      },
                    );

                    // final items = timers.map((timer) {
                    //   return ReorderableStaggeredGridViewItem(
                    //     animationKey:
                    //         GlobalKey(), // ValueKey('anim_${timer.id}'),
                    //     data: timer,
                    //     mainAxisCellCount: 1,
                    //     crossAxisCellCount: 1,
                    //     child: TimerWidget(
                    //       key: ValueKey(timer.id),
                    //       timer: timer,
                    //       onDelete: () => ref
                    //           .read(timersProvider.notifier)
                    //           .remove(timer.id),
                    //       onEdit: () {},
                    //     ),
                    //   );
                    // }).toList();

                    // return ReorderableStaggeredGridView(
                    //   padding: EdgeInsets.zero,
                    //   enable: true,
                    //   crossAxisCount: crossAxisCount,
                    //   mainAxisSpacing: 16,
                    //   crossAxisSpacing: 16,
                    //   isLongPressDraggable: true,
                    //   items: items,
                    // );
                  },
                ),
        ),
        Positioned(
          bottom: context.paddingXXL.left,
          right: context.paddingXXL.left,
          child: FloatingActionButton(
            onPressed: () => ref.read(timersProvider.notifier).create(),
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
