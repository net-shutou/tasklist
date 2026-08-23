import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
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

  TaskListController get _controller =>
      Provider.of<TaskListController>(context, listen: false);

  @override
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _startEdit(int index, List<Task> tasks) {
    _editController.text = tasks[index].title;
    _controller.startEdit(index);
  }

  void _updateTask(int index, String newTitle) {
    _controller.updateTask(index, newTitle);
    _controller.stopEditing();
  }

  void _toggleCompletion(int index) {
    _controller.toggleTaskCompletion(index);
  }

  void _deleteTask(int index) {
    final deletedTaskId = _controller.typedTasks[index].id;
    _controller.deleteTask(index);
    if (_controller.editingTaskId == deletedTaskId) {
      _controller.stopEditing();
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
    final controller = Provider.of<TaskListController>(context);
    final tasks = controller.typedTasks;

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
                editingTaskId: controller.editingTaskId,
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
