import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';

void main() {
  group('TaskListController (editingTaskId: H-1/M-7)', () {
    late TaskListController controller;

    setUp(() {
      controller = TaskListController();
    });

    test('初期状態ではeditingTaskIdはnull', () {
      expect(controller.editingTaskId, isNull);
    });

    test('startEditでeditingTaskIdが指定したタスクのidになる', () {
      controller.addTask('Task 1');
      final taskId = controller.typedTasks[0].id;

      controller.startEdit(0);

      expect(controller.editingTaskId, taskId);
    });

    test('startEditはリスナーに通知する', () {
      controller.addTask('Task 1');
      var notified = false;
      controller.addListener(() => notified = true);

      controller.startEdit(0);

      expect(notified, isTrue);
    });

    test('stopEditingでeditingTaskIdがnullに戻る', () {
      controller.addTask('Task 1');
      controller.startEdit(0);

      controller.stopEditing();

      expect(controller.editingTaskId, isNull);
    });

    test('stopEditingはリスナーに通知する', () {
      controller.addTask('Task 1');
      controller.startEdit(0);
      var notified = false;
      controller.addListener(() => notified = true);

      controller.stopEditing();

      expect(notified, isTrue);
    });

    test('並び替え後も編集対象はタスクの同一性で維持される(M-7)', () {
      controller.addTask('Task A');
      controller.addTask('Task B');
      final taskAId = controller.typedTasks[0].id;

      controller.startEdit(0);
      controller.reorderTasks(1, 0);

      expect(controller.editingTaskId, taskAId);
    });
  });
}
