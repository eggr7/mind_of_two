import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/category_provider.dart';

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
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final taskCategories = categoryProvider.getCategoriesByIds(task.categoryIds);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: task.completed ? null : onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: task.completed ? 0.7 : 1.0,
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
                          color: Theme.of(context).colorScheme.onSurface,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Add due date information 
                if (task.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Due: ${task.dueDate!.toString().split(' ')[0]}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Categories chips
                if (taskCategories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: taskCategories.map<Widget>((category) => Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category.icon,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: category.colorValue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: category.colorValue.withOpacity(0.1),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                      )).toList(),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(
                        _getAssignedToText(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
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
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
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
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
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
      ),
    );
  }
}
