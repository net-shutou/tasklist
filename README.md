# Task List App

Flutter製のシンプルなタスク管理アプリです。タスクの追加・編集・完了・削除・並び替えに対応し、Windows / macOS / Linux / Web / iOS / Android のクロスプラットフォームで動作します。

## 主な機能

- タスクの追加(空文字列・空白のみ・256文字以上は追加不可)
- タスクのインライン編集(タップして編集、フォーカスが外れると確定)
- タスクの完了状態の切り替え(完了タスクは取り消し線で表示)
- タスクの削除
- ドラッグ&ドロップによるタスクの並び替え

## 動作環境・セットアップ

- Flutter SDK ^3.7.0(開発時は 3.29.2 で動作確認)
- 依存パッケージ: [provider](https://pub.dev/packages/provider)(状態管理)

```bash
flutter pub get
flutter run -d windows   # Windowsデスクトップで起動する場合
flutter run -d chrome    # Webで起動する場合
```

## アーキテクチャ

Provider(`ChangeNotifier`)による状態管理を採用しています。

| ファイル | 役割 |
|---|---|
| `lib/task.dart` | タスクを表す不変(`@immutable`)のドメインモデル。`id`/`title`/`isCompleted` |
| `lib/task_manager.dart` | タスクの永続化(現状はメモリ上)を担う。`List<Task>`を単一の真実として保持 |
| `lib/task_list_controller.dart` | `ChangeNotifier`。タスクの追加・更新・削除・並び替え・編集状態(`editingTaskId`)を管理 |
| `lib/task_list_widget.dart` | 画面全体のルートウィジェット。Providerからの状態をUIに反映 |
| `lib/task_list_view.dart` | `ReorderableListView`によるタスク一覧表示 |
| `lib/task_item.dart` / `lib/task_item_builder.dart` | タスク1件分の表示・編集UI |
| `lib/task_input.dart` | タスク追加用の入力欄 |

## テスト

```bash
flutter test                      # 個別ファイルの自動検出実行
flutter test test/all_tests.dart  # 集約スイート経由の実行
```

- `test/robot/tasklist_robot.dart` に、テスト用の操作(タスク追加・並び替え・削除等)をまとめたRobotパターンのヘルパーを用意しています。
- Widgetテストの一部は [mockito](https://pub.dev/packages/mockito) によるモックを使用しており、`@GenerateMocks` のモックは `dart run build_runner build --delete-conflicting-outputs` で再生成できます。

## 公開前セルフレビューで検出・是正した内容

公開前のセルフレビューで、以下の構造的な欠陥を検出し、[Parallel Change(Expand–Migrate–Contract)](https://martinfowler.com/bliki/ParallelChange.html)戦略とTDDに基づいて修正しました。

| # | 重大度 | 内容 | 状態 |
|---|---|---|---|
| C-1 | Critical | `TaskManager`が内部リストの参照をそのまま返却し、カプセル化が破れていた | 解消 |
| C-2 | Critical | `Map<String, dynamic>`が全レイヤーを貫通し、型安全性がなかった | 解消(`Task`ドメインモデルを導入) |
| H-1 | High | 編集中の行(`editingIndex`)がUI層(`State`)で管理されていた | 解消(Controllerへ移動) |
| H-2 | High | `ReorderableListView`のインデックス補正が誤っていた | 解消 |
| M-1 | Medium | 常にfalseになる死んだnullチェック | 解消 |
| M-2 | Medium | `print()`の残存 | 解消 |
| M-3 | Medium | `mockito`/`build_runner`が`dependencies`にも誤って記載 | 解消 |
| M-4 | Medium | ウィジェットのキーが位置/タイトルベースで衝突しうる設計だった | 解消(`Task.id`ベースに変更) |
| M-5 | Medium | `const`コンストラクタの欠落 | 解消 |
| M-6 | Medium | テストの形骸化・重複 | 解消 |
| M-7 | Medium | 編集中タスクの管理が位置ベースで、並び替えると対象がずれる欠陥があった | 解消(`Task.id`ベースに変更) |
| M-8 | Medium | `flutter test`全体実行時、ツール側の要因で低頻度にコンパイラが偽陽性のクラッシュをすることがある | 既知の問題として記録(対応見送り) |
| M-9 | Medium | 実機でのみ、ドラッグ操作を動かし始めた時点で編集中の内容が意図せず確定されることがある | 既知の問題として記録(対応見送り) |
| L-1 | Low | テンプレートの`description`文言が残存 | 解消 |

M-8・M-9 は、自動テスト(widgetテスト)では再現せず、実際のプラットフォーム上で動作する `integration_test` の導入が再現・検証に必要と考えられるものの、現状のアプリ規模に対してコストが見合わないと判断し、既知の問題として記録した上で対応を見送っています。
