import 'package:clickclack/core/features/notes/model/note_list_item.dart';
import 'package:clickclack/core/features/notes/view/note.dart';
import 'package:clickclack/core/theme/app_text_style.dart';
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
              // Container(height: 1, color: Colors.white24),
              const SizedBox(height: 18),
              _buildTitleRow(),
              const SizedBox(height: 20),
              _buildCategoryChips(),
              const SizedBox(height: 30),
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
        Icon(Icons.person, color: Colors.white, size: 24),
      
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
               TextSpan(
                text: 'morning, ',
                style: AppTextStyles.bodyLarge,
              ),
              TextSpan(
                text: "Tahira",
                style: AppTextStyles.headline4
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
        const Text(
            ' Your\n    Notes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              height: 1.3,
              fontWeight: FontWeight.w400,
            ),
          ),
      const SizedBox(width: 40,),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, right: 10),
          child: Text(
            '/${widget.notes.length}',
            style: const TextStyle(color: Colors.grey, fontSize: 35),
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
