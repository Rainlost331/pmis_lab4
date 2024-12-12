import 'package:flutter/material.dart';
import 'package:personal_information_manager/services/database_service.dart';
import 'package:personal_information_manager/models/appointment.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final appointments = await DatabaseService().getAppointments();
    setState(() {
      this.appointments = appointments;
    });
  }

  Future<void> _addAppointment(Appointment appointment) async {
    await DatabaseService().insertAppointment(appointment);
    _loadAppointments();
  }

  Future<void> _updateAppointment(Appointment appointment) async {
    await DatabaseService().updateAppointment(appointment);
    _loadAppointments();
  }

  Future<void> _deleteAppointment(int id) async {
    await DatabaseService().deleteAppointment(id);
    _loadAppointments();
  }

  void _showAppointmentDialog({Appointment? appointment}) {
    final titleController = TextEditingController(text: appointment?.title ?? '');
    final descriptionController = TextEditingController(text: appointment?.description ?? '');
    final dateTimeController = TextEditingController(text: appointment?.dateTime.toIso8601String() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appointment == null ? 'Add Appointment' : 'Edit Appointment'),
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
                controller: dateTimeController,
                decoration: InputDecoration(labelText: 'DateTime'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: appointment?.dateTime ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    dateTimeController.text = pickedDate.toIso8601String();
                  }
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
                final newAppointment = Appointment(
                  id: appointment?.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  dateTime: DateTime.parse(dateTimeController.text),
                );
                if (appointment == null) {
                  _addAppointment(newAppointment);
                } else {
                  _updateAppointment(newAppointment);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return ListTile(
            title: Text(appointment.title),
            subtitle: Text(appointment.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteAppointment(appointment.id!);
              },
            ),
            onTap: () {
              _showAppointmentDialog(appointment: appointment);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAppointmentDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
