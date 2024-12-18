class Appointment {
  int? id;
  String title;
  String description;
  DateTime dateTime;

  Appointment({this.id, required this.title, required this.description, required this.dateTime});

  // Преобразование объекта в Map для записи в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
