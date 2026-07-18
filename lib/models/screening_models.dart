enum SeverityTier { low, moderate, high }

class ScreeningQuestion {
  final String id;
  final String text;
  final bool isTrigger;
  final String? triggerDescription;

  const ScreeningQuestion({
    required this.id,
    required this.text,
    this.isTrigger = false,
    this.triggerDescription,
  });
}

class IllnessScreening {
  final String name;
  final String description;
  final String primaryTarget;
  final List<ScreeningQuestion> questions;
  final Map<SeverityTier, String> tierDescriptions;
  final Map<SeverityTier, String> tierActions;

  const IllnessScreening({
    required this.name,
    required this.description,
    required this.primaryTarget,
    required this.questions,
    required this.tierDescriptions,
    required this.tierActions,
  });

  int get scoredCount => questions.where((q) => !q.isTrigger).length;
}

class ScreeningResult {
  final IllnessScreening illness;
  final int score;
  final SeverityTier tier;
  final String tierDescription;
  final String tierAction;
  final bool hasTriggerFired;
  final String? triggerMessage;

  const ScreeningResult({
    required this.illness,
    required this.score,
    required this.tier,
    required this.tierDescription,
    required this.tierAction,
    this.hasTriggerFired = false,
    this.triggerMessage,
  });

  static SeverityTier _calculateTier(int score) {
    if (score <= 1) return SeverityTier.low;
    if (score <= 3) return SeverityTier.moderate;
    return SeverityTier.high;
  }

  static ScreeningResult calculate({
    required IllnessScreening illness,
    required List<int> answers,
  }) {
    final scoredAnswers = <int>[];
    bool triggerFired = false;
    String? triggerMsg;

    for (int i = 0; i < illness.questions.length; i++) {
      if (illness.questions[i].isTrigger) {
        if (answers[i] >= 1) {
          triggerFired = true;
          triggerMsg = illness.questions[i].triggerDescription;
        }
      } else {
        scoredAnswers.add(answers[i]);
      }
    }

    final score = scoredAnswers.fold(0, (a, b) => a + b);
    final tier = _calculateTier(score);

    return ScreeningResult(
      illness: illness,
      score: score,
      tier: tier,
      tierDescription: illness.tierDescriptions[tier] ?? '',
      tierAction: illness.tierActions[tier] ?? '',
      hasTriggerFired: triggerFired,
      triggerMessage: triggerMsg,
    );
  }
}
