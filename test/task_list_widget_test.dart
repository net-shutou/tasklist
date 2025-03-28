import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasklist/task_manager.dart';
import 'package:tasklist/task_list_widget.dart';

import 'task_list_widget_test.mocks.dart';

@GenerateMocks([TaskManager])
void main() {
  testWidgets('タスクリストが正しく表示される', (WidgetTester tester) async {
    // モックのTaskManagerを準備
    final mockTaskManager = MockTaskManager();
    when(mockTaskManager.getTasks()).thenReturn(['Task 1', 'Task 2', 'Task 3']);

    // テスト対象のウィジェットを作成
    await tester.pumpWidget(MaterialApp(
      home: TaskListWidget(taskManager: mockTaskManager),
    ));

    // タスクがリストに表示されていることを確認
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);
  });
}
