import 'dart:developer';

import 'package:clickclack/core/features/notes/model/note_hive_model.dart';
import 'package:clickclack/core/features/notes/services/hive_boxes.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

/// Bridges the native volume-key overlay (see VolumeKeyAccessibilityService
/// + QuickCaptureOverlay on the Android side) with the Hive-backed notes box.
///
/// The overlay can save a note while the Flutter engine isn't running at
/// all, so it can't touch Hive directly — it just appends to a small JSON
/// queue file on disk. This class asks the native side for whatever's
/// queued (which also clears the queue) and merges it into the notes box.
class QuickCaptureService {
  static const _channel = MethodChannel('clickclack/quick_capture');

  /// Call on app startup and on every resume — cheap no-op when nothing's
  /// queued, since the native side only ever returns unread entries.
  static Future<void> flushPending() async {
    List<dynamic> raw;
    try {
      raw = await _channel.invokeMethod<List<dynamic>>('getPendingCaptures') ?? const [];
    } on PlatformException catch (e) {
      log('QuickCaptureService: flush failed — ${e.message}');
      return;
    }
    if (raw.isEmpty) return;

    final box = Hive.box<NoteHiveModel>(notesBoxName);
    for (final entry in raw) {
      final map = Map<String, dynamic>.from(entry as Map);
      final text = (map['text'] as String?)?.trim() ?? '';
      if (text.isEmpty) continue;

      final createdAtMillis = map['createdAt'] as int;
      final categoryIndex = map['category'] as int;
      // Defensive: an older overlay build or a corrupt entry could carry an
      // out-of-range index — fall back to the first category rather than
      // crash the whole flush.
      final category = categoryIndex >= 0 && categoryIndex < NoteCategory.values.length
          ? NoteCategory.values[categoryIndex]
          : NoteCategory.values.first;

      await box.add(NoteHiveModel(
        id: '${createdAtMillis}_${DateTime.now().microsecondsSinceEpoch}',
        text: text,
        category: category,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      ));
    }
  }

  /// Accessibility services can't be enabled programmatically — Android
  /// requires the user to flip the toggle themselves. This just opens the
  /// system screen where they do that.
  static Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      log('QuickCaptureService: could not open accessibility settings — ${e.message}');
    }
  }
}
