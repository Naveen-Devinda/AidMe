import 'package:flutter/material.dart';
import 'package:aidme/services/wellness_service.dart';
import 'package:fl_chart/fl_chart.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _streak = 0;
  int _points = 0;
  bool _firstStep = false;
  bool _sevenDayStreak = false;
  bool _stressFree = false;
  bool _healthyWeek = false;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final data = await WellnessService.getAchievementsAndStreaks();
    setState(() {
      _streak = data["streak"] ?? 0;
      _points = data["total_points"] ?? 0;
      _firstStep = data["achievement_first_step"] ?? false;
      _sevenDayStreak = data["achievement_7day_streak"] ?? false;
      _stressFree = data["achievement_stress_free_day"] ?? false;
      _healthyWeek = data["achievement_healthy_week"] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        elevation: 0,
        title: const Text(
          "My Rewards",
          style: TextStyle(
            color: Color(0xff5A7273),
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff5A7273)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Score Board
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff3FBBBB), Color(0xff2C6E6E)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.stars, color: Colors.yellow, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      "$_points",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Total Points",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orangeAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$_streak",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Day Streak",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Linear progress graph showing points over recent days
          LinearGraph(
            dataPoints: [10, 20, 15, 30, 25, 40, _points.toDouble()],
            maxY: 50,
          ),
          // Daily reward badge if goal met
          if (_points >= 50) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.card_giftcard, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text(
                    "Daily Reward Unlocked!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            "Badges & Achievements",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff5A7273),
            ),
          ),
          const SizedBox(height: 16),
          _buildBadge(
            "First Step",
            "Completed your first check-in",
            Icons.emoji_events,
            _firstStep,
          ),
          _buildBadge(
            "7-Day Warrior",
            "Maintained a 7-day streak",
            Icons.workspace_premium,
            _sevenDayStreak,
          ),
          _buildBadge(
            "Zen Master",
            "Had a stress-free day",
            Icons.self_improvement,
            _stressFree,
          ),
          _buildBadge(
            "Hydration Hero",
            "Drank enough water for 5 days",
            Icons.water_drop,
            _healthyWeek,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, String desc, IconData icon, bool earned) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: earned ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(16),
        border: earned
            ? Border.all(color: const Color(0xff3FBBBB), width: 2)
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: earned
                ? const Color(0xff3FBBBB).withValues(alpha: 0.2)
                : Colors.grey.shade300,
            radius: 28,
            child: Icon(
              icon,
              color: earned ? const Color(0xff3FBBBB) : Colors.grey,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: earned ? Colors.black87 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: earned ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (earned) const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }
}

class LinearGraph extends StatelessWidget {
  final List<double> dataPoints;
  final double maxY;
  const LinearGraph({super.key, required this.dataPoints, required this.maxY});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxVal = dataPoints.reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxVal > 0 ? maxVal + 10 : 50.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff3FBBBB).withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Points Progress",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1C3D3D)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: effectiveMax,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          "${spot.y.toInt()} pts",
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx < 0 || idx >= days.length) return const SizedBox();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            days[idx],
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: effectiveMax / 4,
                      reservedSize: 30,
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
                  horizontalInterval: effectiveMax / 4,
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
                  LineChartBarData(
                    spots: List.generate(dataPoints.length, (i) => FlSpot(i.toDouble(), dataPoints[i])),
                    isCurved: true,
                    color: const Color(0xff3FBBBB),
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: const Color(0xff3FBBBB),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff3FBBBB).withValues(alpha: 0.35),
                          const Color(0xff3FBBBB).withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}
