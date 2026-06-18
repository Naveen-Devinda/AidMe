import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/physical_firstaid_guide.dart';
import 'package:flutter/material.dart';

class Physicalmainpage extends StatelessWidget {
  const Physicalmainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffBB3F3F), Color(0xffE96A5D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: kWhiteColor,
                      iconSize: 30,
                    ),
                    const Expanded(
                      child: Text(
                        'Emergency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 50),
                const Text(
                  'Emergency Assistance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "We're here to help you to feel better...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.88),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 44),
                _PhysicalButton(
                  title: 'Physical First Aid Guide',
                  subtitle: 'Straightforward first aid guidance',
                  icon: Icons.healing,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhysicalFirstaidGuide(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 26),
                _PhysicalButton(
                  title: 'First Aid Kit',
                  subtitle: 'Check important first aid kit items',
                  icon: Icons.medical_services,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhysicalButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PhysicalButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
        decoration: BoxDecoration(
          color: kWhiteColor.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kWhiteColor.withValues(alpha: 0.22)),
        ),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: kWhiteColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kWhiteColor, size: 34),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.86),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const Icon(Icons.chevron_right, color: kWhiteColor, size: 34),
          ],
        ),
      ),
    );
  }
}
