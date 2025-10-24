import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isInitialized = false;
  String? _activeWorkspaceId;
  StreamSubscription? _firestoreSubscription;
  final FirestoreService _firestoreService = FirestoreService();

  List<Task> get tasks => _tasks;
  String? get activeWorkspaceId => _activeWorkspaceId;

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

  // Set active workspace and start listening to Firestore
  void setActiveWorkspace(String? workspaceId, String? userId) {
    _activeWorkspaceId = workspaceId;
    
    // Cancel previous subscription
    _firestoreSubscription?.cancel();
    
    if (workspaceId != null && userId != null) {
      // Listen to workspace tasks from Firestore
      _firestoreSubscription = _firestoreService
          .getWorkspaceTasks(workspaceId)
          .listen(
            (tasks) {
              _tasks = tasks;
              notifyListeners();
              debugPrint('Firestore tasks updated: ${tasks.length}');
            },
            onError: (error) {
              debugPrint('Error listening to Firestore tasks: $error');
            },
          );
    } else {
      // Load local tasks if no workspace
      _loadTasksFromStorage();
    }
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

  Future<void> addTask(Task task, {String? userId}) async {
    if (_activeWorkspaceId != null && userId != null) {
      // Add to Firestore (will update local via listener)
      final taskWithWorkspace = task.copyWith(
        workspaceId: _activeWorkspaceId,
        userId: userId,
        updatedAt: DateTime.now(),
      );
      await _firestoreService.createTask(taskWithWorkspace, _activeWorkspaceId!);
      debugPrint("Task added to Firestore: ${task.title}");
    } else {
      // Add locally only
      _tasks.add(task);
      notifyListeners();
      await _saveTasksToStorage();
      debugPrint("Task added locally: ${task.title}, Total tasks: ${_tasks.length}");
    }
  }

  Future<void> toggleTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final updatedTask = _tasks[taskIndex].copyWith(
      completed: !_tasks[taskIndex].completed,
      updatedAt: DateTime.now(),
    );

    if (_activeWorkspaceId != null) {
      // Update in Firestore (will update local via listener)
      await _firestoreService.updateTask(updatedTask);
      debugPrint("Task ${taskId} toggled in Firestore. Completed: ${updatedTask.completed}");
    } else {
      // Update locally
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
      await _saveTasksToStorage();
      debugPrint("Task ${taskId} toggled locally. Completed: ${updatedTask.completed}");
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    if (_activeWorkspaceId != null) {
      // Update in Firestore (will update local via listener)
      final taskWithTimestamp = updatedTask.copyWith(updatedAt: DateTime.now());
      await _firestoreService.updateTask(taskWithTimestamp);
      debugPrint("Task updated in Firestore: ${updatedTask.title}");
    } else {
      // Update locally
      final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = updatedTask;
        notifyListeners();
        await _saveTasksToStorage();
        debugPrint("Task updated locally: ${updatedTask.title}");
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (_activeWorkspaceId != null) {
      // Delete from Firestore (will update local via listener)
      await _firestoreService.deleteTask(taskId);
      debugPrint("Task deleted from Firestore: $taskId");
    } else {
      // Delete locally
      _tasks.removeWhere((task) => task.id == taskId);
      await _saveTasksToStorage();
      notifyListeners();
      debugPrint("Task deleted locally, Total tasks: ${_tasks.length}");
    }
  }

  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((task) => task.completed);
    await _saveTasksToStorage();
    notifyListeners();
  }

  // Sync local tasks to Firestore workspace
  Future<void> syncLocalToWorkspace(String userId, String workspaceId) async {
    await _firestoreService.syncLocalToFirestore(
      userId: userId,
      workspaceId: workspaceId,
    );
  }

  // Get count of local tasks (not in workspace)
  int getLocalTasksCount() {
    return _tasks.where((task) => task.workspaceId == null).length;
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

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }
}
