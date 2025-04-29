import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasklist/task_manager.dart';
import 'package:tasklist/task_list_widget.dart';
import 'package:tasklist/task_list_controller.dart';

import 'task_list_widget_test.mocks.dart';

@GenerateMocks([TaskListController, TaskManager]) // TaskManagerを追加
void main() {
  testWidgets('タスクリストが正しく表示される', (WidgetTester tester) async {
    // モックのTaskManagerを準備
    final mockTaskManager = MockTaskManager();
    when(mockTaskManager.getTasks()).thenReturn([
      {'title': 'Task 1', 'isCompleted': false},
      {'title': 'Task 2', 'isCompleted': true},
      {'title': 'Task 3', 'isCompleted': false},
    ]);

    // テスト対象のウィジェットを作成
    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: mockTaskManager),
    ));
    await tester.pumpAndSettle(); // ウィジェットツリーの構築を待つ

    // タスクがリストに表示されていることを確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);

    // 完了状態が正しく反映されていることを確認
    final task2Checkbox = find.byKey(ValueKey('checkbox-Task 2'));
    expect(tester.widget<Checkbox>(task2Checkbox).value, true);
  });
}
