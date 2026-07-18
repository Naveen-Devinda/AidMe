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
  'Bipolar Disorder': [
    ExeciseDetails(
      title: 'Mood Journal',
      description:
          'Write down how you feel right now and rate it from 1 to 10. Tracking your mood helps you notice patterns and talk to your doctor about them.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Keep a Routine',
      description:
          'Go to bed and wake up at the same time today. A steady routine helps balance your energy and keeps mood swings easier to manage.',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Grounding Breath',
      description:
          'Breathe in for 4 seconds, hold for 4, and out for 4. This helps you stay steady when your mood shifts suddenly.',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Call Your Doctor',
      description:
          'Reach out to your doctor or a trusted person to talk about how you are feeling today. Staying connected is important.',
      mediaType: 'phone book',
      mediaUrl: _defaultImage,
    ),
  ],
  'OCD': [
    ExeciseDetails(
      title: 'Delay the Urge',
      description:
          'When you feel the urge to do a ritual, wait for 2 minutes before doing it. Start small and increase the wait time over days.',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Mindfulness Focus',
      description:
          'Sit quietly and focus on your breathing. Notice the obsessive thought without acting on it, and let it pass like a cloud.',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Name the Thought',
      description:
          'When the obsessive thought comes, say to yourself "This is just a thought, not a fact." Naming it helps reduce its power.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Relaxing Audio',
      description:
          'Listen to calming music to redirect your focus away from the repetitive urge and give your mind a rest.',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'PTSD': [
    ExeciseDetails(
      title: '5-4-3-2-1 Grounding',
      description:
          'Name 5 things you see, 4 you can touch, 3 you hear, 2 you smell, and 1 you taste. This brings you back to the present moment.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Find a Safe Person',
      description:
          'Think of one person you trust and feel safe with. Keep their name or photo nearby as a reminder that you are not alone.',
      mediaType: 'phone book',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Slow Breathing',
      description:
          'Breathe in slowly for 5 seconds and out for 7 seconds. This calms your body when a trauma memory or trigger appears.',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Safe Place Visual',
      description:
          'Close your eyes and picture a place where you feel completely safe and calm. Stay there for one minute.',
      mediaType: 'video',
      mediaUrl: _anxiety_sit,
    ),
  ],
  'Burnout': [
    ExeciseDetails(
      title: 'Step Away Completely',
      description:
          'Stop working right now and move to a different room or space. Your body and mind need a full break to start recovering.',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Prioritize Sleep',
      description:
          'Set a firm bedtime tonight and put your phone away 30 minutes before. Rest is the first step to healing from burnout.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Body Scan Relax',
      description:
          'Lie down and slowly notice each part of your body from toes to head. Release tension in each area as you go.',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Calm Down Audio',
      description:
          'Listen to soft calming music and let your mind rest without any tasks or screen time for a few minutes.',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
  'Eating Disorders': [
    ExeciseDetails(
      title: 'Non-Judgmental Check-in',
      description:
          'Ask yourself "How am I feeling about food right now?" without judging the answer. Just notice the thought and let it be.',
      mediaType: 'photo',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Avoid Body Talk',
      description:
          'For the next few hours, avoid commenting on your body or anyone else\'s body. Focus on how you feel inside instead.',
      mediaType: 'gif',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Comfort Breathing',
      description:
          'When anxious thoughts about food appear, breathe slowly and place a hand on your chest. Remind yourself that you are safe.',
      mediaType: 'youtube',
      mediaUrl: _breathingVideo,
    ),
    ExeciseDetails(
      title: 'Reach Out',
      description:
          'Talk to someone you trust or contact a nutritionist. You do not have to face this alone.',
      mediaType: 'phone book',
      mediaUrl: _defaultImage,
    ),
  ],
  'Grief & Bereavement': [
    ExeciseDetails(
      title: 'Allow the Tears',
      description:
          'If you feel like crying, let it happen. Tears are a natural way your body processes deep sadness and loss.',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Talk About It',
      description:
          'Share a memory or feeling about the person or thing you lost. Speaking about them keeps their memory alive.',
      mediaType: 'phone book',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Gentle Walk',
      description:
          'Take a slow walk and notice nature around you. Movement can bring small moments of peace during heavy grief.',
      mediaType: 'video',
      mediaUrl: _defaultImage,
    ),
    ExeciseDetails(
      title: 'Comfort Sound',
      description:
          'Play soft music or a sound that reminds you of better times. Let it comfort you without pushing the sadness away.',
      mediaType: 'music',
      mediaUrl: _defaultImage,
    ),
  ],
};
