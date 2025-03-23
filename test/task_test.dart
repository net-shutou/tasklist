// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('タスクを追加できる', () {
    final tasks = <String>[];

    // タスクを追加
    tasks.add('新しいタスク');

    // 期待する結果
    expect(tasks.length, 1);
    expect(tasks.first, '新しいタスク');
  });
}

