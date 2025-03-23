// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_manager.dart';

void main() {
  test('タスクを追加できる', () {
    final manager = TaskManager();

    manager.addTask('新しいタスク');

    expect(manager.getTasks().length, 1);
    expect(manager.getTasks().first, '新しいタスク');
  });
}

