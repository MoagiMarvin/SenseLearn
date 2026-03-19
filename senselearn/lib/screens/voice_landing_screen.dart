import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_service.dart';
import 'braille_learning_screen.dart';
import 'profile_screen.dart';

class VoiceLandingScreen extends StatefulWidget {
  const VoiceLandingScreen({super.key});

  @override
  State<VoiceLandingScreen> createState() => _VoiceLandingScreenState();
}

class _VoiceLandingScreenState extends State<VoiceLandingScreen> {
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _voiceService = context.read<VoiceService>();
    _startGreeting();
  }

  Future<void> _startGreeting() async {
    await Future.delayed(const Duration(seconds: 1)); // Wait for initialization
    await _voiceService.speak("Good day Marvin, what are you looking to learn today?");
    _startListening();
  }

  void _startListening() {
    _voiceService.listen(onResult: (command) {
      _handleCommand(command);
    });
  }

  void _handleCommand(String command) {
    debugPrint("Command received: $command");
    final target = command.toLowerCase();

    if (target.contains("braille")) {
      _voiceService.speak("Navigating to Braille lesson.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BrailleLearningScreen()),
      ).then((_) => _startListening()); // Resume listening when back
    } else if (target.contains("profile") || target.contains("progress")) {
      _voiceService.speak("Opening your profile.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      ).then((_) => _startListening());
    } else {
      _voiceService.speak("I didn't quite catch that. Would you like to learn Braille or see your profile?");
      _startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Consumer<VoiceService>(
        builder: (context, voice, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mic, color: Colors.white, size: 80),
                const SizedBox(height: 40),
                Text(
                  voice.isListening ? "Listening..." : "I'm hearing you, Marvin",
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (voice.lastWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '"${voice.lastWords}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 60),
                const Text(
                  "Say 'Braille' or 'Profile'",
                  style: TextStyle(color: Colors.white38, fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
