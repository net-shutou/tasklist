import 'package:flutter/material.dart';
import 'task_manager.dart';

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
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskManager.getTasks();

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          Expanded(
            child: _buildTaskList(tasks),
          ),
          Padding(
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
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> tasks) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final task = tasks.removeAt(oldIndex);
          tasks.insert(newIndex, task);
        });
      },
      children: List.generate(tasks.length, (index) {
        final task = tasks[index];
        return ListTile(
          key: ValueKey('$index-${task['title']}'),
          title: _editingIndex == index
              ? TextField(
                  controller: _editController..text = task['title'],
                  autofocus: true,
                  onSubmitted: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        task['title'] = value;
                        _editingIndex = null;
                      }
                    });
                  },
                )
              : Text(
                  task['title'],
                  style: TextStyle(
                    decoration: task['isCompleted']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
          onTap: () {
            setState(() {
              _editingIndex = index;
            });
          },
          leading: Checkbox(
            key: ValueKey('checkbox-${task['title']}'),
            value: task['isCompleted'],
            onChanged: (value) {
              setState(() {
                widget.taskManager.toggleTaskCompletion(index);
              });
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    tasks.removeAt(index);
                    if (_editingIndex == index) {
                      _editingIndex = null;
                    }
                  });
                },
              ),
              ReorderableDragStartListener(
                index: index,
                child: Icon(Icons.drag_handle),
              ),
            ],
          ),
        );
      }),
    );
  }
}
