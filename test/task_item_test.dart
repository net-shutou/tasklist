import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task.dart';
import 'package:tasklist/task_item.dart';

void main() {
  testWidgets('フォーカスを失ったときにタスクが確定される', (WidgetTester tester) async {
    // テスト用のデータ
    final task = const Task(id: '1', title: 'Initial Task', isCompleted: false);
    final editController = TextEditingController();
    String updatedTitle = '';

    // TaskItemウィジェットを作成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskItem(
            key: ValueKey('task-item'),
            index: 0,
            task: task,
            isEditing: true,
            editController: editController,
            onEdit: () {},
            onUpdateTask: (newTitle) {
              updatedTitle = newTitle; // タスクのタイトルを更新
            },
            onToggleCompletion: () {},
            onDeleteTask: () {},
          ),
        ),
      ),
    );

    // TextFieldにフォーカスを設定
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    await tester.tap(textFieldFinder);
    await tester.pumpAndSettle();

    // TextFieldに新しいタイトルを入力
    await tester.enterText(textFieldFinder, 'Updated Task');
    expect(editController.text, 'Updated Task');

    // フォーカスを外す
    FocusScope.of(tester.element(textFieldFinder)).unfocus();
    await tester.pumpAndSettle();

    // タスクが確定されていることを確認
    expect(updatedTitle, 'Updated Task');
  });

  testWidgets('1文字ずつ確定されないことを確認する', (WidgetTester tester) async {
    // テスト用のデータ
    final task = const Task(id: '1', title: 'Initial Task', isCompleted: false);
    final editController = TextEditingController();
    int updateCallCount = 0;

    // TaskItemウィジェットを作成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskItem(
            key: ValueKey('task-item'),
            index: 0,
            task: task,
            isEditing: true,
            editController: editController,
            onEdit: () {},
            onUpdateTask: (newTitle) {
              updateCallCount++; // onUpdateTaskが呼び出された回数をカウント
            },
            onToggleCompletion: () {},
            onDeleteTask: () {},
          ),
        ),
      ),
    );

    // TextFieldにフォーカスを設定
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    await tester.tap(textFieldFinder);
    await tester.pumpAndSettle();

    // TextFieldに1文字ずつ入力
    await tester.enterText(textFieldFinder, 'A');
    await tester.pumpAndSettle();
    await tester.enterText(textFieldFinder, 'AB');
    await tester.pumpAndSettle();
    await tester.enterText(textFieldFinder, 'ABC');
    await tester.pumpAndSettle();

    // onUpdateTaskが1回も呼び出されていないことを確認
    expect(updateCallCount, 0);

    // フォーカスを外す
    FocusScope.of(tester.element(textFieldFinder)).unfocus();
    await tester.pumpAndSettle();

    // フォーカスを外した後にonUpdateTaskが1回だけ呼び出されることを確認
    expect(updateCallCount, 1);
  });
}