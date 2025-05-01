import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';

void main() {
  late TaskListController controller;

  setUp(() {
    controller = TaskListController();
  });

  Future<void> _pumpTaskListWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: controller,
          child: TaskListWidget.withController(),
        ),
      ),
    );
  }

  testWidgets('タスクを完了にできる', (WidgetTester tester) async {
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await _pumpTaskListWidget(tester);

    // 初期状態でタスクが未完了であることを確認
    final task1Checkbox = find.byKey(ValueKey('checkbox-Task 1'));
    final task2Checkbox = find.byKey(ValueKey('checkbox-Task 2'));
    expect(tester.widget<Checkbox>(task1Checkbox).value, isFalse);
    expect(tester.widget<Checkbox>(task2Checkbox).value, isFalse);

    // Task 1を完了にする
    await tester.tap(task1Checkbox);
    await tester.pump();

    // Task 1が完了状態になっていることを確認
    expect(tester.widget<Checkbox>(task1Checkbox).value, isTrue);

    // Task 2は未完了のままであることを確認
    expect(tester.widget<Checkbox>(task2Checkbox).value, isFalse);
  });

  testWidgets('完了したタスクが視覚的に区別される', (WidgetTester tester) async {
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await _pumpTaskListWidget(tester);

    // Task 1を完了にする
    final task1Checkbox = find.byKey(ValueKey('checkbox-Task 1'));
    await tester.tap(task1Checkbox);
    await tester.pump();

    // 完了したタスクに取り消し線が表示されていることを確認
    final task1Text = find.text('Task 1');
    final textWidget = tester.widget<Text>(task1Text);
    expect(textWidget.style?.decoration, TextDecoration.lineThrough);
  });
}