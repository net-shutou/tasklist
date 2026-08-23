import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';
import 'test_helpers.dart';

void main() {
  late TaskListController controller;

  setUp(() {
    controller = TaskListController();
  });

  testWidgets('タスクを選択しても追加用テキストボックスに影響しない', (WidgetTester tester) async {
    // TaskListControllerを使ってタスクを追加
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await tester.pumpTaskListWidget(controller);

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