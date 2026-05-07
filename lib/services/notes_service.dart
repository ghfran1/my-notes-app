import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_task/models/note.dart';

class NoteService {
  NoteService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      _firestore.collection('notes');

  Stream<List<NoteModel>> getNotes() {
    return _notesRef.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map(NoteModel.fromFirestore).toList();
    });
  }

  Future<void> addNote(NoteModel note) {
    return _notesRef.add({
      ...note.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String noteId) {
    return _notesRef.doc(noteId).delete();
  }
}