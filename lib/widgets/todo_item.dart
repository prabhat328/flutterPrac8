import 'package:flutter/material.dart';
import 'package:prac8/models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggleComplete(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.description.length > 50
                  ? '${todo.description.substring(0, 50)}...'
                  : todo.description,
              style: TextStyle(
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (todo.dueDate != null) ...[
                  const Icon(Icons.calendar_today, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    '${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.flag, size: 12),
                const SizedBox(width: 4),
                Text(
                  todo.priority ?? 'Medium',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Todo'),
                content:
                    const Text('Are you sure you want to delete this todo?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
