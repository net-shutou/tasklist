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
  Future<void> _pumpTaskListWidget(WidgetTester tester, TaskManager taskManager) async {
    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));
  }

  testWidgets('TaskListWidget displays tasks', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await _pumpTaskListWidget(tester, taskManager);

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });

  testWidgets('タスクを追加できる', (WidgetTester tester) async {
    final taskManager = TaskManager();

    await _pumpTaskListWidget(tester, taskManager);

    expect(find.text('New Task'), findsNothing);

    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('New Task'), findsOneWidget);
  });

  testWidgets('タスクを削除できる', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await _pumpTaskListWidget(tester, taskManager);

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

  testWidgets('タスクを編集できる', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await _pumpTaskListWidget(tester, taskManager);

    // 初期状態でタスクが表示されていることを確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);

    // タスクをタップして編集モードにする
    await tester.tap(find.text('Task 1'));
    await tester.pump();

    // 編集モードのTextFieldを特定してテキストを入力
    final editableTextField = find.byType(TextField).first;
    await tester.enterText(editableTextField, 'Updated Task 1');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // タスクが更新されていることを確認
    expect(find.text('Updated Task 1'), findsOneWidget);
    expect(find.text('Task 1'), findsNothing);
  });

  testWidgets('ドラッグ用アイコンを使用してタスクを並び替えできる', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');
    taskManager.addTask('Task 3');

    await _pumpTaskListWidget(tester, taskManager);

    // 初期状態でタスクが正しい順序で表示されていることを確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);

    // ドラッグ用アイコンを検索
    final dragIconFinder = find.descendant(
      of: find.byKey(ValueKey('2-Task 3')), // Task 3のListTile
      matching: find.byType(ReorderableDragStartListener),
    );

    // Task 3をTask 1の位置にドラッグ
    final task1Finder = find.byKey(ValueKey('0-Task 1')); // Task 1のキー
    final task1Offset = tester.getCenter(task1Finder);
    final dragIconOffset = tester.getCenter(dragIconFinder);
    final dragOffset = Offset(0, task1Offset.dy - dragIconOffset.dy);

    await tester.drag(dragIconFinder, dragOffset);
    await tester.pumpAndSettle();

    // 並び替え後の順序を確認
    final tasks = taskManager.getTasks();
    expect(tasks[0]['title'], 'Task 3');
    expect(tasks[1]['title'], 'Task 1');
    expect(tasks[2]['title'], 'Task 2');
  });
}