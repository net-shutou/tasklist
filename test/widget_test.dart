// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/main.dart';
import 'package:tasklist/task_manager.dart';
import 'package:tasklist/task_list_widget.dart';

void main() {
  // 既存のテスト: タスクが正しく表示されることを確認
  testWidgets('TaskListWidget displays tasks', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });

  // 新しいテスト: タスクを追加する機能を確認
  testWidgets('タスクを追加できる', (WidgetTester tester) async {
    final taskManager = TaskManager();

    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));

    expect(find.text('New Task'), findsNothing);

    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('New Task'), findsOneWidget);
  });

    // 新しいテスト: タスクを削除する機能を確認
  testWidgets('タスクを削除できる', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));

    // 初期状態でタスクが表示されていることを確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);

    // 削除ボタンをタップ
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    // タスクが削除されていることを確認
    expect(find.text('Task 1'), findsNothing);
    expect(find.text('Task 2'), findsOneWidget);
  });
}
