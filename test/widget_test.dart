import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';
import 'add_task_test.dart' as add_task_test;
import 'reorder_task_test.dart' as reorder_task_test;

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
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('TaskListWidget displays tasks', (WidgetTester tester) async {
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await _pumpTaskListWidget(tester);

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });

  testWidgets('タスクを削除できる', (WidgetTester tester) async {
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await _pumpTaskListWidget(tester);

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
    controller.addTask('Task 1');
    controller.addTask('Task 2');

    await _pumpTaskListWidget(tester);

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
}