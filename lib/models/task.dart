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
  String priority;   // "urgent", "important", "normal"
  
  @HiveField(5)
  bool completed;
  
  @HiveField(6)
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.completed,
    required this.createdAt,
  });

  // Method to generate a unique ID (for simplicity, using timestamp)
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}