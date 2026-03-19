import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_service.dart';
import 'coding_quiz_screen.dart'; // We'll create this next

class HackathonHomeScreen extends StatefulWidget {
  const HackathonHomeScreen({super.key});

  @override
  State<HackathonHomeScreen> createState() => _HackathonHomeScreenState();
}

class _HackathonHomeScreenState extends State<HackathonHomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndGreet();
  }

  Future<void> _initializeAndGreet() async {
    final voiceService = context.read<VoiceService>();
    // Wait for voice initialization
    int retries = 0;
    while (!voiceService.isInitialized && retries < 5) {
      await Future.delayed(const Duration(milliseconds: 500));
      retries++;
    }

    final hour = DateTime.now().hour;
    String timeGreeting;
    if (hour < 12) {
      timeGreeting = "Morning";
    } else if (hour < 17) {
      timeGreeting = "Afternoon";
    } else {
      timeGreeting = "Evening";
    }

    final message = "Good $timeGreeting Marvin, let's tackle this learning together! Say 'Start Coding' to begin our hackathon quiz.";
    await voiceService.speak(message);
    _startListening();
  }

  void _startListening() {
    final voiceService = context.read<VoiceService>();
    voiceService.listen(onResult: (words) {
      if (words.toLowerCase().contains("start") || words.toLowerCase().contains("coding")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CodingQuizScreen()),
        );
      } else {
        voiceService.speak("I'm waiting for you to say Start Coding.");
        _startListening();
      }
    });
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
                const Icon(Icons.mic, color: Colors.white, size: 100),
                const SizedBox(height: 40),
                Text(
                  voice.isListening ? "Hearing you, Marvin..." : "Ready to learn",
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (voice.lastWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      '"${voice.lastWords}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () => _startListening(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo[900],
                  ),
                  child: const Text("Reconnect Voice"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
