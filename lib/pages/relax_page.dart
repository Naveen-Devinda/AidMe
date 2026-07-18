import 'dart:async';
import 'package:aidme/pages/daily_notes_page.dart';
import 'package:flutter/material.dart';

class BreathingExercise {
  final String title;
  final String desc;
  final int inhaleSeconds;
  final int hold1Seconds;
  final int exhaleSeconds;
  final int hold2Seconds;

  const BreathingExercise({
    required this.title,
    required this.desc,
    required this.inhaleSeconds,
    required this.hold1Seconds,
    required this.exhaleSeconds,
    required this.hold2Seconds,
  });
}

const List<BreathingExercise> breathingExercisesList = [
  BreathingExercise(
    title: "4-7-8 Relaxing Breath",
    desc: "For anxiety relief, stress reduction, and deep sleep.",
    inhaleSeconds: 4,
    hold1Seconds: 7,
    exhaleSeconds: 8,
    hold2Seconds: 0,
  ),
  BreathingExercise(
    title: "Box Breathing",
    desc: "Navy SEAL technique to reset nervous system and improve focus.",
    inhaleSeconds: 4,
    hold1Seconds: 4,
    exhaleSeconds: 4,
    hold2Seconds: 4,
  ),
  BreathingExercise(
    title: "Equal Breathing (Sama Vritti)",
    desc: "Balances energy flow, calms panic, and regulates heart rate.",
    inhaleSeconds: 4,
    hold1Seconds: 0,
    exhaleSeconds: 4,
    hold2Seconds: 0,
  ),
  BreathingExercise(
    title: "Deep Relaxation",
    desc: "Longer exhales slow down heartbeat and induce relaxation.",
    inhaleSeconds: 5,
    hold1Seconds: 2,
    exhaleSeconds: 7,
    hold2Seconds: 0,
  ),
  BreathingExercise(
    title: "Quick Recharge",
    desc: "Short rapid cycles to boost oxygen intake and wake up.",
    inhaleSeconds: 2,
    hold1Seconds: 0,
    exhaleSeconds: 2,
    hold2Seconds: 0,
  ),
];

class RelaxPage extends StatefulWidget {
  final bool isTab;
  const RelaxPage({super.key, this.isTab = false});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> with TickerProviderStateMixin {
  // Breathing animation states
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  String _breathingTextEn = "Tap to Start";
  int _secondsRemaining = 60;
  Timer? _sessionTimer;
  bool _isBreathingActive = false;
  int _selectedMinutes = 1; // 1 min or 5 min
  int _selectedExerciseIndex = 0; // 0 to 4 corresponding to 5 exercises

  // Meditation state
  bool _isMeditationActive = false;
  int _meditationSeconds = 0;
  Timer? _meditationTimer;
  String _meditationType = "Mindfulness";
  double _focusPulse = 1.0;
  Timer? _pulseTimer;

  // Guided meditation text rotation
  int _guidedTextIndex = 0;
  final Map<String, List<String>> _meditationScripts = {
    "Mindfulness": [
      "Find a comfortable position.",
      "Close your eyes gently.",
      "Notice the rhythm of your breath.",
      "Let your thoughts drift like clouds.",
      "Bring your focus back to the present.",
      "Feel the peace within you.",
    ],
    "Deep Focus": [
      "Settle into your space.",
      "Take a deep, clearing breath.",
      "Visualize your goal clearly.",
      "Release any distractions.",
      "Feel your concentration sharpening.",
      "You are grounded and ready.",
    ],
    "Relax & Sleep": [
      "Lie down comfortably.",
      "Take a slow, deep breath in.",
      "Exhale and release all tension.",
      "Feel your body getting heavier.",
      "Let the quiet wash over you.",
      "Drift into deep relaxation.",
    ],
  };

  @override
  void initState() {
    super.initState();

    // Scale animation helper
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Dynamic duration set inside cycle
    );

    _breathingAnimation = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _sessionTimer?.cancel();
    _meditationTimer?.cancel();
    _pulseTimer?.cancel();
    super.dispose();
  }

  // 1 Min / 5 Min Breathing Exercise
  void _startBreathing() {
    setState(() {
      _isBreathingActive = true;
      _secondsRemaining = _selectedMinutes * 60;
    });

    _runBreathingCycle();

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        _stopBreathing();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _runBreathingCycle() async {
    if (!_isBreathingActive) return;

    final exercise = breathingExercisesList[_selectedExerciseIndex];

    // Phase 1: Inhale
    if (!mounted || !_isBreathingActive) return;
    setState(() {
      _breathingTextEn = "Breathe In";
    });
    _breathingController.duration = Duration(seconds: exercise.inhaleSeconds);
    _breathingController.forward();
    await Future.delayed(Duration(seconds: exercise.inhaleSeconds));

    // Phase 2: Hold (Inhale state)
    if (exercise.hold1Seconds > 0) {
      if (!mounted || !_isBreathingActive) return;
      setState(() {
        _breathingTextEn = "Hold Breath";
      });
      await Future.delayed(Duration(seconds: exercise.hold1Seconds));
    }

    // Phase 3: Exhale
    if (!mounted || !_isBreathingActive) return;
    setState(() {
      _breathingTextEn = "Breathe Out";
    });
    _breathingController.duration = Duration(seconds: exercise.exhaleSeconds);
    _breathingController.reverse();
    await Future.delayed(Duration(seconds: exercise.exhaleSeconds));

    // Phase 4: Hold (Exhale/Empty state)
    if (exercise.hold2Seconds > 0) {
      if (!mounted || !_isBreathingActive) return;
      setState(() {
        _breathingTextEn = "Hold Empty";
      });
      await Future.delayed(Duration(seconds: exercise.hold2Seconds));
    }

    // Loop if active
    if (_isBreathingActive) {
      _runBreathingCycle();
    }
  }

  void _stopBreathing() {
    _sessionTimer?.cancel();
    _breathingController.reset();
    if (mounted) {
      setState(() {
        _isBreathingActive = false;
        _breathingTextEn = "Session Completed! 🌿";
      });
    }
  }

  // Meditation timer trigger
  void _startMeditation(String type, int durationMinutes) {
    _meditationTimer?.cancel();
    setState(() {
      _isMeditationActive = true;
      _meditationType = type;
      _meditationSeconds = durationMinutes * 60;
    });

    _meditationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_meditationSeconds <= 1) {
        _stopMeditation();
      } else {
        setState(() {
          _meditationSeconds--;
        });
      }
    });

    _pulseTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _focusPulse = _focusPulse == 1.0 ? 1.4 : 1.0;
          // Rotate text every 8 seconds (2 pulses)
          if (timer.tick % 2 == 0) {
            _guidedTextIndex =
                (_guidedTextIndex + 1) %
                (_meditationScripts[_meditationType]?.length ?? 1);
          }
        });
      }
    });
  }

  void _stopMeditation() {
    _meditationTimer?.cancel();
    _pulseTimer?.cancel();
    if (mounted) {
      setState(() {
        _isMeditationActive = false;
      });
    }
  }

  String _formatTime(int totalSeconds) {
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: widget.isTab
          ? null
          : AppBar(
              backgroundColor: const Color(0xffDBF8F2),
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xff5A7273)),
              title: const Text(
                "Relax & Meditation",
                style: TextStyle(
                  color: Color(0xff5A7273),
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inline Header in tab mode
              if (widget.isTab) ...[
                const Text(
                  "Relax & Meditation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff5A7273),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Calm your mind, release stress, and find peace.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff2C6E6E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Guided Breathing Card
              _buildBreathingSection(),
              const SizedBox(height: 24),

              // Meditation Sessions Section
              const Text(
                "Short Meditation Timers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1C3D3D),
                ),
              ),
              const SizedBox(height: 12),
              _isMeditationActive
                  ? _buildMeditationActiveScreen()
                  : _buildMeditationChoices(),
              const SizedBox(height: 24),

              // Journal & Diary Entry
              _buildJournalRedirectCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingSection() {
    final currentExercise = breathingExercisesList[_selectedExerciseIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Guided Breathing",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1C3D3D),
                    ),
                  ),
                ],
              ),
              if (!_isBreathingActive)
                Row(
                  children: [
                    _durationChip(1, "1 Min"),
                    const SizedBox(width: 8),
                    _durationChip(5, "5 Min"),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE2F9F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(
                      color: Color(0xff3FBBBB),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Exercise Selector
          if (!_isBreathingActive) ...[
            const Text(
              "Choose Exercise:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff2C6E6E),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: breathingExercisesList.length,
                itemBuilder: (context, index) {
                  final ex = breathingExercisesList[index];
                  final isSelected = _selectedExerciseIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ex.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xff3FBBBB),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xff1C3D3D),
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedExerciseIndex = index;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Exercise Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffDBF8F2).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentExercise.desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff1C3D3D),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Timing: Inhale ${currentExercise.inhaleSeconds}s | Hold ${currentExercise.hold1Seconds}s | Exhale ${currentExercise.exhaleSeconds}s${currentExercise.hold2Seconds > 0 ? " | Hold Empty ${currentExercise.hold2Seconds}s" : ""}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Breathing Animation Bubble
          Center(
            child: GestureDetector(
              onTap: () {
                if (_isBreathingActive) {
                  _stopBreathing();
                } else {
                  _startBreathing();
                }
              },
              child: SizedBox(
                height: 180,
                width: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring pulsing
                    AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        double scale = _isBreathingActive
                            ? _breathingAnimation.value
                            : 1.0;
                        return Container(
                          height: 70 * scale,
                          width: 70 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xff3FBBBB,
                            ).withValues(alpha: 0.12),
                          ),
                        );
                      },
                    ),
                    // Inner core
                    AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        double scale = _isBreathingActive
                            ? (_breathingAnimation.value - 0.2).clamp(1.0, 2.0)
                            : 1.0;
                        return Container(
                          height: 60 * scale,
                          width: 60 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff3FBBBB),
                                const Color(0xff3FBBBB).withValues(alpha: 0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xff3FBBBB,
                                ).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.spa,
                            color: Colors.white,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Breathing Instruction Text
          Center(
            child: Text(
              _breathingTextEn,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1C3D3D),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action button
          Center(
            child: SizedBox(
              width: 150,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  if (_isBreathingActive) {
                    _stopBreathing();
                  } else {
                    _startBreathing();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBreathingActive
                      ? const Color(0xffBB3F3F)
                      : const Color(0xff3FBBBB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  _isBreathingActive ? "Stop Exercise" : "Start Exercise",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationChip(int minutes, String label) {
    final isSelected = _selectedMinutes == minutes;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMinutes = minutes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff3FBBBB) : Colors.grey[150],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xff1C3D3D),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationChoices() {
    final List<Map<String, dynamic>> sessions = [
      {
        "title": "Mindfulness",
        "desc": "Calm your swirling thoughts",
        "icon": Icons.self_improvement,
        "time": 5,
        "color": Colors.orangeAccent,
      },
      {
        "title": "Deep Focus",
        "desc": "Enhance your concentration",
        "icon": Icons.center_focus_strong,
        "time": 10,
        "color": Colors.indigoAccent,
      },
      {
        "title": "Relax & Sleep",
        "desc": "Prepare for a deep rest",
        "icon": Icons.nightlight_round,
        "time": 15,
        "color": Colors.purpleAccent,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final s = sessions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, s["color"].withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: s["color"].withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _startMeditation(s["title"], s["time"]),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: s["color"].withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(s["icon"], color: s["color"], size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Color(0xff1C3D3D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s["desc"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${s["time"]} Minutes",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: s["color"],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: s["color"].withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Start",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeditationActiveScreen() {
    final scripts = _meditationScripts[_meditationType] ?? ["Breathe deeply."];
    final currentScript = scripts[_guidedTextIndex % scripts.length];

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff1A3B3B),
            _meditationType == "Relax & Sleep"
                ? const Color(0xff2A2A4A)
                : const Color(0xff2A5A5A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _meditationType,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 40),

          // Pulsing Dot Focus Exercise
          AnimatedContainer(
            duration: const Duration(seconds: 4),
            curve: Curves.easeInOutSine,
            height: 140 * _focusPulse,
            width: 140 * _focusPulse,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: const Color(0xff3FBBBB).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOutSine,
                height: 80 * _focusPulse,
                width: 80 * _focusPulse,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff3FBBBB).withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff3FBBBB),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff3FBBBB).withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Guided Text with crossfade
          AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            child: Text(
              currentScript,
              key: ValueKey<String>(currentScript),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),

          Text(
            _formatTime(_meditationSeconds),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: 160,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _stopMeditation,
              icon: const Icon(Icons.stop_circle_outlined, size: 22),
              label: const Text(
                "End Session",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalRedirectCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff3FBBBB), Color(0xff2A8E8E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff3FBBBB).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DailyNotesPage()),
          ),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 24,
                  child: Icon(Icons.edit_note, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Write in Daily Notes / Journal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
