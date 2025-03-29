// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_manager.dart';

void main() {
  late TaskManager manager;

  setUp(() {
    manager = TaskManager();
  });

  test('タスクを追加できる', () {
    manager.addTask('新しいタスク');

    final tasks = manager.getTasks();
    expect(tasks.length, 1);
    expect(tasks.first['title'], '新しいタスク'); // 修正: タスクのタイトルを確認
    expect(tasks.first['isCompleted'], false); // 修正: タスクの完了状態を確認
  });

  test('タスクの完了状態を切り替えられる', () {
    manager.addTask('タスク 1');
    manager.addTask('タスク 2');

    manager.toggleTaskCompletion(0);

    final tasks = manager.getTasks();
    expect(tasks[0]['isCompleted'], true); // 修正: 完了状態を確認
    expect(tasks[1]['isCompleted'], false);

    manager.toggleTaskCompletion(0);
    expect(tasks[0]['isCompleted'], false);
  });

  test('複数のタスクを正しく管理できる', () {
    manager.addTask('タスク 1');
    manager.addTask('タスク 2');
    manager.addTask('タスク 3');

    final tasks = manager.getTasks();
    expect(tasks.length, 3);
    expect(tasks[0]['title'], 'タスク 1'); // 修正: タスクのタイトルを確認
    expect(tasks[1]['title'], 'タスク 2');
    expect(tasks[2]['title'], 'タスク 3');
  });
}

