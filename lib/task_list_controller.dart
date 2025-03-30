import 'package:flutter/material.dart';
import 'task_manager.dart'; // TaskManagerをインポート

class TaskListController extends ChangeNotifier {
  final TaskManager _taskManager = TaskManager(); // TaskManagerをインスタンス化

  List<Map<String, dynamic>> get tasks => _taskManager.getTasks(); // タスクを取得

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
    if (index < 0 || index >= tasks.length) {
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
    if (index < 0 || index >= tasks.length) {
      print('Invalid index for toggleTaskCompletion: $index');
      return; // 無効なインデックスの場合は何もしない
    }
    _taskManager.toggleTaskCompletion(index); // TaskManagerに委譲
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index < 0 || index >= tasks.length) {
      print('Invalid index for deleteTask: $index');
      return; // 無効なインデックスの場合は何もしない
    }
    _taskManager.deleteTask(index); // TaskManagerに委譲
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    print('Before reorder: ${_taskManager.getTasks()}');
    print('oldIndex: $oldIndex, newIndex: $newIndex');

    // 無効なインデックスの場合は何もしない
    if (oldIndex < 0 || oldIndex >= tasks.length || newIndex < 0 || newIndex > tasks.length) {
      print('Invalid indices for reorderTasks. No changes made.');
      return;
    }

    // oldIndexとnewIndexが同じ場合は何もしない
    if (oldIndex == newIndex) {
      print('No changes made for reorderTasks as oldIndex and newIndex are the same.');
      return;
    }

    // newIndexがリストの長さと等しい場合は末尾に挿入
    if (newIndex == tasks.length) {
      newIndex = tasks.length - 1;
    }

    _taskManager.reorderTasks(oldIndex, newIndex); // TaskManagerに委譲

    print('After reorder: ${_taskManager.getTasks()}');
    notifyListeners();
  }
}