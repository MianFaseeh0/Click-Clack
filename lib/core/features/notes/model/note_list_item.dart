import 'dart:io';

import 'package:clickclack/core/features/notes/model/note_hive_model.dart';
import 'package:flutter/material.dart';

class NoteListItem extends StatelessWidget {
  final NoteHiveModel note;
  final int index;
  final VoidCallback onTap;

  const NoteListItem({
    super.key,
    required this.note,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '${index.toString().padLeft(2, '0')} /',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                if (note.imagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(note.imagePath!),
                      height: 44,
                      width: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    note.preview.isEmpty ? '(no text)' : note.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 6),
                  child: Icon(Icons.north_east, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                note.formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
