class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final DateTime? reminderTime;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
  });
}
