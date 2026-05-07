import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import 'add_note_page.dart';
import 'note_details_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notesService = NoteService();
  String search = "";

  final List<Color> colors = const [
    Color(0xFFFFF3E0),
    Color(0xFFE3F2FD),
    Color(0xFFE8F5E9),
    Color(0xFFF3E5F5),
    Color(0xFFFFEBEE),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // ===== BACKGROUND GRADIENT WOW =====
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEF2F3),
              Color(0xFFFFFFFF),
              Color(0xFFE3F2FD),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              // ===== APP BAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    Text(
                      "My Note",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== SEARCH BAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => search = value);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search your notes...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ===== NOTES =====
              Expanded(
                child: StreamBuilder<List<NoteModel>>(
                  stream: notesService.getNotes(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var notes = snapshot.data!;

                    // search filter
                    notes = notes.where((note) {
                      return note.title
                              .toLowerCase()
                              .contains(search.toLowerCase()) ||
                          note.description
                              .toLowerCase()
                              .contains(search.toLowerCase());
                    }).toList();

                    if (notes.isEmpty) {
                      return const Center(
                        child: Text(
                          "No notes yet ",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        final color = colors[index % colors.length];

                        return _NoteCard(
                          key: ValueKey(note.id),
                          note: note,
                          color: color,
                          onDelete: () {
                            if (note.id != null) {
                              notesService.deleteNote(note.id!);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== ADD BUTTON =====
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 125, 102, 207),
        icon: const Icon(Icons.add),
        label: const Text("New Note"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotePage()),
          );
        },
      ),
    );
  }
}

// ================= NOTE CARD =================
class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final Color color;
  final VoidCallback onDelete;

  const _NoteCard({
    super.key,
    required this.note,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),

      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        onDelete();
      },

      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        decoration: BoxDecoration(
          color: color.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),

        child: ListTile(
          contentPadding: const EdgeInsets.all(16),


           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NoteDetailsPage(note: note),
    ),
  );
},

          title: Text(
            note.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),

          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              note.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color.fromARGB(255, 160, 93, 208).withOpacity(0.6),
              ),
            ),
          ),

          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}