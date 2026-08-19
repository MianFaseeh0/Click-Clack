import 'package:clickclack/core/features/notes/model/note_hive_model.dart';
import 'package:clickclack/core/features/notes/model/note_list_item.dart';
import 'package:clickclack/core/features/notes/services/hive_boxes.dart';
import 'package:clickclack/core/features/notes/view/add_note_sheet.dart';
import 'package:clickclack/core/features/notes/view/note_detail_screen.dart';
import 'package:clickclack/core/features/quick_capture/quick_capture_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class NotesListScreen extends StatefulWidget {
  final String userName;

  const NotesListScreen({super.key, required this.userName});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> with WidgetsBindingObserver {
  NoteCategory selectedCategory = NoteCategory.instagram;

  Box<NoteHiveModel> get _box => Hive.box<NoteHiveModel>(notesBoxName);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Covers the common case: app was already running in the background,
    // user long-holds volume-up, saves a note from the overlay, then
    // switches back — pick it up right away instead of waiting for a
    // cold start.
    if (state == AppLifecycleState.resumed) {
      QuickCaptureService.flushPending();
    }
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddNoteSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ValueListenableBuilder<Box<NoteHiveModel>>(
            valueListenable: _box.listenable(),
            builder: (context, box, _) {
              final filtered = box.values.where((n) => n.category == selectedCategory).toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildTitleRow(box.length),
                  const SizedBox(height: 20),
                  _buildCategoryChips(),
                  const SizedBox(height: 30),
                  Container(height: 1, color: Colors.white24),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text('nothing saved here yet', style: TextStyle(color: Colors.grey)),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final note = filtered[i];
                              return NoteListItem(
                                note: note,
                                index: i + 1,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.person, color: Colors.white, size: 24),
        const SizedBox(width: 10),
        Text(
          'hey, ${widget.userName}',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        GestureDetector(
          onTap: QuickCaptureService.openAccessibilitySettings,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.settings_outlined, color: Colors.white54, size: 22),
          ),
        ),
        GestureDetector(
          onTap: _openAddSheet,
          child: Container(
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(int total) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          ' Your\n    Notes',
          style: TextStyle(color: Colors.white, fontSize: 60, height: 1.3, fontWeight: FontWeight.w400),
        ),
        const SizedBox(width: 40),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, right: 10),
          child: Text('/$total', style: const TextStyle(color: Colors.grey, fontSize: 35)),
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
                  color: selected ? const Color(0xFFE8622C) : Colors.transparent,
                  border: Border.all(color: selected ? const Color(0xFFE8622C) : Colors.white54),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  cat.label,
                  style: TextStyle(color: selected ? Colors.black : Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
