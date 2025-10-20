# Mind of Two - Shared Task Manager

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Windows%20|%20macOS%20|%20Linux-lightgrey)

Mind of Two is a modern, cross-platform Flutter application designed to help couples or partners manage shared tasks and responsibilities efficiently. With an intuitive interface and powerful features, it makes collaboration seamless and productive.

## 📱 Features

### 🎯 Task Management
- **Create Tasks**: Quickly add new tasks with title, description, assignee, priority, and due dates
- **Edit Tasks**: Modify task details at any time with a beautiful, user-friendly interface
- **Mark as Complete**: Toggle task completion status with a single tap
- **Delete Tasks**: Remove tasks individually or clear all completed tasks at once
- **Filter Tasks**: View tasks by priority (Urgent, Important, All)

### 📅 Calendar View
- **Visual Planning**: See all tasks organized by due date in an interactive calendar
- **Date Selection**: Tap any date to view tasks scheduled for that day
- **Priority Indicators**: Color-coded markers show task priorities at a glance
- **Quick Task Creation**: Add tasks directly from calendar with pre-filled due dates

### ✅ Completed Tasks
- **Achievement Tracking**: View all completed tasks in a dedicated screen
- **Restore Tasks**: Easily mark completed tasks as pending again
- **Bulk Actions**: Clear all completed tasks with a single action
- **Progress Visibility**: See your accomplishments and productivity

### ⚙️ Settings & Statistics
- **Task Statistics**: View total tasks, completed tasks, and completion rate
- **App Information**: Version details and support contact
- **Future Settings**: Placeholders for notifications, themes, and language preferences

## 🏗️ Architecture

Mind of Two follows Flutter best practices with a clean, maintainable architecture:

### State Management
- **Provider Pattern**: Centralized state management using the `provider` package
- **Reactive UI**: Automatic UI updates when data changes
- **Separation of Concerns**: Business logic separated from UI components

### Data Persistence
- **Hive Database**: Fast, lightweight NoSQL database for local storage
- **Type-Safe**: Generated adapters for type-safe data serialization
- **Efficient**: Optimized for mobile with minimal overhead

### Project Structure
```
lib/
├── main.dart                 # App entry point and configuration
├── models/                   # Data models
│   ├── task.dart            # Task model with Hive annotations
│   └── task.g.dart          # Generated Hive adapter
├── providers/               # State management
│   └── task_provider.dart   # Task state and business logic
├── screens/                 # UI screens
│   ├── task_list_screen.dart      # Main task list with filters
│   ├── calendar_screen.dart       # Calendar view with date selection
│   ├── completed_tasks_screen.dart # Completed tasks management
│   ├── edit_task_screen.dart      # Task creation/editing form
│   └── settings_screen.dart       # Settings and statistics
├── widgets/                 # Reusable UI components
│   └── task_card.dart       # Task display card widget
└── services/                # Business services
    └── storage_service.dart  # Hive database operations
```

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.9.2 or higher): [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (3.0 or higher): Comes with Flutter
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Git**: For version control
- **Platform-specific tools**:
  - Android: Android Studio and Android SDK
  - iOS: Xcode (macOS only)
  - Desktop: Platform-specific build tools

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/eggr7/mind_of_two.git
   cd mind_of_two
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (if not already generated):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Verify installation**:
   ```bash
   flutter doctor
   ```

5. **Run the application**:
   ```bash
   # List available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Run in debug mode (default)
   flutter run
   
   # Run in release mode
   flutter run --release
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS
```bash
flutter build ios --release
# Requires macOS and Xcode
```

#### Windows
```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

#### macOS
```bash
flutter build macos --release
# Requires macOS
```

#### Linux
```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

## 📖 Usage Guide

### Managing Tasks

**Adding a Task**:
1. Tap the floating action button (+) on the Tasks screen
2. Fill in the task details:
   - **Title**: Short description (required)
   - **Description**: Detailed information (optional)
   - **Assigned To**: Choose "Me", "Partner", or "Both"
   - **Priority**: Select "Urgent", "Important", or "Normal"
   - **Due Date**: Pick a date or leave empty
3. Tap "Add Task" to save

**Editing a Task**:
1. Tap on any task card in the list
2. Modify the desired fields
3. Tap "Save Changes" to update

**Completing a Task**:
- Tap the checkmark icon on a task card
- Task will be marked as complete and moved to Completed screen

**Deleting a Task**:
- Tap the delete icon on a task card
- Confirm deletion in the dialog

**Filtering Tasks**:
- Use the filter chips at the top: "All", "Urgent", "Important"
- Tap "Clear filter" to reset

### Using the Calendar

1. Navigate to the Calendar tab
2. View tasks by date with color-coded priority markers:
   - 🔴 Red: Urgent tasks
   - 🟠 Orange: Important tasks
   - 🔵 Blue: Normal tasks
   - 🟢 Green: All tasks completed
3. Tap any date to see tasks for that day
4. Tap a task to edit it
5. Use the floating action button to add a task with the selected date

### Task Properties

Each task contains:

| Property | Description | Options |
|----------|-------------|---------|
| **Title** | Short description of the task | Text (required) |
| **Description** | Detailed information | Text (optional) |
| **Assigned To** | Who is responsible | Me, Partner, Both |
| **Priority** | Task urgency level | Urgent, Important, Normal |
| **Due Date** | Deadline for completion | Date (optional) |
| **Completed** | Completion status | Boolean |
| **Created At** | Timestamp of creation | DateTime (auto) |

## 🛠️ Technologies Used

| Technology | Purpose | Version |
|------------|---------|---------|
| [Flutter](https://flutter.dev/) | Cross-platform UI framework | 3.9.2+ |
| [Dart](https://dart.dev/) | Programming language | 3.0+ |
| [Provider](https://pub.dev/packages/provider) | State management | 6.0.5 |
| [Hive](https://pub.dev/packages/hive) | Local database | 2.2.3 |
| [Hive Flutter](https://pub.dev/packages/hive_flutter) | Hive integration for Flutter | 1.1.0 |
| [Table Calendar](https://pub.dev/packages/table_calendar) | Calendar widget | 3.0.9 |
| [Intl](https://pub.dev/packages/intl) | Internationalization | 0.18.1 |

## 🧪 Testing

Run tests using:
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 🐛 Troubleshooting

### Common Issues

**Issue**: Build runner fails to generate adapters
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue**: Hive box not found error
```bash
# Solution: Ensure Hive is initialized before use
# Check main.dart for proper initialization
```

**Issue**: Hot reload not working
```bash
# Solution: Hot restart instead
# Press 'R' in terminal or use IDE hot restart button
```

**Issue**: Dependencies conflict
```bash
# Solution: Update dependencies
flutter pub upgrade
```

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Quick Contribution Guide

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

See [ARCHITECTURE.md](ARCHITECTURE.md) for technical details about the project structure.

## 📝 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

## 🗺️ Roadmap & Future Enhancements

- [ ] **User Authentication**
  - Email/password authentication
  - Social login (Google, Apple)
  - Multi-device synchronization

- [ ] **Cloud Synchronization**
  - Real-time sync across devices
  - Firebase/Supabase integration
  - Offline-first architecture

- [ ] **Notifications & Reminders**
  - Push notifications for due dates
  - Customizable reminder schedules
  - Daily task summaries

- [ ] **Recurring Tasks**
  - Daily, weekly, monthly patterns
  - Custom recurrence rules
  - Smart rescheduling

- [ ] **Categories & Tags**
  - Custom categories (Work, Home, Shopping, etc.)
  - Multiple tags per task
  - Color-coded organization

- [ ] **Advanced Features**
  - Task dependencies
  - Subtasks and checklists
  - File attachments
  - Task notes and comments

- [ ] **Analytics & Insights**
  - Productivity tracking
  - Completion trends
  - Time estimates
  - Workload distribution

- [ ] **Customization**
  - Dark mode support
  - Custom color themes
  - Multi-language support (Spanish, French, German, etc.)
  - Configurable date formats

- [ ] **Collaboration**
  - Shared task lists
  - Activity feed
  - @mentions
  - Task assignments

## 📞 Contact & Support

- **Project Link**: [https://github.com/eggr7/mind_of_two](https://github.com/eggr7/mind_of_two)
- **Issue Tracker**: [GitHub Issues](https://github.com/eggr7/mind_of_two/issues)
- **Email**: support@mindoftwo.com

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing framework
- [Provider Package](https://pub.dev/packages/provider) for state management
- [Hive Team](https://docs.hivedb.dev/) for the fast local database
- [Table Calendar](https://pub.dev/packages/table_calendar) for calendar functionality
- All contributors who help improve this project

---

Made with ❤️ using Flutter (and learning)
