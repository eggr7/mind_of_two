import 'package:flutter/foundation.dart' hide Category;
import 'dart:async';
import '../models/category.dart' as models;
import '../services/storage_service.dart';
import '../services/firestore_service.dart';

class CategoryProvider with ChangeNotifier {
  List<models.Category> _categories = [];
  bool _isInitialized = false;
  String? _activeWorkspaceId;
  StreamSubscription<List<models.Category>>? _firestoreSubscription;
  final FirestoreService _firestoreService = FirestoreService();

  List<models.Category> get categories => _categories;
  List<models.Category> get predefinedCategories => _categories.where((cat) => cat.isPredefined).toList();
  List<models.Category> get customCategories => _categories.where((cat) => !cat.isPredefined).toList();
  String? get activeWorkspaceId => _activeWorkspaceId;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _loadCategoriesFromStorage();
      if (_categories.isEmpty) {
        await _createPredefinedCategories();
      }
      _isInitialized = true;
    }
  }

  bool _hasCreatedPredefinedForWorkspace = false;
  
  // Set active workspace and start listening to Firestore
  void setActiveWorkspace(String? workspaceId) {
    _activeWorkspaceId = workspaceId;
    _hasCreatedPredefinedForWorkspace = false; // Reset flag for new workspace
    
    // Cancel previous subscription
    _firestoreSubscription?.cancel();
    
    if (workspaceId != null) {
      // Listen to workspace categories from Firestore
      _firestoreSubscription = _firestoreService
          .getWorkspaceCategories(workspaceId)
          .listen(
            (categories) {
              _categories = categories;
              
              // Create predefined categories if workspace has no categories
              // and we haven't already tried to create them for this workspace
              if (categories.isEmpty && !_hasCreatedPredefinedForWorkspace && _activeWorkspaceId != null) {
                debugPrint('📝 Creating predefined categories for workspace: $_activeWorkspaceId');
                _hasCreatedPredefinedForWorkspace = true; // Set flag to prevent loops
                _createPredefinedCategories();
              }
              
              notifyListeners();
              debugPrint('Firestore categories updated: ${categories.length}');
            },
            onError: (Object error) {
              debugPrint('Error listening to Firestore categories: $error');
            },
          );
    } else {
      // Load local categories if no workspace
      _loadCategoriesFromStorage();
    }
  }

  Future<void> _loadCategoriesFromStorage() async {
    _categories = StorageService.loadCategories();
    notifyListeners();
  }

  Future<void> _saveCategoriesToStorage() async {
    await StorageService.saveCategories(_categories);
  }

  Future<void> _createPredefinedCategories() async {
    final predefined = [
      models.Category(
        id: "home_${models.Category.generateId()}",
        name: "Home",
        icon: "🏠",
        color: 0xFF2196F3, // Blue
        isPredefined: true,
        workspaceId: _activeWorkspaceId,
      ),
      models.Category(
        id: "pets_${models.Category.generateId()}",
        name: "Pets",
        icon: "🐾",
        color: 0xFF4CAF50, // Green
        isPredefined: true,
        workspaceId: _activeWorkspaceId,
      ),
      models.Category(
        id: "to_buy_${models.Category.generateId()}",
        name: "To Buy",
        icon: "🛒",
        color: 0xFFFF9800, // Orange
        isPredefined: true,
        workspaceId: _activeWorkspaceId,
      ),
    ];

    if (_activeWorkspaceId != null) {
      // Save to Firestore (will update local via listener)
      for (final category in predefined) {
        await _firestoreService.createCategory(category, _activeWorkspaceId!);
      }
      debugPrint("Predefined categories created in Firestore");
    } else {
      // Save locally
      _categories.addAll(predefined);
      await _saveCategoriesToStorage();
      notifyListeners();
    }
  }

  models.Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  List<models.Category> getCategoriesByIds(List<String> ids) {
    return _categories.where((category) => ids.contains(category.id)).toList();
  }

  Future<void> addCategory(models.Category category) async {
    if (_activeWorkspaceId != null) {
      // Add to Firestore (will update local via listener)
      final categoryWithWorkspace = category.copyWith(workspaceId: _activeWorkspaceId);
      await _firestoreService.createCategory(categoryWithWorkspace, _activeWorkspaceId!);
      debugPrint("Category added to Firestore: ${category.name}");
    } else {
      // Add locally
      _categories.add(category);
      notifyListeners();
      await _saveCategoriesToStorage();
      debugPrint("Category added locally: ${category.name}, Total categories: ${_categories.length}");
    }
  }

  Future<void> updateCategory(models.Category updatedCategory) async {
    if (_activeWorkspaceId != null) {
      // Update in Firestore (will update local via listener)
      await _firestoreService.updateCategory(updatedCategory);
      debugPrint("Category updated in Firestore: ${updatedCategory.name}");
    } else {
      // Update locally
      final categoryIndex = _categories.indexWhere((category) => category.id == updatedCategory.id);
      if (categoryIndex != -1) {
        _categories[categoryIndex] = updatedCategory;
        notifyListeners();
        await _saveCategoriesToStorage();
        debugPrint("Category updated locally: ${updatedCategory.name}");
      }
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    final category = getCategoryById(categoryId);
    if (category != null && !category.isPredefined) {
      if (_activeWorkspaceId != null) {
        // Delete from Firestore (will update local via listener)
        await _firestoreService.deleteCategory(categoryId);
        debugPrint("Category deleted from Firestore: ${category.name}");
      } else {
        // Delete locally
        _categories.removeWhere((category) => category.id == categoryId);
        notifyListeners();
        await _saveCategoriesToStorage();
        debugPrint("Category deleted locally: ${category.name}, Total categories: ${_categories.length}");
      }
    }
  }

  bool canDeleteCategory(String categoryId) {
    final category = getCategoryById(categoryId);
    return category != null && !category.isPredefined;
  }

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }
}
