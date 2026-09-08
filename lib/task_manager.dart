import 'task.dart';

class TaskManager {
  /// GitHub Pages向けビルドで `--dart-define=DEMO_MODE=true` を指定した場合のみ
  /// true になるコンパイル時定数。テスト実行時は未定義のため常に false。
  static const bool _demoMode = bool.fromEnvironment('DEMO_MODE');

  final List<Task> _tasks = [];
  int _nextId = 0;

  TaskManager() {
    if (_demoMode) {
      _seedDemoData();
    }
  }

  /// デモ用データを明示的に投入する。ビルド構成に依存せず検証できるよう、
  /// テストからはこちらを使用する。
  TaskManager.withDemoData() {
    _seedDemoData();
  }

  void _seedDemoData() {
    _addDemoTask('Welcome! Tap a task to edit it');
    _addDemoTask('Drag the handle to reorder tasks');
    _addDemoTask('Tap the checkbox to complete a task', isCompleted: true);
    _addDemoTask('Delete a task with the trash icon');
  }

  void _addDemoTask(String title, {bool isCompleted = false}) {
    _tasks.add(Task(id: '${_nextId++}', title: title, isCompleted: isCompleted));
  }

  List<Task> getTypedTasks() => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.add(Task(id: '${_nextId++}', title: title));
  }

  void updateTaskTitle(int index, String newTitle) {
    _tasks[index] = _tasks[index].copyWith(title: newTitle); // インデックスの検証はTaskListControllerで行う
  }

  void toggleTaskCompletion(int index) {
    _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted); // インデックスの検証はTaskListControllerで行う
  }

  void deleteTask(int index) {
    _tasks.removeAt(index); // インデックスの検証はTaskListControllerで行う
  }

  void reorderTasks(int oldIndex, int newIndex) {
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
  }
}