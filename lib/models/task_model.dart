class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  bool isCompleted;
  bool isPinned;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.isCompleted = false,
    this.isPinned = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'isPinned': isPinned,
    };
  }

  // Create from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'] ?? false,
      isPinned: json['isPinned'] ?? false,
    );
  }

  // Copy with method for updates
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    bool? isCompleted,
    bool? isPinned,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
