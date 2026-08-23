import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklist/main.dart';
import 'package:tasklist/task_list_controller.dart';
import 'package:tasklist/task_list_widget.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpMyApp() async {
    await pumpWidget(MaterialApp(
      home: MyApp(),
    ));
    await pumpAndSettle();
  }

  Future<void> pumpTaskListWidget(
    TaskListController controller, {
    bool settle = false,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskListController>.value(
          value: controller,
          child: const TaskListWidget(),
        ),
      ),
    );
    if (settle) {
      await pumpAndSettle();
    }
  }
}