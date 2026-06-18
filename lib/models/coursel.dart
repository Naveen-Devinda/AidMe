import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselScreen extends StatefulWidget {
  final Function(String) onTipTapped;

  const CarouselScreen({super.key, required this.onTipTapped});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final PageController _controller = PageController(viewportFraction: 0.75);

  final List<Map<String, dynamic>> tips = const [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Daily Tips",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 8),
        // --- Fixed height carousel ---
        SizedBox(
          height:
              100, // adjust to your liking (was 90, but 100 gives more breathing room)
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
                  onTap: () => widget.onTipTapped(tip["title"]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
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
    );
  }
}

// --- TipCard (tappable, fills the available height) ---
class TipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const TipCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
      ),
    );
  }
}
