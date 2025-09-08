import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  TaskProvider() {
    _loadTasksFromStorage();
  }

  List<Task> get tasks => _tasks;

  Future<void> _loadTasksFromStorage() async {
    _tasks = StorageService.loadTasks();
    notifyListeners();
  }

  Future<void> _saveTasksToStorage() async {
    await StorageService.saveTasks(_tasks);
  }

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case "urgent":
        return _tasks.where((task) => task.priority == "urgent").toList();
      case "important":
        return _tasks.where((task) => task.priority == "important").toList();
      case "completed":
        return _tasks.where((task) => task.completed).toList();
      default:
        return _tasks.where((task) => !task.completed).toList();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasksToStorage();
    notifyListeners();
  }

  Future<void> toggleTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].completed = !_tasks[taskIndex].completed;
      await _saveTasksToStorage();
      notifyListeners();
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      await _saveTasksToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasksToStorage();
    notifyListeners();
  }

  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((task) => task.completed);
    await _saveTasksToStorage();
    notifyListeners();
  }

  // Load sample tasks for first-time users
  Future<void> loadSampleTasks() async {
    if (_tasks.isEmpty) {
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
      await _saveTasksToStorage();
      notifyListeners();
    }
  }
}
