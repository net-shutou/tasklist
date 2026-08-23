import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAddTask;

  const TaskInput({required this.controller, required this.onAddTask});

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: widget.controller.text.isEmpty ? null : widget.onAddTask,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}