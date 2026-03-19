import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceService extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();
  
  bool _isListening = false;
  String _lastWords = "";
  bool _isInitialized = false;
  
  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  bool get isInitialized => _isInitialized;

  VoiceService() {
    initVoice();
  }

  Future<void> initVoice() async {
    try {
      await _tts.setLanguage("en-US");
      await _tts.setPitch(1.0);
      _isInitialized = await _stt.initialize(
        onStatus: (status) => debugPrint('STT Status: $status'),
        onError: (error) => debugPrint('STT Error: $error'),
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Voice initialization error: $e");
    }
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> listen({required Function(String) onResult}) async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted && _isInitialized) {
      _isListening = true;
      notifyListeners();

      await _stt.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
            onResult(_lastWords);
            notifyListeners();
          }
        },
      );
    } else {
      debugPrint("Microphone permission or STT init failed");
    }
  }

  Future<void> stopListening() async {
    await _stt.stop();
    _isListening = false;
    notifyListeners();
  }
}
