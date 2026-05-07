import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  const NoteModel({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  final String? id;
  final String title;
  final String description;
  final Timestamp? createdAt;

  factory NoteModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return NoteModel(
      id: doc.id,
      title: (data['title'] as String?)?.trim() ?? '',
      description: (data['description'] as String?)?.trim() ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title.trim(),
      'description': description.trim(),
      'createdAt': createdAt,
    };
  }
}
