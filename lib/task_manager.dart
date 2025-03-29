class TaskManager {
  final List<Map<String, dynamic>> _tasks = [];

  void addTask(String task) {
    _tasks.add({'title': task, 'isCompleted': false});
  }

  void toggleTaskCompletion(int index) {
    _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
  }

  List<Map<String, dynamic>> getTasks() {
    return _tasks;
  }
}