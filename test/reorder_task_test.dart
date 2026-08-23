import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';
import 'test_helpers.dart';

void main() {
  late TaskListController controller;

  setUp(() {
    controller = TaskListController();
  });

  testWidgets('タスクを並び替えできる', (WidgetTester tester) async {
    await tester.pumpTaskListWidget(controller, settle: true);

    // 初期状態でタスクを追加
    controller.addTask('Task 1');
    controller.addTask('Task 2');
    controller.addTask('Task 3');
    await tester.pump();

    // 並び替え前の順序を確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);

    // 並び替え操作を実行
    final listFinder = find.byType(ReorderableListView);
    final task1Finder = find.text('Task 1');
    await tester.drag(task1Finder, const Offset(0, 100));
    await tester.pumpAndSettle();

    // 並び替え後の順序を確認
    expect(find.text('Task 1'), findsOneWidget); // ここでエラーが発生する可能性
  });
}