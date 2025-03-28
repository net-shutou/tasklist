import 'package:flutter/material.dart';
import 'task_manager.dart';
import 'task_list_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TaskManagerのインスタンスを作成
    final taskManager = TaskManager();

    // 初期データを追加（必要に応じて）
    taskManager.addTask('Task 1');
    taskManager.addTask('Task 2');
    taskManager.addTask('Task 3');

    return MaterialApp(
      title: 'Task List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // TaskListWidgetを表示
      home: TaskListWidget(taskManager: taskManager),
    );
  }
}
