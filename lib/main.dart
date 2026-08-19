import 'package:clickclack/core/features/notes/model/note_hive_model.dart';
import 'package:clickclack/core/features/notes/services/hive_boxes.dart';
import 'package:clickclack/core/features/notes/services/user_prefs_service.dart';
import 'package:clickclack/core/features/notes/view/name.dart';
import 'package:clickclack/core/features/notes/view/notes_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteHiveModelAdapter());
  await Hive.openBox<NoteHiveModel>(notesBoxName);

  final userName = await UserPrefsService.getUserName();

  runApp(ClickClackApp(userName: userName));
}

class ClickClackApp extends StatelessWidget {
  final String? userName;

  const ClickClackApp({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickClack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quantico', useMaterial3: true),
      home: (userName == null || userName!.isEmpty)
          ? const NameScreen()
          : NotesListScreen(userName: userName!),
    );
  }
}
