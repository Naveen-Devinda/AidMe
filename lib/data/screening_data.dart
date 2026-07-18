import '../models/screening_models.dart';

const List<Map<String, String>> triageOptions = [
  {
    'label': 'I feel worried or anxious',
    'illness': 'Anxiety Disorder',
    'emoji': '\u{1F630}',
  },
  {
    'label': 'I feel sad, empty, or tired',
    'illness': 'Depression',
    'emoji': '\u{1F622}',
  },
  {
    'label': 'I feel overwhelmed by stress',
    'illness': 'Stress Disorder',
    'emoji': '\u{1F62B}',
  },
  {
    'label': 'I have sudden intense fear attacks',
    'illness': 'Panic Disorder',
    'emoji': '\u{1F4A5}',
  },
  {
    'label': 'I have trouble sleeping',
    'illness': 'Insomnia',
    'emoji': '\u{1F634}',
  },
  {
    'label': 'I have difficulty controlling anger',
    'illness': 'Anger Management',
    'emoji': '\u{1F624}',
  },
  {
    'label': 'I feel emotionally numb or disconnected',
    'illness': 'Emotional Numbness',
    'emoji': '\u{1F636}',
  },
  {
    'label': 'I fear social situations',
    'illness': 'Social Anxiety',
    'emoji': '\u{1F648}',
  },
];

const List<Map<String, String>> durationOptions = [
  {'label': 'Less than a week', 'value': 'acute'},
  {'label': '1 to 4 weeks', 'value': 'short'},
  {'label': '1 to 6 months', 'value': 'medium'},
  {'label': 'More than 6 months', 'value': 'long'},
];

const List<Map<String, String>> impactOptions = [
  {'label': 'Not at all', 'value': 'none'},
  {'label': 'A little', 'value': 'mild'},
  {'label': 'Quite a lot', 'value': 'moderate'},
  {'label': "Very much \u2014 it's hard to function", 'value': 'severe'},
];

const Map<String, IllnessScreening> illnessScreenings = {
  'Anxiety Disorder': IllnessScreening(
    name: 'Anxiety Disorder',
    description: 'Persistent, uncontrollable, and excessive daily worry',
    primaryTarget: 'Excessive worry and anxiety about daily events',
    questions: [
      ScreeningQuestion(
        id: 'a1',
        text:
            'Do you worry more than you think you should about everyday things?',
      ),
      ScreeningQuestion(
        id: 'a2',
        text: 'Do you find it hard to stop worrying once you start?',
      ),
      ScreeningQuestion(
        id: 'a3',
        text: 'Do you feel restless, tense, or on edge?',
      ),
      ScreeningQuestion(
        id: 'a4',
        text:
            'Do you have trouble concentrating or does your mind go blank?',
      ),
      ScreeningQuestion(
        id: 'a5',
        text: 'Do you feel easily tired because of worrying?',
      ),
      ScreeningQuestion(
        id: 'a6',
        text: 'Do you avoid situations that make you anxious?',
      ),
      ScreeningQuestion(
        id: 'a7',
        text:
            'Do you experience physical symptoms like rapid heartbeat, sweating, or shaking when worried?',
        isTrigger: true,
        triggerDescription:
            'Somatic hyper-arousal detected. Starting breathing exercise before assessment.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild anxiety. Routine self-monitoring is recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate anxiety. A detailed assessment (GAD-7) is recommended.',
      SeverityTier.high:
          'Your responses suggest significant anxiety. Professional support is strongly recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Continue with self-monitoring. Practice daily relaxation and breathing techniques.',
      SeverityTier.moderate:
          'Complete the GAD-7 assessment for a more detailed evaluation of your anxiety.',
      SeverityTier.high:
          'Consider reaching out to a mental health professional or teletherapy service for direct support.',
    },
  ),
  'Depression': IllnessScreening(
    name: 'Depression',
    description: 'Persistent low mood, anhedonia, and energy depletion',
    primaryTarget: 'Low mood, loss of interest, and energy depletion',
    questions: [
      ScreeningQuestion(
        id: 'd1',
        text:
            'Have you been feeling sad, down, or hopeless most days?',
      ),
      ScreeningQuestion(
        id: 'd2',
        text:
            'Have you lost interest or pleasure in activities you used to enjoy?',
      ),
      ScreeningQuestion(
        id: 'd3',
        text:
            'Do you feel tired or have little energy even with enough rest?',
      ),
      ScreeningQuestion(
        id: 'd4',
        text:
            'Do you have trouble sleeping or do you sleep much more than usual?',
      ),
      ScreeningQuestion(
        id: 'd5',
        text:
            'Do you feel worthless or excessively guilty about things?',
      ),
      ScreeningQuestion(
        id: 'd6',
        text:
            'Do you have trouble concentrating or making decisions?',
      ),
      ScreeningQuestion(
        id: 'd7',
        text:
            'Have you had thoughts of hurting yourself or that life is not worth living?',
        isTrigger: true,
        triggerDescription:
            'Your safety matters. If you are in immediate danger, please call your local emergency number. You are not alone. Reach out to someone you trust or a crisis helpline.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild low mood. Daily behavioral activation is recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate depression. A detailed assessment (PHQ-9) is recommended.',
      SeverityTier.high:
          'Your responses suggest significant depression. Professional clinical support is strongly recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Practice daily behavioral activation: short walks, sunlight, and connecting with others.',
      SeverityTier.moderate:
          'Complete the PHQ-9 assessment for a more detailed evaluation of your mood.',
      SeverityTier.high:
          'Please consider reaching out to a mental health professional or your doctor for clinical support.',
    },
  ),
  'Stress Disorder': IllnessScreening(
    name: 'Stress Disorder',
    description:
        'Maladaptive responses to overwhelming environmental stressors',
    primaryTarget: 'Overwhelming stress affecting daily functioning',
    questions: [
      ScreeningQuestion(
        id: 's1',
        text: 'Do you feel overwhelmed by your daily responsibilities?',
      ),
      ScreeningQuestion(
        id: 's2',
        text: 'Do you feel irritable or easily upset?',
      ),
      ScreeningQuestion(
        id: 's3',
        text: 'Do you have trouble relaxing or calming down?',
      ),
      ScreeningQuestion(
        id: 's4',
        text:
            'Do you feel like you cannot accomplish everything you need to?',
      ),
      ScreeningQuestion(
        id: 's5',
        text: 'Do you forget things or feel mentally scattered?',
      ),
      ScreeningQuestion(
        id: 's6',
        text:
            'Do you feel physically tense or get headaches frequently?',
      ),
      ScreeningQuestion(
        id: 's7',
        text:
            'Do you feel mentally foggy or unable to think clearly?',
        isTrigger: true,
        triggerDescription:
            'Cognitive impairment detected. Simplifying your experience for comfort.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild stress. Proactive stress hygiene is recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate stress. A detailed assessment (PSS-10) is recommended.',
      SeverityTier.high:
          'Your responses suggest significant stress. A clinical burnout assessment is recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Practice stress hygiene: regular breaks, boundaries, and relaxation techniques.',
      SeverityTier.moderate:
          'Complete the Perceived Stress Scale (PSS-10) for a more detailed evaluation.',
      SeverityTier.high:
          'Consider a clinical burnout assessment and professional support.',
    },
  ),
  'Panic Disorder': IllnessScreening(
    name: 'Panic Disorder',
    description:
        'Sudden, unexpected, and intense physiological terror',
    primaryTarget: 'Sudden intense fear attacks with physical symptoms',
    questions: [
      ScreeningQuestion(
        id: 'p1',
        text:
            'Have you experienced sudden attacks of intense fear or discomfort?',
      ),
      ScreeningQuestion(
        id: 'p2',
        text: 'Do you worry about when the next attack might happen?',
      ),
      ScreeningQuestion(
        id: 'p3',
        text:
            'Do you avoid places or situations where you had a past attack?',
      ),
      ScreeningQuestion(
        id: 'p4',
        text: 'During an attack, does your heart race or pound?',
      ),
      ScreeningQuestion(
        id: 'p5',
        text:
            'During an attack, do you feel dizzy, shaky, or like you might pass out?',
      ),
      ScreeningQuestion(
        id: 'p6',
        text:
            'During an attack, do you feel detached from yourself or things seem unreal?',
      ),
      ScreeningQuestion(
        id: 'p7',
        text: 'Do you experience these attacks several times a week?',
        isTrigger: true,
        triggerDescription:
            'High distress detected. Starting quick-start calming guide and sensory grounding.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest occasional panic. Preventative education is recommended.',
      SeverityTier.moderate:
          'Your responses suggest active panic symptoms. Distress tolerance skills are recommended.',
      SeverityTier.high:
          'Your responses suggest significant panic disorder. Immediate support is recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Learn about panic attacks and practice preventative breathing techniques.',
      SeverityTier.moderate:
          'Practice active distress tolerance skills: grounding, pacing, and safe breathing.',
      SeverityTier.high:
          'Use the emergency calming guide. Consider reaching out to a professional for immediate support.',
    },
  ),
  'Insomnia': IllnessScreening(
    name: 'Insomnia',
    description:
        'Chronic sleep initiation, consolidation, and quality deficits',
    primaryTarget:
        'Difficulty falling asleep, staying asleep, or poor sleep quality',
    questions: [
      ScreeningQuestion(
        id: 'i1',
        text: 'Do you have trouble falling asleep at night?',
      ),
      ScreeningQuestion(
        id: 'i2',
        text:
            'Do you wake up during the night and have trouble going back to sleep?',
      ),
      ScreeningQuestion(
        id: 'i3',
        text: 'Do you feel tired or sleepy during the day?',
      ),
      ScreeningQuestion(
        id: 'i4',
        text:
            'Does your sleep problem affect your mood or energy?',
      ),
      ScreeningQuestion(
        id: 'i5',
        text:
            'Do you spend more than 30 minutes in bed trying to fall asleep?',
      ),
      ScreeningQuestion(
        id: 'i6',
        text:
            'Do you use your phone or screens within an hour of bedtime?',
      ),
      ScreeningQuestion(
        id: 'i7',
        text:
            'Do you have trouble staying awake during normal daily activities?',
        isTrigger: true,
        triggerDescription:
            'Diurnal impairment detected. Consider scheduling a wind-down routine 2 hours before bed.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild sleep issues. Sleep hygiene tracking is recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate insomnia. A detailed assessment (ISI) is recommended.',
      SeverityTier.high:
          'Your responses suggest significant insomnia. Specialist sleep coaching is recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Track your sleep hygiene: consistent bedtime, no screens, and a calm environment.',
      SeverityTier.moderate:
          'Complete the Insomnia Severity Index (ISI) for a more detailed evaluation.',
      SeverityTier.high:
          'Consider specialist sleep coaching or professional support for your sleep issues.',
    },
  ),
  'Anger Management': IllnessScreening(
    name: 'Anger Management',
    description:
        'Acute emotional dysregulation and behavioral dyscontrol',
    primaryTarget: 'Difficulty controlling anger and emotional reactions',
    questions: [
      ScreeningQuestion(
        id: 'am1',
        text:
            'Do you get angry more quickly than most people would?',
      ),
      ScreeningQuestion(
        id: 'am2',
        text:
            'Do you say or do things when angry that you later regret?',
      ),
      ScreeningQuestion(
        id: 'am3',
        text:
            'Do you feel physical tension like clenched fists or tight jaw when upset?',
      ),
      ScreeningQuestion(
        id: 'am4',
        text:
            'Do you find it hard to calm down after getting angry?',
      ),
      ScreeningQuestion(
        id: 'am5',
        text:
            'Does your anger cause problems in your relationships?',
      ),
      ScreeningQuestion(
        id: 'am6',
        text:
            'Do you feel like anger builds up inside you over time?',
      ),
      ScreeningQuestion(
        id: 'am7',
        text:
            'Do you raise your voice, shout, or slam things when angry?',
        isTrigger: true,
        triggerDescription:
            'Physical tension and verbal reactivity detected. Starting 60-second calming exercise.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild anger patterns. Reflection profiling is recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate anger issues. A conflict style assessment is recommended.',
      SeverityTier.high:
          'Your responses suggest significant anger difficulties. Professional support is recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Practice reflection: notice your anger triggers and patterns.',
      SeverityTier.moderate:
          'Complete a Conflict Style Assessment to understand your anger patterns better.',
      SeverityTier.high:
          'Consider direct therapeutic interventions for anger management.',
    },
  ),
  'Emotional Numbness': IllnessScreening(
    name: 'Emotional Numbness',
    description:
        'Chronic dissociative states and affective depersonalization',
    primaryTarget: 'Feeling emotionally flat, disconnected, or detached',
    questions: [
      ScreeningQuestion(
        id: 'en1',
        text:
            'Do you feel emotionally flat, empty, or like you have no feelings?',
      ),
      ScreeningQuestion(
        id: 'en2',
        text:
            'Do you feel disconnected from the people around you?',
      ),
      ScreeningQuestion(
        id: 'en3',
        text:
            'Do activities and hobbies feel meaningless or boring?',
      ),
      ScreeningQuestion(
        id: 'en4',
        text:
            'Do you feel like you are watching yourself from outside your body?',
      ),
      ScreeningQuestion(
        id: 'en5',
        text:
            'Do you have trouble feeling physical sensations like touch or warmth?',
      ),
      ScreeningQuestion(
        id: 'en6',
        text:
            'Do you feel like you are going through the motions on autopilot?',
      ),
      ScreeningQuestion(
        id: 'en7',
        text:
            'Did this feeling start after a stressful or traumatic event?',
        isTrigger: true,
        triggerDescription:
            'Post-stressor response detected. Starting sensory-stimulation grounding module.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild emotional numbness. Routine self-awareness checks are recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate dissociation. A dissociative experiences assessment is recommended.',
      SeverityTier.high:
          'Your responses suggest significant dissociation. Trauma-focused support is recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Practice self-awareness: name your feelings and notice small sensations.',
      SeverityTier.moderate:
          'Complete the Dissociative Experiences Scale for a more detailed evaluation.',
      SeverityTier.high:
          'Consider trauma-focused therapeutic support for your dissociative experiences.',
    },
  ),
  'Social Anxiety': IllnessScreening(
    name: 'Social Anxiety',
    description:
        'Excessive fear of negative evaluation and public scrutiny',
    primaryTarget:
        'Fear of being judged or negatively evaluated in social situations',
    questions: [
      ScreeningQuestion(
        id: 'sa1',
        text:
            'Do you fear being judged or evaluated negatively by others?',
      ),
      ScreeningQuestion(
        id: 'sa2',
        text:
            'Do you avoid social situations or gatherings when possible?',
      ),
      ScreeningQuestion(
        id: 'sa3',
        text:
            'Do you worry about embarrassing yourself in front of others?',
      ),
      ScreeningQuestion(
        id: 'sa4',
        text:
            'Do you feel very anxious before social events or meetings?',
      ),
      ScreeningQuestion(
        id: 'sa5',
        text:
            'Do you have trouble making eye contact during conversations?',
      ),
      ScreeningQuestion(
        id: 'sa6',
        text:
            'Do you replay social interactions in your mind wondering what you did wrong?',
      ),
      ScreeningQuestion(
        id: 'sa7',
        text:
            'Do you cancel plans or skip events specifically to avoid social situations?',
        isTrigger: true,
        triggerDescription:
            'Avoidant behavior detected. Starting cognitive pre-exposure exercises.',
      ),
    ],
    tierDescriptions: {
      SeverityTier.low:
          'Your responses suggest mild social anxiety. Basic social goal-setting is recommended.',
      SeverityTier.moderate:
          'Your responses suggest moderate social anxiety. A fear of negative evaluation assessment is recommended.',
      SeverityTier.high:
          'Your responses suggest significant social anxiety. Cognitive restructuring support is recommended.',
    },
    tierActions: {
      SeverityTier.low:
          'Set small social goals: one conversation, one greeting, one shared moment.',
      SeverityTier.moderate:
          'Complete the Brief Fear of Negative Evaluation (BFNE) scale for a more detailed assessment.',
      SeverityTier.high:
          'Consider cognitive restructuring modules or professional support for social anxiety.',
    },
  ),
};
