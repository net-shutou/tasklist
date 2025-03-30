import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final void Function(int oldIndex, int newIndex) onReorder;
  final Widget Function(List<Map<String, dynamic>>, int) buildTaskItem;

  TaskListView({
    required this.tasks,
    required this.onReorder,
    required this.buildTaskItem,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: onReorder,
      children: List.generate(tasks.length, (index) {
        return buildTaskItem(tasks, index);
      }),
    );
  }
}