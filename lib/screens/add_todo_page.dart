import 'package:flutter/material.dart';
import 'package:prac8/models/todo_model.dart';
import 'package:prac8/services/auth_service.dart';
import 'package:prac8/services/database_service.dart';

class AddTodoPage extends StatefulWidget {
  final TodoModel? todo;

  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  DateTime? _dueDate;
  String _priority = 'Medium';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _dueDate = widget.todo!.dueDate;
      _priority = widget.todo!.priority ?? 'Medium';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final user = _authService.getCurrentUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final todo = TodoModel(
          id: widget.todo?.id,
          userId: user.uid,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          isCompleted: widget.todo?.isCompleted ?? false,
          createdAt: widget.todo?.createdAt ?? DateTime.now(),
          dueDate: _dueDate,
          priority: _priority,
        );

        if (widget.todo == null) {
          await _databaseService.addTodo(todo);
        } else {
          await _databaseService.updateTodo(widget.todo!.id!, todo);
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDueDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _dueDate == null
                              ? 'Select Due Date'
                              : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDueDate,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                value: _priority,
                items: ['Low', 'Medium', 'High'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _priority = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveTodo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.todo == null ? 'Add Todo' : 'Update Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
