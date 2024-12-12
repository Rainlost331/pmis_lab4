import 'package:flutter/material.dart';
import 'package:personal_information_manager/services/database_service.dart';
import 'package:personal_information_manager/models/task.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseService().getTasks();
    setState(() {
      this.tasks = tasks;
    });
  }

  // Здесь добавьте методы для добавления, обновления и удаления задач

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Метод для удаления задачи
              },
            ),
            onTap: () {
              // Метод для редактирования задачи
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Метод для добавления новой задачи
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
