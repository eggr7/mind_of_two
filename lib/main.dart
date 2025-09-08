import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';
import 'screens/completed_tasks_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init Hive
  await Hive.initFlutter();
  
  // Register the adapter for Task
  Hive.registerAdapter(TaskAdapter());
  
  // Open the box for tasks
  await Hive.openBox<Task>('tasks');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Mind of Two',
        theme: ThemeData(
          primaryColor: const Color(0xFF6C63FF),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6C63FF),
            secondary: Color(0xFFF50057),
            // background: Color(0xFFF8F9FA),
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            // onBackground: Color(0xFF212121),
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
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
            bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF424242)),
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
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
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
            icon: Icon(Icons.check_circle_outline),
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
