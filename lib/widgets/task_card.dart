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

  Color _getPriorityColor() {
    switch (task.priority) {
      case "urgent":
        return const Color(0xFFF50057); // Red/pink for urgent
      case "important":
        return const Color(0xFFFF9800); // Orange for important
      default:
        return const Color(0xFF6C63FF); // Purple for normal
    }
  }

  IconData _getPriorityIcon() {
    switch (task.priority) {
      case "urgent":
        return Icons.error_outline;
      case "important":
        return Icons.warning_amber_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _getAssignedToText() {
    switch (task.assignedTo) {
      case "me":
        return "👤 Me";
      case "partner":
        return "👥 Partner";
      case "both":
        return "🌆 Both";
      default:
        return "👤 Me";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getPriorityIcon(),
                      color: _getPriorityColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (task.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    task.description,
                    style: TextStyle(
                      color: const Color(0xFF616161),
                      fontSize: 14,
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      _getAssignedToText(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: const Color(0xFFE3F2FD),
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                  Chip(
                    label: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getPriorityColor(),
                      ),
                    ),
                    backgroundColor: _getPriorityColor().withOpacity(0.1),
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      task.completed ? Icons.undo : Icons.check_circle,
                      color: task.completed
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF9E9E9E),
                    ),
                    onPressed: onToggle,
                    tooltip: task.completed ? 'Mark as pending' : 'Complete',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
                    onPressed: onDelete,
                    tooltip: 'Delete task',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}