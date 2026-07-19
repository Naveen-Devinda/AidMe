import 'package:aidme/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aidme/pages/mental_assessment_screen.dart';
import 'package:aidme/pages/physicalmainpage.dart';
import 'package:aidme/pages/setting.dart';
import 'package:aidme/pages/ai_chat_page.dart';
import 'package:aidme/pages/community_page.dart';
import 'package:aidme/pages/trackers_page.dart';
import 'package:aidme/pages/emergency_services_page.dart';
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
  int _currentIndex = 1;
  late final List<Widget> _tabs;

  static const Color _navBarBg = Color(0xff1F7A7A);

  @override
  void initState() {
    super.initState();
    _tabs = [
      const TrackersPage(isTab: true),
      HomeTab(
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const ResourcesTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            _currentIndex = 1;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffDBF8F2),
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
        bottomNavigationBar: SizedBox(
          height: 100,
          child: _buildCustomNavBar(),
        ),
      ),
    );
  }

  void _onNavTap(int navIndex) {
    if (navIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EmergencyServicesPage(),
        ),
      );
    } else if (navIndex == 1) {
      setState(() => _currentIndex = 0);
    } else if (navIndex == 2) {
      setState(() => _currentIndex = 1);
    } else if (navIndex == 3) {
      setState(() => _currentIndex = 2);
    } else if (navIndex == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Setting()),
      );
    }
  }

  Widget _buildCustomNavBar() {
    const int centerNavIndex = 2;

    final items = [
      _NavItem(icon: Icons.emergency_outlined, activeIcon: Icons.emergency, label: 'Emergency', navIndex: 0),
      _NavItem(icon: Icons.analytics_outlined, activeIcon: Icons.analytics, label: 'Trackers', navIndex: 1),
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', navIndex: centerNavIndex),
      _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Resources', navIndex: 3),
      _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings', navIndex: 4),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: _navBarBg,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            if (item.navIndex == centerNavIndex) {
              return _buildCenterButton(item);
            }
            return _buildSideButton(item);
          }).toList(),
        ),
      ),
    );
  }

  bool _isNavActive(_NavItem item) {
    if (item.navIndex == 0) return false;
    if (item.navIndex == 4) return false;
    final tabMap = {1: 0, 2: 1, 3: 2};
    return _currentIndex == tabMap[item.navIndex];
  }

  Widget _buildCenterButton(_NavItem item) {
    final isActive = _isNavActive(item);
    return GestureDetector(
      onTap: () => _onNavTap(item.navIndex),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xffBAFCFB),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffBAFCFB).withValues(alpha: 0.3),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isActive ? item.activeIcon : item.icon,
              color: const Color(0xff1C2B2B),
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              color: isActive ? const Color(0xffDBF8F2) : Colors.white54,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSideButton(_NavItem item) {
    final isActive = _isNavActive(item);
    return GestureDetector(
      onTap: () => _onNavTap(item.navIndex),
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Icon(
              isActive ? item.activeIcon : item.icon,
              color: isActive ? const Color(0xffDBF8F2) : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? const Color(0xffDBF8F2) : Colors.white54,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int navIndex;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.navIndex,
  });
}

// ── HOME TAB CONTENT ────────────────────────────────────────────────────────
class HomeTab extends StatefulWidget {
  final Function(int) onTabChange;
  const HomeTab({super.key, required this.onTabChange});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("username");
    if (mounted) {
      setState(() {
        _userName = (name != null && name.isNotEmpty) ? name : "User";
      });
    }
  }

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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Hi, $_userName 👋",
                style: const TextStyle(
                  color: Color(0xff5A7273),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    "AI & Community",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Two Cards: AI Chat + Community
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          title: "Ask AidMe AI",
                          subtitle: "Get instant support & tips",
                          icon: Icons.smart_toy,
                          color: const Color(0xff3FBBBB),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AIChatPage()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          title: "Community",
                          subtitle: "Connect & share experiences",
                          icon: Icons.people,
                          color: Colors.blue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CommunityPage()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Daily Tips
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.9),
              Colors.white.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
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
            "Health & Wellness",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),

          // Health Trackers
          WellnessCard(
            title: "Health Trackers",
            subtitle: "Mood, Sleep, Water, Exercise tracking",
            icon: Icons.analytics,
            iconColor: const Color(0xff3FBBBB),
            backgroundColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 16),

          // Reminders
          WellnessCard(
            title: "Reminders & Alerts",
            subtitle: "Routine hydration & sleep alerts",
            icon: Icons.alarm,
            iconColor: Colors.purple,
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RemindersPage()),
            ),
          ),
          const SizedBox(height: 16),

          // Daily Games
          WellnessCard(
            title: "Daily Games",
            subtitle: "Play to relax & earn points",
            icon: Icons.videogame_asset,
            iconColor: Colors.pinkAccent,
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DailyGamesPage()),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Emergency & Learning",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),

          // First Aid Quiz
          WellnessCard(
            title: "First Aid Quiz",
            subtitle: "Test emergency response knowledge",
            icon: Icons.assignment_outlined,
            iconColor: Colors.orange,
            backgroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizPage()),
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
