class TaskManager {
  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> getTasks() {
    return _tasks;
  }

  void addTask(String title) {
    _tasks.add({'title': title, 'isCompleted': false});
  }

  void toggleTaskCompletion(int index) {
    _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
  }

  void updateTaskTitle(int index, String newTitle) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index]['title'] = newTitle;
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }
}