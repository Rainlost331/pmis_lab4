class Note {
  int id;
  String title;
  String content;
  DateTime dateTime;

  Note({required this.id, required this.title, required this.content, required this.dateTime});

  // Преобразование объекта в Map для записи в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Создание объекта из Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
