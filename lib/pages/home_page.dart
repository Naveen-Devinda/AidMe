import 'package:aidme/constants/colors.dart';

import 'package:aidme/pages/mental_assessment_screen.dart';
import 'package:aidme/pages/physicalmainpage.dart';
import 'package:aidme/pages/setting.dart';
import 'package:aidme/pages/ai_chat_page.dart';
import 'package:aidme/pages/community_page.dart';
import 'package:aidme/pages/trackers_page.dart';
import 'package:aidme/pages/relax_page.dart';
import 'package:aidme/pages/daily_games_page.dart';
import 'package:aidme/widgets/daily_tips_carousel.dart';
import 'package:aidme/pages/quiz_page.dart';
import 'package:aidme/pages/reminders_page.dart';
import 'package:aidme/widgets/button2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeTab(
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const TrackersPage(isTab: true),
      const RelaxPage(isTab: true),
      const ResourcesTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffDBF8F2),
        body: IndexedStack(index: _currentIndex, children: _tabs),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff3FBBBB).withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffF0FDFC), Colors.white],
                ),
                border: Border(
                  top: BorderSide(color: Color(0xff3FBBBB), width: 0.8),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: const Color(0xff3FBBBB),
                unselectedItemColor: const Color(0xff98A9AA),
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 11),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined),
                    activeIcon: Icon(Icons.analytics),
                    label: "Trackers",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.spa_outlined),
                    activeIcon: Icon(Icons.spa),
                    label: "Relax",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.support_agent_outlined),
                    activeIcon: Icon(Icons.support_agent),
                    label: "Resources",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── HOME TAB CONTENT ────────────────────────────────────────────────────────
class HomeTab extends StatelessWidget {
  final Function(int) onTabChange;
  const HomeTab({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        elevation: 0,
        title: const Text(
          "AidMe",
          style: TextStyle(
            color: Color(0xff5A7273),
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
            },
            icon: const Icon(Icons.settings),
            iconSize: 28,
            color: const Color(0xff5A7273),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        children: [
          // Emergency Header
          const Text(
            "Emergency First Aid",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // Mental First Aid Button
          SizedBox(
            height: screenHeight * 0.11,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MentalAssessmentScreen(),
                ),
              ),
              child: Button2(
                buttoName: "Mental FirstAid",
                buttonColor: const Color(0xff3FBBBB),
                fontSize: 20,
                fontColor: kWhiteColor,
                imageUrl: 'assets/images/icons8-brain-64.png',
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Physical First Aid Button
          SizedBox(
            height: screenHeight * 0.11,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Physicalmainpage()),
              ),
              child: Button2(
                buttoName: "Physical FirstAid",
                buttonColor: const Color(0xffBB3F3F),
                fontSize: 20,
                fontColor: kWhiteColor,
                imageUrl: 'assets/images/icons8-plus-50.png',
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Wellness Dashboard Section Title
          const Text(
            "Wellness & Trackers",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // Grid of Health & Wellness Cards
          _buildDashboardGrid(context),

          const SizedBox(height: 24),

          // Carousel (Daily Tips)
          const Text(
            "Daily Tips",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: const DailyTipsCarousel()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final List<Map<String, dynamic>> dashboardItems = [
      {
        "title": "Health Trackers",
        "subtitle": "Mood, Sleep, Water, Exercise",
        "icon": Icons.analytics,
        "color": const Color(0xff3FBBBB),
        "onTap": () {
          // Open Trackers Page directly
          onTabChange(1); // switch tab in main navigation shell
        },
      },
      {
        "title": "Relax & Breathe",
        "subtitle": "5 Calming breathing exercises",
        "icon": Icons.spa,
        "color": Colors.teal,
        "onTap": () {
          onTabChange(2); // switch tab to relax
        },
      },
      {
        "title": "First Aid Quiz",
        "subtitle": "Test emergency knowledge",
        "icon": Icons.assignment,
        "color": Colors.orange,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuizPage()),
          );
        },
      },
      {
        "title": "Reminders",
        "subtitle": "Routine hydration & sleep alerts",
        "icon": Icons.alarm,
        "color": Colors.purple,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RemindersPage()),
          );
        },
      },
      {
        "title": "Ask AidMe AI",
        "subtitle": "Get instant support & tips",
        "icon": Icons.smart_toy,
        "color": const Color(0xff3FBBBB),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AIChatPage()),
          );
        },
      },
      {
        "title": "Community",
        "subtitle": "Connect & share experiences",
        "icon": Icons.people,
        "color": Colors.blue,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CommunityPage()),
          );
        },
      },
      {
        "title": "Daily Games",
        "subtitle": "Play to relax & earn points",
        "icon": Icons.videogame_asset,
        "color": Colors.pinkAccent,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DailyGamesPage()),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: dashboardItems.length,
      itemBuilder: (context, index) {
        final item = dashboardItems[index];
        return GestureDetector(
          onTap: item["onTap"],
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: item["color"].withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item["color"].withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item["icon"], color: item["color"], size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item["title"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["subtitle"],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── RESOURCES TAB CONTENT ───────────────────────────────────────────────────
class ResourcesTab extends StatelessWidget {
  const ResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        elevation: 0,
        title: const Text(
          "Resources & Assistance",
          style: TextStyle(
            color: Color(0xff5A7273),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "Emergency Chat & Community",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),

          // AI Chat Assistant
          WellnessCard(
            title: "Ask AidMe AI",
            subtitle: "Instant mental support & first aid guidance",
            icon: Icons.smart_toy,
            iconColor: const Color(0xff3FBBBB),
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AIChatPage()),
            ),
          ),
          const SizedBox(height: 16),

          // First Aid Quiz
          WellnessCard(
            title: "First Aid Quiz",
            subtitle: "Test and improve your emergency response knowledge",
            icon: Icons.assignment_outlined,
            iconColor: Colors.orange,
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizPage()),
            ),
          ),
          const SizedBox(height: 16),

          // Community Board
          WellnessCard(
            title: "Community Forum",
            subtitle: "Connect and share wellness tips with others",
            icon: Icons.people,
            iconColor: Colors.blue,
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CommunityPage()),
            ),
          ),
          const SizedBox(height: 16),

          // Health Reminders
          WellnessCard(
            title: "Reminders & Alerts",
            subtitle: "Configure hydration and lifestyle logs",
            icon: Icons.alarm_on,
            iconColor: Colors.purple,
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RemindersPage()),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CUSTOM CARD WIDGETS ─────────────────────────────────────────────────────
class WellnessCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const WellnessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: iconColor.withValues(alpha: 0.12),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
