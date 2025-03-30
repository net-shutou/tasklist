import 'package:flutter/material.dart';
import 'task_manager.dart';
import 'task_list_view.dart';
import 'task_item.dart';

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
              buildTaskItem: (tasks, index) {
                final task = tasks[index];
                return TaskItem(
                  key: ValueKey('$index-${task['title']}'),
                  index: index,
                  task: task,
                  isEditing: _editingIndex == index,
                  editController: _editController,
                  onEdit: () {
                    setState(() {
                      _editingIndex = index;
                      _editController.text = task['title'];
                    });
                  },
                  onUpdateTask: (newTitle) {
                    setState(() {
                      if (newTitle.isNotEmpty) {
                        task['title'] = newTitle;
                        _editingIndex = null;
                      }
                    });
                  },
                  onToggleCompletion: () {
                    setState(() {
                      widget.taskManager.toggleTaskCompletion(index);
                    });
                  },
                  onDeleteTask: () {
                    setState(() {
                      tasks.removeAt(index);
                      if (_editingIndex == index) {
                        _editingIndex = null;
                      }
                    });
                  },
                );
              },
            ),
          ),
          _buildTaskInput(),
        ],
      ),
    );
  }

  Widget _buildTaskInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _addController,
              decoration: InputDecoration(
                labelText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_addController.text.isNotEmpty) {
                  widget.taskManager.addTask(_addController.text);
                  _addController.clear();
                }
              });
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
