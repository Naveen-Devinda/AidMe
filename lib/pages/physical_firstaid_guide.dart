import 'dart:ui';

import 'package:aidme/constants/colors.dart';
import 'package:aidme/services/recent_activity_service.dart';
import 'package:aidme/services/voice_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:aidme/widgets/full_screen_media_viewer.dart';

class PhysicalFirstaidGuide extends StatefulWidget {
  const PhysicalFirstaidGuide({super.key});

  @override
  State<PhysicalFirstaidGuide> createState() => _PhysicalFirstaidGuideState();
}

class _PhysicalFirstaidGuideState extends State<PhysicalFirstaidGuide> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Injuries',
    'Airway',
    'Emergency',
    'Environmental',
    'Medical',
    'Bites',
  ];

  final List<Map<String, Object>> _guides = const [
    {
      'title': 'Burns & Scalds',
      'description': 'Cool the burn and protect it from infection',
      'category': 'Injuries',
      'icon': Icons.local_fire_department,
      'color': Color(0xffFFE7B8),
      'iconColor': Color(0xffFF9800),
      'images': [
        'assets/images/Burns/1.png',
        'assets/images/Burns/2.png',
        'assets/images/Burns/3.png',
        'assets/images/Burns/4.png',
        'assets/images/Burns/5.png',
        'assets/images/Burns/6.png',
      ],
      'videos': ['assets/Video/Burns.mp4'],
      'imageLabels': [
        'Move away from the heat source immediately',
        'Cool the burn with running water for 20 minutes',
        'Remove rings or tight clothing near burn',
        'Cover burn with a clean cloth or bandage',
        'Do not burst blisters or apply oils',
        'Get medical help for large or severe burns',
      ],
      'steps': [
        'Move away from the heat source.',
        'Cool the burn with cool running water for 20 minutes.',
        'Remove rings or tight clothing near the burn.',
        'Cover the burn with a clean cloth or bandage.',
        'Get medical help if the burn is large or severe.',
      ],
      'dos': [
        'Use cool running water for the full cooling time.',
        'Remove tight items before swelling starts.',
        'Cover the burn with a clean, loose dressing.',
      ],
      'donts': [
        'Do not use ice, butter, or oils on the burn.',
        'Do not burst blisters.',
        'Do not remove clothing stuck to the skin.',
      ],
    },
    {
      'title': 'Choking',
      'description': 'Help clear a blocked airway safely',
      'category': 'Airway',
      'icon': Icons.air,
      'color': Color(0xffFFD6D6),
      'iconColor': Color(0xffE53935),
      'images': [
        'assets/images/choking/1.jpg',
        'assets/images/choking/2.jpg',
        'assets/images/choking/3.jpg',
        'assets/images/choking/4.jpg',
        'assets/images/choking/5.jpg',
      ],
      'videos': ['assets/Video/chocking.mp4'],
      'imageLabels': [
        'Recognize signs of choking in a person',
        'Encourage coughing if person is conscious',
        'Perform back blows between shoulder blades',
        'Give 5 abdominal thrusts (Heimlich maneuver)',
        'Call emergency services if blockage does not clear',
      ],
      'steps': [
        'If the person can cough or speak, encourage them to keep coughing.',
        'Stay with them and watch carefully.',
        'If they cannot breathe or speak, stand behind the person.',
        'Give 5 back blows between the shoulder blades.',
        'Give 5 abdominal thrusts (Heimlich maneuver).',
        'Repeat until the object comes out.',
        'Call emergency services if needed.',
      ],
      'dos': [
        'Encourage coughing if they can breathe or speak.',
        'Alternate back blows and abdominal thrusts if fully blocked.',
        'Call emergency services if the blockage does not clear.',
      ],
      'donts': [
        'Do not give abdominal thrusts to infants.',
        'Do not put fingers in the mouth unless you can see the object.',
        'Do not leave the person alone.',
      ],
    },
    {
      'title': 'CPR (Adults)',
      'description': 'Cardiopulmonary resuscitation for adults',
      'category': 'Emergency',
      'icon': Icons.favorite,
      'color': Color(0xffF8C7DD),
      'iconColor': Color(0xffE91E63),
      'images': [
        'assets/images/cpr/1.png',
        'assets/images/cpr/2.png',
        'assets/images/cpr/3.png',
        'assets/images/cpr/4.png',
        'assets/images/cpr/5.png',
      ],
      'videos': ['assets/Video/cpr.mp4'],
      'imageLabels': [
        'Check if person responds and call emergency',
        'Place hands in center of chest',
        'Push hard and fast at 100-120 per minute',
        'Let chest rise fully between compressions',
        'Continue compressions until help arrives',
      ],
      'steps': [
        'Check if the person responds.',
        'Call emergency services.',
        'Place hands in the center of the chest.',
        'Push hard and fast (100-120 compressions per minute).',
        'Continue until help arrives or the person wakes up.',
      ],
      'dos': [
        'Call emergency services before starting if you are alone.',
        'Keep compressions in the center of the chest.',
        'Let the chest rise fully between compressions.',
      ],
      'donts': [
        'Do not stop unless help arrives, the person wakes, or you are exhausted.',
        'Do not press on the ribs or stomach.',
        'Do not delay calling for help.',
      ],
    },
    {
      'title': 'Severe Bleeding',
      'description': 'How to control severe bleeding from wounds',
      'category': 'Injuries',
      'icon': Icons.bloodtype,
      'color': Color(0xffF8D2D2),
      'iconColor': Color(0xffD63A3A),
      'images': [
        'assets/images/Severe-Bleeding/1.png',
        'assets/images/Severe-Bleeding/2.png',
        'assets/images/Severe-Bleeding/3.png',
        'assets/images/Severe-Bleeding/4.png',
      ],
      'videos': ['assets/Video/Bleeding.mp4'],
      'imageLabels': [
        'Apply firm direct pressure to the wound',
        'Raise the injured area above the heart',
        'Add more cloth if blood soaks through',
        'Keep pressing until bleeding stops',
      ],
      'steps': [
        'Stay calm and wear gloves if available.',
        'Apply firm pressure to the wound.',
        'Raise the injured area if possible.',
        'Keep pressing until bleeding stops.',
        'Call emergency services if bleeding is severe.',
      ],
      'dos': [
        'Use steady direct pressure.',
        'Add more cloth on top if blood soaks through.',
        'Keep the injured person lying or sitting safely.',
      ],
      'donts': [
        'Do not remove embedded objects.',
        'Do not keep checking the wound too often.',
        'Do not remove the first soaked dressing.',
      ],
    },
    {
      'title': 'Fractures',
      'description': 'First aid for broken bones and painful swelling',
      'category': 'Injuries',
      'icon': Icons.healing,
      'color': Color(0xffDCE5EA),
      'iconColor': Color(0xff607D8B),
      'images': [
        'assets/images/fracture/fracture1.jpg',
        'assets/images/fracture/fracture2.jpg',
        'assets/images/fracture/fracture3.jpg',
        'assets/images/fracture/fracture4.jpg',
        'assets/images/fracture/fracture5.jpg',
        'assets/images/fracture/fracture6.jpg',
        'assets/images/fracture/fracture7.jpg',
        'assets/images/fracture/fracture8.jpg',
      ],
      'videos': ['assets/Video/fracture.mp4'],
      'imageLabels': [
        'Keep the injured area still and immobilized',
        'Do not try to straighten the bone',
        'Apply wrapped ice to reduce swelling',
        'Support with a splint if trained',
        'Check for numbness or color change',
        'Immobilize the injured area safely',
        'Wrap ice before applying to skin',
        'Get medical help immediately',
      ],
      'steps': [
        'Keep the injured area still.',
        'Do not try to straighten the bone.',
        'Apply ice wrapped in a cloth.',
        'Support the area with a splint if trained.',
        'Get medical help immediately.',
      ],
      'dos': [
        'Immobilize the injured area.',
        'Wrap ice before applying it.',
        'Watch for numbness, swelling, or color change.',
      ],
      'donts': [
        'Do not push the bone back into place.',
        'Do not move the person unless necessary for safety.',
        'Do not give food or drink if surgery may be needed.',
      ],
    },
    {
      'title': 'Electric Shock',
      'description': 'Turn off power before helping the person',
      'category': 'Emergency',
      'icon': Icons.electric_bolt,
      'color': Color(0xffFFF4B8),
      'iconColor': Color(0xffF9A825),
      'images': [
        'assets/images/Electric-Shock/1.png',
        'assets/images/Electric-Shock/2.png',
        'assets/images/Electric-Shock/3.png',
        'assets/images/Electric-Shock/4.png',
        'assets/images/Electric-Shock/5.png',
        'assets/images/Electric-Shock/6.png',
        'assets/images/Electric-Shock/7.png',
      ],
      'videos': ['assets/Video/electric-shock.mp4'],
      'imageLabels': [
        'Turn off power source before approaching',
        'Do not touch person until power is off',
        'Check breathing and responsiveness',
        'Start CPR if needed and trained',
        'Call emergency services immediately',
        'Treat burns with clean covering',
        'Monitor until medical help arrives',
      ],
      'steps': [
        'Turn off the power source first.',
        'Do not touch the person until power is off.',
        'Check breathing and responsiveness.',
        'Start CPR if needed and trained.',
        'Call emergency services.',
      ],
      'dos': [
        'Switch off power before approaching.',
        'Use a dry non-metal object only if you must move a wire.',
        'Call emergency services after any serious shock.',
      ],
      'donts': [
        'Do not touch the person while electricity may still be active.',
        'Do not use water near the electrical source.',
        'Do not ignore burns or breathing changes.',
      ],
    },
    {
      'title': 'Allergic Reaction',
      'description': 'Watch breathing and help with epinephrine if available',
      'category': 'Airway',
      'icon': Icons.coronavirus,
      'color': Color(0xffD4F0F4),
      'iconColor': Color(0xff00838F),
      'images': [
        'assets/images/allergic reaction/allergic01.jpg',
        'assets/images/allergic reaction/allergic02.jpg',
        'assets/images/allergic reaction/allergic03.jpg',
      ],
      'videos': ['assets/Video/lung_breathing.mp4'],
      'imageLabels': [
        'Move away from the allergen immediately',
        'Use epinephrine injector if available',
        'Monitor breathing and call emergency',
      ],
      'steps': [
        'Move away from the allergen.',
        'Help the person sit comfortably.',
        'Use an epinephrine injector if available.',
        'Monitor breathing closely.',
        'Call emergency services immediately.',
      ],
      'dos': [
        'Use an epinephrine injector if prescribed and available.',
        'Keep the person sitting or lying comfortably.',
        'Monitor breathing until help arrives.',
      ],
      'donts': [
        'Do not wait to see if severe symptoms improve.',
        'Do not give food or drink if breathing is difficult.',
        'Do not let the person stand suddenly.',
      ],
    },
    {
      'title': 'Fainting',
      'description': 'Help the person lie down and recover safely',
      'category': 'Medical',
      'icon': Icons.airline_seat_flat,
      'color': Color(0xffE0F2F1),
      'iconColor': Color(0xff00897B),
      'images': [
        'assets/images/fainting/fainting1.jpg',
        'assets/images/fainting/fainting2.jpg',
        'assets/images/fainting/fainting3.jpg',
      ],
      'videos': ['assets/Video/sitdown.mp4'],
      'imageLabels': [
        'Help the person lie down safely',
        'Raise their legs slightly for blood flow',
        'Loosen tight clothing and give fresh air',
      ],
      'steps': [
        'Help the person lie down.',
        'Raise their legs slightly.',
        'Loosen tight clothing.',
        'Give fresh air and stay with them.',
        'Seek medical help if they do not recover quickly.',
      ],
      'dos': [
        'Keep the person lying down until fully recovered.',
        'Check breathing and responsiveness.',
        'Seek help if fainting repeats or recovery is slow.',
      ],
      'donts': [
        'Do not make them stand up quickly.',
        'Do not splash water on their face.',
        'Do not give food or drink until fully alert.',
      ],
    },
    {
      'title': 'Heat Stroke',
      'description': 'Cool the person and call emergency services',
      'category': 'Environmental',
      'icon': Icons.wb_sunny,
      'color': Color(0xffFFE4C7),
      'iconColor': Color(0xffF57C00),
      'images': [
        'assets/images/Heatstroke/Heatstroke01.jpg',
        'assets/images/Heatstroke/Heatstroke02.jpg',
        'assets/images/Heatstroke/Heatstroke03.jpg',
        'assets/images/Heatstroke/Heatstroke04.jpg',
        'assets/images/Heatstroke/Heatstroke05.jpg',
      ],
      'videos': [],
      'imageLabels': [
        'Move person to a cool shaded place',
        'Remove extra clothing to cool down',
        'Cool body with wet towels or fan',
        'Give small sips of water if awake',
        'Call emergency services immediately',
      ],
      'steps': [
        'Move the person to a cool place.',
        'Remove extra clothing.',
        'Cool the body with wet towels or a fan.',
        'Give small sips of water if awake.',
        'Call emergency services immediately.',
      ],
      'dos': [
        'Cool the person as quickly as possible.',
        'Use wet towels, fans, or cool water.',
        'Call emergency services immediately.',
      ],
      'donts': [
        'Do not give drinks if the person is confused or unconscious.',
        'Do not leave them in direct heat.',
        'Do not use very cold water on a frail person without guidance.',
      ],
    },
    {
      'title': 'Hypothermia',
      'description': 'Warm the person carefully and seek medical help',
      'category': 'Environmental',
      'icon': Icons.ac_unit,
      'color': Color(0xffD8ECFF),
      'iconColor': Color(0xff1E88E5),
      'images': [
        'assets/images/hypothermia/Hypothermia01.jpg',
        'assets/images/hypothermia/Hypothermia02.jpg',
        'assets/images/hypothermia/Hypothermia03.jpg',
        'assets/images/hypothermia/Hypothermia04.jpg',
      ],
      'videos': [],
      'imageLabels': [
        'Move person to a warm shelter',
        'Remove wet clothes carefully',
        'Cover with blankets to warm up',
        'Give warm drinks only if fully awake',
      ],
      'steps': [
        'Move the person to a warm place.',
        'Remove wet clothes carefully.',
        'Cover with blankets.',
        'Give warm drinks if fully awake.',
        'Get medical help as soon as possible.',
      ],
      'dos': [
        'Warm the person slowly and gently.',
        'Keep the head and neck covered.',
        'Give warm drinks only if fully awake.',
      ],
      'donts': [
        'Do not rub or massage cold skin.',
        'Do not use direct heat like a heater or hot bath.',
        'Do not give alcohol.',
      ],
    },
    {
      'title': 'Snake Bite',
      'description': 'Keep still and get emergency medical help quickly',
      'category': 'Bites',
      'icon': Icons.warning,
      'color': Color(0xffE8D7F5),
      'iconColor': Color(0xff7B3FB3),
      'images': [
        'assets/images/snake bite/snake01.jpg',
        'assets/images/snake bite/snake02.jpg',
        'assets/images/snake bite/snake03.jpg',
        'assets/images/snake bite/snake04.jpg',
        'assets/images/snake bite/snake05.jpg',
        'assets/images/snake bite/snake06.jpg',
      ],
      'videos': ['assets/Video/snake-bite.mp4'],
      'imageLabels': [
        'Keep person calm and still',
        'Keep bitten area below heart level',
        'Remove rings or tight items',
        'Do not cut, suck, or apply ice',
        'Clean the wound gently',
        'Go to hospital immediately',
      ],
      'steps': [
        'Keep the person calm and still.',
        'Keep the bitten area below heart level.',
        'Remove rings or tight items.',
        'Do not cut, suck, or apply ice.',
        'Go to the nearest hospital immediately.',
      ],
      'dos': [
        'Keep movement as low as possible.',
        'Remove tight items before swelling starts.',
        'Go to hospital immediately.',
      ],
      'donts': [
        'Do not cut or suck the bite.',
        'Do not apply ice or a tight tourniquet.',
        'Do not try to catch the snake.',
      ],
    },
  ];

  List<Map<String, Object>> get _filteredGuides {
    return _guides.where((guide) {
      final title = guide['title'].toString().toLowerCase();
      final description = guide['description'].toString().toLowerCase();
      final category = guide['category'].toString();
      final searchText = _searchText.toLowerCase();

      final categoryMatched =
          _selectedCategory == 'All' || category == _selectedCategory;
      final searchMatched =
          searchText.isEmpty ||
          title.contains(searchText) ||
          description.contains(searchText) ||
          category.toLowerCase().contains(searchText);

      return categoryMatched && searchMatched;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              color: const Color(0xffE53935),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: kWhiteColor,
                  ),
                  const Expanded(
                    child: Text(
                      'Emergency Guides',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search emergencies...',
                  hintStyle: TextStyle(
                    color: kBlackColor.withValues(alpha: 0.55),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Icon(Icons.search, color: kBlackColor),
                  filled: true,
                  fillColor: kWhiteColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: kBlackColor.withValues(alpha: 0.65),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xffE53935),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;

                  return _CategoryButton(
                    title: category,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredGuides.isEmpty
                  ? const Center(
                      child: Text(
                        'No emergency guide found',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _filteredGuides.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 14);
                      },
                      itemBuilder: (context, index) {
                        final guide = _filteredGuides[index];

                        return _GuideCard(
                          title: guide['title'].toString(),
                          description: guide['description'].toString(),
                          category: guide['category'].toString(),
                          icon: guide['icon'] as IconData,
                          color: guide['color'] as Color,
                          iconColor: guide['iconColor'] as Color,
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return _GuidePopupCard(
                                  title: guide['title'].toString(),
                                  description: guide['description'].toString(),
                                  category: guide['category'].toString(),
                                  icon: guide['icon'] as IconData,
                                  color: guide['color'] as Color,
                                  iconColor: guide['iconColor'] as Color,
                                  images: List<String>.from(
                                    guide['images'] as List,
                                  ),
                                  videos: List<String>.from(
                                    guide['videos'] as List,
                                  ),
                                  imageLabels: guide.containsKey('imageLabels')
                                      ? List<String>.from(
                                          guide['imageLabels'] as List,
                                        )
                                      : const [],
                                  steps: List<String>.from(
                                    guide['steps'] as List,
                                  ),
                                  dos: List<String>.from(guide['dos'] as List),
                                  donts: List<String>.from(
                                    guide['donts'] as List,
                                  ),
                                );
                              },
                            );
                            await VoiceService.stop();
                            if (mounted) {
                              RecentActivityService.add(
                                'Physical - ${guide['title']}',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Guide completed'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidePopupCard extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final List<String> steps;
  final List<String> dos;
  final List<String> donts;
  final List<String> images;
  final List<String> videos;
  final List<String> imageLabels;

  const _GuidePopupCard({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.images,
    required this.videos,
    required this.steps,
    required this.dos,
    required this.donts,
    this.imageLabels = const [],
  });

  @override
  State<_GuidePopupCard> createState() => _GuidePopupCardState();
}

class _GuidePopupCardState extends State<_GuidePopupCard> {
  late final PageController _imagePageController;
  late final PageController _videoPageController;
  late final List<Map<String, String>> _imageItems;
  late final List<Map<String, String>> _videoItems;
  final Map<int, VideoPlayerController> _videoControllers = {};
  int _selectedTab = 0; // 0 = images, 1 = videos

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    _videoPageController = PageController();
    _imageItems = widget.images
        .map((i) => {'type': 'image', 'url': i})
        .toList();
    _videoItems = widget.videos
        .map((v) => {'type': 'video', 'url': v})
        .toList();
    for (int i = 0; i < _videoItems.length; i++) {
      final controller = VideoPlayerController.asset(_videoItems[i]['url']!);
      controller.initialize().then((_) {
        if (mounted) setState(() {});
      });
      _videoControllers[i] = controller;
    }
  }

  @override
  void dispose() {
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _imagePageController.dispose();
    _videoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      // Dialog properties are now handled by the modal bottom sheet.
      // Using a transparent container to retain the custom blurred UI.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.82),
            decoration: BoxDecoration(
              color: kWhiteColor.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kWhiteColor.withValues(alpha: 0.58)),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: kBlackColor,
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: widget.iconColor,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.category,
                                  style: TextStyle(
                                    color: widget.iconColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          bool isSpeaking =
                              VoiceService.isPlaying &&
                              VoiceService.currentText.startsWith(widget.title);
                          return IconButton(
                            tooltip: "Voice Guidance",
                            onPressed: () async {
                              if (isSpeaking) {
                                await VoiceService.stop();
                              } else {
                                String readText =
                                    "${widget.title}. ${widget.description}. Instructions: ${widget.steps.join('. ')}";
                                await VoiceService.speak(readText);
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              isSpeaking ? Icons.volume_up : Icons.volume_mute,
                              color: isSpeaking
                                  ? const Color(0xff3FBBBB)
                                  : kBlackColor.withValues(alpha: 0.62),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          VoiceService.stop();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        color: kBlackColor.withValues(alpha: 0.58),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                    shrinkWrap: true,
                    children: [
                      _GlassInfoTile(
                        icon: Icons.info_outline,
                        text: widget.description,
                        accentColor: widget.iconColor,
                      ),
                      const SizedBox(height: 14),
                      if (_imageItems.isNotEmpty || _videoItems.isNotEmpty)
                        Column(
                          children: [
                            // Media tab icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_imageItems.isNotEmpty)
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedTab = 0),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedTab == 0
                                            ? widget.iconColor.withValues(
                                                alpha: 0.15,
                                              )
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _selectedTab == 0
                                              ? widget.iconColor
                                              : Colors.grey.shade300,
                                          width: _selectedTab == 0 ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.photo_library,
                                            size: 20,
                                            color: _selectedTab == 0
                                                ? widget.iconColor
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Images',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _selectedTab == 0
                                                  ? widget.iconColor
                                                  : Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (_imageItems.isNotEmpty &&
                                    _videoItems.isNotEmpty)
                                  const SizedBox(width: 12),
                                if (_videoItems.isNotEmpty)
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedTab = 1),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedTab == 1
                                            ? widget.iconColor.withValues(
                                                alpha: 0.15,
                                              )
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _selectedTab == 1
                                              ? widget.iconColor
                                              : Colors.grey.shade300,
                                          width: _selectedTab == 1 ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.play_circle_outline,
                                            size: 20,
                                            color: _selectedTab == 1
                                                ? widget.iconColor
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Videos',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _selectedTab == 1
                                                  ? widget.iconColor
                                                  : Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Images section
                            if (_selectedTab == 0 && _imageItems.isNotEmpty)
                              Column(
                                children: [
                                  SizedBox(
                                    height: 220,
                                    child: Stack(
                                      children: [
                                        PageView.builder(
                                          controller: _imagePageController,
                                          itemCount: _imageItems.length,
                                          itemBuilder: (context, index) {
                                            final item = _imageItems[index];
                                            return GestureDetector(
                                              onTap: () async {
                                                await Navigator.of(
                                                  context,
                                                ).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        FullScreenMediaViewer(
                                                          url: item['url']!,
                                                          isVideo: false,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.asset(
                                                  item['url']!,
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                  height: 220,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        if (_imageItems.length > 1) ...[
                                          Positioned(
                                            left: 8,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (_imagePageController
                                                      .hasClients) {
                                                    _imagePageController
                                                        .previousPage(
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    300,
                                                              ),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black38,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 8,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (_imagePageController
                                                      .hasClients) {
                                                    _imagePageController
                                                        .nextPage(
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    300,
                                                              ),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.black38,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (widget.imageLabels.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 4,
                                        right: 4,
                                      ),
                                      child: AnimatedBuilder(
                                        animation: _imagePageController,
                                        builder: (context, child) {
                                          int currentPage = 0;
                                          try {
                                            currentPage =
                                                _imagePageController.page
                                                    ?.round() ??
                                                0;
                                          } catch (_) {}
                                          if (currentPage <
                                              widget.imageLabels.length) {
                                            return Text(
                                              widget.imageLabels[currentPage],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: widget.iconColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            // Videos section
                            if (_selectedTab == 1 && _videoItems.isNotEmpty)
                              SizedBox(
                                height: 220,
                                child: Stack(
                                  children: [
                                    PageView.builder(
                                      controller: _videoPageController,
                                      itemCount: _videoItems.length,
                                      itemBuilder: (context, index) {
                                        final controller =
                                            _videoControllers[index]!;
                                        return GestureDetector(
                                          onTap: () async {
                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FullScreenMediaViewer(
                                                      url:
                                                          _videoItems[index]['url']!,
                                                      isVideo: true,
                                                      startPosition: controller
                                                          .value
                                                          .position,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child:
                                                controller.value.isInitialized
                                                ? Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      AspectRatio(
                                                        aspectRatio: controller
                                                            .value
                                                            .aspectRatio,
                                                        child: VideoPlayer(
                                                          controller,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 8,
                                                        right: 8,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (controller
                                                                  .value
                                                                  .isPlaying) {
                                                                controller
                                                                    .pause();
                                                              } else {
                                                                controller
                                                                    .play();
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  6,
                                                                ),
                                                            decoration:
                                                                const BoxDecoration(
                                                                  color: Colors
                                                                      .black54,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                            child: Icon(
                                                              controller
                                                                      .value
                                                                      .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                        .play_arrow,
                                                              color:
                                                                  Colors.white,
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (_videoItems.length > 1) ...[
                                      Positioned(
                                        left: 8,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (_videoPageController
                                                  .hasClients) {
                                                _videoPageController
                                                    .previousPage(
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      curve: Curves.easeInOut,
                                                    );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.black38,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.arrow_back_ios_new,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 8,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (_videoPageController
                                                  .hasClients) {
                                                _videoPageController.nextPage(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.black38,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 14),
                      _SectionHeader(
                        icon: Icons.format_list_numbered,
                        title: 'Instructions',
                        color: widget.iconColor,
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(widget.steps.length, (index) {
                        return _StepTile(
                          number: index + 1,
                          text: widget.steps[index],
                          accentColor: widget.iconColor,
                        );
                      }),
                      const SizedBox(height: 6),
                      _ActionSection(
                        title: 'Do',
                        icon: Icons.check_circle,
                        items: widget.dos,
                        color: const Color(0xff2E7D32),
                      ),
                      const SizedBox(height: 12),
                      _ActionSection(
                        title: "Don't",
                        icon: Icons.cancel,
                        items: widget.donts,
                        color: const Color(0xffC62828),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Duplicate _GuidePopupCard block removed}

class _CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE53935) : const Color(0xffFFF5F8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xffE53935)
                : kBlackColor.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: kWhiteColor, size: 15),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? kWhiteColor
                    : kBlackColor.withValues(alpha: 0.70),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _GuideCard({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kBlackColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kBlackColor.withValues(alpha: 0.72),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: kBlackColor.withValues(alpha: 0.24),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accentColor;

  const _GlassInfoTile({
    required this.icon,
    required this.text,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kWhiteColor.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kWhiteColor.withValues(alpha: 0.48)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: kBlackColor.withValues(alpha: 0.78),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: kBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Color color;

  const _ActionSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, color: color, size: 7),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: kBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int number;
  final String text;
  final Color accentColor;

  const _StepTile({
    required this.number,
    required this.text,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Text(
              number.toString(),
              style: TextStyle(
                color: accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
