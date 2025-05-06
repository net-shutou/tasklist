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

  TaskListController get _controller => 
      Provider.of<TaskListController>(context, listen: false);

  @override
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _startEdit(int index, List tasks) {
    setState(() {
      _editingIndex = index;
      _editController.text = tasks[index]['title'];
    });
  }

  void _updateTask(int index, String newTitle) {
    _controller.updateTask(index, newTitle);
    setState(() => _editingIndex = null);
  }

  void _toggleCompletion(int index) {
    _controller.toggleTaskCompletion(index);
  }

  void _deleteTask(int index) {
    _controller.deleteTask(index);
    if (_editingIndex == index) {
      setState(() => _editingIndex = null);
    }
  }

  void _addTask() {
    if (_addController.text.isEmpty) return;
    _controller.addTask(_addController.text);
    _addController.clear();
  }

  void _reorderTasks(int oldIndex, int newIndex) {
    _controller.reorderTasks(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskListController>(context).tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Column(
        children: [
          Expanded(
            child: TaskListView(
              tasks: tasks,
              onReorder: _reorderTasks,
              buildTaskItem: (tasks, index) => buildTaskItem(
                tasks: tasks,
                index: index,
                editController: _editController,
                editingIndex: _editingIndex,
                onEdit: (index) => _startEdit(index, tasks),
                onUpdateTask: _updateTask,
                onToggleCompletion: _toggleCompletion,
                onDeleteTask: _deleteTask,
              ),
            ),
          ),
          TaskInput(
            controller: _addController,
            onAddTask: _addTask,
          ),
        ],
      ),
    );
  }
}
