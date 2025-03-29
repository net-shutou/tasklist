import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_manager.dart';
import 'package:tasklist/task_list_widget.dart';

void main() {
  late TaskManager taskManager;

  setUp(() {
    taskManager = TaskManager();
  });

  Future<void> _pumpTaskListWidget(WidgetTester tester, TaskManager taskManager) async {
    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));
  }

  testWidgets('タスクを選択しても追加用テキストボックスに影響しない', (WidgetTester tester) async {
    final taskManager = TaskManager();
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');

    await _pumpTaskListWidget(tester, taskManager);

    // 初期状態で追加用テキストボックスが空であることを確認
    final addTextField = find.widgetWithText(TextField, 'Enter a task');
    expect(addTextField, findsOneWidget);
    expect(tester.widget<TextField>(addTextField).controller?.text, isEmpty);

    // タスクをタップして編集モードにする
    await tester.tap(find.text('Task 1'));
    await tester.pump();

    // 追加用テキストボックスが空のままであることを確認
    expect(tester.widget<TextField>(addTextField).controller?.text, isEmpty);
  });
}