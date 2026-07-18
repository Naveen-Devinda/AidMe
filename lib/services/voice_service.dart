import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isPlaying = false;
  static String _currentText = "";

  static bool get isPlaying => _isPlaying;
  static String get currentText => _currentText;

  static Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    if (_isPlaying && _currentText == text) {
      await stop();
      return;
    }

    await stop();
    _currentText = text;

    // Detect if text contains Tamil characters
    bool isTamil = RegExp(r'[\u0b80-\u0bff]').hasMatch(text);
    if (isTamil) {
      await _flutterTts.setLanguage("ta-IN");
    } else {
      await _flutterTts.setLanguage("en-US");
    }

    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _isPlaying = true;
    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      _currentText = "";
    });

    _flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
      _currentText = "";
    });

    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying = false;
    _currentText = "";
  }
}
