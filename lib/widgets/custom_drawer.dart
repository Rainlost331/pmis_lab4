import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Personal Information Manager'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Appointments'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/appointments');
            },
          ),
          ListTile(
            title: Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contacts');
            },
          ),
          ListTile(
            title: Text('Notes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/notes');
            },
          ),
          ListTile(
            title: Text('Tasks'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/tasks');
            },
          ),
        ],
      ),
    );
  }
}
