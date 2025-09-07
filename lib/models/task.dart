class Task {
  String id;
  String title;
  String description;
  String assignedTo; // "me", "partner", "both"
  String priority;   // "urgent", "important", "normal"
  bool completed;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.completed,
    required this.createdAt,
  });

  // Method to generate a unique ID (for simplicity, using timestamp)
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}