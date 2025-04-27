import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/main.dart';
import 'robot/tasklist_robot.dart';

void main() {
  Future<void> _pumpApp(WidgetTester tester, {required bool useController}) async {
    await tester.pumpWidget(MyApp(useController: useController));
    await tester.pumpAndSettle(); // アプリ起動後の初期化を待つ
  }

  Future<void> expectTaskNotVisible(String text) async {
    final listTiles = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.byType(ListTile),
    );
    bool found = false;
    for (final tile in listTiles.evaluate()) {
      final textWidgets = find.descendant(
        of: find.byWidget(tile.widget),
        matching: find.text(text),
      ).evaluate().where((e) => e.widget is Text);
      if (textWidgets.isNotEmpty) {
        found = true;
        break;
      }
    }
    expect(found, isFalse, reason: 'ListTile内に"$text"が残っています');
  }

  group('TaskListWidget Robot Test', () {
    for (final useController in [false, true]) {
      testWidgets('タスク追加・削除ができる (useController=$useController)', (tester) async {
        await _pumpApp(tester, useController: useController);
        final robot = TaskListRobot(tester);

        await robot.enterTask('New Task');
        await robot.tapAddButton();
        await tester.pumpAndSettle();
        await robot.expectTaskVisible('New Task');

        await robot.tapDeleteIcon(0);
        await tester.pumpAndSettle();
        await robot.expectTaskNotVisible('New Task');
      });

      testWidgets('タスクを並び替えできる (useController=$useController)', (tester) async {
        await _pumpApp(tester, useController: useController);
        final robot = TaskListRobot(tester);

        // タスク追加
        await robot.enterTask('Task 1');
        await robot.tapAddButton();
        await robot.enterTask('Task 2');
        await robot.tapAddButton();
        await robot.enterTask('Task 3');
        await robot.tapAddButton();

        // 並び替え前の確認
        await robot.expectTaskOrder(['Task 1', 'Task 2', 'Task 3']);

        // Task 1を3番目に移動
        await robot.reorderTask(0, 2);

        // 並び替え後の確認
        await robot.expectTaskOrder(['Task 2', 'Task 3', 'Task 1']);
      });

      testWidgets('タスクの並び替えの様々なパターン (useController=$useController)', (tester) async {
        await _pumpApp(tester, useController: useController);
        final robot = TaskListRobot(tester);

        // タスク追加
        for (var i = 1; i <= 5; i++) {
          await robot.enterTask('Task $i');
          await robot.tapAddButton();
        }

        // 初期状態確認
        await robot.expectTaskOrder(['Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5']);

        // ケース1: 隣接するタスクの入れ替え（上から下）
        await robot.reorderTask(0, 1);
        await robot.expectTaskOrder(['Task 2', 'Task 1', 'Task 3', 'Task 4', 'Task 5']);

        // ケース2: 隣接するタスクの入れ替え（下から上）
        await robot.reorderTask(4, 3);
        await robot.expectTaskOrder(['Task 2', 'Task 1', 'Task 3', 'Task 5', 'Task 4']);

        // ケース3: 離れたタスクの入れ替え（上から下）
        await robot.reorderTask(0, 4);
        await robot.expectTaskOrder(['Task 1', 'Task 3', 'Task 5', 'Task 4', 'Task 2']);

        // ケース4: 離れたタスクの入れ替え（下から上）
        await robot.reorderTask(4, 0);
        await robot.expectTaskOrder(['Task 2', 'Task 1', 'Task 3', 'Task 5', 'Task 4']);

        // ケース5: 中央のタスクを端に移動
        await robot.reorderTask(2, 0);
        await robot.expectTaskOrder(['Task 3', 'Task 2', 'Task 1', 'Task 5', 'Task 4']);
      });

      testWidgets('タスクの並び替え後に他の操作が正しく動作する (useController=$useController)', (tester) async {
        await _pumpApp(tester, useController: useController);
        final robot = TaskListRobot(tester);

        // タスク追加
        for (var i = 1; i <= 3; i++) {
          await robot.enterTask('Task $i');
          await robot.tapAddButton();
        }

        // 並び替え
        await robot.reorderTask(0, 2);
        await robot.expectTaskOrder(['Task 2', 'Task 3', 'Task 1']);

        // 並び替え後にタスクを追加
        await robot.enterTask('Task 4');
        await robot.tapAddButton();
        await robot.expectTaskOrder(['Task 2', 'Task 3', 'Task 1', 'Task 4']);

        // 並び替え後にタスクを削除
        await robot.tapDeleteIcon(1);
        await robot.expectTaskOrder(['Task 2', 'Task 1', 'Task 4']);

        // 並び替え後にタスクを編集
        await robot.editTask(0, 'Updated Task 2');
        await robot.expectTaskOrder(['Updated Task 2', 'Task 1', 'Task 4']);
      });

      testWidgets('タスクの並び替えをキャンセルできる (useController=$useController)', (tester) async {
        await _pumpApp(tester, useController: useController);
        final robot = TaskListRobot(tester);

        // タスク追加
        for (var i = 1; i <= 3; i++) {
          await robot.enterTask('Task $i');
          await robot.tapAddButton();
          await tester.pumpAndSettle();  // 各タスク追加後に待機
        }

        // 並び替え前の状態を確認
        final originalOrder = ['Task 1', 'Task 2', 'Task 3'];
        await robot.expectTaskOrder(originalOrder);

        // ドラッグを開始して中断
        await robot.startReorderDrag(0);
        await tester.pump();  // ドラッグ開始後の状態更新を待機
        await robot.cancelReorderDrag();
        await tester.pumpAndSettle();  // キャンセル後の状態が安定するまで待機

        // 元の順序が維持されていることを確認
        await robot.expectTaskOrder(originalOrder);
      });
    }
  });
}
