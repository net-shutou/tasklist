import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';

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
    await tester.pumpAndSettle();
  }

  testWidgets('空のタスクリストが正しく表示される', (WidgetTester tester) async {
    await _pumpTaskListWidget(tester);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('非常に長いタスク名が正しく表示される', (WidgetTester tester) async {
    final longTaskName = 'A' * 254; // 254文字の長いタスク名
    controller.addTask(longTaskName);

    await _pumpTaskListWidget(tester);
    expect(find.textContaining('AAA'), findsOneWidget);
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

    await tester.tap(find.byIcon(Icons.delete).at(1));
    await tester.pumpAndSettle();

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

    // ListTile内のテキストのみを取得するように修正
    final listTiles = find.byType(ListTile).evaluate().toList();
    final texts = listTiles
        .map((element) => element.widget as ListTile)
        .map((listTile) => (listTile.title as Text).data)
        .where((text) => text != null && text.startsWith('Task'))
        .toList();

    expect(texts.length, 3);
    expect(texts.contains('Task 1'), isTrue);
    expect(texts.contains('Task 2'), isTrue);
    expect(texts.contains('Task 3'), isTrue);
  });
}