import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/mental_execise_screen.dart';
import 'package:flutter/material.dart';

class MentalIllnessDetails extends StatelessWidget {
  final String title;
  final String description;

  const MentalIllnessDetails({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3FBBBB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '($description)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kBlackColor.withValues(alpha: 0.75),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(42),
                    topRight: Radius.circular(42),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      'Ready to',
                      style: TextStyle(
                        color: Color(0xff3FBBBB),
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const Text(
                      'fix you',
                      style: TextStyle(
                        color: Color(0xff3FBBBB),
                        fontSize: 38,
                        fontWeight: FontWeight.w300,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: 0.28,
                      child: Image.asset(
                        'assets/images/mainmentalpage.png',
                        width: 260,
                        height: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MentalExeciseScreen(illnessTitle: title),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff3FBBBB),
                            foregroundColor: kWhiteColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 72),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
