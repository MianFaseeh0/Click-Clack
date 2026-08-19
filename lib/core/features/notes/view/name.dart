import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickclack/core/features/notes/services/user_prefs_service.dart';
import 'package:clickclack/core/features/notes/view/notes_list_screen.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _controller = TextEditingController();
  bool _saving = false;

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _saving) return;

    setState(() => _saving = true);
    await UserPrefsService.saveUserName(name);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => NotesListScreen(userName: name)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(seconds: 3),
                animatedTexts: [
                  TypewriterAnimatedText(
                    "THE NAME PLEASE?",
                    cursor: '',
                    textStyle: const TextStyle(fontSize: 25, color: Colors.white),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_box_rounded, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE8622C))),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8622C),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text("let's go"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
