import 'package:clickclack/core/features/notes/view/note.dart';
import 'package:flutter/material.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final paragraphs =
        note.body.split('\n\n').where((p) => p.trim().isNotEmpty).toList();

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
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'delete',
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(height: 1, color: Colors.black26),
              const SizedBox(height: 22),
              // date + category tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.formattedDate,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  Text(
                    note.category.label,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // title
              Text(
                note.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 20),
              // body paragraphs
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: paragraphs
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Text(
                              p.trim(),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
