import 'package:flutter/material.dart';
import 'package:personal_information_manager/services/database_service.dart';
import 'package:personal_information_manager/models/contact.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await DatabaseService().getContacts();
    setState(() {
      this.contacts = contacts;
    });
  }

  Future<void> _addContact(Contact contact) async {
    await DatabaseService().insertContact(contact);
    _loadContacts();
  }

  Future<void> _updateContact(Contact contact) async {
    await DatabaseService().updateContact(contact);
    _loadContacts();
  }

  Future<void> _deleteContact(int id) async {
    await DatabaseService().deleteContact(id);
    _loadContacts();
  }

  void _showContactDialog({Contact? contact}) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneNumberController = TextEditingController(text: contact?.phoneNumber ?? '');
    final emailController = TextEditingController(text: contact?.email ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
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
                final newContact = Contact(
                  id: contact?.id ?? 0,
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
                );
                if (contact == null) {
                  _addContact(newContact);
                } else {
                  _updateContact(newContact);
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
        title: Text('Manage Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteContact(contact.id);
              },
            ),
            onTap: () {
              _showContactDialog(contact: contact);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
