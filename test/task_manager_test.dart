import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task.dart';
import 'package:tasklist/task_manager.dart';

void main() {
  late TaskManager manager;

  setUp(() {
    manager = TaskManager();
  });

  group('TaskManager (typed API)', () {
    test('addTask 後、getTypedTasks が Task のリストを返す', () {
      manager.addTask('タスク1');

      final tasks = manager.getTypedTasks();

      expect(tasks.length, 1);
      expect(tasks.first.title, 'タスク1');
      expect(tasks.first.isCompleted, false);
    });

    test('addTask を複数回呼ぶと、各 Task に一意な id が割り振られる', () {
      manager.addTask('タスク1');
      manager.addTask('タスク2');
      manager.addTask('タスク3');

      final tasks = manager.getTypedTasks();
      final ids = tasks.map((t) => t.id).toSet();

      expect(ids.length, 3);
    });

    test('toggleTaskCompletion が getTypedTasks に反映される', () {
      manager.addTask('タスク1');

      manager.toggleTaskCompletion(0);

      expect(manager.getTypedTasks()[0].isCompleted, true);
    });

    test('updateTaskTitle が getTypedTasks に反映される', () {
      manager.addTask('タスク1');

      manager.updateTaskTitle(0, '新しいタイトル');

      expect(manager.getTypedTasks()[0].title, '新しいタイトル');
    });

    test('deleteTask が getTypedTasks に反映される', () {
      manager.addTask('タスク1');
      manager.addTask('タスク2');

      manager.deleteTask(0);

      final tasks = manager.getTypedTasks();
      expect(tasks.length, 1);
      expect(tasks.first.title, 'タスク2');
    });

    test('reorderTasks が getTypedTasks に反映される', () {
      manager.addTask('タスク1');
      manager.addTask('タスク2');
      manager.addTask('タスク3');

      manager.reorderTasks(0, 2);

      final titles = manager.getTypedTasks().map((t) => t.title).toList();
      expect(titles, ['タスク2', 'タスク3', 'タスク1']);
    });

    test('getTypedTasks が返すリストは変更不能(unmodifiable)', () {
      manager.addTask('タスク1');

      final tasks = manager.getTypedTasks();

      expect(
        () => tasks.add(const Task(id: 'x', title: 'y')),
        throwsUnsupportedError,
      );
    });
  });
}
