import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/mental_execise_screen.dart';
import 'package:flutter/material.dart';

class MentalQuestionnaireScreen extends StatefulWidget {
  const MentalQuestionnaireScreen({super.key});

  @override
  State<MentalQuestionnaireScreen> createState() =>
      _MentalQuestionnaireScreenState();
}

class _MentalQuestionnaireScreenState
    extends State<MentalQuestionnaireScreen> {
  int _currentStep = 0;
  String? _selectedFeeling;
  String? _selectedFearType;
  String? _suggestedIllness;
  String? _suggestedDescription;

  static const List<Map<String, String>> _illnesses = [
    {'name': 'Anxiety Disorder', 'description': 'Too much fear or worry'},
    {'name': 'Depression', 'description': 'Feeling very sad, empty or tired'},
    {'name': 'Stress Disorder', 'description': 'Sudden stress overload'},
    {'name': 'Panic Disorder', 'description': 'Sudden strong fear attacks'},
    {'name': 'Insomnia', 'description': 'Trouble sleeping'},
    {'name': 'Anger Disorder', 'description': 'Trouble controlling anger'},
    {
      'name': 'Emotional Numbness',
      'description': 'No feelings or emotions',
    },
    {'name': 'Social Anxiety', 'description': 'Fear of people or social groups'},
  ];

  String _getDescription(String illnessName) {
    return _illnesses
            .firstWhere((i) => i['name'] == illnessName)['description'] ??
        '';
  }

  void _selectFeeling(String feeling) {
    setState(() {
      _selectedFeeling = feeling;
      if (feeling == 'anxious') {
        _currentStep = 1;
      } else {
        _suggestedIllness = _mapToIllness(feeling, null);
        _suggestedDescription = _getDescription(_suggestedIllness!);
        _currentStep = 2;
      }
    });
  }

  void _selectFearType(String fearType) {
    setState(() {
      _selectedFearType = fearType;
      _suggestedIllness = _mapToIllness('anxious', fearType);
      _suggestedDescription = _getDescription(_suggestedIllness!);
      _currentStep = 2;
    });
  }

  String _mapToIllness(String feeling, String? fearType) {
    switch (feeling) {
      case 'sad':
        return 'Depression';
      case 'anxious':
        if (fearType == 'constant_worry') return 'Anxiety Disorder';
        if (fearType == 'panic_attacks') return 'Panic Disorder';
        if (fearType == 'social_fear') return 'Social Anxiety';
        return 'Anxiety Disorder';
      case 'angry':
        return 'Anger Disorder';
      case 'numb':
        return 'Emotional Numbness';
      case 'stressed':
        return 'Stress Disorder';
      case 'insomnia':
        return 'Insomnia';
      default:
        return 'Anxiety Disorder';
    }
  }

  void _startExercises() {
    if (_suggestedIllness != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MentalExeciseScreen(illnessTitle: _suggestedIllness!),
        ),
      );
    }
  }

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
                const SizedBox(height: 14),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    Text(
                      'Step ${_currentStep + 1} of 3',
                      style: TextStyle(
                        color: kBlackColor.withValues(alpha: 0.45),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 6),
                Expanded(child: _buildStep()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildQuestion1();
      case 1:
        return _buildQuestion2();
      case 2:
        return _buildResult();
      default:
        return const SizedBox();
    }
  }

  Widget _buildQuestion1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'How have you been feeling lately?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kBlackColor,
          ),
        ),
        const SizedBox(height: 24),
        ..._feelingOptions.map((option) {
          final isSelected = _selectedFeeling == option['value'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              emoji: option['emoji']!,
              label: option['label']!,
              isSelected: isSelected,
              onTap: () => _selectFeeling(option['value']!),
            ),
          );
        }),
      ],
    );
  }

  List<Map<String, String>> get _feelingOptions => [
        {'emoji': '😢', 'label': 'Sad, empty, or tired', 'value': 'sad'},
        {'emoji': '😰', 'label': 'Anxious or fearful', 'value': 'anxious'},
        {'emoji': '😤', 'label': 'Angry or irritable', 'value': 'angry'},
        {'emoji': '😶', 'label': 'Numb or disconnected', 'value': 'numb'},
        {'emoji': '😫', 'label': 'Stressed or overwhelmed', 'value': 'stressed'},
        {'emoji': '😴', 'label': 'Trouble sleeping', 'value': 'insomnia'},
      ];

  Widget _buildQuestion2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'What kind of fear do you experience?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kBlackColor,
          ),
        ),
        const SizedBox(height: 24),
        ..._fearOptions.map((option) {
          final isSelected = _selectedFearType == option['value'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              emoji: option['emoji']!,
              label: option['label']!,
              isSelected: isSelected,
              onTap: () => _selectFearType(option['value']!),
            ),
          );
        }),
      ],
    );
  }

  List<Map<String, String>> get _fearOptions => [
        {
          'emoji': '😟',
          'label': 'Constant worry about daily things',
          'value': 'constant_worry',
        },
        {
          'emoji': '💥',
          'label': 'Sudden intense fear attacks',
          'value': 'panic_attacks',
        },
        {
          'emoji': '🙈',
          'label': 'Fear of social situations',
          'value': 'social_fear',
        },
      ];

  Widget _buildResult() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 72, color: Color(0xff3FBBBB)),
            const SizedBox(height: 20),
            const Text(
              'We suggest you explore:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kBlackColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _suggestedIllness ?? '',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xff3FBBBB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _suggestedDescription ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: kBlackColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startExercises,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3FBBBB),
                  foregroundColor: kWhiteColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff3FBBBB) : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kBlackColor,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xff3FBBBB), size: 24),
          ],
        ),
      ),
    );
  }
}
