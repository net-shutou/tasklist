import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list_controller.dart';
import 'task_list_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskListController(),
      child: MaterialApp(
        title: 'Task List App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const TaskListWidget(),
      ),
    );
  }
}
