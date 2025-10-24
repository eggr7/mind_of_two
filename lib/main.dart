import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'models/task.dart';
import 'models/category.dart';
import 'providers/task_provider.dart';
import 'providers/category_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/workspace_provider.dart';
import 'services/notification_service.dart';
import 'screens/task_list_screen.dart';
import 'screens/completed_tasks_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/workspace/workspace_selector_screen.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✓ Firebase initialized');

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Init Hive with Flutter-specific directory
    await Hive.initFlutter();
    debugPrint('✓ Hive initialized');
    
    // Register the adapters (only once)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
      debugPrint('✓ TaskAdapter registered');
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
      debugPrint('✓ CategoryAdapter registered');
    }
    
    // Close boxes if they're already open (for hot restart)
    if (Hive.isBoxOpen('tasks')) {
      await Hive.box<Task>('tasks').close();
    }
    if (Hive.isBoxOpen('categories')) {
      await Hive.box<Category>('categories').close();
    }
    if (Hive.isBoxOpen('settings')) {
      await Hive.box<dynamic>('settings').close();
    }
    
    // Open the boxes
    await Hive.openBox<Task>('tasks');
    debugPrint('✓ Tasks box opened with ${Hive.box<Task>('tasks').length} items');
    
    await Hive.openBox<Category>('categories');
    debugPrint('✓ Categories box opened with ${Hive.box<Category>('categories').length} items');
    
    await Hive.openBox<dynamic>('settings');
    debugPrint('✓ Settings box opened');
    
    // Check if we need to migrate data (clear corrupted data)
    final tasksBox = Hive.box<Task>('tasks');
    try {
      tasksBox.values.toList();
      debugPrint('✓ Tasks data is valid');
    } catch (e) {
      debugPrint('⚠️ Corrupted task data detected, clearing: $e');
      await tasksBox.clear();
      debugPrint('✓ Tasks box cleared');
    }
  } catch (e) {
    debugPrint('✗ Error initializing app: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => WorkspaceProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..initialize()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Mind of Two',
            themeMode: themeProvider.themeMode,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: const AuthGate(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6C63FF),
        secondary: Color(0xFFF50057),
        background: Color(0xFFF8F9FA),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFF212121),
        onSurface: Color(0xFF212121),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF212121),
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF212121),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6C63FF),
        unselectedItemColor: Color(0xFF9E9E9E),
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6C63FF),
        secondary: Color(0xFFF50057),
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFFE1E1E1),
        onSurface: Color(0xFFE1E1E1),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Color(0xFFE1E1E1),
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFE1E1E1),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF6C63FF),
        unselectedItemColor: Color(0xFF9E9E9E),
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
      ),
    );
  }
}

// Auth Gate - handles navigation based on authentication state
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final NotificationService _notificationService = NotificationService();
  String? _initializedWorkspaceUserId;
  String? _initializedTaskWorkspaceId;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<AuthProvider, WorkspaceProvider, TaskProvider, CategoryProvider>(
      builder: (context, authProvider, workspaceProvider, taskProvider, categoryProvider, child) {
        debugPrint('🔄 AuthGate: Building...');
        debugPrint('   - isAuthenticated: ${authProvider.isAuthenticated}');
        debugPrint('   - hasWorkspace: ${workspaceProvider.hasWorkspace}');
        debugPrint('   - activeWorkspace: ${workspaceProvider.activeWorkspace?.name}');
        debugPrint('   - workspaces count: ${workspaceProvider.workspaces.length}');
        
        // Show loading while checking auth state
        if (authProvider.currentUser == null && authProvider.isLoading) {
          debugPrint('🔄 AuthGate: Showing loading screen');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not authenticated - show welcome screen
        if (!authProvider.isAuthenticated) {
          debugPrint('🔄 AuthGate: User not authenticated → WelcomeScreen');
          // Reset initialization flags when user logs out
          _initializedWorkspaceUserId = null;
          _initializedTaskWorkspaceId = null;
          return const WelcomeScreen();
        }

        // Authenticated but no workspace - show workspace selector
        if (!workspaceProvider.hasWorkspace) {
          debugPrint('🔄 AuthGate: User authenticated but no workspace → WorkspaceSelectorScreen');
          // Initialize workspace provider with user ID (only once per user)
          if (authProvider.currentUser != null && 
              _initializedWorkspaceUserId != authProvider.currentUser!.uid) {
            _initializedWorkspaceUserId = authProvider.currentUser!.uid;
            debugPrint('🔄 AuthGate: Initializing WorkspaceProvider for user ${authProvider.currentUser!.uid}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              workspaceProvider.initialize(authProvider.currentUser!.uid);
            });
          }
          return const WorkspaceSelectorScreen();
        }

        // Authenticated with workspace - connect providers and show main app
        debugPrint('🔄 AuthGate: User authenticated with workspace → HomeScreen');
        if (workspaceProvider.activeWorkspace != null && authProvider.currentUser != null) {
          final workspaceId = workspaceProvider.activeWorkspace!.id;
          // Only initialize providers once per workspace change
          if (_initializedTaskWorkspaceId != workspaceId) {
            _initializedTaskWorkspaceId = workspaceId;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              debugPrint('✅ Connecting TaskProvider to workspace: $workspaceId');
              taskProvider.setActiveWorkspace(
                workspaceId,
                authProvider.currentUser!.uid,
              );
              debugPrint('✅ Connecting CategoryProvider to workspace: $workspaceId');
              categoryProvider.setActiveWorkspace(workspaceId);
            });
          }
        }

        return const HomeScreen();
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TaskListScreen(),
    const CalendarScreen(),
    const CompletedTasksScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outlined),
            activeIcon: Icon(Icons.check_circle),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}