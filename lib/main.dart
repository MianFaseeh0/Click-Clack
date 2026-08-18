import 'package:clickclack/core/features/notes/view/note.dart';
import 'package:clickclack/core/features/notes/view/notes_list_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quantico',
        useMaterial3: true,
      ),
      home: NotesListScreen(notes: sampleNotes),
    );
  }
}

final List<Note> sampleNotes = [
  Note(
    id: '1',
    title: 'call summary',
    body: 'several new features need to be implemented in the existing '
        'application. we discussed the priority order and agreed to '
        'start with the analytics dashboard first.',
    category: NoteCategory.work,
    date: DateTime(2022, 11, 15),
  ),
  Note(
    id: '2',
    title: 'what to discuss',
    body: 'we have started the analytics phase. we need test access to '
        'the app to try out the existing features.\n\n'
        'we need to coordinate a call with management to understand how '
        'soon we can start wireframes.\n\n'
        'ask the client to collect positive and negative references that '
        'will help in the work on the concept.',
    category: NoteCategory.work,
    date: DateTime(2022, 11, 18),
  ),
  Note(
    id: '3',
    title: 'about project',
    body: 'making a mobile application for a major bank in canada. the '
        'main idea is to simplify everyday banking for younger users '
        'while keeping it secure and trustworthy.',
    category: NoteCategory.work,
    date: DateTime(2022, 11, 20),
  ),
  Note(
    id: '4',
    title: 'grocery list',
    body: 'milk, eggs, bread, spinach, chicken breast, olive oil, coffee '
        'beans, and something sweet for the weekend.',
    category: NoteCategory.personal,
    date: DateTime(2022, 11, 10),
  ),
  Note(
    id: '5',
    title: 'weekend trip',
    body: 'plan a short road trip with friends, book a cabin near the '
        'lake, and check the weather forecast before leaving.',
    category: NoteCategory.personal,
    date: DateTime(2022, 11, 12),
  ),
  Note(
    id: '6',
    title: 'home repairs',
    body: 'fix the leaking kitchen faucet, repaint the hallway, and '
        'schedule the annual heating system check.',
    category: NoteCategory.home,
    date: DateTime(2022, 11, 14),
  ),
  Note(
    id: '7',
    title: 'furniture ideas',
    body: 'looking for a new bookshelf and a small desk for the study '
        'room, preferably in a light oak finish.',
    category: NoteCategory.home,
    date: DateTime(2022, 11, 16),
  ),
];
