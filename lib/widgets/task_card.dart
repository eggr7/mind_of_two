import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
  });

  String getAssignedToIcon() {
    switch (task.assignedTo) {
      case "me":
        return "👤";
      case "partner":
        return "👥";
      case "both":
        return "🌆";
      default:
        return "👤";
    }
  }

  Color getPriorityColor() {
    switch (task.priority) {
      case "urgent":
        return Colors.red;
      case "important":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onEdit,
        leading: CircleAvatar(
          backgroundColor: getPriorityColor(),
          child: Text(
            getAssignedToIcon(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(
                color: Colors.grey[600],
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task.priority.toUpperCase(),
              style: TextStyle(
                color: getPriorityColor(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.completed ? Icons.undo : Icons.check_circle,
                color: task.completed ? Colors.green : Colors.grey,
              ),
              onPressed: onToggle,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}