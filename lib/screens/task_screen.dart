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

  Future<void> _addTask(Task task) async {
    await DatabaseService().insertTask(task);
    _loadTasks();
  }

  Future<void> _updateTask(Task task) async {
    await DatabaseService().updateTask(task);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseService().deleteTask(id);
    _loadTasks();
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');
    final dueDateController = TextEditingController(text: task?.dueDate.toIso8601String() ?? '');
    bool isCompleted = task?.isCompleted ?? false;

    FocusScopeNode currentFocus = FocusScope.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: AlertDialog(
            title: Text(task == null ? 'Add Task' : 'Edit Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: dueDateController,
                  decoration: InputDecoration(labelText: 'Due Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: task?.dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      dueDateController.text = pickedDate.toIso8601String();
                    }
                  },
                ),
                SwitchListTile(
                  title: Text('Completed'),
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newTask = Task(
                    id: task?.id ?? 0,
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: DateTime.parse(dueDateController.text),
                    isCompleted: isCompleted,
                  );
                  if (task == null) {
                    _addTask(newTask);
                  } else {
                    _updateTask(newTask);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

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
                _deleteTask(task.id);
              },
            ),
            onTap: () {
              _showTaskDialog(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
