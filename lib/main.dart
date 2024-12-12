import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Инициализация базы данных для веб
    sqfliteFfiInit();
  } else {
    // Инициализация базы данных для мобильных платформ
    sqfliteFfiInit();
  }

  // Инициализация базы данных
  await DatabaseService().database;

  runApp(PersonalInformationManagerApp());
}

class PersonalInformationManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Information Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
