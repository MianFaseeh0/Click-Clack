import 'dart:io';

import 'package:clickclack/core/features/notes/model/note_hive_model.dart';
import 'package:clickclack/core/features/notes/services/hive_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AddNoteSheet extends StatefulWidget {
  const AddNoteSheet({super.key});

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  final _textController = TextEditingController();
  final _picker = ImagePicker();

  File? _pickedImage;
  NoteCategory _category = NoteCategory.instagram;
  bool _saving = false;

  Future<void> _pickImage() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (xfile == null) return;
    setState(() => _pickedImage = File(xfile.path));
  }

  // image_picker's path is a cache path — copy it into app documents
  // so it survives cache clears / OS cleanup.
  Future<String> _persistImage(File source) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'clickclack_images'));
    if (!await imagesDir.exists()) await imagesDir.create(recursive: true);
    final fileName = '${DateTime.now().microsecondsSinceEpoch}${p.extension(source.path)}';
    final saved = await source.copy(p.join(imagesDir.path, fileName));
    return saved.path;
  }

  Future<void> _pickCategory() async {
    final result = await showCupertinoModalPopup<NoteCategory>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Category'),
        actions: NoteCategory.values
            .map((cat) => CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, cat),
                  child: Text(cat.label),
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (result != null) setState(() => _category = result);
  }

  Future<void> _save() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _pickedImage == null) return;
    if (_saving) return;
    setState(() => _saving = true);

    final imagePath = _pickedImage != null ? await _persistImage(_pickedImage!) : null;

    final note = NoteHiveModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      imagePath: imagePath,
      category: _category,
      createdAt: DateTime.now(),
    );

    await Hive.box<NoteHiveModel>(notesBoxName).add(note);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: CupertinoColors.systemGrey, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'New capture',
              style: TextStyle(color: CupertinoColors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _textController,
              placeholder: 'write something about it…',
              placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
              style: const TextStyle(color: CupertinoColors.white),
              maxLines: 4,
              minLines: 2,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey.withValues(alpha: 0.3)),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickCategory,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category: ${_category.label}', style: const TextStyle(color: CupertinoColors.white, fontSize: 15)),
                    const Icon(CupertinoIcons.chevron_down, color: CupertinoColors.systemGrey, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: const Color(0xFFE8622C),
                borderRadius: BorderRadius.circular(30),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CupertinoActivityIndicator(color: CupertinoColors.black)
                    : const Text('Save', style: TextStyle(color: CupertinoColors.black, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    if (_pickedImage == null) {
      return GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
            color: CupertinoColors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CupertinoColors.systemGrey.withValues(alpha: 0.3)),
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey, size: 24),
                SizedBox(height: 4),
                Text('select an image', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
              ],
            ),
          ),
        ),
      );
    }

    // Attachment-chip style: thumbnail + floating remove button.
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(_pickedImage!, height: 90, width: 90, fit: BoxFit.cover),
          ),
          Positioned(
            top: -8,
            right: -8,
            child: GestureDetector(
              onTap: () => setState(() => _pickedImage = null),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: CupertinoColors.black, shape: BoxShape.circle),
                child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
