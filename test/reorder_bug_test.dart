import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task_list_controller.dart';

void main() {
  group('TaskListController reorderTasks (H-2: 中間位置への下方向移動)', () {
    late TaskListController controller;

    setUp(() {
      controller = TaskListController();
    });

    test('中間位置から、末尾より手前の位置への下方向移動で正しい順序になる', () {
      controller.addTask('Task 1');
      controller.addTask('Task 2');
      controller.addTask('Task 3');
      controller.addTask('Task 4');

      // Task 2(index 1)を index 3 へ移動
      // ReorderableListViewの規約では、下方向移動時のnewIndexは
      // 「削除前」のインデックスで渡されるため、oldIndex(1) < newIndex(3)
      // の場合は挿入位置を1つ前に補正する必要がある。
      controller.reorderTasks(1, 3);

      final titles = controller.typedTasks.map((t) => t.title).toList();
      expect(titles, ['Task 1', 'Task 3', 'Task 2', 'Task 4']);
    });
  });
}
