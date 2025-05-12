import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String? id;
  final String userId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String? priority;

  TodoModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority,
  });

  // Convert TodoModel to Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'priority': priority,
    };
  }

  // Create TodoModel from Map
  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      dueDate: map['dueDate'] != null ? (map['dueDate'] as Timestamp).toDate() : null,
      priority: map['priority'],
    );
  }

  // Create a copy of TodoModel with some changes
  TodoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
