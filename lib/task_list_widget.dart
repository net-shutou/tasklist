import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list_controller.dart';
import 'task_list_view.dart';
import 'task_input.dart';
import 'task_item_builder.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({Key? key}) : super(key: key);

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
          final controller = Provider.of<TaskListController>(context, listen: false);
          controller.updateTask(_editingIndex!, newTitle);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskListController>(context).tasks;

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          Expanded(
            child: TaskListView(
              tasks: tasks,
              onReorder: (oldIndex, newIndex) {
                final controller = Provider.of<TaskListController>(context, listen: false);
                controller.reorderTasks(oldIndex, newIndex);
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
                  final controller = Provider.of<TaskListController>(context, listen: false);
                  controller.updateTask(index, newTitle);
                  setState(() {
                    _editingIndex = null;
                  });
                },
                onToggleCompletion: (index) {
                  final controller = Provider.of<TaskListController>(context, listen: false);
                  controller.toggleTaskCompletion(index);
                },
                onDeleteTask: (index) {
                  final controller = Provider.of<TaskListController>(context, listen: false);
                  controller.deleteTask(index);
                  setState(() {
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
              if (_addController.text.isEmpty) return;
              final controller = Provider.of<TaskListController>(context, listen: false);
              controller.addTask(_addController.text);
              _addController.clear();
            },
          ),
        ],
      ),
    );
  }
}
