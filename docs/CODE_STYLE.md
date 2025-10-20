# Code Style Guide

This document defines the coding standards for Mind of Two. Following these guidelines ensures consistency and maintainability across the codebase.

## Table of Contents

- [Language Requirements](#language-requirements)
- [Naming Conventions](#naming-conventions)
- [File Organization](#file-organization)
- [Code Formatting](#code-formatting)
- [Dart Best Practices](#dart-best-practices)
- [Flutter Best Practices](#flutter-best-practices)
- [Comments and Documentation](#comments-and-documentation)
- [Error Handling](#error-handling)
- [State Management](#state-management)
- [Testing](#testing)

## Language Requirements

### ⚠️ Critical Rule: English Only

**ALL code must be written in English**, including:

✅ **Allowed in English**:
- Variable names
- Function names
- Class names
- File names
- Comments
- Documentation strings
- Commit messages (preferred)
- Error messages in code

❌ **Never in Code**:
- Spanish variable names
- Spanish comments
- Spanish class names
- Spanish function names

```dart
// ✅ GOOD
class TaskProvider {
  List<Task> tasks = [];
  
  /// Adds a new task to the list
  void addTask(Task task) {
    tasks.add(task);
  }
}

// ❌ BAD
class ProveedorDeTareas {
  List<Tarea> tareas = [];
  
  /// Añade una nueva tarea a la lista
  void agregarTarea(Tarea tarea) {
    tareas.add(tarea);
  }
}
```

**Spanish is only acceptable for**:
- User-facing UI text (prepare for localization)
- Discussion in issues/PRs (optional)
- Communication with project owner

## Naming Conventions

### Classes, Enums, and Typedefs

Use `PascalCase`:

```dart
// Classes
class TaskProvider {}
class UserProfile {}
class DatabaseHelper {}

// Enums
enum TaskPriority { urgent, important, normal }
enum AssignmentType { me, partner, both }

// Typedefs
typedef TaskCallback = void Function(Task task);
```

### Variables and Parameters

Use `camelCase`:

```dart
// Variables
String taskTitle;
int numberOfTasks;
bool isCompleted;

// Parameters
void updateTask(String taskId, Task updatedTask) {}

// Private variables
String _internalState;
List<Task> _cachedTasks;
```

### Functions and Methods

Use `camelCase`:

```dart
// Public methods
void loadTasks() {}
Future<void> saveToDatabase() async {}
List<Task> getFilteredTasks(String filter) {}

// Private methods
void _updateLocalCache() {}
Future<void> _performNetworkRequest() async {}
```

### Constants

Use `camelCase` with `const` or `final`:

```dart
// Constants
const primaryColor = Color(0xFF6C63FF);
const defaultPadding = 16.0;
const apiTimeout = Duration(seconds: 30);

// Compile-time constants
const String appName = 'Mind of Two';
const int maxTasksPerPage = 20;

// Runtime constants
final now = DateTime.now();
final deviceInfo = DeviceInfo.current;
```

### Files

Use `snake_case.dart`:

```dart
// Screen files
task_list_screen.dart
edit_task_screen.dart
calendar_screen.dart

// Widget files
task_card.dart
priority_chip.dart

// Model files
task.dart
user.dart

// Service files
storage_service.dart
api_service.dart

// Provider files
task_provider.dart
auth_provider.dart
```

## File Organization

### Import Order

1. Dart SDK imports
2. Flutter imports
3. Package imports
4. Relative imports

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

// 4. Relative imports
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
```

### File Structure

```dart
// 1. Imports
import 'package:flutter/material.dart';

// 2. Constants (if any)
const _kDefaultPadding = 16.0;

// 3. Main class
class TaskListScreen extends StatefulWidget {
  // Constructor
  const TaskListScreen({super.key});
  
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

// 4. State class (if StatefulWidget)
class _TaskListScreenState extends State<TaskListScreen> {
  // 4.1 Fields
  String _currentFilter = 'all';
  
  // 4.2 Lifecycle methods
  @override
  void initState() {
    super.initState();
  }
  
  // 4.3 Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(/* ... */);
  }
  
  // 4.4 Private methods
  void _updateFilter(String filter) {
    setState(() => _currentFilter = filter);
  }
  
  Widget _buildHeader() {
    return Container(/* ... */);
  }
}

// 5. Helper classes or widgets (if needed)
class _TaskListItem extends StatelessWidget {
  /* ... */
}
```

## Code Formatting

### Line Length

- Target: **80 characters**
- Maximum: **120 characters** (only when necessary)

```dart
// ✅ GOOD
final taskProvider = Provider.of<TaskProvider>(
  context,
  listen: false,
);

// ❌ BAD - Too long
final taskProvider = Provider.of<TaskProvider>(context, listen: false);
```

### Trailing Commas

Always use trailing commas for better formatting:

```dart
// ✅ GOOD
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    child: Text('Hello'),
  );
}

// ❌ BAD - No trailing commas
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Text('Hello')
  );
}
```

### Indentation

- Use **2 spaces** for indentation (Flutter default)
- Never use tabs

### Spacing

```dart
// ✅ GOOD - Spaces around operators
int total = count + 1;
bool isValid = value > 0 && value < 100;

// ❌ BAD - No spaces
int total=count+1;
bool isValid=value>0&&value<100;

// ✅ GOOD - Space after comma
void updateTask(String id, Task task, bool notify) {}

// ❌ BAD - No space after comma
void updateTask(String id,Task task,bool notify) {}
```

## Dart Best Practices

### Type Annotations

Always specify types for clarity:

```dart
// ✅ GOOD
final String title = 'Task';
final List<Task> tasks = [];
final Map<String, int> counts = {};

// ❌ BAD - Unclear types
final title = 'Task';
final tasks = [];
final counts = {};
```

### Const Constructors

Use `const` whenever possible:

```dart
// ✅ GOOD
const Text('Static text')
const SizedBox(height: 16)
const Padding(padding: EdgeInsets.all(8))

// ❌ BAD - Missing const
Text('Static text')
SizedBox(height: 16)
```

### Final vs Var

Prefer `final` over `var`:

```dart
// ✅ GOOD
final String name = 'John';
final count = 5; // Type inferred

// ⚠️ OK - Value will change
var counter = 0;
counter++;

// ❌ BAD - Should use final
var name = 'John';
```

### Null Safety

Use null-safety operators correctly:

```dart
// Null-aware access
final length = text?.length;

// Null-coalescing
final value = nullableValue ?? defaultValue;

// Null assertion (use sparingly)
final length = text!.length; // Only when 100% sure

// Late initialization
late final String computedValue;
```

### Collections

```dart
// ✅ GOOD - Use collection literals
final list = <String>[];
final map = <String, int>{};
final set = <int>{};

// ❌ BAD - Don't use constructors
final list = List<String>();
final map = Map<String, int>();
final set = Set<int>();

// ✅ GOOD - Use spread operator
final combined = [...list1, ...list2];

// ✅ GOOD - Use collection if
final items = [
  'Always shown',
  if (condition) 'Conditional item',
];
```

### String Interpolation

```dart
// ✅ GOOD
final message = 'Hello $name';
final info = 'Task: ${task.title}';

// ❌ BAD
final message = 'Hello ' + name;
final info = 'Task: ' + task.title.toString();
```

### Expression Bodies

Use for simple functions:

```dart
// ✅ GOOD - Simple expression
bool get isEmpty => tasks.isEmpty;
String get title => task.title;

// ✅ GOOD - Multi-line needs braces
List<Task> getFilteredTasks(String filter) {
  return tasks.where((task) => task.priority == filter).toList();
}

// ❌ BAD - Too complex for expression body
bool get isValid => tasks.isNotEmpty && tasks.length > 0 && tasks.first.completed;
```

## Flutter Best Practices

### Widget Organization

Extract complex widgets:

```dart
// ✅ GOOD - Extracted widget
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Tasks'));
  }
  
  Widget _buildBody() {
    return ListView(/* ... */);
  }
}

// ❌ BAD - Everything in one method
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [/* 20 lines */],
      ),
      body: ListView(/* 50 lines */),
    );
  }
}
```

### StatefulWidget vs StatelessWidget

```dart
// Use StatelessWidget when no mutable state
class TaskCard extends StatelessWidget {
  final Task task;
  
  const TaskCard({super.key, required this.task});
  
  @override
  Widget build(BuildContext context) {
    return Card(/* ... */);
  }
}

// Use StatefulWidget when managing state
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _filter = 'all';
  
  @override
  Widget build(BuildContext context) {
    // Use _filter
  }
}
```

### Keys

Use keys when necessary:

```dart
// Use ValueKey for widgets in lists
ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (context, index) {
    return TaskCard(
      key: ValueKey(tasks[index].id),
      task: tasks[index],
    );
  },
)

// Use GlobalKey for accessing widget state
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: /* ... */,
)
```

### Async/Await

```dart
// ✅ GOOD
Future<void> loadTasks() async {
  try {
    final tasks = await StorageService.loadTasks();
    setState(() => _tasks = tasks);
  } catch (e) {
    print('Error loading tasks: $e');
  }
}

// ❌ BAD - Not handling errors
Future<void> loadTasks() async {
  final tasks = await StorageService.loadTasks();
  setState(() => _tasks = tasks);
}
```

## Comments and Documentation

### Documentation Comments

Use `///` for public APIs:

```dart
/// Adds a new task to the list and persists it to storage.
///
/// The [task] parameter must have a unique ID. If the task
/// already exists, it will not be added.
///
/// Throws a [StorageException] if persistence fails.
///
/// Example:
/// ```dart
/// final task = Task(id: '1', title: 'Buy milk');
/// await taskProvider.addTask(task);
/// ```
Future<void> addTask(Task task) async {
  // Implementation
}
```

### Implementation Comments

Use `//` for explaining complex logic:

```dart
// ✅ GOOD - Explains WHY
// Sort by priority (urgent first) then by due date
tasks.sort((a, b) {
  final priorityComparison = _getPriorityValue(a).compareTo(_getPriorityValue(b));
  return priorityComparison != 0 
      ? priorityComparison 
      : (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100));
});

// ❌ BAD - States the obvious
// Loop through tasks
for (var task in tasks) {
  // Add task to list
  newTasks.add(task);
}
```

### TODOs

Use standardized format:

```dart
// TODO: Implement pagination for large task lists
// FIXME: This causes a memory leak
// HACK: Temporary workaround for Provider initialization
// NOTE: This behavior may change in future versions
```

## Error Handling

### Try-Catch

```dart
// ✅ GOOD
Future<void> saveTask(Task task) async {
  try {
    await StorageService.saveTask(task);
    _showSuccessMessage();
  } on StorageException catch (e) {
    _showErrorMessage('Failed to save: ${e.message}');
  } catch (e) {
    _showErrorMessage('Unexpected error: $e');
  }
}
```

### User Feedback

```dart
// Always provide feedback for async operations
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Task saved successfully'),
    backgroundColor: Colors.green,
  ),
);
```

## State Management

### Provider Pattern

```dart
// ✅ GOOD - Listen only when needed
final taskProvider = Provider.of<TaskProvider>(context, listen: false);
taskProvider.addTask(task);

// ✅ GOOD - Use Consumer for specific rebuilds
Consumer<TaskProvider>(
  builder: (context, taskProvider, child) {
    return Text('${taskProvider.tasks.length} tasks');
  },
)

// ❌ BAD - Unnecessary rebuilds
final taskProvider = Provider.of<TaskProvider>(context);
```

### ChangeNotifier

```dart
class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  
  // Always call notifyListeners after state change
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners(); // ✅ Good
  }
}
```

## Testing

### Test Naming

```dart
// ✅ GOOD - Descriptive names
test('addTask should add task to list and notify listeners', () {
  // ...
});

testWidgets('TaskCard displays task title', (tester) async {
  // ...
});

// ❌ BAD - Vague names
test('test1', () {});
testWidgets('widget test', (tester) async {});
```

### Test Structure

```dart
test('description', () {
  // Arrange
  final provider = TaskProvider();
  final task = Task(/* ... */);
  
  // Act
  provider.addTask(task);
  
  // Assert
  expect(provider.tasks.length, 1);
  expect(provider.tasks.first, task);
});
```

## Checklist

Before committing code, ensure:

- [ ] All code and comments are in English
- [ ] Code follows naming conventions
- [ ] Imports are organized correctly
- [ ] Using `const` where possible
- [ ] Trailing commas added
- [ ] Code formatted (`dart format .`)
- [ ] No linter warnings (`flutter analyze`)
- [ ] Tests pass (`flutter test`)
- [ ] Documentation added for public APIs
- [ ] Complex logic has explanatory comments

---

For more information, see:
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

