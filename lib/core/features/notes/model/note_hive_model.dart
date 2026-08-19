import 'package:hive/hive.dart';

/// Category is stored as an int index inside NoteHiveModel's own
/// adapter below — no separate enum TypeAdapter to register. Only
/// ever APPEND new categories to this list; inserting one in the
/// middle shifts every index and corrupts categories on notes
/// already saved on a real device.
enum NoteCategory { instagram, screenshots, tiktok }

extension NoteCategoryX on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.instagram:
        return 'Instagram';
      case NoteCategory.screenshots:
        return 'Screenshots';
      case NoteCategory.tiktok:
        return 'TikTok';
    }
  }
}

/// Extends HiveObject so once a note is read out of the box it can
/// call `.save()` / `.delete()` on itself — no manual key tracking.
class NoteHiveModel extends HiveObject {
  String id;
  String text;
  String? imagePath;
  NoteCategory category;
  DateTime createdAt;

  NoteHiveModel({
    required this.id,
    required this.text,
    required this.category,
    required this.createdAt,
    this.imagePath,
  });

  String get preview {
    final flat = text.replaceAll('\n', ' ').trim();
    if (flat.isEmpty) return imagePath != null ? '📷 image' : '';
    return flat.length > 80 ? '${flat.substring(0, 80)}...' : flat;
  }

  String get formattedDate {
    final dd = createdAt.day.toString().padLeft(2, '0');
    final mm = createdAt.month.toString().padLeft(2, '0');
    final yy = createdAt.year.toString().substring(2);
    return '$dd / $mm / $yy';
  }
}

/// Hand-written TypeAdapter — no build_runner/codegen dependency.
/// The write order below IS the binary schema: append new fields at
/// the end only, never reorder or remove one.
class NoteHiveModelAdapter extends TypeAdapter<NoteHiveModel> {
  @override
  final int typeId = 0;

  @override
  NoteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteHiveModel(
      id: fields[0] as String,
      text: fields[1] as String,
      imagePath: fields[2] as String?,
      category: NoteCategory.values[fields[3] as int],
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NoteHiveModel obj) {
    writer
      ..writeByte(5) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.category.index)
      ..writeByte(4)
      ..write(obj.createdAt);
  }
}
