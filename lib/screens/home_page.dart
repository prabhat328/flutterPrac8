import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prac8/auth/login_page.dart';
import 'package:prac8/models/todo_model.dart';
import 'package:prac8/screens/add_todo_page.dart';
import 'package:prac8/screens/todo_detail_page.dart';
import 'package:prac8/services/auth_service.dart';
import 'package:prac8/services/database_service.dart';
import 'package:prac8/services/theme_service.dart';
import 'package:prac8/widgets/todo_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _signOut() async {
    await _authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _navigateToAddTodo() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddTodoPage()),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search todos...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('My Todos'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(
              themeService.isDarkModeOn ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeService.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('No user logged in'))
          : StreamBuilder<QuerySnapshot>(
              stream: _searchQuery.isEmpty
                  ? _databaseService.getTodos(user.uid)
                  : _databaseService.searchTodos(user.uid, _searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No todos yet. Add one!'
                              : 'No todos found for "$_searchQuery"',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final todos = snapshot.data!.docs.map((doc) {
                  return TodoModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoItem(
                      todo: todo,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TodoDetailPage(todo: todo),
                          ),
                        );
                      },
                      onToggleComplete: () async {
                        await _databaseService.updateTodo(
                          todo.id!,
                          todo.copyWith(isCompleted: !todo.isCompleted),
                        );
                      },
                      onDelete: () async {
                        await _databaseService.deleteTodo(todo.id!);
                      },
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
