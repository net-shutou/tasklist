import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/task.dart';

void main() {
  group('Task', () {
    test('コンストラクタで id/title/isCompleted が正しく設定される', () {
      const task = Task(id: '1', title: 'タスク1', isCompleted: true);

      expect(task.id, '1');
      expect(task.title, 'タスク1');
      expect(task.isCompleted, true);
    });

    test('isCompleted のデフォルトは false', () {
      const task = Task(id: '1', title: 'タスク1');

      expect(task.isCompleted, false);
    });

    test('copyWith で title のみ変更できる(id・isCompletedは維持される)', () {
      const original = Task(id: '1', title: '元のタイトル', isCompleted: true);

      final updated = original.copyWith(title: '新しいタイトル');

      expect(updated.id, '1');
      expect(updated.title, '新しいタイトル');
      expect(updated.isCompleted, true);
    });

    test('copyWith で isCompleted のみ変更できる', () {
      const original = Task(id: '1', title: 'タスク1', isCompleted: false);

      final updated = original.copyWith(isCompleted: true);

      expect(updated.id, '1');
      expect(updated.title, 'タスク1');
      expect(updated.isCompleted, true);
    });

    test('同一の id/title/isCompleted を持つ2つの Task は == で等しい', () {
      const a = Task(id: '1', title: 'タスク1', isCompleted: false);
      const b = Task(id: '1', title: 'タスク1', isCompleted: false);

      expect(a, equals(b));
    });

    test('id が異なれば != となる', () {
      const a = Task(id: '1', title: 'タスク1', isCompleted: false);
      const b = Task(id: '2', title: 'タスク1', isCompleted: false);

      expect(a == b, false);
    });

    test('== が等しい2つの Task は hashCode も等しい', () {
      const a = Task(id: '1', title: 'タスク1', isCompleted: false);
      const b = Task(id: '1', title: 'タスク1', isCompleted: false);

      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
