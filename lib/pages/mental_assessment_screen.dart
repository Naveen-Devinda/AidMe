import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/mental_illness.dart';
import 'package:aidme/pages/mental_questionnaire_screen.dart';
import 'package:flutter/material.dart';

class MentalAssessmentScreen extends StatelessWidget {
  const MentalAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3FBBBB), Color(0xffDBF8F2), kWhiteColor],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 28),
                const Text(
                  'Mental First Aid',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Do you know what you are feeling right now?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kBlackColor.withValues(alpha: 0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 36),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _AssessmentCard(
                          title: "I'm Aware",
                          subtitle: 'I know what I\'m feeling',
                          icon: Icons.self_improvement,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MentalIllness(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _AssessmentCard(
                          title: "I'm Confused",
                          subtitle: 'Help me figure it out',
                          icon: Icons.help_outline,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MentalQuestionnaireScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _AssessmentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xff3FBBBB), size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                color: kBlackColor.withValues(alpha: 0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
