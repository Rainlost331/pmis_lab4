class Contact {
  int id;
  String name;
  String phoneNumber;
  String email;

  Contact({required this.id, required this.name, required this.phoneNumber, required this.email});

  // Преобразование объекта в Map для записи в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  // Создание объекта из Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }
}
