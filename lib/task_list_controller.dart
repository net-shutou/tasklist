import 'package:flutter/material.dart';
import 'task.dart';
import 'task_manager.dart'; // TaskManagerをインポート

class TaskListController extends ChangeNotifier {
  final TaskManager _taskManager = TaskManager(); // TaskManagerをインスタンス化

  List<Task> get typedTasks => _taskManager.getTypedTasks(); // タスクを取得

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
      return; // 空文字列や空白のみの入力を無視
    }
    if (title.length > 255) {
      return; // 長すぎるタイトルを無視
    }
    _taskManager.addTask(title); // TaskManagerに委譲
    notifyListeners();
  }

  void updateTask(int index, String newTitle) {
    if (index < 0 || index >= typedTasks.length) {
      return; // 無効なインデックスの場合は何もしない
    }
    if (newTitle.trim().isEmpty) {
      return; // 空文字列や空白のみの入力を無視
    }
    _taskManager.updateTaskTitle(index, newTitle); // TaskManagerに委譲
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    if (index < 0 || index >= typedTasks.length) {
      return; // 無効なインデックスの場合は何もしない
    }
    _taskManager.toggleTaskCompletion(index); // TaskManagerに委譲
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index < 0 || index >= typedTasks.length) {
      return; // 無効なインデックスの場合は何もしない
    }
    _taskManager.deleteTask(index); // TaskManagerに委譲
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    // 無効なインデックスの場合は何もしない
    if (oldIndex < 0 || oldIndex >= typedTasks.length || newIndex < 0 || newIndex > typedTasks.length) {
      return;
    }

    // oldIndexとnewIndexが同じ場合は何もしない
    if (oldIndex == newIndex) {
      return;
    }

    // ReorderableListViewは下方向移動時に「削除前」のインデックスをnewIndexとして渡すため、
    // oldIndex < newIndex の場合は削除による1つ分のずれを補正する
    var adjustedNewIndex = newIndex;
    if (oldIndex < newIndex) {
      adjustedNewIndex -= 1;
    }

    _taskManager.reorderTasks(oldIndex, adjustedNewIndex); // TaskManagerに委譲

    notifyListeners();
  }
}
