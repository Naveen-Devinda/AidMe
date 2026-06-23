import 'package:aidme/constants/colors.dart';
import 'package:aidme/models/coursel.dart';
import 'package:aidme/pages/mental_illness.dart';
import 'package:aidme/pages/physicalmainpage.dart';
import 'package:aidme/pages/setting.dart';
import 'package:aidme/services/recent_activity_service.dart';
import 'package:aidme/widgets/button2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecentActivityEntry> _recentActivities = [];
  bool _showRecentActivity = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final items = await RecentActivityService.load();
    if (mounted) setState(() => _recentActivities = items);
  }

  Future<void> _navigateAndReload(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    await _loadActivities();
  }

  void _clearRecentActivity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Recent Activity'),
        content: const Text(
          'Are you sure you want to clear all recent activity history?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              RecentActivityService.clear().then((_) => _loadActivities());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        title: const Text(
          "AidMe",
          style: TextStyle(
            color: Color(0xff98A9AA),
            fontWeight: FontWeight.w600,
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
            iconSize: 30,
            color: const Color(0xff98A9AA),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          // ---------- Mental First Aid ----------
          GestureDetector(
            onTap: () => _navigateAndReload(
              const MentalIllness(),
            ),
            child: Button2(
              buttoName: "Mental FirstAid",
              buttonColor: const Color(0xff3FBBBB),
              fontSize: 20,
              fontColor: kWhiteColor,
              imageUrl: 'assets/images/icons8-brain-64.png',
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Physical First Aid ----------
          GestureDetector(
            onTap: () => _navigateAndReload(
              const Physicalmainpage(),
            ),
            child: Button2(
              buttoName: "Physical FirstAid",
              buttonColor: const Color(0xffBB3F3F),
              fontSize: 20,
              fontColor: kWhiteColor,
              imageUrl: 'assets/images/icons8-plus-50.png',
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Carousel ----------
          SizedBox(
            height: 180,
            child: const CarouselScreen(),
          ),
          const SizedBox(height: 20),

          // ---------- Recent Activity ----------
          if (_showRecentActivity) _buildRecentActivitySection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff98A9AA),
              ),
            ),
            IconButton(
              onPressed: _recentActivities.isEmpty
                  ? null
                  : _clearRecentActivity,
              icon: Icon(
                Icons.delete_outline,
                color: _recentActivities.isEmpty
                    ? Colors.grey.shade300
                    : Colors.red.shade300,
                size: 22,
              ),
              tooltip: 'Clear recent activity',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_recentActivities.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No recent activity yet.',
                style: TextStyle(color: Color(0xffB0C4C4), fontSize: 14),
              ),
            ),
          )
        else
          ..._recentActivities.map((activity) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff3F5A5A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    activity.formattedTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff98A9AA),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
