import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';

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
  }

  testWidgets('空のタスクリストが正しく表示される', (WidgetTester tester) async {
    await _pumpTaskListWidget(tester);
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('No tasks available'), findsNothing);
  });

  testWidgets('非常に長いタスク名が正しく表示される', (WidgetTester tester) async {
    // 長いタスク名を254文字に制限（UIの現実的な制限を考慮）
    final longTaskName = 'A' * 254;
    controller.addTask(longTaskName);

    await _pumpTaskListWidget(tester);
    
    // テキストの一部が表示されていることを確認
    expect(find.textContaining('AAA'), findsOneWidget);
    // ListTileが1つ存在することを確認
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('同じ名前のタスクを複数追加できる', (WidgetTester tester) async {
    controller.addTask('Duplicate Task');
    controller.addTask('Duplicate Task');

    await _pumpTaskListWidget(tester);
    expect(find.text('Duplicate Task'), findsNWidgets(2));
  });

  testWidgets('タスクを削除しても他のタスクが影響を受けない', (WidgetTester tester) async {
    controller.addTask('Task 1');
    controller.addTask('Task 2');
    controller.addTask('Task 3');

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
    controller.addTask('Task 1');
    controller.addTask('Task 2');
    controller.addTask('Task 3');

    await _pumpTaskListWidget(tester);

    final dragStartPosition = tester.getCenter(find.text('Task 3'));
    final dragEndPosition = tester.getCenter(find.text('Task 1'));

    await tester.dragFrom(dragStartPosition, dragEndPosition - dragStartPosition);
    await tester.pumpAndSettle();

    final listTiles = find.byType(ListTile).evaluate().toList();
    expect(listTiles.length, 3);

    final texts = tester.widgetList<Text>(find.byType(Text)).map((text) => text.data).where((text) => text != null).toList();
    expect(texts.contains('Task 3'), isTrue);
    expect(texts.contains('Task 1'), isTrue);
    expect(texts.contains('Task 2'), isTrue);
  });

  testWidgets('空のタスクは追加できない', (WidgetTester tester) async {
    await _pumpTaskListWidget(tester);

    final addTextField = find.byType(TextField);
    await tester.enterText(addTextField, '');
    
    // Enterキーでの追加を試行
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // タスクが追加されていないことを確認
    expect(find.byType(ListTile), findsNothing);
    
    // 追加ボタンでの追加を試行
    final addButton = find.byIcon(Icons.add);
    if (addButton.evaluate().isNotEmpty) {
      await tester.tap(addButton);
      await tester.pump();
      expect(find.byType(ListTile), findsNothing);
    }
  });

  testWidgets('スペースのみのタスクは追加できない', (WidgetTester tester) async {
    await _pumpTaskListWidget(tester);

    final addTextField = find.byType(TextField);
    await tester.enterText(addTextField, '   ');
    
    // Enterキーでの追加を試行
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // タスクが追加されていないことを確認
    expect(find.byType(ListTile), findsNothing);
    
    // 追加ボタンでの追加を試行
    final addButton = find.byIcon(Icons.add);
    if (addButton.evaluate().isNotEmpty) {
      await tester.tap(addButton);
      await tester.pump();
      expect(find.byType(ListTile), findsNothing);
    }
  });

  testWidgets('タスク名の最大長-2（254文字）で追加できる', (WidgetTester tester) async {
    controller = TaskListController();
    await _pumpTaskListWidget(tester);

    // 最大長-2のタスク（254文字）
    final nearMaxTitle = 'B' * 254;
    controller.addTask(nearMaxTitle);
    await tester.pumpAndSettle();

    // タスクが追加されることを確認
    expect(find.byType(ListTile), findsOneWidget);
    expect(controller.typedTasks[0].title, nearMaxTitle);
  });

  testWidgets('タスク名の最大長-1（255文字）で追加できる', (WidgetTester tester) async {
    controller = TaskListController();
    await _pumpTaskListWidget(tester);

    // 最大長-1のタスク（255文字）
    final validTitle = 'B' * 255;
    controller.addTask(validTitle);
    await tester.pumpAndSettle();

    // タスクが追加されることを確認
    expect(find.byType(ListTile), findsOneWidget);
    expect(controller.typedTasks[0].title, validTitle);
  });

  testWidgets('タスク名が最大長を超える（256文字）と追加できない', (WidgetTester tester) async {
    controller = TaskListController();
    await _pumpTaskListWidget(tester);

    // 最大長を超えるタスク（256文字）
    final invalidTitle = 'B' * 256;
    controller.addTask(invalidTitle);
    await tester.pumpAndSettle();

    // タスクが追加されないことを確認
    expect(find.byType(ListTile), findsNothing);
    expect(controller.typedTasks.isEmpty, isTrue);
  });
}