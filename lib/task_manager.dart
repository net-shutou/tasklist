class TaskManager {
  List<String> _tasks = [];

  void addTask(String task) {
    _tasks.add(task);
  }

  List<String> getTasks() {
    return _tasks;
  }
}
