import 'package:aidme/services/wellness_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aidme/pages/rewards_page.dart' as aidme_rewards;

class TrackersPage extends StatefulWidget {
  final bool isTab;
  const TrackersPage({super.key, this.isTab = false});

  @override
  State<TrackersPage> createState() => _TrackersPageState();
}

class _TrackersPageState extends State<TrackersPage> {
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  
  // Todays values
  String _mood = "Calm";
  double _sleepHours = 7.0;
  double _waterMl = 1000.0;
  double _exerciseMin = 15.0;
  String _eatingHabit = "Average";
  double _screenTimeHours = 4.0;
  String _stressLevel = "Medium";

  // Score & History values
  double _mentalScore = 0.0;
  double _physicalScore = 0.0;
  int _streak = 0;
  List<Map<String, dynamic>> _history = [];
  Map<String, dynamic> _achievements = {};

  final List<Map<String, String>> _moods = [
    {"mood": "Happy", "emoji": "😊"},
    {"mood": "Calm", "emoji": "😌"},
    {"mood": "Tired", "emoji": "😴"},
    {"mood": "Sad", "emoji": "😢"},
    {"mood": "Stressed", "emoji": "😰"},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final logs = await WellnessService.getLogsHistory();
    final streakData = await WellnessService.getAchievementsAndStreaks();
    
    // Find log for selected date
    final selectedDateStr = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    Map<String, dynamic>? selectedLog;
    for (var log in logs) {
      if (log["date"] == selectedDateStr) {
        selectedLog = log;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _history = logs;
        _streak = streakData["streak"] ?? 0;
        _achievements = streakData;

        if (selectedLog != null) {
          _mood = selectedLog["mood"] ?? "Calm";
          _sleepHours = (selectedLog["sleepHours"] as num?)?.toDouble() ?? 7.0;
          _waterMl = (selectedLog["waterMl"] as num?)?.toDouble() ?? 1000.0;
          _exerciseMin = (selectedLog["exerciseMin"] as num?)?.toDouble() ?? 15.0;
          _eatingHabit = selectedLog["eatingHabit"] ?? "Average";
          _screenTimeHours = (selectedLog["screenTimeHours"] as num?)?.toDouble() ?? 4.0;
          _stressLevel = selectedLog["stressLevel"] ?? "Medium";
          _mentalScore = (selectedLog["mentalScore"] as num?)?.toDouble() ?? 0.0;
          _physicalScore = (selectedLog["physicalScore"] as num?)?.toDouble() ?? 0.0;
        } else {
          // Defaults if not logged for selected date
          _mood = "Calm";
          _sleepHours = 7.0;
          _waterMl = 1000.0;
          _exerciseMin = 15.0;
          _eatingHabit = "Average";
          _screenTimeHours = 4.0;
          _stressLevel = "Medium";
          _mentalScore = 0.0;
          _physicalScore = 0.0;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTodayLog() async {
    setState(() => _isLoading = true);
    await WellnessService.saveDailyLog(
      mood: _mood,
      sleepHours: _sleepHours,
      waterMl: _waterMl,
      exerciseMin: _exerciseMin,
      eatingHabit: _eatingHabit,
      screenTimeHours: _screenTimeHours,
      stressLevel: _stressLevel,
      date: _selectedDate,
    );
    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Daily health log saved successfully! 🌿"),
          backgroundColor: Color(0xff3FBBBB),
        ),
      );
    }
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
                "Health Trackers",
                style: TextStyle(
                  color: Color(0xff5A7273),
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff3FBBBB)),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading for non‑tab mode
if (!widget.isTab) ...[
  const SizedBox(height: 16),
  const Text(
    'Health Trackers',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      color: Color(0xff5A7273),
    ),
  ),
  const SizedBox(height: 4),
  Text(
    '${_achievements['total_points'] ?? 0} Points',
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.green,
    ),
  ),
  const SizedBox(height: 24),
],
                    // Top header for tab mode
                    if (widget.isTab) ...[
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Health Trackers",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff5A7273),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.green, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "${_achievements['total_points'] ?? 0} Points",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "$_streak Day Streak",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Date Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                              _isLoading = true;
                            });
                            _loadData();
                          },
                          icon: const Icon(Icons.chevron_left, color: Color(0xff5A7273)),
                        ),
                        Text(
                          _selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month && _selectedDate.year == DateTime.now().year
                              ? "Today"
                              : "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff5A7273)),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month && _selectedDate.year == DateTime.now().year) return;
                            setState(() {
                              _selectedDate = _selectedDate.add(const Duration(days: 1));
                              _isLoading = true;
                            });
                            _loadData();
                          },
                          icon: Icon(Icons.chevron_right, color: _selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month && _selectedDate.year == DateTime.now().year ? Colors.grey : const Color(0xff5A7273)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Health Score Section
                    _buildHealthScoreCard(),
                    const SizedBox(height: 24),

                    // Daily Check-in Form
                    const Text(
                      "Log Daily Check-in",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D)),
                    ),
                    const SizedBox(height: 12),
                    _buildCheckInForm(),
                    const SizedBox(height: 24),

                    // Weekly Progress Report (embedded line graph)
                    if (_history.isNotEmpty) ...[
                      const Text(
                        "Weekly Progress Report",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D)),
                      ),
                      const SizedBox(height: 12),
                      _buildWeeklyReportCard(),
                      const SizedBox(height: 24),
                    ],

                    // Achievements Section
                    const Text(
                      "Achievements & Rewards",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D)),
                    ),
                    const SizedBox(height: 12),
                    _buildAchievementsGrid(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const aidme_rewards.RewardsPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff3FBBBB),
                          side: const BorderSide(color: Color(0xff3FBBBB)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("View Full Rewards Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHealthScoreCard() {
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Health Score",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1C3D3D)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressRing(
                title: "Mental Health",
                score: _mentalScore,
                color: const Color(0xff3FBBBB),
              ),
              Container(width: 1, height: 80, color: Colors.grey.shade200),
              _buildProgressRing(
                title: "Physical Health",
                score: _physicalScore,
                color: const Color(0xffBB3F3F),
              ),
            ],
          ),
          if (_mentalScore == 0 && _physicalScore == 0) ...[
            const SizedBox(height: 16),
            const Text(
              "⚠️ You haven't saved your check-in log today. Fill in the form below and hit 'Save Daily Log' to calculate your health score!",
              style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w600),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildProgressRing({
    required String title,
    required double score,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 75,
          width: 75,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                backgroundColor: color.withValues(alpha: 0.12),
                color: color,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
              ),
              Text(
                "${score.toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xff1C3D3D)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xff1C3D3D))),
      ],
    );
  }

  Widget _buildCheckInForm() {
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Mood
          const Text(
            "1. How is your mood today?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moods.map((m) {
              final isSelected = _mood == m["mood"];
              return GestureDetector(
                onTap: () => setState(() => _mood = m["mood"]!),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xff3FBBBB).withValues(alpha: 0.2) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xff3FBBBB) : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Text(m["emoji"]!, style: const TextStyle(fontSize: 26)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      m["mood"]!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? const Color(0xff3FBBBB) : const Color(0xff1C3D3D),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const Divider(height: 36),

          // 2. Sleep hours
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "2. Sleep duration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
              ),
              Text(
                "${_sleepHours.toStringAsFixed(1)} Hours",
                style: const TextStyle(color: Color(0xff2C6E6E), fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
          Slider.adaptive(
            value: _sleepHours,
            min: 0,
            max: 16,
            divisions: 32,
            activeColor: const Color(0xff3FBBBB),
            onChanged: (val) => setState(() => _sleepHours = val),
          ),
          const Divider(height: 36),

          // 3. Water Intake
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "3. Water Intake",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
              ),
              Text(
                "${_waterMl.toInt()} ml",
                style: const TextStyle(color: Color(0xff2C6E6E), fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => _waterMl = (_waterMl - 250).clamp(0, 5000)),
                icon: const Icon(Icons.remove, size: 16),
                label: const Text("-250ml", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _waterMl = (_waterMl + 250).clamp(0, 5000)),
                icon: const Icon(Icons.add, size: 16),
                label: const Text("+250ml", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                ),
              ),
            ],
          ),
          const Divider(height: 36),

          // 4. Exercise time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "4. Exercise time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
              ),
              Text(
                "${_exerciseMin.toInt()} Mins",
                style: const TextStyle(color: Color(0xff2C6E6E), fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
          Slider.adaptive(
            value: _exerciseMin,
            min: 0,
            max: 120,
            divisions: 24,
            activeColor: const Color(0xff3FBBBB),
            onChanged: (val) => setState(() => _exerciseMin = val),
          ),
          const Divider(height: 36),

          // 5. Eating Habits
          const Text(
            "5. Eating Habits",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
          ),
          const SizedBox(height: 10),
          Row(
            children: ["Healthy", "Average", "Junk"].map((habit) {
              final isSel = _eatingHabit == habit;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(habit),
                    selected: isSel,
                    selectedColor: const Color(0xff3FBBBB),
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : const Color(0xff1C3D3D),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _eatingHabit = habit);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          const Divider(height: 36),

          // 6. Screen Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "6. Screen Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
              ),
              Text(
                "${_screenTimeHours.toStringAsFixed(1)} Hours",
                style: const TextStyle(color: Color(0xff2C6E6E), fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
          Slider.adaptive(
            value: _screenTimeHours,
            min: 0,
            max: 18,
            divisions: 36,
            activeColor: const Color(0xff3FBBBB),
            onChanged: (val) => setState(() => _screenTimeHours = val),
          ),
          const Divider(height: 36),

          // 7. Stress level
          const Text(
            "7. Stress Level",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
          ),
          const SizedBox(height: 10),
          Row(
            children: ["Low", "Medium", "High"].map((stress) {
              final isSel = _stressLevel == stress;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(stress),
                    selected: isSel,
                    selectedColor: const Color(0xff3FBBBB),
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : const Color(0xff1C3D3D),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _stressLevel = stress);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _saveTodayLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3FBBBB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Save Daily Log",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeeklyReportCard() {
    int count = _history.length > 7 ? 7 : _history.length;
    double avgSleep = 0;
    double avgWater = 0;
    double avgExercise = 0;

    for (int i = 0; i < count; i++) {
      avgSleep += (_history[i]["sleepHours"] as num?)?.toDouble() ?? 0.0;
      avgWater += (_history[i]["waterMl"] as num?)?.toDouble() ?? 0.0;
      avgExercise += (_history[i]["exerciseMin"] as num?)?.toDouble() ?? 0.0;
    }

    avgSleep /= count;
    avgWater /= count;
    avgExercise /= count;

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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly average based on last $count entries",
            style: const TextStyle(color: Color(0xff2C6E6E), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildReportValue(Icons.bedtime, "${avgSleep.toStringAsFixed(1)}h", "Sleep", Colors.purple),
              _buildReportValue(Icons.local_drink, "${avgWater.toInt()}ml", "Water", Colors.blue),
              _buildReportValue(Icons.directions_run, "${avgExercise.toInt()}m", "Exercise", Colors.green),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            "Weekly Score Trend",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1C3D3D)),
          ),
          const SizedBox(height: 20),
          
          // Animated Medical-Style Line Chart using fl_chart
          SizedBox(
            height: 180,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final sortedList = _history.take(7).toList().reversed.toList();
                        int idx = value.toInt();
                        if (idx < 0 || idx >= sortedList.length) return const SizedBox();
                        DateTime dt = DateTime.now().subtract(Duration(days: sortedList.length - 1 - idx));
                        final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            days[dt.weekday % 7],
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    left: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                ),
                lineBarsData: [
                  // Mental Score Line
                  LineChartBarData(
                    spots: _history.take(7).toList().reversed.toList().asMap().entries.map((e) {
                      double score = (e.value["mentalScore"] as num?)?.toDouble() ?? 0.0;
                      return FlSpot(e.key.toDouble(), score);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xff3FBBBB),
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xff3FBBBB).withValues(alpha: 0.15),
                    ),
                  ),
                  // Physical Score Line
                  LineChartBarData(
                    spots: _history.take(7).toList().reversed.toList().asMap().entries.map((e) {
                      double score = (e.value["physicalScore"] as num?)?.toDouble() ?? 0.0;
                      return FlSpot(e.key.toDouble(), score);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xffBB3F3F),
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xffBB3F3F).withValues(alpha: 0.15),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          "${spot.y.toInt()}%",
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Past", style: TextStyle(color: Color(0xff2C6E6E), fontSize: 11, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xff3FBBBB), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 6),
                  const Text("Mental", style: TextStyle(color: Color(0xff1C3D3D), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xffBB3F3F), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 6),
                  const Text("Physical", style: TextStyle(color: Color(0xff1C3D3D), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text("Today", style: TextStyle(color: Color(0xff2C6E6E), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReportValue(IconData icon, String val, String title, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          radius: 20,
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff1C3D3D))),
        Text(title, style: const TextStyle(color: Color(0xff2C6E6E), fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAchievementsGrid() {
    final List<Map<String, dynamic>> items = [
      {
        "key": "achievement_first_step",
        "title": "First Step",
        "desc": "Log your very first check-in",
        "icon": Icons.emoji_events,
        "color": Colors.green,
      },
      {
        "key": "achievement_7day_streak",
        "title": "7 Day Streak",
        "desc": "Check-in 7 days consecutively",
        "icon": Icons.workspace_premium,
        "color": Colors.orangeAccent,
      },
      {
        "key": "achievement_stress_free_day",
        "title": "Stress-Free Day",
        "desc": "Happy/Calm mood + Low stress",
        "icon": Icons.wb_sunny,
        "color": Colors.amber,
      },
      {
        "key": "achievement_healthy_week",
        "title": "Healthy Week",
        "desc": "Met 2L water goal for 5+ days",
        "icon": Icons.favorite,
        "color": Colors.pinkAccent,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 85,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isUnlocked = _achievements[item["key"]] ?? false;

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: isUnlocked ? item["color"].withValues(alpha: 0.12) : Colors.grey.shade100,
              radius: 22,
              child: Icon(
                item["icon"],
                color: isUnlocked ? item["color"] : Colors.grey.shade400,
                size: 24,
              ),
            ),
            title: Text(
              item["title"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isUnlocked ? const Color(0xff1C3D3D) : Colors.grey.shade600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 2),
                Text(
                  item["desc"],
                  style: TextStyle(fontSize: 11, color: isUnlocked ? Colors.black54 : Colors.grey.shade400),
                ),
              ],
            ),
            trailing: Icon(
              isUnlocked ? Icons.check_circle : Icons.lock_outline,
              color: isUnlocked ? const Color(0xff3FBBBB) : Colors.grey.shade300,
              size: 22,
            ),
          ),
        );
      },
    );
  }
}
