import 'package:flutter/foundation.dart' hide Category;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/category.dart' as models;

class StorageService {
  static const String _tasksBoxName = 'tasks';
  static const String _categoriesBoxName = 'categories';
  static const String _settingsBoxName = 'settings';
  static const String _themeKey = 'theme_mode';

  // Save all tasks (overwrite existing)
  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final box = Hive.box<Task>(_tasksBoxName);
      debugPrint('Saving ${tasks.length} tasks...');
      await box.clear();
      for (var task in tasks) {
        await box.add(task);
      }
      // Force flush to disk
      await box.flush();
      debugPrint('✓ Saved and flushed ${tasks.length} tasks to storage');
    } catch (e) {
      debugPrint('✗ Error saving tasks: $e');
    }
  }

  // Load all tasks
  static List<Task> loadTasks() {
    try {
      final box = Hive.box<Task>(_tasksBoxName);
      final tasks = box.values.toList();
      debugPrint('Loaded ${tasks.length} tasks from storage');
      return tasks;
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      return [];
    }
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
    try {
      final box = Hive.box<dynamic>(_settingsBoxName);
      await box.put(_themeKey, mode);
      await box.flush();
      debugPrint('✓ Theme mode saved and flushed: $mode');
    } catch (e) {
      debugPrint('✗ Error saving theme mode: $e');
    }
  }

  // Load theme mode
  static String loadThemeMode() {
    try {
      final box = Hive.box<dynamic>(_settingsBoxName);
      final theme = box.get(_themeKey, defaultValue: 'light') as String;
      debugPrint('Theme mode loaded: $theme');
      return theme;
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      return 'light';
    }
  }

  // Save all categories (overwrite existing)
  static Future<void> saveCategories(List<models.Category> categories) async {
    try {
      final box = Hive.box<models.Category>(_categoriesBoxName);
      await box.clear();
      for (var category in categories) {
        await box.add(category);
      }
      await box.flush();
      debugPrint('✓ Saved and flushed ${categories.length} categories');
    } catch (e) {
      debugPrint('✗ Error saving categories: $e');
    }
  }

  // Load all categories
  static List<models.Category> loadCategories() {
    final box = Hive.box<models.Category>(_categoriesBoxName);
    return box.values.toList();
  }

  // Add a new category
  static Future<void> addCategory(models.Category category) async {
    final box = Hive.box<models.Category>(_categoriesBoxName);
    await box.add(category);
  }

  // Update an existing category
  static Future<void> updateCategory(models.Category updatedCategory) async {
    final box = Hive.box<models.Category>(_categoriesBoxName);
    final categories = box.values.toList();
    final index = categories.indexWhere((category) => category.id == updatedCategory.id);

    if (index != -1) {
      await box.putAt(index, updatedCategory);
    }
  }

  // Delete a category
  static Future<void> deleteCategory(String categoryId) async {
    final box = Hive.box<models.Category>(_categoriesBoxName);
    final categories = box.values.toList();
    final index = categories.indexWhere((category) => category.id == categoryId);

    if (index != -1) {
      await box.deleteAt(index);
    }
  }
}
