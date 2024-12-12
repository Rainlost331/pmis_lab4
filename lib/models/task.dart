class Task {
  int id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({required this.id, required this.title, required this.description, required this.dueDate, this.isCompleted = false});

  // Преобразование объекта в Map для записи в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Создание объекта из Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
