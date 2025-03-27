import 'package:flutter/material.dart';
import 'task_manager.dart';

class TaskListWidget extends StatefulWidget {
  final TaskManager taskManager;

  TaskListWidget({required this.taskManager});

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskManager.getTasks();

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
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
                      if (_controller.text.isNotEmpty) {
                        widget.taskManager.addTask(_controller.text);
                        _controller.clear();
                      }
                    });
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
