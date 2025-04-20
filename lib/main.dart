import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_manager.dart';
import 'task_list_controller.dart';
import 'task_list_widget.dart';

void main() {
  const useController = true; // trueでTaskListControllerモード
  runApp(MyApp(useController: useController));
}

class MyApp extends StatelessWidget {
  final bool useController;
  const MyApp({super.key, required this.useController});

  @override
  Widget build(BuildContext context) {
    if (useController) {
      return ChangeNotifierProvider(
        create: (_) => TaskListController(),
        child: MaterialApp(
          title: 'Task List App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: TaskListWidget.withController(),
        ),
      );
    } else {
      final taskManager = TaskManager();
      taskManager.addTask('Task 1');
      taskManager.addTask('Task 2');
      taskManager.addTask('Task 3');
      return MaterialApp(
        title: 'Task List App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TaskListWidget(taskManager: taskManager),
      );
    }
  }
}
