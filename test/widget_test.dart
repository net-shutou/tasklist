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
import 'add_task_test.dart' as add_task_test;
import 'reorder_task_test.dart' as reorder_task_test;
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';

void main() {
  Future<void> _pumpTaskListWidget(WidgetTester tester, TaskManager taskManager) async {
    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));
  }

  Future<void> _pumpTaskListWidgetWithController(
      WidgetTester tester, TaskListController controller) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<TaskListController>.value(
        value: controller,
        child: MaterialApp(
          home: TaskListWidget.withController(),
        ),
      ),
    );
  }

  testWidgets('TaskListWidget displays tasks', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await _pumpTaskListWidget(tester, taskManager);

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });

  add_task_test.main();

  testWidgets('タスクを削除できる', (WidgetTester tester) async {
    final controller = TaskListController();
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await _pumpTaskListWidgetWithController(tester, controller);

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

  reorder_task_test.main();
}