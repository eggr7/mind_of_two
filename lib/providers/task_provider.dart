import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isInitialized = false;

  List<Task> get tasks => _tasks;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _loadTasksFromStorage();
      _isInitialized = true;
      debugPrint("TaskProvider initialized with ${_tasks.length} tasks");
    }
  }

  Future<void> _loadTasksFromStorage() async {
    try {
      _tasks = StorageService.loadTasks();
      debugPrint("TaskProvider loaded ${_tasks.length} tasks from storage");
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading tasks in TaskProvider: $e");
      _tasks = [];
    }
  }

  Future<void> _saveTasksToStorage() async {
    await StorageService.saveTasks(_tasks);
  }

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case "urgent":
        return _tasks.where((task) => !task.completed && task.priority == "urgent").toList();
      case "important":
        return _tasks.where((task) => !task.completed && task.priority == "important").toList();
      case "completed":
        return _tasks.where((task) => task.completed).toList();
      default:
        // Check if filter is a category ID
        if (filter.startsWith("category_")) {
          final categoryId = filter.substring(9); // Remove "category_" prefix (9 chars)
          debugPrint('Filtering by category: $categoryId');
          final filtered = _tasks.where((task) => 
            !task.completed && task.categoryIds.contains(categoryId)
          ).toList();
          debugPrint('Found ${filtered.length} tasks for category $categoryId');
          return filtered;
        }
        return _tasks.where((task) => !task.completed).toList();
    }
  }

  List<Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => 
      !task.completed && task.categoryIds.contains(categoryId)
    ).toList();
  }

  Map<String, int> getCategoryStats() {
    Map<String, int> stats = {};
    
    for (var task in _tasks) {
      if (!task.completed) {
        for (var categoryId in task.categoryIds) {
          stats[categoryId] = (stats[categoryId] ?? 0) + 1;
        }
      }
    }
    
    return stats;
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    // Save immediately and wait to ensure data persistence
    await _saveTasksToStorage();
    debugPrint("Task added: ${task.title}, Total tasks: ${_tasks.length}");
  }

  Future<void> toggleTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].completed = !_tasks[taskIndex].completed;
      notifyListeners();
      // Save immediately to prevent data loss
      await _saveTasksToStorage();
      debugPrint("Task toggled: ${_tasks[taskIndex].title}");
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
      // Save immediately to prevent data loss
      await _saveTasksToStorage();
      debugPrint("Task updated: ${updatedTask.title}");
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasksToStorage();
    notifyListeners();
    print("Task deleted, Total tasks: ${_tasks.length}");
  }

  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((task) => task.completed);
    await _saveTasksToStorage();
    notifyListeners();
  }

  // Load sample data
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
          dueDate: DateTime.now().add(const Duration(days: 7)),
          categoryIds: [],
        ),
        Task(
          id: "2",
          title: "Buy groceries",
          description: "Milk, bread, eggs, vegetables",
          assignedTo: "me",
          priority: "important",
          completed: false,
          createdAt: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 2)),
          categoryIds: ["to_buy"],
        ),
        Task(
          id: "3",
          title: "Call parents",
          description: "Weekly catch-up call",
          assignedTo: "partner",
          priority: "normal",
          completed: false,
          createdAt: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 5)),
          categoryIds: [],
        ),
      ]);
      await _saveTasksToStorage();
      notifyListeners();
    }
  }
}
