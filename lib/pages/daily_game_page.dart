import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyGamePage extends StatefulWidget {
  const DailyGamePage({super.key});

  @override
  State<DailyGamePage> createState() => _DailyGamePageState();
}

enum _Difficulty { easy, normal, hard }

extension _DifficultyExt on _Difficulty {
  String get label {
    switch (this) {
      case _Difficulty.easy:
        return 'Easy';
      case _Difficulty.normal:
        return 'Normal';
      case _Difficulty.hard:
        return 'Hard';
    }
  }

  String get emoji {
    switch (this) {
      case _Difficulty.easy:
        return '😊';
      case _Difficulty.normal:
        return '🧠';
      case _Difficulty.hard:
        return '💪';
    }
  }

  int get durationSeconds {
    switch (this) {
      case _Difficulty.easy:
        return 5;
      case _Difficulty.normal:
        return 3;
      case _Difficulty.hard:
        return 2;
    }
  }

  int get points {
    switch (this) {
      case _Difficulty.easy:
        return 10;
      case _Difficulty.normal:
        return 20;
      case _Difficulty.hard:
        return 30;
    }
  }

  Color get color {
    switch (this) {
      case _Difficulty.easy:
        return Colors.green;
      case _Difficulty.normal:
        return Colors.orange;
      case _Difficulty.hard:
        return Colors.red;
    }
  }
}

class _DailyGamePageState extends State<DailyGamePage> {
  _Difficulty _selected = _Difficulty.easy;
  bool _isRunning = false;
  int _remaining = 0;
  int _tapCount = 0;
  Timer? _timer;

  void _startGame() {
    setState(() {
      _tapCount = 0;
      _remaining = _selected.durationSeconds;
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
        _endGame();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  Future<void> _endGame() async {
    setState(() => _isRunning = false);

    // Award points based on taps and difficulty
    final prefs = await SharedPreferences.getInstance();
    int points = prefs.getInt("total_wellness_points") ?? 0;
    int earned = (_tapCount ~/ 5) + _selected.points;
    await prefs.setInt("total_wellness_points", points + earned);

    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Text(_selected.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            const Text('Time Up!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You tapped $_tapCount times!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "+$earned Wellness Points",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _selected.color),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildDifficultySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _Difficulty.values.map((d) {
        final bool isSelected = d == _selected;
        return GestureDetector(
          onTap: () => setState(() => _selected = d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? d.color.withValues(alpha: 0.15) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? d.color : Colors.grey.shade300,
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(d.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 4),
                Text(d.label, style: TextStyle(color: isSelected ? d.color : Colors.black54, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap Speed Game'),
        backgroundColor: const Color(0xff3FBBBB),
      ),
      backgroundColor: const Color(0xffFAFAFA),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select Difficulty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDifficultySelector(),
            const SizedBox(height: 8),
            Text(
              "${_selected.durationSeconds}s timer | ${_selected.points}+ pts",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 32),
            if (!_isRunning)
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selected.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Start ${_selected.emoji}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            else
              Column(
                children: [
                  Text('Time left: $_remaining s', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Taps: $_tapCount', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => setState(() => _tapCount++),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: _selected.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _selected.color.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _selected.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
