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
  int? _editingIndex;

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskManager.getTasks();

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
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
                return ListTile(
                  key: ValueKey('$index-${tasks[index]}'),
                  title: _editingIndex == index
                      ? TextField(
                          controller: TextEditingController(text: tasks[index]),
                          autofocus: true,
                          onSubmitted: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                widget.taskManager.tasks[index] = value;
                              }
                              _editingIndex = null;
                            });
                          },
                        )
                      : Text(tasks[index]),
                  onTap: () {
                    setState(() {
                      _editingIndex = index;
                    });
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.taskManager.tasks.removeAt(index);
                            if (_editingIndex == index) {
                              _editingIndex = null;
                            }
                          });
                        },
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_handle), // ドラッグ用アイコン
                      ),
                    ],
                  ),
                );
              }),
            ),
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
}
