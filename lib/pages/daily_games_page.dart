import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameDifficulty { easy, normal, hard }

extension GameDifficultyExt on GameDifficulty {
  String get label {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.normal:
        return 'Normal';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  String get emoji {
    switch (this) {
      case GameDifficulty.easy:
        return '😊';
      case GameDifficulty.normal:
        return '🧠';
      case GameDifficulty.hard:
        return '💪';
    }
  }

  int get pairs {
    switch (this) {
      case GameDifficulty.easy:
        return 6;
      case GameDifficulty.normal:
        return 12;
      case GameDifficulty.hard:
        return 15;
    }
  }

  int get crossAxisCount {
    switch (this) {
      case GameDifficulty.easy:
        return 3;
      case GameDifficulty.normal:
        return 4;
      case GameDifficulty.hard:
        return 5;
    }
  }

  int get points {
    switch (this) {
      case GameDifficulty.easy:
        return 10;
      case GameDifficulty.normal:
        return 20;
      case GameDifficulty.hard:
        return 30;
    }
  }

  Color get color {
    switch (this) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.normal:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
    }
  }
}

class DailyGamesPage extends StatefulWidget {
  const DailyGamesPage({super.key});

  @override
  State<DailyGamesPage> createState() => _DailyGamesPageState();
}

class _DailyGamesPageState extends State<DailyGamesPage> {
  // Mental health related emojis
  final List<String> _allEmojis = [
    "😊", "😌", "🧠", "💪", "❤️", "🧘", "🌿", "☀️",
    "😴", "🎵", "🦋", "🌈", "⭐", "🕊️", "🌸", "💫",
    "🍃", "🌻", "🧡", "💛", "💚", "💙", "💜", "🤍",
  ];

  late List<String> _cards;
  List<bool> _isFlipped = [];
  List<bool> _isMatched = [];

  int _previousIndex = -1;
  bool _isProcessing = false;
  int _moves = 0;
  bool _isGameWon = false;
  GameDifficulty _selectedDifficulty = GameDifficulty.easy;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void _startNewGame() {
    final numPairs = _selectedDifficulty.pairs;
    final selectedEmojis = _allEmojis.sublist(0, numPairs);
    final totalCards = numPairs * 2;

    setState(() {
      _cards = [...selectedEmojis, ...selectedEmojis];
      _cards.shuffle();
      _isFlipped = List<bool>.filled(totalCards, false);
      _isMatched = List<bool>.filled(totalCards, false);
      _previousIndex = -1;
      _isProcessing = false;
      _moves = 0;
      _isGameWon = false;
      _gameStarted = true;
    });
  }

  void _onCardTap(int index) {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) return;

    setState(() {
      _isFlipped[index] = true;
    });

    if (_previousIndex == -1) {
      _previousIndex = index;
    } else {
      _moves++;
      _isProcessing = true;
      if (_cards[_previousIndex] == _cards[index]) {
        setState(() {
          _isMatched[_previousIndex] = true;
          _isMatched[index] = true;
        });
        _previousIndex = -1;
        _isProcessing = false;
        _checkWinCondition();
      } else {
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _isFlipped[_previousIndex] = false;
              _isFlipped[index] = false;
              _previousIndex = -1;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  Future<void> _checkWinCondition() async {
    if (!_isMatched.contains(false)) {
      setState(() {
        _isGameWon = true;
      });
      final prefs = await SharedPreferences.getInstance();
      int points = prefs.getInt("total_wellness_points") ?? 0;
      await prefs.setInt("total_wellness_points", points + _selectedDifficulty.points);
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = _selectedDifficulty.crossAxisCount;

    return Scaffold(
      backgroundColor: const Color(0xffF4F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4F9F9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff1C3D3D)),
        title: const Text(
          "Daily Game",
          style: TextStyle(color: Color(0xff1C3D3D), fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Memory Match",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff3FBBBB)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Train your brain! Match all pairs to earn wellness points.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Level Selector
              if (!_gameStarted) ...[
                const Text(
                  "Select Difficulty",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: GameDifficulty.values.map((d) {
                    final isSelected = d == _selectedDifficulty;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDifficulty = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? d.color.withValues(alpha: 0.15) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? d.color : Colors.grey.shade200,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: d.color.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Text(d.emoji, style: const TextStyle(fontSize: 32)),
                            const SizedBox(height: 6),
                            Text(
                              d.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? d.color : Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${d.points} pts",
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? d.color : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _startNewGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedDifficulty.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      "Start ${_selectedDifficulty.label} Game",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],

              if (_gameStarted) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(_selectedDifficulty.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(
                          _selectedDifficulty.label,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _selectedDifficulty.color),
                        ),
                      ],
                    ),
                    Text(
                      "Moves: $_moves",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _gameStarted = false;
                          _isGameWon = false;
                        });
                      },
                      icon: Icon(Icons.refresh, color: _selectedDifficulty.color),
                      label: Text("New", style: TextStyle(color: _selectedDifficulty.color, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (_gameStarted && _isGameWon)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 100),
                        const SizedBox(height: 16),
                        const Text("You Won!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D))),
                        const SizedBox(height: 8),
                        Text("Completed in $_moves moves.", style: const TextStyle(fontSize: 18, color: Colors.black54)),
                        const SizedBox(height: 8),
                        Text(
                          "+${_selectedDifficulty.points} Wellness Points!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _selectedDifficulty.color),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _startNewGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedDifficulty.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text("Play Again", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                )
              else if (_gameStarted)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      bool isRevealed = _isFlipped[index] || _isMatched[index];
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isRevealed ? Colors.white : _selectedDifficulty.color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              if (!isRevealed)
                                BoxShadow(
                                  color: _selectedDifficulty.color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                            ],
                            border: isRevealed ? Border.all(color: Colors.grey.shade300, width: 2) : null,
                          ),
                          child: Center(
                            child: isRevealed
                                ? Text(_cards[index], style: const TextStyle(fontSize: 36))
                                : const Icon(Icons.question_mark, color: Colors.white, size: 30),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
