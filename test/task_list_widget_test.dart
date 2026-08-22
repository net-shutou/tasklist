import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';

import 'task_list_widget_test.mocks.dart';

@GenerateMocks([TaskListController])
void main() {
  late MockTaskListController mockController;
  final listeners = <VoidCallback>[];
  int? currentEditingIndex;

  setUp(() {
    mockController = MockTaskListController();
    listeners.clear();
    currentEditingIndex = null;

    // ChangeNotifierProviderが登録するリスナーを実際に保持し、
    // startEdit/stopEditingの呼び出し時に発火させることで、
    // editingIndexの変化に応じた再描画をシミュレートする
    when(mockController.addListener(any)).thenAnswer((invocation) {
      listeners.add(invocation.positionalArguments[0] as VoidCallback);
    });
    when(mockController.removeListener(any)).thenAnswer((invocation) {
      listeners.remove(invocation.positionalArguments[0] as VoidCallback);
    });
    when(mockController.editingIndex).thenAnswer((_) => currentEditingIndex);
    when(mockController.startEdit(any)).thenAnswer((invocation) {
      currentEditingIndex = invocation.positionalArguments[0] as int;
      for (final listener in List.of(listeners)) {
        listener();
      }
    });
    when(mockController.stopEditing()).thenAnswer((_) {
      currentEditingIndex = null;
      for (final listener in List.of(listeners)) {
        listener();
      }
    });
  });

  // 基本的な表示のテスト
  testWidgets('タスクリストが正しく表示される', (WidgetTester tester) async {
    when(mockController.typedTasks).thenReturn([
      const Task(id: '1', title: 'Task 1', isCompleted: false),
      const Task(id: '2', title: 'Task 2', isCompleted: true),
      const Task(id: '3', title: 'Task 3', isCompleted: false),
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

    final task2Checkbox = find.byType(Checkbox).at(1);
    expect(tester.widget<Checkbox>(task2Checkbox).value, true);
  });

  // Create操作のテスト
  testWidgets('新しいタスクを追加できる', (WidgetTester tester) async {
    when(mockController.typedTasks).thenReturn([]);

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
    when(mockController.typedTasks).thenAnswer((_) => [
      const Task(id: '1', title: 'Task 1', isCompleted: false),
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
    when(mockController.typedTasks).thenReturn([
      const Task(id: '1', title: 'Task 1', isCompleted: false),
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
    when(mockController.typedTasks).thenReturn([]);

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
    when(mockController.typedTasks).thenReturn([
      const Task(id: '1', title: 'Task 1', isCompleted: false),
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
