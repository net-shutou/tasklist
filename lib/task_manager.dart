class TaskManager {
  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> getTasks() => _tasks;

  void addTask(String title) {
    _tasks.add({'title': title, 'isCompleted': false});
  }

  void updateTaskTitle(int index, String newTitle) {
    _tasks[index]['title'] = newTitle; // インデックスの検証はTaskListControllerで行う
  }

  void toggleTaskCompletion(int index) {
    _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted']; // インデックスの検証はTaskListControllerで行う
  }

  void deleteTask(int index) {
    _tasks.removeAt(index); // インデックスの検証はTaskListControllerで行う
  }

  void reorderTasks(int oldIndex, int newIndex) {
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
  }
}