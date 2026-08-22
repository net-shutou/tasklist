import 'package:flutter/material.dart';
import 'task.dart';
import 'task_manager.dart'; // TaskManagerをインポート

class TaskListController extends ChangeNotifier {
  final TaskManager _taskManager = TaskManager(); // TaskManagerをインスタンス化

  List<Task> get typedTasks => _taskManager.getTypedTasks(); // タスクを取得

  int? _editingIndex;
  int? get editingIndex => _editingIndex;

  void startEdit(int index) {
    _editingIndex = index;
    notifyListeners();
  }

  void stopEditing() {
    _editingIndex = null;
    notifyListeners();
  }

  void addTask(String title) {
    if (title == null || title.trim().isEmpty) {
      print('Invalid title for addTask: "$title"');
      return; // 空文字列や空白のみ、またはnullの入力を無視
    }
    if (title.length > 255) {
      print('Title too long for addTask: "$title"');
      return; // 長すぎるタイトルを無視
    }
    _taskManager.addTask(title); // TaskManagerに委譲
    notifyListeners();
  }

  void updateTask(int index, String newTitle) {
    if (index < 0 || index >= typedTasks.length) {
      print('Invalid index for updateTask: $index');
      return; // 無効なインデックスの場合は何もしない
    }
    if (newTitle == null || newTitle.trim().isEmpty) {
      print('Invalid title for updateTask: "$newTitle"');
      return; // 空文字列や空白のみ、またはnullの入力を無視
    }
    _taskManager.updateTaskTitle(index, newTitle); // TaskManagerに委譲
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    if (index < 0 || index >= typedTasks.length) {
      print('Invalid index for toggleTaskCompletion: $index');
      return; // 無効なインデックスの場合は何もしない
    }
    _taskManager.toggleTaskCompletion(index); // TaskManagerに委譲
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index < 0 || index >= typedTasks.length) {
      print('Invalid index for deleteTask: $index');
      return; // 無効なインデックスの場合は何もしない
    }
    _taskManager.deleteTask(index); // TaskManagerに委譲
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    print('Before reorder: ${_taskManager.getTypedTasks()}');
    print('oldIndex: $oldIndex, newIndex: $newIndex');

    // 無効なインデックスの場合は何もしない
    if (oldIndex < 0 || oldIndex >= typedTasks.length || newIndex < 0 || newIndex > typedTasks.length) {
      print('Invalid indices for reorderTasks. No changes made.');
      return;
    }

    // oldIndexとnewIndexが同じ場合は何もしない
    if (oldIndex == newIndex) {
      print('No changes made for reorderTasks as oldIndex and newIndex are the same.');
      return;
    }

    // ReorderableListViewは下方向移動時に「削除前」のインデックスをnewIndexとして渡すため、
    // oldIndex < newIndex の場合は削除による1つ分のずれを補正する
    var adjustedNewIndex = newIndex;
    if (oldIndex < newIndex) {
      adjustedNewIndex -= 1;
    }

    _taskManager.reorderTasks(oldIndex, adjustedNewIndex); // TaskManagerに委譲

    print('After reorder: ${_taskManager.getTypedTasks()}');
    notifyListeners();
  }
}
