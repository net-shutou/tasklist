import 'package:flutter/material.dart';
import 'task.dart';
import 'task_item.dart';

Widget buildTaskItem({
  required List<Task> tasks,
  required int index,
  required TextEditingController editController,
  required int? editingIndex,
  required Function(int index) onEdit,
  required Function(int index, String newTitle) onUpdateTask,
  required Function(int index) onToggleCompletion,
  required Function(int index) onDeleteTask,
}) {
  final task = tasks[index];
  return TaskItem(
    key: ValueKey('$index-${task.title}'),
    index: index,
    task: task,
    isEditing: editingIndex == index,
    editController: editController,
    onEdit: () => onEdit(index),
    onUpdateTask: (newTitle) => onUpdateTask(index, newTitle),
    onToggleCompletion: () => onToggleCompletion(index),
    onDeleteTask: () => onDeleteTask(index),
  );
}
