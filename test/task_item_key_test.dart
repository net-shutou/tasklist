import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';

import 'robot/tasklist_robot.dart';

void main() {
  late TaskListController controller;

  setUp(() {
    controller = TaskListController();
  });

  Future<void> pumpTaskListWidget(WidgetTester tester) async {
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

  testWidgets(
    'task.idに基づく安定したキーにより、並び替えでインデックスが変わっても同一のTaskItem要素が再利用される(M-4)',
    (tester) async {
      controller.addTask('Task A');
      controller.addTask('Task B');
      controller.addTask('Task C');

      await pumpTaskListWidget(tester);

      final robot = TaskListRobot(tester);

      final elementBefore = tester.element(find.text('Task A'));

      // Task Aとは別のタスク(Task C)を先頭へ移動し、
      // Task Aの表示位置(インデックス)をずらす
      await robot.reorderTask(2, 0);

      final elementAfter = tester.element(find.text('Task A'));

      expect(
        identical(elementBefore, elementAfter),
        isTrue,
        reason:
            'task.idに基づく安定したキーであれば、位置が変わってもTask Aの要素は再利用されるはず。'
            'indexを含む不安定なキーだと、並び替えのたびに要素が破棄・再生成される。',
      );
    },
  );
}
