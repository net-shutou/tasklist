import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';

void main() {
  group('TaskListController (typed API)', () {
    late TaskListController controller;

    setUp(() {
      controller = TaskListController();
    });

    test('タスクを追加できる', () {
      controller.addTask('New Task');
      expect(controller.typedTasks.length, 1);
      expect(controller.typedTasks[0].title, 'New Task');
      expect(controller.typedTasks[0].isCompleted, false);
    });

    test('タスクを更新できる', () {
      controller.addTask('Old Task');
      controller.updateTask(0, 'Updated Task');
      expect(controller.typedTasks[0].title, 'Updated Task');
    });

    test('タスクの完了状態を切り替えられる', () {
      controller.addTask('Task');
      expect(controller.typedTasks[0].isCompleted, false);

      controller.toggleTaskCompletion(0);
      expect(controller.typedTasks[0].isCompleted, true);

      controller.toggleTaskCompletion(0);
      expect(controller.typedTasks[0].isCompleted, false);
    });

    test('タスクを削除できる', () {
      controller.addTask('Task 1');
      controller.addTask('Task 2');
      expect(controller.typedTasks.length, 2);

      controller.deleteTask(0);
      expect(controller.typedTasks.length, 1);
      expect(controller.typedTasks[0].title, 'Task 2');
    });

    test('タスクを並べ替えられる', () {
      controller.addTask('Task 1');
      controller.addTask('Task 2');
      controller.addTask('Task 3');

      // oldIndex < newIndex
      controller.reorderTasks(0, 2);
      expect(controller.typedTasks[0].title, 'Task 2');
      expect(controller.typedTasks[1].title, 'Task 3');
      expect(controller.typedTasks[2].title, 'Task 1');

      // oldIndex > newIndex
      controller.reorderTasks(2, 0);
      expect(controller.typedTasks[0].title, 'Task 1');
      expect(controller.typedTasks[1].title, 'Task 2');
      expect(controller.typedTasks[2].title, 'Task 3');

      // oldIndex == newIndex
      controller.reorderTasks(1, 1);
      expect(controller.typedTasks[0].title, 'Task 1');
      expect(controller.typedTasks[1].title, 'Task 2');
      expect(controller.typedTasks[2].title, 'Task 3');

      // oldIndex == 0, newIndex == リストの末尾
      controller.reorderTasks(0, 3);
      expect(controller.typedTasks[0].title, 'Task 2');
      expect(controller.typedTasks[1].title, 'Task 3');
      expect(controller.typedTasks[2].title, 'Task 1');

      // oldIndex == リストの末尾, newIndex == 0
      controller.reorderTasks(2, 0);
      expect(controller.typedTasks[0].title, 'Task 1');
      expect(controller.typedTasks[1].title, 'Task 2');
      expect(controller.typedTasks[2].title, 'Task 3');

      // リストに1つしかタスクがない場合
      controller.deleteTask(2);
      controller.deleteTask(1);
      expect(controller.typedTasks.length, 1);
      controller.reorderTasks(0, 0);
      expect(controller.typedTasks[0].title, 'Task 1');

      // リストが空の場合
      controller.deleteTask(0);
      expect(controller.typedTasks.isEmpty, true);
      expect(() => controller.reorderTasks(0, 1), returnsNormally);
    });

    test('無効なインデックスで操作してもエラーが発生しない', () {
      controller.addTask('Task');
      expect(() => controller.updateTask(1, 'Invalid'), returnsNormally);
      expect(() => controller.toggleTaskCompletion(1), returnsNormally);
      expect(() => controller.deleteTask(1), returnsNormally);
      expect(() => controller.reorderTasks(1, 2), returnsNormally);
    });

    test('addTask handles edge cases', () {
      // 空文字列を追加
      controller.addTask('');
      expect(controller.typedTasks.length, 0);

      // 非常に長い文字列を追加
      final longTitle = 'A' * 255;
      controller.addTask(longTitle);
      expect(controller.typedTasks.length, 1);
      expect(controller.typedTasks[0].title, longTitle);
    });

    test('updateTask handles invalid indices', () {
      controller.addTask('Task 1');

      expect(() => controller.updateTask(-1, 'Invalid'), returnsNormally);
      expect(() => controller.updateTask(1, 'Invalid'), returnsNormally);

      controller.updateTask(0, 'Updated Task');
      expect(controller.typedTasks[0].title, 'Updated Task');
    });

    test('toggleTaskCompletion handles invalid indices', () {
      controller.addTask('Task 1');

      expect(() => controller.toggleTaskCompletion(-1), returnsNormally);
      expect(() => controller.toggleTaskCompletion(1), returnsNormally);

      controller.toggleTaskCompletion(0);
      expect(controller.typedTasks[0].isCompleted, true);
    });

    test('deleteTask handles invalid indices', () {
      controller.addTask('Task 1');

      expect(() => controller.deleteTask(-1), returnsNormally);
      expect(() => controller.deleteTask(1), returnsNormally);

      controller.deleteTask(0);
      expect(controller.typedTasks.length, 0);
    });

    test('reorderTasks handles invalid indices', () {
      controller.addTask('Task 1');
      controller.addTask('Task 2');

      expect(() => controller.reorderTasks(-1, 1), returnsNormally);
      expect(() => controller.reorderTasks(0, 3), returnsNormally);

      controller.reorderTasks(0, 1);
      expect(controller.typedTasks[0].title, 'Task 2');
      expect(controller.typedTasks[1].title, 'Task 1');
    });
  });
}
