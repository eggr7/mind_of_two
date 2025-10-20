import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context, categoryProvider),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Predefined Categories Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Predefined Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...categoryProvider.predefinedCategories.map<Widget>((category) =>
                        _buildCategoryTile(context, categoryProvider, category, false)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Custom Categories Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Custom Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddCategoryDialog(context, categoryProvider),
                          icon: const Icon(Icons.add),
                          label: const Text("Add"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (categoryProvider.customCategories.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No custom categories",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap 'Add' to create your first custom category",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...categoryProvider.customCategories.map<Widget>((category) =>
                          _buildCategoryTile(context, categoryProvider, category, true)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, CategoryProvider categoryProvider, Category category, bool canEdit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: category.colorValue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              category.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          canEdit ? "Custom category" : "Predefined category",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: canEdit
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditCategoryDialog(context, categoryProvider, category),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteCategoryDialog(context, categoryProvider, category),
                  ),
                ],
              )
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, CategoryProvider categoryProvider) {
    final nameController = TextEditingController();
    final iconController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Category"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: iconController,
                    decoration: const InputDecoration(
                      labelText: "Icon (emoji)",
                      border: OutlineInputBorder(),
                      hintText: "🏠",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Color",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.red,
                      Colors.purple,
                      Colors.teal,
                      Colors.indigo,
                      Colors.pink,
                    ].map((color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    )).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && iconController.text.isNotEmpty) {
                      final category = Category(
                        id: Category.generateId(),
                        name: nameController.text,
                        icon: iconController.text,
                        color: selectedColor.value,
                        isPredefined: false,
                      );
                      categoryProvider.addCategory(category);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Category added successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryProvider categoryProvider, Category category) {
    final nameController = TextEditingController(text: category.name);
    final iconController = TextEditingController(text: category.icon);
    Color selectedColor = category.colorValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Category"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: iconController,
                    decoration: const InputDecoration(
                      labelText: "Icon (emoji)",
                      border: OutlineInputBorder(),
                      hintText: "🏠",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Color",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.red,
                      Colors.purple,
                      Colors.teal,
                      Colors.indigo,
                      Colors.pink,
                    ].map((color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    )).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && iconController.text.isNotEmpty) {
                      final updatedCategory = Category(
                        id: category.id,
                        name: nameController.text,
                        icon: iconController.text,
                        color: selectedColor.value,
                        isPredefined: category.isPredefined,
                      );
                      categoryProvider.updateCategory(updatedCategory);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Category updated successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, CategoryProvider categoryProvider, Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text("Are you sure you want to delete '${category.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                categoryProvider.deleteCategory(category.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Category deleted successfully!"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
