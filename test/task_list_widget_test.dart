import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';

import 'task_list_widget_test.mocks.dart';

@GenerateMocks([TaskListController])
void main() {
  late MockTaskListController mockController;

  setUp(() {
    mockController = MockTaskListController();
    // TaskInputの initState() で addListener() / removeListener() が呼ばれるため、モック化する
    when(mockController.addListener(any)).thenReturn(null);
    when(mockController.removeListener(any)).thenReturn(null);
  });

  // 基本的な表示のテスト
  testWidgets('タスクリストが正しく表示される', (WidgetTester tester) async {
    when(mockController.tasks).thenReturn([
      {'title': 'Task 1', 'isCompleted': false},
      {'title': 'Task 2', 'isCompleted': true},
      {'title': 'Task 3', 'isCompleted': false},
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: mockController,
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);

    final task2Checkbox = find.byKey(ValueKey('checkbox-Task 2'));
    expect(tester.widget<Checkbox>(task2Checkbox).value, true);
  });

  // Create操作のテスト
  testWidgets('新しいタスクを追加できる', (WidgetTester tester) async {
    when(mockController.tasks).thenReturn([]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: mockController,
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.pumpAndSettle(); // UIが更新されるまで待機
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(mockController.addTask('New Task')).called(1);
  });

  // Update操作のテスト
  testWidgets('タスクを編集できる', (WidgetTester tester) async {
    when(mockController.tasks).thenAnswer((_) => [
      {'title': 'Task 1', 'isCompleted': false},
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: mockController,
          child: const TaskListWidget(),
        ),
      ),
    );

    expect(find.text('Task 1'), findsOneWidget);

    // 編集モードに入る
    await tester.tap(find.text('Task 1'));
    await tester.pumpAndSettle();

    // 編集用TextFieldを特定して入力
    final editTextField = find.descendant(
      of: find.byType(ListTile).first,
      matching: find.byType(TextField),
    );
    await tester.enterText(editTextField, 'Updated Task');
    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // 1回以上呼ばれていればOKとする
    verify(mockController.updateTask(0, 'Updated Task')).called(greaterThanOrEqualTo(1));
  });

  // Delete操作のテスト
  testWidgets('タスクを削除できる', (WidgetTester tester) async {
    when(mockController.tasks).thenReturn([
      {'title': 'Task 1', 'isCompleted': false},
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: mockController,
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    verify(mockController.deleteTask(0)).called(1);
  });

  // バリデーションテスト：空のテキストではタスクが追加されない
  testWidgets('空のテキストではタスクが追加されない', (WidgetTester tester) async {
    when(mockController.tasks).thenReturn([]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: mockController,
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 空のテキストでボタンをタップ
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // addTaskが呼ばれていないことを確認
    verifyNever(mockController.addTask(any));
  });

  // 完了状態の切り替えテスト
  testWidgets('タスクの完了状態を切り替えできる', (WidgetTester tester) async {
    when(mockController.tasks).thenReturn([
      {'title': 'Task 1', 'isCompleted': false},
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: mockController,
          child: const TaskListWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    verify(mockController.toggleTaskCompletion(0)).called(1);
  });
}
