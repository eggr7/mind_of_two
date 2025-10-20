# Contributing to Mind of Two

First off, thank you for considering contributing to Mind of Two! It's people like you that make Mind of Two such a great tool for couples managing shared tasks.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your First Code Contribution](#your-first-code-contribution)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
- [Style Guidelines](#style-guidelines)
  - [Git Commit Messages](#git-commit-messages)
  - [Code Style](#code-style)
  - [Documentation](#documentation)
- [Testing Guidelines](#testing-guidelines)
- [Project Structure](#project-structure)

## Code of Conduct

This project and everyone participating in it is governed by a code of conduct. By participating, you are expected to uphold this code. Please be respectful, inclusive, and considerate in all interactions.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

**Bug Report Template**:

```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - OS: [e.g. Windows 11, macOS 13, Ubuntu 22.04]
 - Flutter Version: [e.g. 3.9.2]
 - Device: [e.g. Pixel 6, iPhone 14, Desktop]
 - App Version: [e.g. 1.0.0]

**Additional context**
Add any other context about the problem here.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

**Enhancement Template**:

```markdown
**Is your feature request related to a problem?**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.

**Would you like to work on this feature?**
Let us know if you're interested in implementing this yourself.
```

### Your First Code Contribution

Unsure where to begin? You can start by looking through `good-first-issue` and `help-wanted` issues:

- **Good First Issues**: Simple issues that should only require a few lines of code
- **Help Wanted**: More involved issues that require deeper understanding

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our style guidelines
3. **Test your changes** thoroughly
4. **Update documentation** if needed
5. **Submit a pull request** with a clear description

**Pull Request Template**:

```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Related Issue
Fixes #(issue number)

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- [ ] I have tested this code locally
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] All new and existing tests passed

## Screenshots (if applicable)
Add screenshots to demonstrate the changes.

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have added tests that prove my fix is effective or that my feature works
```

## Development Setup

### Prerequisites

1. **Flutter SDK** (3.9.2 or higher)
   ```bash
   # Verify installation
   flutter --version
   ```

2. **IDE** (choose one):
   - [VS Code](https://code.visualstudio.com/) with Flutter extension
   - [Android Studio](https://developer.android.com/studio)
   - [IntelliJ IDEA](https://www.jetbrains.com/idea/)

3. **Git**
   ```bash
   # Verify installation
   git --version
   ```

### Setup Steps

1. **Fork and Clone**
   ```bash
   # Fork the repository on GitHub, then:
   git clone https://github.com/YOUR-USERNAME/mind_of_two.git
   cd mind_of_two
   ```

2. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/eggr7/mind_of_two.git
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate Code** (for Hive adapters)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Verify Setup**
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

6. **Run the App**
   ```bash
   flutter run
   ```

### Keeping Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream main into your local main
git checkout main
git merge upstream/main

# Push updates to your fork
git push origin main
```

## Style Guidelines

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable emoji:
  - ✨ `:sparkles:` New feature
  - 🐛 `:bug:` Bug fix
  - 📝 `:memo:` Documentation
  - 🎨 `:art:` Code style/formatting
  - ♻️ `:recycle:` Refactoring
  - ⚡ `:zap:` Performance improvement
  - ✅ `:white_check_mark:` Adding tests
  - 🔧 `:wrench:` Configuration changes

**Examples**:
```bash
git commit -m "✨ Add due date filtering to calendar view"
git commit -m "🐛 Fix task deletion bug in CompletedTasksScreen"
git commit -m "♻️ Refactor TaskProvider for better performance"
git commit -m "📝 Update README with installation instructions"
```

### Code Style

#### Language Requirements

⚠️ **IMPORTANT**: All code, comments, and documentation within source files MUST be in English. This includes:
- Variable names
- Function names
- Class names
- Comments
- Documentation strings

Spanish (or other languages) should only be used in:
- User-facing UI text (prepare for i18n)
- Commit messages (if preferred)
- Issue discussions

#### Dart/Flutter Conventions

1. **Follow Official Dart Style Guide**
   - Read: [Effective Dart](https://dart.dev/guides/language/effective-dart)
   - Use `flutter analyze` to check

2. **Naming Conventions**
   ```dart
   // Classes, enums, typedefs: PascalCase
   class TaskProvider {}
   enum TaskPriority {}
   
   // Variables, functions, parameters: camelCase
   String taskTitle;
   void loadTasks() {}
   
   // Constants: camelCase with const
   const primaryColor = Color(0xFF6C63FF);
   
   // Private members: prefix with underscore
   String _privateField;
   void _privateMethod() {}
   
   // Files: snake_case
   task_list_screen.dart
   ```

3. **Code Formatting**
   ```bash
   # Format all Dart files
   dart format .
   
   # Format specific file
   dart format lib/screens/task_list_screen.dart
   ```

4. **Import Organization**
   ```dart
   // 1. Dart imports
   import 'dart:async';
   
   // 2. Flutter imports
   import 'package:flutter/material.dart';
   
   // 3. Package imports
   import 'package:provider/provider.dart';
   import 'package:hive/hive.dart';
   
   // 4. Relative imports
   import '../models/task.dart';
   import '../providers/task_provider.dart';
   ```

5. **Use Trailing Commas**
   ```dart
   // Good - enables better formatting
   Widget build(BuildContext context) {
     return Container(
       padding: const EdgeInsets.all(16),
       child: Text('Hello'),
     );
   }
   ```

6. **Prefer const Constructors**
   ```dart
   // Good - better performance
   const Text('Static text')
   const SizedBox(height: 16)
   
   // Avoid if const is possible
   Text('Static text')
   ```

7. **Type Annotations**
   ```dart
   // Good - explicit types
   final String taskTitle = 'Buy groceries';
   final List<Task> tasks = [];
   
   // Avoid - unclear types
   final taskTitle = 'Buy groceries';
   final tasks = [];
   ```

### Documentation

1. **Public APIs**: Use `///` documentation comments
   ```dart
   /// Adds a new task to the list and persists it to storage.
   ///
   /// The [task] parameter must have a unique ID.
   /// Throws an exception if storage fails.
   Future<void> addTask(Task task) async {
     // Implementation
   }
   ```

2. **Complex Logic**: Add explaining comments
   ```dart
   // Calculate completion rate as a percentage
   // Handle division by zero for empty task lists
   final completionRate = totalTasks > 0 
       ? (completedTasks / totalTasks * 100).toStringAsFixed(1)
       : "0";
   ```

3. **TODOs**: Use standardized format
   ```dart
   // TODO: Add error handling for network failures
   // FIXME: This causes performance issues with large lists
   // HACK: Temporary workaround until Provider supports async initialization
   ```

## Testing Guidelines

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/providers/task_provider_test.dart

# Run with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Writing Tests

1. **Unit Tests**: Test individual functions and classes
   ```dart
   test('addTask should add task to list', () {
     final provider = TaskProvider();
     final task = Task(/* ... */);
     
     provider.addTask(task);
     
     expect(provider.tasks.length, 1);
     expect(provider.tasks.first.id, task.id);
   });
   ```

2. **Widget Tests**: Test UI components
   ```dart
   testWidgets('TaskCard displays task title', (WidgetTester tester) async {
     final task = Task(/* ... */);
     
     await tester.pumpWidget(
       MaterialApp(
         home: TaskCard(task: task),
       ),
     );
     
     expect(find.text(task.title), findsOneWidget);
   });
   ```

3. **Integration Tests**: Test complete flows
   - Located in `integration_test/` directory
   - Test real user scenarios

### Test Coverage Goals

- **Minimum**: 70% code coverage
- **Target**: 80%+ code coverage
- **Critical paths**: 100% coverage (task CRUD operations)

## Project Structure

Please familiarize yourself with the project structure before contributing:

```
lib/
├── main.dart              # Entry point
├── models/               # Data models
├── providers/            # State management
├── screens/              # Full-page screens
├── widgets/              # Reusable components
└── services/             # Business logic

test/                     # Unit and widget tests
integration_test/         # Integration tests
docs/                     # Additional documentation
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed information.

## Additional Resources

- [ARCHITECTURE.md](ARCHITECTURE.md) - Technical architecture details
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) - Development guide
- [docs/CODE_STYLE.md](docs/CODE_STYLE.md) - Detailed style guide
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Documentation](https://docs.hivedb.dev/)

## Questions?

If you have questions about contributing, feel free to:

- Open an issue with the `question` label
- Reach out to maintainers
- Check existing documentation

## Recognition

Contributors will be recognized in our README.md file. Thank you for making Mind of Two better!

---

**Happy Contributing! 🎉**

