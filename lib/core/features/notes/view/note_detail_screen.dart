import 'dart:io';

import 'package:clickclack/core/features/notes/model/note_hive_model.dart';
import 'package:flutter/material.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteHiveModel note;

  const NoteDetailScreen({super.key, required this.note});

  Future<void> _delete(BuildContext context) async {
    await note.delete(); // HiveObject knows its own box + key
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Icon(Icons.arrow_back, color: Colors.black, size: 22),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _delete(context),
                    child: const Text('delete', style: TextStyle(color: Colors.black87, fontSize: 15)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(height: 1, color: Colors.black26),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(note.formattedDate, style: const TextStyle(color: Colors.black54, fontSize: 15)),
                  Text(note.category.label, style: const TextStyle(color: Colors.black54, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.imagePath != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(File(note.imagePath!), width: double.infinity, fit: BoxFit.cover),
                          ),
                        ),
                      if (note.text.trim().isNotEmpty)
                        Text(note.text.trim(), style: const TextStyle(color: Colors.black87, fontSize: 17, height: 1.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
