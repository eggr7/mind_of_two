import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final bool isNew;

  const EditTaskScreen({super.key, required this.task, this.isNew = false});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _assignedTo;
  late String _priority;
  late DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _assignedTo = widget.task.assignedTo;
    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? "Add New Task" : "Edit Task"),
        actions: widget.isNew
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, taskProvider),
                ),
              ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Assigned To Dropdown
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Assigned To",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _assignedTo,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "me", child: Text("👤 Me")),
                        DropdownMenuItem(
                          value: "partner",
                          child: Text("👥 Partner"),
                        ),
                        DropdownMenuItem(value: "both", child: Text("🌆 Both")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _assignedTo = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Priority Dropdown
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _priority,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: "urgent",
                          child: Text("🔴 Urgent"),
                        ),
                        DropdownMenuItem(
                          value: "important",
                          child: Text("🟠 Important"),
                        ),
                        DropdownMenuItem(
                          value: "normal",
                          child: Text("🔵 Normal"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Due Date Picker
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    _dueDate == null
                        ? "No due date"
                        : "Due: ${_dueDate!.toString().split(' ')[0]}",
                  ),
                  trailing: _dueDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => setState(() => _dueDate = null),
                        )
                      : null,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() => _dueDate = selectedDate);
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedTask = Task(
                          id: widget.task.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          assignedTo: _assignedTo,
                          priority: _priority,
                          completed: widget.task.completed,
                          createdAt: widget.task.createdAt,
                          dueDate: _dueDate,
                        );

                        if (widget.isNew) {
                          taskProvider.addTask(updatedTask);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task added successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          taskProvider.updateTask(updatedTask);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task updated successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }

                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.isNew ? Icons.add : Icons.save),
                        const SizedBox(width: 10),
                        Text(
                          widget.isNew ? "Add Task" : "Save Changes",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: Text(
            "Are you sure you want to delete '${widget.task.title}'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                taskProvider.deleteTask(widget.task.id);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task deleted successfully!"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
