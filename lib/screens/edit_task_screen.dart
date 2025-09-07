import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final bool isNew;

  const EditTaskScreen({
    super.key,
    required this.task,
    this.isNew = false,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _assignedTo;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _assignedTo = widget.task.assignedTo;
    _priority = widget.task.priority;
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
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    taskProvider.deleteTask(widget.task.id);
                    Navigator.pop(context);
                  },
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Assigned To",
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _assignedTo,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "me", child: Text("Me")),
                      DropdownMenuItem(value: "partner", child: Text("Partner")),
                      DropdownMenuItem(value: "both", child: Text("Both")),
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
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _priority,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "urgent", child: Text("Urgent")),
                      DropdownMenuItem(value: "important", child: Text("Important")),
                      DropdownMenuItem(value: "normal", child: Text("Normal")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
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
                    );

                    if (widget.isNew) {
                      taskProvider.addTask(updatedTask);
                    } else {
                      taskProvider.updateTask(updatedTask);
                    }

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.isNew ? "Add Task" : "Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}