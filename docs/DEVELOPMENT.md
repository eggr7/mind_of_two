# Development Guide

This guide provides detailed information for developers working on Mind of Two.

## Table of Contents

- [Environment Setup](#environment-setup)
- [Development Workflow](#development-workflow)
- [Running the Application](#running-the-application)
- [Building the Application](#building-the-application)
- [Debugging](#debugging)
- [Common Development Tasks](#common-development-tasks)
- [Tools and Extensions](#tools-and-extensions)
- [Troubleshooting](#troubleshooting)

## Environment Setup

### System Requirements

**Minimum Requirements**:
- RAM: 8GB (16GB recommended)
- Disk Space: 10GB free space
- OS: Windows 10+, macOS 10.14+, or Ubuntu 18.04+

### Install Flutter

#### Windows
```powershell
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin

# Verify installation
flutter doctor
```

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or download from https://flutter.dev/docs/get-started/install/macos

# Verify installation
flutter doctor
```

#### Linux
```bash
# Download Flutter SDK
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
tar xf flutter_linux_3.9.2-stable.tar.xz

# Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### Platform-Specific Setup

#### Android Development

1. **Install Android Studio**
   - Download from [https://developer.android.com/studio](https://developer.android.com/studio)
   - Install during setup: Android SDK, Android SDK Platform, Android Virtual Device

2. **Configure Android SDK**
   ```bash
   flutter config --android-sdk /path/to/android/sdk
   ```

3. **Accept Licenses**
   ```bash
   flutter doctor --android-licenses
   ```

4. **Create Virtual Device** (optional)
   - Open Android Studio → AVD Manager
   - Create a new device (Pixel 6, API 33 recommended)

#### iOS Development (macOS only)

1. **Install Xcode**
   ```bash
   # From App Store or
   xcode-select --install
   ```

2. **Configure Xcode**
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

4. **Accept Xcode License**
   ```bash
   sudo xcodebuild -license accept
   ```

#### Desktop Development

**Windows**:
- Visual Studio 2022 with C++ desktop development tools

**macOS**:
- Xcode (already installed for iOS)

**Linux**:
```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

### IDE Setup

#### VS Code (Recommended)

1. **Install VS Code**
   - Download from [https://code.visualstudio.com/](https://code.visualstudio.com/)

2. **Install Extensions**
   - Flutter (includes Dart)
   - Dart Data Class Generator (optional)
   - Error Lens (optional)
   - GitLens (optional)

3. **Configure Settings**
   ```json
   {
     "dart.flutterSdkPath": "/path/to/flutter",
     "dart.lineLength": 80,
     "editor.formatOnSave": true,
     "editor.rulers": [80],
     "[dart]": {
       "editor.defaultFormatter": "Dart-Code.dart-code",
       "editor.formatOnSave": true,
       "editor.selectionHighlight": false,
       "editor.suggest.snippetsPreventQuickSuggestions": false,
       "editor.suggestSelection": "first",
       "editor.tabCompletion": "onlySnippets",
       "editor.wordBasedSuggestions": false
     }
   }
   ```

#### Android Studio

1. **Install Plugins**
   - Flutter plugin
   - Dart plugin

2. **Configure Flutter SDK**
   - Settings → Languages & Frameworks → Flutter
   - Set Flutter SDK path

## Development Workflow

### 1. Create a Feature Branch

```bash
# Ensure main is up to date
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/task-categories

# Or for bug fixes
git checkout -b fix/task-deletion-bug
```

### 2. Make Changes

- Write code following style guidelines
- Add tests for new functionality
- Update documentation as needed

### 3. Test Locally

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Run app
flutter run
```

### 4. Commit Changes

```bash
git add .
git commit -m "✨ Add task categories feature"
```

### 5. Push and Create PR

```bash
git push origin feature/task-categories

# Then create a Pull Request on GitHub
```

## Running the Application

### Development Mode (Debug)

```bash
# List available devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d chrome           # Web
flutter run -d windows          # Windows
flutter run -d macos            # macOS
flutter run -d emulator-5554    # Android emulator
flutter run -d "iPhone 14"      # iOS simulator

# Run with custom entry point
flutter run -t lib/main_dev.dart
```

### Hot Reload

While app is running:
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `p` to show performance overlay
- Press `o` to toggle platform (Android/iOS)
- Press `q` to quit

### Release Mode

```bash
# Android
flutter run --release

# iOS
flutter run --release -d "iPhone 14"

# Desktop
flutter run --release -d windows
```

## Building the Application

### Android

**APK (for testing)**:
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**App Bundle (for Play Store)**:
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**Split APKs by ABI**:
```bash
flutter build apk --split-per-abi --release
# Generates separate APKs for arm64-v8a, armeabi-v7a, x86_64
```

### iOS

```bash
# Build for simulator
flutter build ios --debug --simulator

# Build for device
flutter build ios --release

# Create IPA for App Store
flutter build ipa --release
# Output: build/ios/ipa/mind_of_two.ipa
```

### Windows

```bash
flutter build windows --release
# Output: build\windows\runner\Release\
```

### macOS

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/mind_of_two.app
```

### Linux

```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

### Web

```bash
# Build for web
flutter build web --release

# Build with canvas renderer (better performance)
flutter build web --release --web-renderer canvaskit

# Build with HTML renderer (smaller size)
flutter build web --release --web-renderer html

# Output: build/web/
```

## Debugging

### Debug Tools

**Flutter DevTools**:
```bash
# Open DevTools in browser
flutter pub global activate devtools
flutter pub global run devtools
```

**Debug in IDE**:
- VS Code: F5 or Run → Start Debugging
- Android Studio: Shift+F10 or Run → Debug

### Print Debugging

```dart
// Simple print
print('Task added: ${task.title}');

// Debug print (stripped in release)
debugPrint('Debug info: $value');

// Pretty print objects
import 'dart:developer' as developer;
developer.log('Task data', name: 'TaskProvider', error: task);
```

### Breakpoints

- VS Code: Click left of line number
- Android Studio: Click left gutter
- Set conditional breakpoints for specific cases

### Performance Profiling

```bash
# Run with performance overlay
flutter run --profile

# Enable performance monitoring
# In DevTools → Performance tab
```

### Memory Debugging

```bash
# Run with memory profiling
flutter run --profile

# Take memory snapshot
# In DevTools → Memory tab
```

## Common Development Tasks

### Generate Hive Adapters

When you modify models with `@HiveType`:

```bash
# One-time generation
flutter pub run build_runner build

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (continuous generation)
flutter pub run build_runner watch
```

### Add a New Dependency

```bash
# Add to dependencies
flutter pub add provider

# Add to dev_dependencies
flutter pub add --dev flutter_test

# Get all dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

### Clean Build

```bash
# Clean build files
flutter clean

# Get dependencies again
flutter pub get

# Rebuild
flutter run
```

### Analyze Code

```bash
# Analyze all code
flutter analyze

# Analyze specific directory
flutter analyze lib/screens

# Fix auto-fixable issues
dart fix --apply
```

### Format Code

```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart

# Check formatting without changing
dart format --output=none --set-exit-if-changed .
```

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/providers/task_provider_test.dart

# With coverage
flutter test --coverage

# Update golden files (for golden tests)
flutter test --update-goldens

# Run integration tests
flutter test integration_test/app_test.dart
```

### Database Operations

**View Hive Database**:
```dart
// In code
import 'package:hive_flutter/hive_flutter.dart';

void inspectDatabase() async {
  final box = Hive.box<Task>('tasks');
  print('Total tasks: ${box.length}');
  for (var task in box.values) {
    print('Task: ${task.title}');
  }
}
```

**Clear Database** (for testing):
```dart
// Delete all tasks
await Hive.box<Task>('tasks').clear();

// Delete entire database
await Hive.deleteBoxFromDisk('tasks');
```

### Update App Icons

```bash
# Install flutter_launcher_icons
flutter pub add --dev flutter_launcher_icons

# Configure in pubspec.yaml, then run
flutter pub run flutter_launcher_icons:main
```

### Update Splash Screen

```bash
# Install flutter_native_splash
flutter pub add --dev flutter_native_splash

# Configure in pubspec.yaml, then run
flutter pub run flutter_native_splash:create
```

## Tools and Extensions

### Recommended VS Code Extensions

- **Flutter** (Dart-Code.flutter)
- **Dart** (Dart-Code.dart-code)
- **Error Lens** (usernamehw.errorlens)
- **GitLens** (eamodio.gitlens)
- **Pubspec Assist** (jeroen-meijer.pubspec-assist)
- **Flutter Intl** (localizely.flutter-intl)
- **Flutter Widget Snippets** (alexisvt.flutter-snippets)

### Command Line Tools

```bash
# Flutter Doctor
flutter doctor -v

# Device logs
flutter logs

# Screenshot
flutter screenshot

# Install to device
flutter install

# Attach to running app
flutter attach
```

### Useful Packages

- **flutter_lints**: Linting rules
- **mocktail**: Mocking for tests
- **integration_test**: Integration testing
- **flutter_test**: Widget testing

## Troubleshooting

### Common Issues

**1. "Waiting for another flutter command to release the startup lock"**
```bash
# Delete lock file
rm /path/to/flutter/bin/cache/lockfile
```

**2. "Could not find a file named pubspec.yaml"**
```bash
# Ensure you're in project directory
cd mind_of_two
```

**3. "Version solving failed"**
```bash
flutter clean
flutter pub get
```

**4. "Gradle build failed"**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**5. "Hive box not found"**
```bash
# Regenerate adapters
flutter pub run build_runner build --delete-conflicting-outputs
```

**6. "Hot reload not working"**
- Use hot restart (R) instead
- Some changes require full restart

**7. "Build runner fails"**
```bash
flutter clean
flutter pub get
dart run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Getting Help

1. Check existing issues on GitHub
2. Run `flutter doctor` to check setup
3. Search on Stack Overflow
4. Ask in Flutter Discord/Slack
5. Create an issue with reproduction steps

## Performance Tips

1. Use `const` constructors
2. Avoid rebuilding entire widgets
3. Use `ListView.builder` for long lists
4. Profile before optimizing
5. Use DevTools to find bottlenecks

## Best Practices

1. **Commit often** with descriptive messages
2. **Test your changes** before pushing
3. **Keep branches focused** on single features
4. **Update documentation** with code changes
5. **Follow style guidelines** consistently
6. **Review your own code** before requesting review

---

Happy Developing! 🚀

