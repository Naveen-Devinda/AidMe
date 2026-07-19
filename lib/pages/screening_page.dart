import 'package:aidme/constants/colors.dart';
import 'package:aidme/data/screening_data.dart';
import 'package:aidme/models/screening_models.dart';
import 'package:aidme/pages/mental_execise_screen.dart';
import 'package:flutter/material.dart';

class ScreeningPage extends StatefulWidget {
  const ScreeningPage({super.key});

  @override
  State<ScreeningPage> createState() => _ScreeningPageState();
}

class _ScreeningPageState extends State<ScreeningPage> {
  int _currentPhase = 0;

  int _triageStep = 0;
  String? _selectedIllness;
  String? _selectedDuration;
  String? _selectedImpact;

  int _screeningStep = 0;
  List<int> _screeningAnswers = [];

  ScreeningResult? _result;
  bool _hasCrisisTrigger = false;

  IllnessScreening? get _currentScreening =>
      _selectedIllness != null ? illnessScreenings[_selectedIllness!] : null;

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
        child: SafeArea(child: _buildCurrentPhase()),
      ),
    );
  }

  Widget _buildCurrentPhase() {
    switch (_currentPhase) {
      case 0:
        return _buildTriagePhase();
      case 1:
        return _buildScreeningPhase();
      case 2:
        return _buildResultsPhase();
      default:
        return const SizedBox();
    }
  }

  // ─── TRIAGE PHASE ──────────────────────────────────────

  Widget _buildTriagePhase() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_triageStep > 0) {
                    setState(() => _triageStep--);
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              Text(
                'Step ${_triageStep + 1} of 3',
                style: TextStyle(
                  color: kBlackColor.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_triageStep + 1) / 3,
            backgroundColor: kBlackColor.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation(Color(0xff3FBBBB)),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildTriageStep()),
        ],
      ),
    );
  }

  Widget _buildTriageStep() {
    switch (_triageStep) {
      case 0:
        return _buildTriageStep0();
      case 1:
        return _buildTriageStep1();
      case 2:
        return _buildTriageStep2();
      default:
        return const SizedBox();
    }
  }

  Widget _buildTriageStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What best describes your main concern?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kBlackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the option that feels closest to what you are experiencing.',
          style: TextStyle(
            fontSize: 14,
            color: kBlackColor.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: triageOptions.length,
            itemBuilder: (context, index) {
              final option = triageOptions[index];
              final isSelected = _selectedIllness == option['illness'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RadioOption(
                  emoji: option['emoji'],
                  label: option['label']!,
                  isSelected: isSelected,
                  onTap: () =>
                      setState(() => _selectedIllness = option['illness']),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _ContinueButton(
          enabled: _selectedIllness != null,
          onPressed: () => setState(() => _triageStep = 1),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTriageStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How long have you been feeling this way?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kBlackColor,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: durationOptions.length,
            itemBuilder: (context, index) {
              final option = durationOptions[index];
              final isSelected = _selectedDuration == option['value'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RadioOption(
                  label: option['label']!,
                  isSelected: isSelected,
                  onTap: () =>
                      setState(() => _selectedDuration = option['value']),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _ContinueButton(
          enabled: _selectedDuration != null,
          onPressed: () => setState(() => _triageStep = 2),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTriageStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How much does this affect your daily life?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kBlackColor,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: impactOptions.length,
            itemBuilder: (context, index) {
              final option = impactOptions[index];
              final isSelected = _selectedImpact == option['value'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RadioOption(
                  label: option['label']!,
                  isSelected: isSelected,
                  onTap: () =>
                      setState(() => _selectedImpact = option['value']),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _ContinueButton(
          enabled: _selectedImpact != null,
          onPressed: _startScreening,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _startScreening() {
    if (_currentScreening == null) return;
    _screeningAnswers = List.filled(_currentScreening!.questions.length, -1);
    setState(() {
      _currentPhase = 1;
      _screeningStep = 0;
    });
  }

  // ─── SCREENING PHASE ────────────────────────────────────

  Widget _buildScreeningPhase() {
    final screening = _currentScreening;
    if (screening == null) return const SizedBox();

    final question = screening.questions[_screeningStep];
    final totalQuestions = screening.questions.length;
    final progress = (_screeningStep + 1) / totalQuestions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_screeningStep > 0) {
                    setState(() => _screeningStep--);
                  } else {
                    setState(() => _currentPhase = 0);
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              Text(
                'Question ${_screeningStep + 1} of $totalQuestions',
                style: TextStyle(
                  color: kBlackColor.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: kBlackColor.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation(Color(0xff3FBBBB)),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xff3FBBBB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              screening.name,
              style: const TextStyle(
                color: Color(0xff3FBBBB),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kBlackColor,
              height: 1.3,
            ),
          ),
          if (question.isTrigger) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'This question helps us provide better support.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.orange),
              ),
            ),
          ],
          const SizedBox(height: 32),
          _AnswerOption(
            label: 'Yes',
            isSelected: _screeningAnswers[_screeningStep] == 1,
            onTap: () => _answerQuestion(1),
          ),
          const SizedBox(height: 12),
          _AnswerOption(
            label: 'Sometimes',
            isSelected: _screeningAnswers[_screeningStep] == 1,
            onTap: () => _answerQuestion(1),
          ),
          const SizedBox(height: 12),
          _AnswerOption(
            label: 'No',
            isSelected: _screeningAnswers[_screeningStep] == 0,
            onTap: () => _answerQuestion(0),
          ),
          const Spacer(),
          Row(
            children: [
              if (_screeningStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _screeningStep--),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xff3FBBBB),
                      side: const BorderSide(color: Color(0xff3FBBBB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              if (_screeningStep > 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _screeningAnswers[_screeningStep] != -1
                      ? () => _nextScreeningQuestion()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3FBBBB),
                    foregroundColor: kWhiteColor,
                    disabledBackgroundColor: kBlackColor.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _screeningStep == totalQuestions - 1
                        ? 'See Results'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _answerQuestion(int score) {
    setState(() {
      _screeningAnswers[_screeningStep] = score;
    });
  }

  void _nextScreeningQuestion() {
    final screening = _currentScreening!;
    if (_screeningStep < screening.questions.length - 1) {
      setState(() => _screeningStep++);
    } else {
      _calculateResults();
    }
  }

  void _calculateResults() {
    final result = ScreeningResult.calculate(
      illness: _currentScreening!,
      answers: _screeningAnswers,
    );
    setState(() {
      _result = result;
      _hasCrisisTrigger =
          result.hasTriggerFired && _currentScreening!.name == 'Depression';
      _currentPhase = 2;
    });
  }

  // ─── RESULTS PHASE ──────────────────────────────────────

  Widget _buildResultsPhase() {
    final result = _result;
    if (result == null) return const SizedBox();

    final tierColor = switch (result.tier) {
      SeverityTier.low => Colors.green,
      SeverityTier.moderate => Colors.orange,
      SeverityTier.high => Colors.red,
    };

    final tierLabel = switch (result.tier) {
      SeverityTier.low => 'LOW',
      SeverityTier.moderate => 'MODERATE',
      SeverityTier.high => 'HIGH',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Screening Results',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: kBlackColor,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: kBlackColor.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          result.illness.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kBlackColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: result.score /
                                    result.illness.scoredCount,
                                strokeWidth: 8,
                                backgroundColor:
                                    kBlackColor.withValues(alpha: 0.08),
                                valueColor:
                                    AlwaysStoppedAnimation(tierColor),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${result.score}/${result.illness.scoredCount}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: tierColor,
                                      ),
                                    ),
                                    Text(
                                      tierLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: tierColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          result.tierDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: kBlackColor.withValues(alpha: 0.7),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (result.hasTriggerFired) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _hasCrisisTrigger
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _hasCrisisTrigger
                              ? Colors.red
                              : Colors.orange,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _hasCrisisTrigger
                                ? Icons.warning
                                : Icons.info_outline,
                            color: _hasCrisisTrigger
                                ? Colors.red
                                : Colors.orange,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.triggerMessage ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _hasCrisisTrigger
                                  ? Colors.red.shade700
                                  : Colors.orange.shade700,
                              height: 1.4,
                            ),
                          ),
                          if (_hasCrisisTrigger) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Emergency: Call your local emergency number\nMental Health Helpline: Reach out to a trusted person',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff3FBBBB).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recommended Next Steps',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff3FBBBB),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.tierAction,
                          style: TextStyle(
                            fontSize: 14,
                            color: kBlackColor.withValues(alpha: 0.7),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kBlackColor.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'This screening is for informational purposes only and does not constitute a medical diagnosis. All data is processed in-memory and is never stored or shared. Please consult a healthcare professional for proper evaluation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MentalExeciseScreen(
                      illnessTitle: result.illness.name,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3FBBBB),
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Start Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _retakeScreening,
            child: const Text('Retake Screening'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _retakeScreening() {
    setState(() {
      _currentPhase = 0;
      _triageStep = 0;
      _selectedIllness = null;
      _selectedDuration = null;
      _selectedImpact = null;
      _screeningStep = 0;
      _screeningAnswers = [];
      _result = null;
      _hasCrisisTrigger = false;
    });
  }
}

// ─── HELPER WIDGETS ────────────────────────────────────────

class _RadioOption extends StatelessWidget {
  final String? emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    this.emoji,
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff3FBBBB) : Colors.transparent,
            width: 2,
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
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kBlackColor,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xff3FBBBB),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnswerOption({
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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: kBlackColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ContinueButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff3FBBBB),
          foregroundColor: kWhiteColor,
          disabledBackgroundColor: kBlackColor.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
