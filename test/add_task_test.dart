import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';
import 'test_helpers.dart';

void main() {
  late TaskListController controller;

  setUp(() {
    controller = TaskListController();
  });

  testWidgets('タスクを追加できる', (WidgetTester tester) async {
    await tester.pumpTaskListWidget(controller, settle: true);

    // 初期状態でタスクが存在しないことを確認
    expect(find.text('New Task'), findsNothing);

    // タスクを追加
    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // タスクが追加されたことを確認
    expect(find.text('New Task'), findsOneWidget);
  });
}