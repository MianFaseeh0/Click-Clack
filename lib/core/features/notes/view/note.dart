enum NoteCategory { personal, work, home }

extension NoteCategoryX on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.personal:
        return '#personal';
      case NoteCategory.work:
        return '#work';
      case NoteCategory.home:
        return '#home';
    }
  }
}

class Note {
  final String id;
  final String title;
  final String body;
  final NoteCategory category;
  final DateTime date;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.date,
  });

  String get preview {
    final flat = body.replaceAll('\n', ' ').trim();
    return flat.length > 72 ? '${flat.substring(0, 72)}...' : flat;
  }

  String get formattedDate {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yy = date.year.toString().substring(2);
    return '$dd / $mm / $yy';
  }
}
