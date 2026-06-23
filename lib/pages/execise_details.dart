class ExeciseDetails {
  final String title;
  final String description;
  final String mediaType;
  final String mediaUrl;

  const ExeciseDetails({
    required this.title,
    required this.description,
    required this.mediaType,
    required this.mediaUrl,
  });
}

const String _anxiety_sit = 'assets/Video/sitdown.mp4';
const String _breathingVideo = 'https://www.youtube.com/shorts/Cq7nmTw1epA';
const String _defaultImage = 'assets/images/mainmentalpage.png';

const Map<String, List<ExeciseDetails>> mentalIllnessExecises = {
  'Anxiety Disorder': [
    ExeciseDetails(
      title: 'Sit safe place',
      description:
          'Sit somewhere quiet and comfortable where you feel safe. Keep your body relaxed, feel your feet on the ground, and focus on being calm and still for a moment.',
      mediaType: 'video',
      mediaUrl: _anxiety_sit,
    ),
    ExeciseDetails(
      title: 'Breathing',
      description:
          'Take a slow breath in for 5 seconds, hold for 5 seconds, and breathe out for 5 seconds to help your body relax and feel calmer.',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Muscle exercise',
      description:
          'Tighten your muscles for 5 seconds, then slowly relax. Repeat with different body parts to release tension and feel calm.',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Count 5 to 1 and 1 to 5',
      description:
          'Slowly count from 5 to 1, then 1 to 5. Focus on each number to calm your mind and reduce anxiety',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
  ],
  'Depression': [
    ExeciseDetails(
      title: 'Get sunlight 3 Minutes',
      description:
          'Step outside and enjoy sunlight for 3 minutes. Fresh air and natural light can boost your mood and energy.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Connected with friends',
      description:
          'Send a message or talk with a friend. Staying connected can improve your mood and help you feel supported.',
      mediaType: 'phone book',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Walk',
      description:
          'Take a short walk at your own pace. Walking helps clear your mind, reduce stress, and boost your mood',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Calm sound',
      description: 'Play quiet music and rest your eyes',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Stress Disorder': [
    ExeciseDetails(
      title: 'Sit comfortably on a chair.',
      description:
          'Sit comfortably on a chair with your back straight, keeping your body relaxed and stable to begin your meditation.',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Stretch Break',
      description:
          'a.	Raise both hands above your head. b.	Stretch for 10 seconds. c.	Roll your shoulders backward 10 times. d.	Slowly turn your neck left and right.',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Connected with friends',
      description:
          'Send a message or talk with a friend. Staying connected can improve your mood and help you feel supported.',
      mediaType: 'phone book',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Soft reset',
      description: 'One minute calming audio',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Panic Disorder': [
    ExeciseDetails(
      title: 'Stay in place if safe',
      description:
          'Sit somewhere quiet and comfortable where you feel safe. Keep your body relaxed, feel your feet on the ground, and focus on being calm and still for a moment.',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Slow deep breaths',
      description: 'Breathe out longer than you breathe in',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Safe sentence',
      description: 'Repeat: this feeling will pass',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Calm audio',
      description: 'Listen to a steady breathing beat',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Insomnia': [
    ExeciseDetails(
      title: 'Sleep breathing',
      description: 'Inhale 4, exhale 6 until relaxed',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Avoid late caffeine/alcohol',
      description:
          'Avoid caffeine and alcohol late in the day, as they can disturb your sleep and reduce the quality of your meditation and relaxation.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Body relax',
      description: 'Relax toes, legs, arms, and face',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Sleep sound',
      description: 'Quiet rain music for sleep',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Anger Disorder': [
    ExeciseDetails(
      title: 'Step back',
      description: 'Move away and take three deep breaths',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Cool hands',
      description: 'Hold cool water and relax your grip',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Count slowly',
      description: 'Count backward from twenty',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Calm track',
      description: 'Listen before replying',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Emotional Numbness': [
    ExeciseDetails(
      title: 'Name one feeling',
      description: 'Choose any word that feels close enough',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Warm touch',
      description: 'Hold a warm cup and notice the feeling',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Tiny movement',
      description: 'Stretch your hands and shoulders',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Gentle music',
      description: 'Listen and notice one sound',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Social Anxiety': [
    ExeciseDetails(
      title: 'Prepare one line',
      description: 'Practice a simple greeting out loud',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Relax your face',
      description: 'Unclench jaw and soften shoulders',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Small eye contact',
      description: 'Look near the person for two seconds',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Confidence audio',
      description: 'Play a short calming reminder',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
};
