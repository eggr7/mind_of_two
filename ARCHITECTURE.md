# Architecture Documentation

## Overview

Mind of Two is built using Flutter with a clean, maintainable architecture that separates concerns and follows industry best practices. The application uses the Provider pattern for state management and Hive for local data persistence.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [State Management](#state-management)
- [Data Persistence](#data-persistence)
- [Project Structure](#project-structure)
- [Data Flow](#data-flow)
- [Key Components](#key-components)
- [Design Patterns](#design-patterns)
- [Navigation Structure](#navigation-structure)

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                    Presentation Layer                │
│  (Screens & Widgets - UI Components)                │
│  - task_list_screen.dart                            │
│  - calendar_screen.dart                             │
│  - completed_tasks_screen.dart                      │
│  - edit_task_screen.dart                            │
│  - settings_screen.dart                             │
│  - task_card.dart (widget)                          │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ User Actions / State Updates
                  ▼
┌─────────────────────────────────────────────────────┐
│              Business Logic Layer                    │
│  (Providers - State Management)                     │
│  - TaskProvider (ChangeNotifier)                    │
│    * Manages task state                             │
│    * Handles business logic                         │
│    * Notifies UI of changes                         │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ Data Operations
                  ▼
┌─────────────────────────────────────────────────────┐
│                 Data Layer                           │
│  (Services & Models)                                │
│  - StorageService (Hive operations)                 │
│  - Task Model (Data structure)                      │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ Persistence
                  ▼
┌─────────────────────────────────────────────────────┐
│              Local Storage                           │
│  (Hive Database)                                    │
│  - tasks.hive (Task data)                           │
└─────────────────────────────────────────────────────┘
```

## State Management

### Provider Pattern

Mind of Two uses the **Provider** package for state management, which offers:

- **Simplicity**: Easy to understand and implement
- **Performance**: Efficient rebuilds only when necessary
- **Testability**: Business logic separated from UI
- **Scalability**: Easy to extend with additional providers

### TaskProvider

The central state manager of the application.

**Location**: `lib/providers/task_provider.dart`

**Responsibilities**:
- Maintain the list of tasks in memory
- Provide methods to manipulate tasks (add, update, delete, toggle)
- Filter tasks based on criteria (priority, completion status)
- Persist changes to local storage
- Notify listeners when state changes

**Key Methods**:

```dart
// Initialize provider and load data
Future<void> initialize()

// Add a new task
Future<void> addTask(Task task)

// Update existing task
Future<void> updateTask(Task updatedTask)

// Delete a task by ID
Future<void> deleteTask(String taskId)

// Toggle task completion status
Future<void> toggleTask(String taskId)

// Get filtered tasks
List<Task> getFilteredTasks(String filter)

// Clear all completed tasks
Future<void> clearCompletedTasks()

// Load sample data for testing
Future<void> loadSampleTasks()
```

**Usage in Widgets**:

```dart
// Access provider
final taskProvider = Provider.of<TaskProvider>(context);

// Access without rebuild
final taskProvider = Provider.of<TaskProvider>(context, listen: false);

// Using Consumer for granular rebuilds
Consumer<TaskProvider>(
  builder: (context, taskProvider, child) {
    return ListView.builder(
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) => TaskCard(task: taskProvider.tasks[index]),
    );
  },
)
```

## Data Persistence

### Hive Database

**Why Hive?**
- Lightning-fast NoSQL database written in pure Dart
- No native dependencies
- Type-safe with code generation
- Supports encryption
- Works on all platforms (mobile, desktop, web)
- Minimal overhead

### Data Models

#### Task Model

**Location**: `lib/models/task.dart`

**Structure**:
```dart
@HiveType(typeId: 0)
class Task {
  @HiveField(0) final String id;
  @HiveField(1) String title;
  @HiveField(2) String description;
  @HiveField(3) String assignedTo;    // "me" | "partner" | "both"
  @HiveField(4) String priority;      // "urgent" | "important" | "normal"
  @HiveField(5) bool completed;
  @HiveField(6) final DateTime createdAt;
  @HiveField(7) DateTime? dueDate;
}
```

**Field Descriptions**:
- `id`: Unique identifier (milliseconds since epoch)
- `title`: Task name (required)
- `description`: Detailed information (optional)
- `assignedTo`: Responsibility assignment
- `priority`: Urgency level
- `completed`: Completion status
- `createdAt`: Creation timestamp
- `dueDate`: Optional deadline

### Storage Service

**Location**: `lib/services/storage_service.dart`

Provides an abstraction layer over Hive operations:

```dart
class StorageService {
  // Save all tasks (overwrite)
  static Future<void> saveTasks(List<Task> tasks)
  
  // Load all tasks
  static List<Task> loadTasks()
  
  // Add single task
  static Future<void> addTask(Task task)
  
  // Update task
  static Future<void> updateTask(Task updatedTask)
  
  // Delete task
  static Future<void> deleteTask(String taskId)
  
  // Clear completed tasks
  static Future<void> clearCompletedTasks()
}
```

**Initialization Flow**:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Hive
  await Hive.initFlutter();
  
  // 2. Register adapters
  Hive.registerAdapter(TaskAdapter());
  
  // 3. Open boxes
  await Hive.openBox<Task>('tasks');
  
  // 4. Run app
  runApp(const MyApp());
}
```

## Project Structure

```
lib/
│
├── main.dart                          # Application entry point
│   ├── main()                         # Initializes Hive, runs app
│   ├── MyApp                          # Root widget, theme config
│   └── HomeScreen                     # Bottom navigation container
│
├── models/                            # Data models
│   ├── task.dart                      # Task model with Hive annotations
│   └── task.g.dart                    # Generated Hive adapter
│
├── providers/                         # State management
│   └── task_provider.dart             # Task state and business logic
│
├── screens/                           # Full-screen views
│   ├── task_list_screen.dart          # Main task list with filtering
│   ├── calendar_screen.dart           # Calendar view with date selection
│   ├── completed_tasks_screen.dart    # Completed tasks management
│   ├── edit_task_screen.dart          # Task creation and editing form
│   └── settings_screen.dart           # Settings and statistics
│
├── widgets/                           # Reusable UI components
│   └── task_card.dart                 # Task display card
│
└── services/                          # Business services
    └── storage_service.dart           # Hive database operations
```

## Data Flow

### Adding a Task

```
User fills form in EditTaskScreen
          │
          ▼
Form validation passes
          │
          ▼
TaskProvider.addTask(task) called
          │
          ▼
Task added to _tasks list in memory
          │
          ▼
StorageService.saveTasks() persists to Hive
          │
          ▼
notifyListeners() triggers UI rebuild
          │
          ▼
TaskListScreen rebuilds with new task
```

### Loading Tasks

```
App starts → main() executes
          │
          ▼
Hive initialized and box opened
          │
          ▼
MyApp creates TaskProvider
          │
          ▼
TaskProvider.initialize() called
          │
          ▼
StorageService.loadTasks() retrieves from Hive
          │
          ▼
Tasks loaded into _tasks list
          │
          ▼
notifyListeners() triggers initial render
          │
          ▼
UI displays tasks
```

### Updating a Task

```
User taps task → EditTaskScreen opens
          │
          ▼
User modifies fields
          │
          ▼
User taps "Save Changes"
          │
          ▼
Form validation passes
          │
          ▼
TaskProvider.updateTask(updatedTask) called
          │
          ▼
Task found in _tasks list and replaced
          │
          ▼
StorageService.saveTasks() persists changes
          │
          ▼
notifyListeners() triggers UI rebuild
          │
          ▼
TaskCard reflects updated information
```

## Key Components

### 1. Task List Screen

**File**: `lib/screens/task_list_screen.dart`

**Purpose**: Main screen displaying all active tasks with filtering

**Features**:
- Filter chips (All, Urgent, Important)
- Task count display
- Floating action button to add tasks
- Task cards with actions (edit, delete, complete)

**State**: Stateful (manages filter selection)

### 2. Calendar Screen

**File**: `lib/screens/calendar_screen.dart`

**Purpose**: Visual calendar view of tasks by due date

**Features**:
- Interactive table calendar
- Color-coded priority markers
- Date selection
- Daily task list
- Quick task creation with pre-selected date

**Dependencies**: `table_calendar` package

### 3. Edit Task Screen

**File**: `lib/screens/edit_task_screen.dart`

**Purpose**: Form for creating and editing tasks

**Features**:
- Text inputs (title, description)
- Dropdown selectors (assignee, priority)
- Date picker for due date
- Form validation
- Delete option (edit mode only)

**State**: Stateful (manages form state)

### 4. Task Card Widget

**File**: `lib/widgets/task_card.dart`

**Purpose**: Reusable component displaying task information

**Features**:
- Priority indicator icon
- Title and description
- Due date display
- Assignee chip
- Priority chip
- Action buttons (complete, delete)
- Visual feedback for completed tasks

**Widget Type**: StatelessWidget (receives callbacks)

## Design Patterns

### 1. Provider Pattern (State Management)

**Implementation**:
```dart
ChangeNotifierProvider(
  create: (context) => TaskProvider()..initialize(),
  child: MaterialApp(...),
)
```

**Benefits**:
- Centralized state
- Automatic UI updates
- Easy testing
- Minimal boilerplate

### 2. Repository Pattern (Data Access)

`StorageService` acts as a repository, abstracting Hive operations:

**Benefits**:
- Easy to swap storage implementations
- Simplified testing (mock the service)
- Clean separation of concerns

### 3. Builder Pattern (Lists)

Using `ListView.builder` for efficient rendering:

```dart
ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (context, index) => TaskCard(task: tasks[index]),
)
```

**Benefits**:
- Lazy loading
- Better performance
- Memory efficient

### 4. Callback Pattern (Widget Communication)

TaskCard uses callbacks to communicate with parent:

```dart
TaskCard(
  task: task,
  onEdit: () => navigateToEdit(task),
  onDelete: () => showDeleteDialog(task),
  onToggle: () => taskProvider.toggleTask(task.id),
)
```

## Navigation Structure

### Bottom Navigation

The app uses a `BottomNavigationBar` with 4 main sections:

```
HomeScreen (StatefulWidget)
│
├─ Index 0: TaskListScreen      (Tasks tab)
├─ Index 1: CalendarScreen      (Calendar tab)
├─ Index 2: CompletedTasksScreen (Completed tab)
└─ Index 3: SettingsScreen      (Settings tab)
```

### Modal Navigation

Task editing uses push navigation:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => EditTaskScreen(task: task),
  ),
);
```

### Navigation Flow

```
Main App
    │
    ├─ Tasks Screen
    │      └─ [Tap task] → Edit Task Screen
    │      └─ [Tap FAB] → Edit Task Screen (new)
    │
    ├─ Calendar Screen
    │      └─ [Tap task] → Edit Task Screen
    │      └─ [Tap FAB] → Edit Task Screen (new, with due date)
    │
    ├─ Completed Screen
    │      └─ [Tap delete] → Delete confirmation dialog
    │
    └─ Settings Screen
           └─ (Future: navigate to setting detail screens)
```

## Theme & Styling

### Theme Configuration

Defined in `main.dart`:

```dart
ThemeData(
  primaryColor: Color(0xFF6C63FF),       // Purple
  colorScheme: ColorScheme.light(...),
  appBarTheme: AppBarTheme(...),
  floatingActionButtonTheme: ...,
  bottomNavigationBarTheme: ...,
  textTheme: TextTheme(...),
  inputDecorationTheme: InputDecorationTheme(...),
)
```

### Design System

**Colors**:
- Primary: `#6C63FF` (Purple) - Main brand color
- Secondary: `#F50057` (Pink/Red) - Urgent priority
- Background: `#F8F9FA` - Screen background
- Surface: `#FFFFFF` - Cards, AppBar

**Spacing Scale**: 8, 16, 24, 32, 40, 48 (multiples of 8)

**Border Radius**: 8, 12, 16

**Elevation**: 1, 2, 4, 8

## Performance Considerations

### Optimizations Used

1. **Const Constructors**: Widgets that don't change use `const`
2. **ListView.builder**: Lazy loading for task lists
3. **Provider Granularity**: Single provider prevents over-rebuilding
4. **Efficient Storage**: Hive provides fast read/write operations
5. **Minimal Dependencies**: Only essential packages included

### Future Optimizations

- Implement pagination for large task lists
- Add indices to Hive for faster queries
- Use `Selector` instead of `Consumer` for specific fields
- Implement virtual scrolling for very long lists

## Testing Strategy

### Unit Tests
- Test TaskProvider methods
- Test Task model serialization
- Test StorageService operations

### Widget Tests
- Test UI rendering
- Test user interactions
- Test navigation

### Integration Tests
- Test complete user flows
- Test data persistence

## Future Architecture Considerations

### Cloud Sync
- Add remote repository layer
- Implement sync service
- Handle conflict resolution
- Offline-first approach

### Authentication
- Add auth provider
- Implement user service
- Secure local storage

### Multi-tenancy
- Support multiple users
- Share tasks between accounts
- Implement permissions

## Conclusion

Mind of Two follows a clean, scalable architecture that separates concerns and makes the codebase maintainable. The use of Provider for state management and Hive for persistence provides a solid foundation for future enhancements while keeping the app performant and responsive.

