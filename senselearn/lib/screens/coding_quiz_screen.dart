import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/voice_service.dart';

class CodingQuizScreen extends StatefulWidget {
  const CodingQuizScreen({super.key});

  @override
  State<CodingQuizScreen> createState() => _CodingQuizScreenState();
}

class _CodingQuizScreenState extends State<CodingQuizScreen> {
  int _currentStep = 1; // 1: Multiple Choice, 2: Braille Input
  final Set<int> _activeDots = {};
  
  @override
  void initState() {
    super.initState();
    _startStep1();
  }

  Future<void> _startStep1() async {
    final voiceService = context.read<VoiceService>();
    await voiceService.speak("Question 1. What is a variable? Option A: A container for data. Option B: A type of computer. Option C: A website. Tell me your answer.");
    _listenForStep1();
  }

  void _listenForStep1() {
    final voiceService = context.read<VoiceService>();
    voiceService.listen(onResult: (words) {
      final answer = words.toLowerCase();
      if (answer.contains("option a") || answer.contains("container") || answer.contains("data")) {
        voiceService.speak("Correct! A variable is indeed a container for data. Now for Question 2.");
        setState(() => _currentStep = 2);
        _startStep2();
      } else {
        voiceService.speak("Not quite. Listen again. What is a variable? Option A, B, or C?");
        _listenForStep1();
      }
    });
  }

  Future<void> _startStep2() async {
    final voiceService = context.read<VoiceService>();
    await voiceService.speak("Question 2. How do you write the letter A in Braille? Tap the dots on your screen, then say 'Submit'. Hint: It's just Dot 1.");
  }

  void _onDotPressed(int dotIndex) {
    HapticFeedback.lightImpact();
    final voiceService = context.read<VoiceService>();
    setState(() {
      if (_activeDots.contains(dotIndex)) {
        _activeDots.remove(dotIndex);
        voiceService.speak("Dot $dotIndex removed.");
      } else {
        _activeDots.add(dotIndex);
        voiceService.speak("Dot $dotIndex added.");
      }
    });
  }

  void _submitBraille() {
    final voiceService = context.read<VoiceService>();
    if (_activeDots.length == 1 && _activeDots.contains(1)) {
      voiceService.speak("Amazing! You've mastered the letter A and completed the hackathon quiz! Well done, Marvin.");
      Navigator.pop(context);
    } else {
      voiceService.speak("That's not the letter A. Try again. It's just Dot 1.");
      setState(() => _activeDots.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coding Quiz"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _currentStep == 1 ? _buildStep1() : _buildStep2(),
      floatingActionButton: _currentStep == 2 ? FloatingActionButton.extended(
        onPressed: _submitBraille,
        label: const Text("Submit Answer"),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.green,
      ) : null,
    );
  }

  Widget _buildStep1() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.question_answer, size: 60, color: Colors.indigo),
            const SizedBox(height: 20),
            const Text(
              "Question 1: Multiple Choice",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _buildOptionCard("A", "A container for data"),
            _buildOptionCard("B", "A type of computer"),
            _buildOptionCard("C", "A website"),
            const SizedBox(height: 40),
            const Text("Say your answer clearly.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String letter, String text) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(letter)),
        title: Text(text),
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Step 2: Enter 'A' in Braille",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  children: List.generate(6, (index) {
                    int dotMapping = [1, 4, 2, 5, 3, 6][index];
                    bool isActive = _activeDots.contains(dotMapping);

                    return GestureDetector(
                      onTap: () => _onDotPressed(dotMapping),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isActive ? Colors.indigo : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "$dotMapping",
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black54,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
