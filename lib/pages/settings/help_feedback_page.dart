import 'package:flutter/material.dart';

class HelpFeedbackPage extends StatelessWidget {
  const HelpFeedbackPage({super.key});

  static final List<_FAQ> _faqs = [
    _FAQ(
      'How do I use Mental First Aid?',
      'Go to the home page and tap on "Mental FirstAid". You will find information about common mental health conditions and guided exercises.',
    ),
    _FAQ(
      'How do I add emergency contacts?',
      'During registration you can add up to 3 emergency contacts. You can also update them anytime from Profile Management in Settings.',
    ),
    _FAQ(
      'Can I change my medical information?',
      'Yes, go to Settings > Profile Management where you can view all your medical details including blood group, height, and weight.',
    ),
    _FAQ(
      'Is my data stored securely?',
      'Yes, your personal data is stored in Firebase Firestore with industry-standard security. Read our Privacy Agreement in Privacy & Security settings.',
    ),
    _FAQ(
      'How do I reset my password?',
      'You can change your password from Settings > Privacy & Security > Change Password. If you forgot your password, use the "Forgotten password?" link on the login page.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(title: const Text('Help & Feedback')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          const Text('Frequently Asked Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._faqs.map((faq) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)
                  ],
                ),
                child: ExpansionTile(
                  title: Text(faq.question,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  children: [
                    Text(faq.answer,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withValues(alpha: 0.7),
                            height: 1.5)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _FAQ {
  final String question;
  final String answer;
  const _FAQ(this.question, this.answer);
}
