import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksBoxName = 'tasks';
  static const String _settingsBoxName = 'settings';
  static const String _themeKey = 'theme_mode';

  // Save all tasks (overwrite existing)
  static Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box<Task>(_tasksBoxName);
    await box.clear();
    for (var task in tasks) {
      await box.add(task);
    }
  }

  // Load all tasks
  static List<Task> loadTasks() {
    final box = Hive.box<Task>(_tasksBoxName);
    return box.values.toList();
  }

  // Add a new task
  static Future<void> addTask(Task task) async {
    final box = Hive.box<Task>(_tasksBoxName);
    await box.add(task);
  }

  //Update an existing task
  static Future<void> updateTask(Task updatedTask) async {
    final box = Hive.box<Task>(_tasksBoxName);
    final tasks = box.values.toList();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index != -1) {
      await box.putAt(index, updatedTask);
    }
  }

  // Delete a task
  static Future<void> deleteTask(String taskId) async {
    final box = Hive.box<Task>(_tasksBoxName);
    final tasks = box.values.toList();
    final index = tasks.indexWhere((task) => task.id == taskId);

    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  // Clear all completed tasks
  static Future<void> clearCompletedTasks() async {
    final box = Hive.box<Task>(_tasksBoxName);
    final tasks = box.values.toList();

    for (int i = tasks.length - 1; i >= 0; i--) {
      if (tasks[i].completed) {
        await box.deleteAt(i);
      }
    }
  }

  // Save theme mode
  static Future<void> saveThemeMode(String mode) async {
    final box = Hive.box<dynamic>(_settingsBoxName);
    await box.put(_themeKey, mode);
  }

  // Load theme mode
  static String loadThemeMode() {
    final box = Hive.box<dynamic>(_settingsBoxName);
    return box.get(_themeKey, defaultValue: 'light') as String;
  }
}
