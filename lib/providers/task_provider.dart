import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case "urgent":
        return _tasks.where((task) => task.priority == "urgent").toList();
      case "important":
        return _tasks.where((task) => task.priority == "important").toList();
      default:
        return _tasks;
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].completed = !_tasks[taskIndex].completed;
      notifyListeners();
    }
  }

  void updateTask(Task updatedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Load data samples
  void loadSampleTasks() {
    _tasks.addAll([
      Task(
        id: "1",
        title: "Plan weekend trip",
        description: "Research destinations and book accommodation",
        assignedTo: "both",
        priority: "urgent",
        completed: false,
        createdAt: DateTime.now(),
      ),
      Task(
        id: "2",
        title: "Buy groceries",
        description: "Milk, bread, eggs, vegetables",
        assignedTo: "me",
        priority: "important",
        completed: false,
        createdAt: DateTime.now(),
      ),
      Task(
        id: "3",
        title: "Call parents",
        description: "Weekly catch-up call",
        assignedTo: "partner",
        priority: "normal",
        completed: false,
        createdAt: DateTime.now(),
      ),
    ]);
    notifyListeners();
  }
}