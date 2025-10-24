import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/workspace_selector_widget.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final completedTasks = taskProvider.tasks.where((task) => task.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Tasks"),
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: WorkspaceSelectorWidget(),
        ),
        leadingWidth: 120,
        actions: [
          if (completedTasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _showClearAllDialog(context, taskProvider),
              tooltip: "Clear all completed tasks",
            ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: completedTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No completed tasks yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Complete some tasks to see them here",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Header with count
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.surface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${completedTasks.length} completed tasks",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          "Tap to restore",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Task list
                  Expanded(
                    child: ListView.builder(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = completedTasks[index];
                        return TaskCard(
                          task: task,
                          onDelete: () => _showDeleteDialog(context, task),
                          onToggle: () => taskProvider.toggleTask(task.id), // Esto restaurará la tarea
                          onEdit: () {
                            // No permitir edición directa en tareas completadas
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Restore the task first to edit it"),
                                backgroundColor: Colors.orange,
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
    );
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog<void>(
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

  void _showClearAllDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear All Completed"),
          content: const Text("Are you sure you want to delete all completed tasks? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                taskProvider.clearCompletedTasks();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All completed tasks cleared"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                "Clear All",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}