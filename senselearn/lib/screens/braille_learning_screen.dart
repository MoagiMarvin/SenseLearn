import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/accessibility_overlay.dart';
import '../models/user_profile.dart';

class BrailleLearningScreen extends StatefulWidget {
  const BrailleLearningScreen({super.key});

  @override
  State<BrailleLearningScreen> createState() => _BrailleLearningScreenState();
}

class _BrailleLearningScreenState extends State<BrailleLearningScreen> {
  final Set<int> _activeDots = {};
  String _lastCharacter = "";

  // Braille Dot Mapping (English Grade 1)
  final Map<String, String> _brailleMap = {
    "1": "A",
    "1,2": "B",
    "1,4": "C",
    "1,4,5": "D",
    "1,5": "E",
    // Add more if needed for demo
  };

  void _onDotPressed(int dotIndex) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_activeDots.contains(dotIndex)) {
        _activeDots.remove(dotIndex);
        _announce("Dot $dotIndex removed.");
      } else {
        _activeDots.add(dotIndex);
        _announce("Dot $dotIndex added.");
      }
    });
  }

  void _announce(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("AI Voice: $message"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitDots() {
    if (_activeDots.isEmpty) return;
    
    final sortedDots = _activeDots.toList()..sort();
    final dotString = sortedDots.join(",");
    setState(() {
      _lastCharacter = _brailleMap[dotString] ?? "?";
      _activeDots.clear();
    });
    
    _announce("Character entered: $_lastCharacter");
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityOverlay(
      screenName: "Braille Practice Area",
      child: Scaffold(
        appBar: AppBar(
        title: const Text("Braille Input Practice"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Tap the dots to form a character, then tap the center to submit.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                      int dotNum = index + 1;
                      // Mapping grid index to Braille dot positions:
                      // 0:1, 1:4
                      // 2:2, 3:5
                      // 4:3, 5:6
                      int dotMapping = [1, 4, 2, 5, 3, 6][index];
                      bool isActive = _activeDots.contains(dotMapping);

                      return GestureDetector(
                        onTap: () => _onDotPressed(dotMapping),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isActive ? Colors.indigo : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: isActive ? [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ] : [],
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
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _activeDots.clear()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text("Clear", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _submitDots,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          if (_lastCharacter.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                "Last Char: $_lastCharacter",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    ),
  );
}
}
