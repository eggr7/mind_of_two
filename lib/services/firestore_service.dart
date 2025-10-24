import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/category.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== TASKS ====================

  // Create task
  Future<void> createTask(Task task, String workspaceId) async {
    try {
      // Create task in Firestore
      await _firestore.collection('tasks').doc(task.id).set(task.toMap());

      // Also save to Hive for offline access
      final tasksBox = Hive.box<Task>('tasks');
      await tasksBox.put(task.id, task);
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    try {
      // Update in Firestore
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      await _firestore.collection('tasks').doc(task.id).update(updatedTask.toMap());

      // Update in Hive
      final tasksBox = Hive.box<Task>('tasks');
      await tasksBox.put(task.id, updatedTask);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('tasks').doc(taskId).delete();

      // Delete from Hive
      final tasksBox = Hive.box<Task>('tasks');
      await tasksBox.delete(taskId);
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  // Get workspace tasks (stream for real-time updates)
  Stream<List<Task>> getWorkspaceTasks(String workspaceId) {
    return _firestore
        .collection('tasks')
        .where('workspaceId', isEqualTo: workspaceId)
        .snapshots()
        .map((snapshot) {
      final tasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.data()))
          .toList();

      // Update Hive cache
      _updateTasksCache(tasks);

      return tasks;
    });
  }

  // Update tasks cache in Hive
  Future<void> _updateTasksCache(List<Task> tasks) async {
    try {
      final tasksBox = Hive.box<Task>('tasks');
      
      // Clear existing workspace tasks in Hive
      final existingKeys = tasksBox.keys.where((key) {
        final task = tasksBox.get(key);
        return task?.workspaceId != null;
      }).toList();
      
      for (final key in existingKeys) {
        await tasksBox.delete(key);
      }

      // Add new tasks
      for (final task in tasks) {
        await tasksBox.put(task.id, task);
      }
    } catch (e) {
      print('Error updating tasks cache: $e');
    }
  }

  // ==================== CATEGORIES ====================

  // Create category
  Future<void> createCategory(Category category, String workspaceId) async {
    try {
      // Create in Firestore
      await _firestore.collection('categories').doc(category.id).set(category.toMap());

      // Save to Hive
      final categoriesBox = Hive.box<Category>('categories');
      await categoriesBox.put(category.id, category);
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  // Update category
  Future<void> updateCategory(Category category) async {
    try {
      // Update in Firestore
      await _firestore.collection('categories').doc(category.id).update(category.toMap());

      // Update in Hive
      final categoriesBox = Hive.box<Category>('categories');
      await categoriesBox.put(category.id, category);
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('categories').doc(categoryId).delete();

      // Delete from Hive
      final categoriesBox = Hive.box<Category>('categories');
      await categoriesBox.delete(categoryId);
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  // Get workspace categories (stream for real-time updates)
  Stream<List<Category>> getWorkspaceCategories(String workspaceId) {
    return _firestore
        .collection('categories')
        .where('workspaceId', isEqualTo: workspaceId)
        .snapshots()
        .map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => Category.fromMap(doc.data()))
          .toList();

      // Update Hive cache
      _updateCategoriesCache(categories);

      return categories;
    });
  }

  // Update categories cache in Hive
  Future<void> _updateCategoriesCache(List<Category> categories) async {
    try {
      final categoriesBox = Hive.box<Category>('categories');
      
      // Clear existing workspace categories in Hive
      final existingKeys = categoriesBox.keys.where((key) {
        final category = categoriesBox.get(key);
        return category?.workspaceId != null;
      }).toList();
      
      for (final key in existingKeys) {
        await categoriesBox.delete(key);
      }

      // Add new categories
      for (final category in categories) {
        await categoriesBox.put(category.id, category);
      }
    } catch (e) {
      print('Error updating categories cache: $e');
    }
  }

  // ==================== SYNC ====================

  // Sync local tasks to Firestore (for migration)
  Future<void> syncLocalToFirestore({
    required String userId,
    required String workspaceId,
  }) async {
    try {
      final tasksBox = Hive.box<Task>('tasks');
      final localTasks = tasksBox.values.where((task) => task.workspaceId == null).toList();

      for (final task in localTasks) {
        final updatedTask = task.copyWith(
          workspaceId: workspaceId,
          userId: userId,
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('tasks').doc(updatedTask.id).set(updatedTask.toMap());
        await tasksBox.put(updatedTask.id, updatedTask);
      }

      // Sync local categories
      final categoriesBox = Hive.box<Category>('categories');
      final localCategories = categoriesBox.values.where((cat) => cat.workspaceId == null).toList();

      for (final category in localCategories) {
        final updatedCategory = category.copyWith(
          workspaceId: workspaceId,
        );

        await _firestore.collection('categories').doc(updatedCategory.id).set(updatedCategory.toMap());
        await categoriesBox.put(updatedCategory.id, updatedCategory);
      }
    } catch (e) {
      print('Error syncing local to Firestore: $e');
      rethrow;
    }
  }

  // Sync Firestore to local (download workspace data)
  Future<void> syncFirestoreToLocal(String workspaceId) async {
    try {
      // Download tasks
      final tasksSnapshot = await _firestore
          .collection('tasks')
          .where('workspaceId', isEqualTo: workspaceId)
          .get();

      final tasks = tasksSnapshot.docs
          .map((doc) => Task.fromMap(doc.data()))
          .toList();

      await _updateTasksCache(tasks);

      // Download categories
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .where('workspaceId', isEqualTo: workspaceId)
          .get();

      final categories = categoriesSnapshot.docs
          .map((doc) => Category.fromMap(doc.data()))
          .toList();

      await _updateCategoriesCache(categories);
    } catch (e) {
      print('Error syncing Firestore to local: $e');
      rethrow;
    }
  }
}

