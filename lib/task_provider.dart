import 'package:flutter/material.dart';
import 'task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      title: "Plan weekend trip",
      description: "Research destinations and book accommodation",
      assignedTo: "both",
      priority: "urgent",
    ),
    Task(
      title: "Buy groceries",
      description: "Milk, bread, eggs, vegetables",
      assignedTo: "me",
      priority: "urgent",
    ),
    Task(
      title: "Call parents",
      description: "Weekly catch-up call",
      assignedTo: "partner",
      priority: "normal",
    ),
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.completed = !task.completed;
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
