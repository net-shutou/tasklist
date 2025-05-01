// TODO: TaskManagerからControllerへの移行計画
// 
// 移行手順:
// 1. タスク追加機能
//    - [x] Controller版のテスト作成済み
//    - [ ] TaskManager版のテストを移行
//    - [ ] TaskManager関連コードの削除
//
// 2. タスク削除機能
//    - [x] Controller版のテスト作成済み
//    - [ ] TaskManager版のテストを移行
//    - [ ] TaskManager関連コードの削除
//
// 3. タスク完了状態の切り替え機能
//    - [x] Controller版のテスト作成
//    - [ ] TaskManager版のテストを移行
//    - [ ] TaskManager関連コードの削除
//
// 4. タスクタイトルの更新機能
//    - [x] Controller版のテスト作成
//    - [ ] TaskManager版のテストを移行
//    - [ ] TaskManager関連コードの削除
//
// 5. タスクの並び替え機能
//    - [x] Controller版のテスト作成
//    - [ ] TaskManager版のテストを移行
//    - [ ] TaskManager関連コードの削除


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list_controller.dart';
import 'task_list_view.dart';
import 'task_input.dart';
import 'task_manager.dart';
import 'task_item_builder.dart';

class TaskListWidget extends StatefulWidget {
  final TaskManager? taskManager;

  // 通常のコンストラクタ（TaskManagerを使用）
  TaskListWidget({required this.taskManager});

  // 名前付きコンストラクタ（TaskListControllerを使用）
  TaskListWidget.withController({Key? key})
      : taskManager = null,
        super(key: key);

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _editController.addListener(_handleEditControllerChange);
  }

  @override
  void dispose() {
    _addController.dispose();
    _editController.removeListener(_handleEditControllerChange);
    _editController.dispose();
    super.dispose();
  }

  void _handleEditControllerChange() {
    if (_editingIndex != null) {
      final newTitle = _editController.text;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _editingIndex != null && newTitle.isNotEmpty) {
          if (widget.taskManager != null) {
            // TaskManagerを使用
            setState(() {
              widget.taskManager!.updateTaskTitle(_editingIndex!, newTitle);
            });
          } else {
            // TaskListControllerを使用
            final controller = Provider.of<TaskListController>(context, listen: false);
            controller.updateTask(_editingIndex!, newTitle);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskManager?.getTasks() ??
        Provider.of<TaskListController>(context).tasks;

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          Expanded(
            child: TaskListView(
              tasks: tasks,
              onReorder: (oldIndex, newIndex) {
                if (widget.taskManager != null) {
                  setState(() {
                    widget.taskManager!.reorderTasks(oldIndex, newIndex);
                  });
                } else {
                  final controller = Provider.of<TaskListController>(context, listen: false);
                  controller.reorderTasks(oldIndex, newIndex);
                }
              },
              buildTaskItem: (tasks, index) => buildTaskItem(
                tasks: tasks,
                index: index,
                editController: _editController,
                editingIndex: _editingIndex,
                onEdit: (index) {
                  setState(() {
                    _editingIndex = index;
                    _editController.text = tasks[index]['title'];
                  });
                },
                onUpdateTask: (index, newTitle) {
                  if (widget.taskManager != null) {
                    // TaskManagerを使用
                    setState(() {
                      if (newTitle.isNotEmpty) {
                        widget.taskManager!.updateTaskTitle(index, newTitle);
                        _editingIndex = null;
                      }
                    });
                  } else {
                    // TaskListControllerを使用
                    final controller = Provider.of<TaskListController>(context, listen: false);
                    controller.updateTask(index, newTitle);
                    setState(() {
                      _editingIndex = null;
                    });
                  }
                },
                onToggleCompletion: (index) {
                  if (widget.taskManager != null) {
                    // TaskManagerを使用
                    setState(() {
                      widget.taskManager!.toggleTaskCompletion(index);
                    });
                  } else {
                    // TaskListControllerを使用
                    final controller = Provider.of<TaskListController>(context, listen: false);
                    controller.toggleTaskCompletion(index);
                  }
                },
                onDeleteTask: (index) {
                  if (widget.taskManager != null) {
                    // TaskManagerを使用
                    setState(() {
                      widget.taskManager!.deleteTask(index);
                      if (_editingIndex == index) {
                        _editingIndex = null;
                      }
                    });
                  } else {
                    // TaskListControllerを使用
                    final controller = Provider.of<TaskListController>(context, listen: false);
                    controller.deleteTask(index);
                    setState(() {
                      if (_editingIndex == index) {
                        _editingIndex = null;
                      }
                    });
                  }
                },
              ),
            ),
          ),
          TaskInput(
            controller: _addController,
            onAddTask: () {
              if (_addController.text.isNotEmpty) {
                if (widget.taskManager != null) {
                  setState(() {
                    widget.taskManager!.addTask(_addController.text);
                  });
                  _addController.clear();
                } else {
                  final controller = Provider.of<TaskListController>(context, listen: false);
                  controller.addTask(_addController.text);
                  _addController.clear();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
