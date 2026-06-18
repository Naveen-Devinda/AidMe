import 'dart:ui';

import 'package:aidme/constants/colors.dart';
import 'package:flutter/material.dart';

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
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor: kBlackColor.withValues(alpha: 0.42),
                              builder: (context) {
                                return _GuidePopupCard(
                                  title: guide['title'].toString(),
                                  description: guide['description'].toString(),
                                  category: guide['category'].toString(),
                                  icon: guide['icon'] as IconData,
                                  color: guide['color'] as Color,
                                  iconColor: guide['iconColor'] as Color,
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

class _GuidePopupCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final List<String> steps;
  final List<String> dos;
  final List<String> donts;

  const _GuidePopupCard({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.steps,
    required this.dos,
    required this.donts,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      backgroundColor: Colors.transparent,
      elevation: 0,
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
                          color: color.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: iconColor, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
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
                                  color: iconColor,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: iconColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        color: kBlackColor.withValues(alpha: 0.62),
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
                        text: description,
                        accentColor: iconColor,
                      ),
                      const SizedBox(height: 14),
                      _SectionHeader(
                        icon: Icons.format_list_numbered,
                        title: 'Instructions',
                        color: iconColor,
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(steps.length, (index) {
                        return _StepTile(
                          number: index + 1,
                          text: steps[index],
                          accentColor: iconColor,
                        );
                      }),
                      const SizedBox(height: 6),
                      _ActionSection(
                        title: 'Do',
                        icon: Icons.check_circle,
                        items: dos,
                        color: const Color(0xff2E7D32),
                      ),
                      const SizedBox(height: 12),
                      _ActionSection(
                        title: "Don't",
                        icon: Icons.cancel,
                        items: donts,
                        color: const Color(0xffC62828),
                      ),
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
