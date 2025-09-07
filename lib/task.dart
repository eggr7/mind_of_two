class Task {
  String title;
  String description;
  String assignedTo; // "me", "partner", "both"
  String priority;   // "urgent", "important", "normal"
  bool completed;

  Task({
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    this.completed = false,
  });
}
