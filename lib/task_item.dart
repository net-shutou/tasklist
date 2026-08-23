import 'package:flutter/material.dart';
import 'task.dart';

class TaskItem extends StatefulWidget {
  final int index;
  final Task task;
  final bool isEditing;
  final TextEditingController editController;
  final VoidCallback onEdit;
  final void Function(String newTitle) onUpdateTask;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDeleteTask;

  const TaskItem({
    required Key key,
    required this.index,
    required this.task,
    required this.isEditing,
    required this.editController,
    required this.onEdit,
    required this.onUpdateTask,
    required this.onToggleCompletion,
    required this.onDeleteTask,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onUpdateTask(widget.editController.text);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey('listtile-${widget.task.id}'),
      title: widget.isEditing
          ? TextField(
              controller: widget.editController,
              focusNode: _focusNode,
              autofocus: true,
              onSubmitted: (newTitle) {
                widget.onUpdateTask(newTitle);
              },
              decoration: InputDecoration(
                hintText: 'Edit task',
              ),
            )
          : Text(
              widget.task.title,
              style: TextStyle(
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
      onTap: () {
        widget.onEdit();
        _focusNode.requestFocus();
      },
      leading: Checkbox(
        key: ValueKey('checkbox-${widget.task.id}'),
        value: widget.task.isCompleted,
        onChanged: (_) => widget.onToggleCompletion(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: widget.onDeleteTask,
          ),
          ReorderableDragStartListener(
            key: ValueKey('drag-${widget.task.id}'),
            index: widget.index,
            child: Icon(Icons.drag_handle),
          ),
        ],
      ),
    );
  }
}