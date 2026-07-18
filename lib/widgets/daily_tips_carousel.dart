import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyTipsCarousel extends StatefulWidget {
  const DailyTipsCarousel({super.key});

  @override
  State<DailyTipsCarousel> createState() => _DailyTipsCarouselState();
}

class _DailyTipsCarouselState extends State<DailyTipsCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  final List<String> tips = const [
    "Stay hydrated – drink at least 8 glasses of water a day.",
    "Take short breaks during work to stretch and relax your eyes.",
    "Practice deep breathing for 5 minutes to reduce stress.",
    "Maintain a regular sleep schedule for better recovery.",
    "Add a fruit or vegetable to each meal for extra vitamins.",
    "Set a reminder to stand up and move every hour.",
    "Focus on positive thoughts – write down 3 things you are grateful for.",
    "Limit screen time before bed to improve sleep quality.",
    "Practice mindfulness meditation for 10 minutes daily.",
    "Take a short walk outside for fresh air and mental clarity.",
    "Listen to calming music to lower your blood pressure.",
    "Do 15 minutes of light stretching to relieve muscle tension.",
    "Stay connected with loved ones for emotional support.",
    "Organize your workspace to clear your mind.",
    "Remember to smile; it naturally boosts your mood and relieves stress."
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % tips.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: tips.length,
      controller: _pageController,
      onPageChanged: (index) {
        _currentPage = index;
      },
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            tips[index],
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xff5A7273),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
