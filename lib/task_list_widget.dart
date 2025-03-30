import 'package:flutter/material.dart';
import 'task_manager.dart';
import 'task_list_view.dart';
import 'task_item.dart';
import 'task_input.dart'; // TaskInputをインポート
import 'task_item_builder.dart'; // TaskItemBuilderをインポート

class TaskListWidget extends StatefulWidget {
  final TaskManager taskManager;

  TaskListWidget({required this.taskManager});

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
    _editController.addListener(_handleEditControllerChange); // リスナーを登録
  }

  @override
  void dispose() {
    _addController.dispose();
    _editController.removeListener(_handleEditControllerChange); // リスナーを削除
    _editController.dispose();
    super.dispose();
  }

  void _handleEditControllerChange() {
    if (_editingIndex != null) {
      final newTitle = _editController.text;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _editingIndex != null && newTitle.isNotEmpty) {
          setState(() {
            widget.taskManager.updateTaskTitle(_editingIndex!, newTitle);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskManager.getTasks();

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          Expanded(
            child: TaskListView(
              tasks: tasks,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final task = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, task);
                });
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
                  setState(() {
                    if (newTitle.isNotEmpty) {
                      tasks[index]['title'] = newTitle;
                      _editingIndex = null;
                    }
                  });
                },
                onToggleCompletion: (index) {
                  setState(() {
                    widget.taskManager.toggleTaskCompletion(index);
                  });
                },
                onDeleteTask: (index) {
                  setState(() {
                    tasks.removeAt(index);
                    if (_editingIndex == index) {
                      _editingIndex = null;
                    }
                  });
                },
              ),
            ),
          ),
          TaskInput(
            controller: _addController,
            onAddTask: () {
              setState(() {
                if (_addController.text.isNotEmpty) {
                  widget.taskManager.addTask(_addController.text);
                  _addController.clear();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
