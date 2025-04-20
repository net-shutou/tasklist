import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_manager.dart';
import 'package:tasklist/task_list_widget.dart';

void main() {
  late TaskManager taskManager;

  setUp(() {
    taskManager = TaskManager();
  });

  Future<void> _pumpTaskListWidget(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: taskManager),
    ));
  }

  testWidgets('空のタスクリストが正しく表示される', (WidgetTester tester) async {
    await _pumpTaskListWidget(tester);

    // タスクリストが空であることを確認
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('No tasks available'), findsNothing); // 必要なら空リスト用のメッセージを追加
  });

  testWidgets('非常に長いタスク名が正しく表示される', (WidgetTester tester) async {
    final longTaskName = 'A' * 1000; // 1000文字の長いタスク名
    taskManager.addTask(longTaskName);

    await _pumpTaskListWidget(tester);

    // 長いタスク名が正しく表示されていることを確認
    expect(find.text(longTaskName), findsOneWidget);
  });

  testWidgets('同じ名前のタスクを複数追加できる', (WidgetTester tester) async {
    taskManager.addTask('Duplicate Task');
    taskManager.addTask('Duplicate Task');

    await _pumpTaskListWidget(tester);

    // 同じ名前のタスクが複数表示されていることを確認
    expect(find.text('Duplicate Task'), findsNWidgets(2));
  });

  testWidgets('タスクを削除しても他のタスクが影響を受けない', (WidgetTester tester) async {
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');
    taskManager.addTask('Task 3');

    await _pumpTaskListWidget(tester);

    // Task 2を削除
    await tester.tap(find.byIcon(Icons.delete).at(1));
    await tester.pump();

    // Task 2が削除され、他のタスクが影響を受けていないことを確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsNothing);
    expect(find.text('Task 3'), findsOneWidget);
  });

  testWidgets('タスクを並び替えた後も正しい順序で表示される', (WidgetTester tester) async {
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');
    taskManager.addTask('Task 3');

    await _pumpTaskListWidget(tester);

    // Task 3をTask 1の位置にドラッグ
    final dragIconFinder = find.descendant(
      of: find.byKey(ValueKey('2-Task 3')),
      matching: find.byType(ReorderableDragStartListener),
    );
    final task1Finder = find.byKey(ValueKey('0-Task 1'));
    final task1Offset = tester.getCenter(task1Finder);
    final dragIconOffset = tester.getCenter(dragIconFinder);
    final dragOffset = Offset(0, task1Offset.dy - dragIconOffset.dy);

    await tester.drag(dragIconFinder, dragOffset);
    await tester.pumpAndSettle();

    // 並び替え後の順序を確認
    final taskList = taskManager.getTasks();
    expect(taskList, ['Task 3', 'Task 1', 'Task 2']);
  });
}