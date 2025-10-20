import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart' as models;
import '../services/storage_service.dart';

class CategoryProvider with ChangeNotifier {
  List<models.Category> _categories = [];
  bool _isInitialized = false;

  List<models.Category> get categories => _categories;
  List<models.Category> get predefinedCategories => _categories.where((cat) => cat.isPredefined).toList();
  List<models.Category> get customCategories => _categories.where((cat) => !cat.isPredefined).toList();

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _loadCategoriesFromStorage();
      if (_categories.isEmpty) {
        await _createPredefinedCategories();
      }
      _isInitialized = true;
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
        id: "home",
        name: "Home",
        icon: "🏠",
        color: 0xFF2196F3, // Blue
        isPredefined: true,
      ),
      models.Category(
        id: "pets",
        name: "Pets",
        icon: "🐾",
        color: 0xFF4CAF50, // Green
        isPredefined: true,
      ),
      models.Category(
        id: "to_buy",
        name: "To Buy",
        icon: "🛒",
        color: 0xFFFF9800, // Orange
        isPredefined: true,
      ),
    ];

    _categories.addAll(predefined);
    await _saveCategoriesToStorage();
    notifyListeners();
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
    _categories.add(category);
    notifyListeners();
    await _saveCategoriesToStorage();
    debugPrint("Category added: ${category.name}, Total categories: ${_categories.length}");
  }

  Future<void> updateCategory(models.Category updatedCategory) async {
    final categoryIndex = _categories.indexWhere((category) => category.id == updatedCategory.id);
    if (categoryIndex != -1) {
      _categories[categoryIndex] = updatedCategory;
      notifyListeners();
      await _saveCategoriesToStorage();
      debugPrint("Category updated: ${updatedCategory.name}");
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    final category = getCategoryById(categoryId);
    if (category != null && !category.isPredefined) {
      _categories.removeWhere((category) => category.id == categoryId);
      notifyListeners();
      await _saveCategoriesToStorage();
      debugPrint("Category deleted: ${category.name}, Total categories: ${_categories.length}");
    }
  }

  bool canDeleteCategory(String categoryId) {
    final category = getCategoryById(categoryId);
    return category != null && !category.isPredefined;
  }

}
