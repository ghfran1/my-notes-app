import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteDetailsPage extends StatelessWidget {
  final NoteModel note;

  const NoteDetailsPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Center(
        child: Text(
          note.description,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}