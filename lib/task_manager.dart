class TaskManager {
  List<String> tasks = [];

  // タスクを追加するメソッド
  void addTask(String task) {
    tasks.add(task);
  }

  // タスクを取得するメソッド
  List<String> getTasks() {
    return tasks;
  }
}