import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task.dart';
import 'package:tasklist/task_item_builder.dart';
import 'package:tasklist/task_item.dart';

void main() {
  testWidgets('buildTaskItemが正しくTaskItemを生成する', (WidgetTester tester) async {
    // テスト用のデータ
    final tasks = [
      const Task(id: '1', title: 'Task 1', isCompleted: false),
      const Task(id: '2', title: 'Task 2', isCompleted: true),
    ];
    final editController = TextEditingController();
    String? editingTaskId;
    bool onEditCalled = false;
    bool onUpdateTaskCalled = false;
    bool onToggleCompletionCalled = false;
    bool onDeleteTaskCalled = false;

    // buildTaskItemを使用してTaskItemを生成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildTaskItem(
            tasks: tasks,
            index: 0,
            editController: editController,
            editingTaskId: editingTaskId,
            onEdit: (index) {
              onEditCalled = true;
            },
            onUpdateTask: (index, newTitle) {
              onUpdateTaskCalled = true;
            },
            onToggleCompletion: (index) {
              onToggleCompletionCalled = true;
            },
            onDeleteTask: (index) {
              onDeleteTaskCalled = true;
            },
          ),
        ),
      ),
    );

    // TaskItemが正しく生成されていることを確認
    final taskItemFinder = find.byType(TaskItem);
    expect(taskItemFinder, findsOneWidget);

    // TaskItemの内容を確認
    final taskTitleFinder = find.text('Task 1');
    expect(taskTitleFinder, findsOneWidget);

    // onEditが呼び出されることを確認
    final taskItem = tester.widget<TaskItem>(taskItemFinder);
    taskItem.onEdit();
    expect(onEditCalled, isTrue);

    // onUpdateTaskが呼び出されることを確認
    taskItem.onUpdateTask('Updated Task');
    expect(onUpdateTaskCalled, isTrue);

    // onToggleCompletionが呼び出されることを確認
    taskItem.onToggleCompletion();
    expect(onToggleCompletionCalled, isTrue);

    // onDeleteTaskが呼び出されることを確認
    taskItem.onDeleteTask();
    expect(onDeleteTaskCalled, isTrue);
  });
}