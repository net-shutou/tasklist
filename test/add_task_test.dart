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
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('タスクを追加できる', (WidgetTester tester) async {
    await _pumpTaskListWidget(tester);

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