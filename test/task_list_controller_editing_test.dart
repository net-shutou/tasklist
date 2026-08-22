import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';

void main() {
  group('TaskListController (editingIndex: H-1)', () {
    late TaskListController controller;

    setUp(() {
      controller = TaskListController();
    });

    test('初期状態ではeditingIndexはnull', () {
      expect(controller.editingIndex, isNull);
    });

    test('startEditでeditingIndexが指定したインデックスになる', () {
      controller.addTask('Task 1');

      controller.startEdit(0);

      expect(controller.editingIndex, 0);
    });

    test('startEditはリスナーに通知する', () {
      controller.addTask('Task 1');
      var notified = false;
      controller.addListener(() => notified = true);

      controller.startEdit(0);

      expect(notified, isTrue);
    });

    test('stopEditingでeditingIndexがnullに戻る', () {
      controller.addTask('Task 1');
      controller.startEdit(0);

      controller.stopEditing();

      expect(controller.editingIndex, isNull);
    });

    test('stopEditingはリスナーに通知する', () {
      controller.addTask('Task 1');
      controller.startEdit(0);
      var notified = false;
      controller.addListener(() => notified = true);

      controller.stopEditing();

      expect(notified, isTrue);
    });
  });
}
