import 'task.dart';

class TaskManager {
  final List<Task> _tasks = [];
  int _nextId = 0;

  List<Task> getTypedTasks() => List.unmodifiable(_tasks);

  @Deprecated('Use getTypedTasks() instead')
  List<Map<String, dynamic>> getTasks() =>
      _tasks.map((t) => {'title': t.title, 'isCompleted': t.isCompleted}).toList();

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