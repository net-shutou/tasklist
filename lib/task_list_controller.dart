import 'package:flutter/material.dart';
import 'task.dart';
import 'task_manager.dart';

class TaskListController extends ChangeNotifier {
  final TaskManager _taskManager = TaskManager();

  List<Task> get typedTasks => _taskManager.getTypedTasks();

  String? _editingTaskId;
  String? get editingTaskId => _editingTaskId;

  void startEdit(int index) {
    if (index < 0 || index >= typedTasks.length) {
      return;
    }
    _editingTaskId = typedTasks[index].id;
    notifyListeners();
  }

  void stopEditing() {
    _editingTaskId = null;
    notifyListeners();
  }

  void addTask(String title) {
    if (title.trim().isEmpty) {
      return;
    }
    if (title.length > 255) {
      return;
    }
    _taskManager.addTask(title);
    notifyListeners();
  }

  void updateTask(int index, String newTitle) {
    if (index < 0 || index >= typedTasks.length) {
      return;
    }
    if (newTitle.trim().isEmpty) {
      return;
    }
    _taskManager.updateTaskTitle(index, newTitle);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    if (index < 0 || index >= typedTasks.length) {
      return;
    }
    _taskManager.toggleTaskCompletion(index);
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index < 0 || index >= typedTasks.length) {
      return;
    }
    _taskManager.deleteTask(index);
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= typedTasks.length || newIndex < 0 || newIndex > typedTasks.length) {
      return;
    }

    if (oldIndex == newIndex) {
      return;
    }

    // ReorderableListViewは下方向移動時に「削除前」のインデックスをnewIndexとして渡すため、
    // oldIndex < newIndex の場合は削除による1つ分のずれを補正する
    var adjustedNewIndex = newIndex;
    if (oldIndex < newIndex) {
      adjustedNewIndex -= 1;
    }

    _taskManager.reorderTasks(oldIndex, adjustedNewIndex);

    notifyListeners();
  }
}
