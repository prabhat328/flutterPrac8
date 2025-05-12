import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prac8/models/todo_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user profile
  Future<void> createUserProfile(String uid, String name, String email) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }

  // Get user profile
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // Add a new todo
  Future<void> addTodo(TodoModel todo) async {
    await _firestore.collection('todos').add(todo.toMap());
  }

  // Update a todo
  Future<void> updateTodo(String id, TodoModel todo) async {
    await _firestore.collection('todos').doc(id).update(todo.toMap());
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    await _firestore.collection('todos').doc(id).delete();
  }

  // Get todos for a specific user
  Stream<QuerySnapshot> getTodos(String uid) {
    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Search todos
  Stream<QuerySnapshot> searchTodos(String uid, String query) {
    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: uid)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }
}
