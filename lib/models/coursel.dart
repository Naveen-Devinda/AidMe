import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final PageController _controller = PageController(viewportFraction: 0.7);

  final List<Map<String, dynamic>> tips = [
    {
      "title": "Mindfulness Minute",
      "subtitle": "2 min - Breathing",
      "icon": Icons.lightbulb_outline,
      "color": Colors.orange,
    },
    {
      "title": "Stay Hydrate",
      "subtitle": "Drink Water",
      "icon": Icons.favorite,
      "color": Colors.amber,
    },
    {
      "title": "Stretch Break",
      "subtitle": "5 min - Stretch",
      "icon": Icons.fitness_center,
      "color": Colors.green,
    },
    {
      "title": "Quick Walk",
      "subtitle": "10 min walk",
      "icon": Icons.directions_walk,
      "color": Colors.blue,
    },
    {
      "title": "Relax Eyes",
      "subtitle": "Look away",
      "icon": Icons.remove_red_eye,
      "color": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Daily Tips",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 16),

            /// ✅ FIXED CAROUSEL (NO OVERFLOW)
            SizedBox(
              height: 100, // IMPORTANT: controls card height
              child: PageView.builder(
                controller: _controller,
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TipCard(
                      title: tip["title"],
                      subtitle: tip["subtitle"],
                      icon: tip["icon"],
                      color: tip["color"],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            /// Dots Indicator
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: tips.length,
                effect: const WormEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: Color(0xff3FBBBB),
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const TipCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
