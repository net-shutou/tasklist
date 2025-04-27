import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';  // 追加: 定数のimport

class TaskListRobot {
  final WidgetTester tester;
  TestGesture? _currentDragGesture;

  TaskListRobot(this.tester);

  Future<void> enterTask(String text) async {
    await tester.enterText(find.byType(TextField), text);
  }

  Future<void> tapAddButton() async {
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();
  }

  Future<void> expectTaskVisible(String text, {int? count}) async {
    final listTileText = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.text(text),
    );
    if (count != null) {
      expect(listTileText, findsNWidgets(count));
    } else {
      expect(listTileText, findsWidgets);
    }
  }

  Future<void> tapDeleteIcon(int index) async {
    await tester.tap(find.byIcon(Icons.delete).at(index));
    await tester.pump();
  }

  Future<void> reorderTaskByIndex(int fromIndex, Offset offset) async {
    // ドラッグハンドルを見つける
    final dragHandleFinder = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.byType(ReorderableDragStartListener),
    ).at(fromIndex);

    // まずドラッグ先の位置を計算
    final targetFinder = find.byType(ListTile).at(1); // 2番目の位置へ
    final targetLocation = tester.getCenter(targetFinder);

    // 正確なドラッグ操作
    final startLocation = tester.getCenter(dragHandleFinder);
    final dragOffset = Offset(0, targetLocation.dy - startLocation.dy);

    // ドラッグ操作を実行
    await tester.longPress(dragHandleFinder);
    await tester.pumpAndSettle();
    await tester.drag(dragHandleFinder, dragOffset);
    await tester.pumpAndSettle();
  }

  Future<void> expectTaskVisibleInList(String text) async {
    final listTileText = find.descendant(
      of: find.byType(ListView),
      matching: find.text(text),
    );
    expect(listTileText, findsWidgets);
  }

  Future<void> expectTaskNotVisible(String text) async {
    // --- 追加 ---
    // アサーションの前にUIが安定するまで待機します。
    await tester.pumpAndSettle();
    // --- 追加終わり ---

    final listTiles = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.byType(ListTile),
    );
    bool found = false;
    // evaluate() を使うと要素の数を取得できるので、ループの条件式を簡潔にできます。
    final evaluatedListTiles = listTiles.evaluate();
    for (var i = 0; i < evaluatedListTiles.length; i++) {
      // at(i) ではなく、取得済みの要素を使用します。
      final tileElement = evaluatedListTiles.elementAt(i);
      // find.descendant の `of` には Finder ではなく Element を渡すこともできます。
      final textFinder = find.descendant(of: find.byElementPredicate((element) => element == tileElement), matching: find.text(text));
      // TextFieldではなくTextのみをカウント
      final textWidgets = textFinder.evaluate().where((e) => e.widget is Text).toList();
      if (textWidgets.isNotEmpty) {
        found = true;
        break;
      }
    }
    expect(found, isFalse, reason: 'ListTile内に"$text"が残っています');
  }

  /// タスクを指定位置に並び替える
  /// @param fromIndex 移動元のインデックス
  /// @param toIndex 移動先のインデックス
  Future<void> reorderTask(int fromIndex, int toIndex) async {
    // ドラッグハンドルを見つける
    final dragHandleFinder = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.byType(ReorderableDragStartListener),
    ).at(fromIndex);

    // 移動先のListTileを見つける
    final targetFinder = find.byType(ListTile).at(toIndex);

    // ドラッグの方向と距離を計算
    final startLocation = tester.getCenter(dragHandleFinder);
    final targetLocation = tester.getCenter(targetFinder);
    final dragOffset = Offset(0, targetLocation.dy - startLocation.dy);

    // ドラッグ操作を実行
    await tester.longPress(dragHandleFinder);
    await tester.pumpAndSettle();
    await tester.drag(dragHandleFinder, dragOffset);
    await tester.pumpAndSettle();
  }

  /// タスクの順序を検証
  Future<void> expectTaskOrder(List<String> expectedTasks) async {
    await tester.pumpAndSettle();

    final listTiles = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.byType(ListTile),
    );

    final actualTasks = [];
    for (var i = 0; i < expectedTasks.length; i++) {
      final tile = listTiles.at(i);
      final text = find.descendant(
        of: tile,
        matching: find.byType(Text),
      ).first;
      actualTasks.add(tester.widget<Text>(text).data);
    }

    expect(actualTasks, expectedTasks);
  }

  /// ドラッグ開始のみ実行
  Future<void> startReorderDrag(int fromIndex) async {
    final dragHandleFinder = find.descendant(
      of: find.byType(ReorderableListView),
      matching: find.byType(ReorderableDragStartListener),
    ).at(fromIndex);

    // ドラッグハンドルを長押し
    _currentDragGesture = await tester.startGesture(tester.getCenter(dragHandleFinder));
    await tester.pump(kLongPressTimeout + kPressTimeout);  // 定数を使用
    await tester.pumpAndSettle();
  }

  Offset? _dragStartLocation;

  /// ドラッグをキャンセル
  Future<void> cancelReorderDrag() async {
    if (_currentDragGesture == null) return;

    // ドラッグを中断（小さな移動で終了）
    await _currentDragGesture!.moveBy(const Offset(0, 5.0));
    await _currentDragGesture!.up();
    await tester.pumpAndSettle();

    // 編集モードから抜けるため、空の領域をタップ
    final scaffold = find.byType(Scaffold);
    if (scaffold.evaluate().isNotEmpty) {
      final scaffoldRect = tester.getRect(scaffold);
      await tester.tapAt(Offset(
        scaffoldRect.left + 10,  // 左端から少し右
        scaffoldRect.top + 10,   // 上端から少し下
      ));
      await tester.pumpAndSettle();
    }

    _currentDragGesture = null;
  }

  /// タスクを編集
  Future<void> editTask(int index, String newText) async {
    await tester.tap(find.byType(ListTile).at(index));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, newText);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }
}