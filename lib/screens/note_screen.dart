import 'package:flutter/material.dart';
import 'package:personal_information_manager/services/database_service.dart';
import 'package:personal_information_manager/models/note.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseService().getNotes();
    setState(() {
      this.notes = notes;
    });
  }

  Future<void> _addNote(Note note) async {
    await DatabaseService().insertNote(note);
    _loadNotes();
  }

  Future<void> _updateNote(Note note) async {
    await DatabaseService().updateNote(note);
    _loadNotes();
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseService().deleteNote(id);
    _loadNotes();
  }

  void _showNoteDialog({Note? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'Add Note' : 'Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
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
                final newNote = Note(
                  id: note?.id ?? 0,
                  title: titleController.text,
                  content: contentController.text,
                  dateTime: DateTime.now(),
                );
                if (note == null) {
                  _addNote(newNote);
                } else {
                  _updateNote(newNote);
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
        title: Text('Manage Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteNote(note.id);
              },
            ),
            onTap: () {
              _showNoteDialog(note: note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNoteDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
