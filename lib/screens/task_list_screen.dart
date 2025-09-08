import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import './edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _currentFilter = "all";

  @override
  void initState() {
    super.initState();
    // La carga de datos ahora la maneja TaskProvider automáticamente
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.getFilteredTasks(_currentFilter);
    final allTasks = taskProvider.tasks;
    final activeTasksCount = allTasks.where((task) => !task.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Tasks"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          _buildFilterChip("All", "all"),
          _buildFilterChip("Urgent", "urgent"),
          _buildFilterChip("Important", "important"),
        ],
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: Column(
          children: [
            // Header with task count
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$activeTasksCount active of ${allTasks.length} total tasks",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF616161),
                    ),
                  ),
                  if (_currentFilter != "all")
                    GestureDetector(
                      onTap: () => setState(() => _currentFilter = "all"),
                      child: const Text(
                        "Clear filter",
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Task list
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                          onDelete: () => _showDeleteDialog(context, task),
                          onToggle: () => taskProvider.toggleTask(task.id),
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTaskScreen(task: task),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditTaskScreen(
                task: Task(
                  id: Task.generateId(),
                  title: "",
                  description: "",
                  assignedTo: "both",
                  priority: "normal",
                  completed: false,
                  createdAt: DateTime.now(),
                ),
                isNew: true,
              ),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 64,
            color: const Color(0xFF9E9E9E),
          ),
          const SizedBox(height: 16),
          const Text(
            "No tasks found",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Try changing your filter or add a new task",
            style: TextStyle(color: Color(0xFF9E9E9E)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: Text("Are you sure you want to delete '${task.title}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(task.id);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _currentFilter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6C63FF),
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _currentFilter = selected ? value : "all";
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF6C63FF),
        checkmarkColor: Colors.white,
        side: const BorderSide(color: Color(0xFF6C63FF)),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : const Color(0xFFE0E0E0),
          ),
        ),
      ),
    );
  }
}