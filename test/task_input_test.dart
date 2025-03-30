import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_input.dart';

void main() {
  testWidgets('TaskInputウィジェットが正しく表示される', (WidgetTester tester) async {
    // テスト用のコントローラーとコールバック
    final controller = TextEditingController();
    bool addTaskCalled = false;

    // TaskInputウィジェットを作成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskInput(
            controller: controller,
            onAddTask: () {
              addTaskCalled = true;
            },
          ),
        ),
      ),
    );

    // TextFieldが表示されていることを確認
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // ボタンが表示されていることを確認
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    // ボタンのテキストが「Add」であることを確認
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('タスク追加ボタンが押されたときにコールバックが呼び出される', (WidgetTester tester) async {
    // テスト用のコントローラーとコールバック
    final controller = TextEditingController();
    bool addTaskCalled = false;

    // TaskInputウィジェットを作成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskInput(
            controller: controller,
            onAddTask: () {
              addTaskCalled = true;
            },
          ),
        ),
      ),
    );

    // ボタンをタップ
    final buttonFinder = find.byType(ElevatedButton);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // コールバックが呼び出されたことを確認
    expect(addTaskCalled, isTrue);
  });

  testWidgets('TextFieldに入力したテキストがコントローラーに反映される', (WidgetTester tester) async {
    // テスト用のコントローラー
    final controller = TextEditingController();

    // TaskInputウィジェットを作成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskInput(
            controller: controller,
            onAddTask: () {},
          ),
        ),
      ),
    );

    // TextFieldにテキストを入力
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'New Task');
    await tester.pumpAndSettle();

    // コントローラーに入力内容が反映されていることを確認
    expect(controller.text, 'New Task');
  });
}