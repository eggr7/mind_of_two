import 'package:hive/hive.dart';

part 'task.g.dart'; // This file will generate automatically

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String assignedTo; // "me", "partner", "both"

  @HiveField(4)
  String priority; // "urgent", "important", "normal"

  @HiveField(5)
  bool completed;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7) // New field
  DateTime? dueDate; // Optional due date

  @HiveField(8)
  List<String> categoryIds; // List of category IDs

  @HiveField(9)
  String? workspaceId; // Workspace this task belongs to (nullable for local tasks)

  @HiveField(10)
  String? userId; // User who created the task (nullable for local tasks)

  @HiveField(11)
  DateTime? updatedAt; // Last update timestamp for sync

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.completed,
    required this.createdAt,
    this.dueDate,
    List<String>? categoryIds,
    this.workspaceId,
    this.userId,
    this.updatedAt,
  }) : categoryIds = categoryIds ?? [];

  // Method to generate a unique ID (for simplicity, using timestamp)
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'priority': priority,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'categoryIds': categoryIds,
      'workspaceId': workspaceId,
      'userId': userId,
      'updatedAt': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  // Create Task from Firestore Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      assignedTo: map['assignedTo'] as String,
      priority: map['priority'] as String,
      completed: map['completed'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
      categoryIds: List<String>.from(map['categoryIds'] as List? ?? []),
      workspaceId: map['workspaceId'] as String?,
      userId: map['userId'] as String?,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  // Copy with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedTo,
    String? priority,
    bool? completed,
    DateTime? createdAt,
    DateTime? dueDate,
    List<String>? categoryIds,
    String? workspaceId,
    String? userId,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      categoryIds: categoryIds ?? this.categoryIds,
      workspaceId: workspaceId ?? this.workspaceId,
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
