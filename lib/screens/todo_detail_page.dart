import 'package:flutter/material.dart';
import 'package:prac8/models/todo_model.dart';
import 'package:prac8/screens/add_todo_page.dart';
import 'package:prac8/services/database_service.dart';

class TodoDetailPage extends StatelessWidget {
  final TodoModel todo;
  final DatabaseService _databaseService = DatabaseService();

  TodoDetailPage({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddTodoPage(todo: todo),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Todo'),
                  content:
                      const Text('Are you sure you want to delete this todo?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _databaseService.deleteTodo(todo.id!);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            todo.isCompleted ? 'Completed' : 'Pending',
                            style: TextStyle(
                              color: todo.isCompleted
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          backgroundColor:
                              todo.isCompleted ? Colors.green : Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      todo.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Created: ${_formatDate(todo.createdAt)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    if (todo.dueDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.event, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Due: ${_formatDate(todo.dueDate!)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.flag, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Priority: ${todo.priority ?? 'Medium'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _databaseService.updateTodo(
                  todo.id!,
                  todo.copyWith(isCompleted: !todo.isCompleted),
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(todo.isCompleted ? Icons.close : Icons.check),
              label: Text(
                  todo.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: todo.isCompleted ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
