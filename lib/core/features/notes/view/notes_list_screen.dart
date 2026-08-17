import 'package:clickclack/core/features/notes/model/note_list_item.dart';
import 'package:clickclack/core/features/notes/view/note.dart';
import 'package:flutter/material.dart';

import 'note_detail_screen.dart';

class NotesListScreen extends StatefulWidget {
  final String userName;
  final List<Note> notes;

  const NotesListScreen({
    super.key,
    required this.notes,
    this.userName = 'Justin',
  });

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  // Selected category circle — matches "#work" being highlighted in the design.
  NoteCategory selectedCategory = NoteCategory.work;

  @override
  Widget build(BuildContext context) {
    final filteredNotes =
        widget.notes.where((n) => n.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              _buildHeader(),
              const SizedBox(height: 14),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 18),
              _buildTitleRow(),
              const SizedBox(height: 20),
              _buildCategoryChips(),
              const SizedBox(height: 8),
              Container(height: 1, color: Colors.white24),
              Expanded(
                child: filteredNotes.isEmpty
                    ? const Center(
                        child: Text(
                          'No notes here yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, i) {
                          final note = filteredNotes[i];
                          return NoteListItem(
                            note: note,
                            index: i + 1,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NoteDetailScreen(note: note),
                                ),
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
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'morning, ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              TextSpan(
                text: widget.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Icon(Icons.add, color: Colors.white, size: 26),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Text(
            'your\nnotes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 52,
              height: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 6),
          child: Text(
            '/${widget.notes.length}',
            style: const TextStyle(color: Colors.grey, fontSize: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: NoteCategory.values.map((cat) {
          final selected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFE8622C)
                      : Colors.transparent,
                  border: Border.all(
                    color:
                        selected ? const Color(0xFFE8622C) : Colors.white54,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  cat.label,
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
