import 'dart:ui';

import 'package:aidme/constants/colors.dart';
import 'package:flutter/material.dart';

// ---------- Helper date formatting (shared) ----------
String _formatDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return '${date.day} ${_monthAbbr(date.month)} ${date.year}';
  } catch (_) {
    return dateStr;
  }
}

String _monthAbbr(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

// ---------- Main Screen (matches guide style exactly) ----------
class PhysicalFirstAidKit extends StatefulWidget {
  const PhysicalFirstAidKit({super.key});

  @override
  State<PhysicalFirstAidKit> createState() => _PhysicalFirstAidKitState();
}

class _PhysicalFirstAidKitState extends State<PhysicalFirstAidKit> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Wound Care',
    'Medication',
    'Tools',
    'Protection',
    'Other',
  ];

  // ---------- Kit data (with category, colour, tips) ----------
  final List<Map<String, Object>> _kitItems = const [
    {
      'name': 'Adhesive Bandages',
      'description':
          'Protect small cuts, blisters, and wounds from dirt and bacteria.',
      'category': 'Wound Care',
      'icon': Icons.healing,
      'color': Color(0xffFFE7B8), // same warm tone as guide
      'iconColor': Color(0xffFF9800),
      'lastUpdated': '2026-06-18',
      'tips': 'Change daily or when wet. Use larger sizes for bigger scrapes.',
    },
    {
      'name': 'Sterile Gauze Pads & Tape',
      'description':
          'Cover larger wounds; sterile pads prevent infection, tape holds them in place.',
      'category': 'Wound Care',
      'icon': Icons.medical_services,
      'color': Color(0xffDCE5EA),
      'iconColor': Color(0xff607D8B),
      'lastUpdated': '2026-06-15',
      'tips': 'Secure with tape without pressing directly on the wound.',
    },
    {
      'name': 'Antiseptic Wipes & Ointment',
      'description':
          'Clean wounds and apply antibiotic to reduce infection risk.',
      'category': 'Wound Care',
      'icon': Icons.clean_hands,
      'color': Color(0xffD4F0F4),
      'iconColor': Color(0xff00838F),
      'lastUpdated': '2026-06-12',
      'tips':
          'Use wipes to clean around the wound, then apply a thin layer of ointment.',
    },
    {
      'name': 'Pain Relievers',
      'description':
          'Reduce fever, headache, muscle pain (ibuprofen, acetaminophen).',
      'category': 'Medication',
      'icon': Icons.medication,
      'color': Color(0xffF8C7DD),
      'iconColor': Color(0xffE91E63),
      'lastUpdated': '2026-06-10',
      'tips':
          'Follow dosage instructions. Do not exceed recommended daily dose.',
    },
    {
      'name': 'Scissors & Tweezers',
      'description':
          'Cut tape, clothing, or bandages; remove splinters or debris.',
      'category': 'Tools',
      'icon': Icons.content_cut,
      'color': Color(0xffE8D7F5),
      'iconColor': Color(0xff7B3FB3),
      'lastUpdated': '2026-06-08',
      'tips':
          'Sterilise with alcohol before use. Use tweezers to grasp splinters close to the skin.',
    },
    {
      'name': 'Disposable Gloves',
      'description':
          'Protect both rescuer and victim from infection during treatment.',
      'category': 'Protection',
      'icon': Icons.clean_hands_outlined,
      'color': Color(0xffE0F2F1),
      'iconColor': Color(0xff00897B),
      'lastUpdated': '2026-06-14',
      'tips': 'Always wear when dealing with blood or bodily fluids.',
    },
    {
      'name': 'Instant Cold Pack',
      'description':
          'Reduce swelling and numb pain from sprains, strains, or bruises.',
      'category': 'Other',
      'icon': Icons.ac_unit,
      'color': Color(0xffD8ECFF),
      'iconColor': Color(0xff1E88E5),
      'lastUpdated': '2026-06-09',
      'tips': 'Wrap in a cloth before applying to skin. Use for 15‑20 minutes.',
    },
    {
      'name': 'CPR Mask',
      'description':
          'Provide safe rescue breaths during CPR, preventing disease transmission.',
      'category': 'Protection',
      'icon': Icons.masks,
      'color': Color(0xffF8C7DD),
      'iconColor': Color(0xffE91E63),
      'lastUpdated': '2026-06-07',
      'tips':
          'Place the mask over the victim\'s mouth and nose; seal properly.',
    },
    {
      'name': 'Emergency Blanket',
      'description':
          'Retain body heat and prevent hypothermia in shock or cold conditions.',
      'category': 'Other',
      'icon': Icons.waves,
      'color': Color(0xffFFE4C7),
      'iconColor': Color(0xffF57C00),
      'lastUpdated': '2026-06-13',
      'tips': 'Wrap the person completely, reflecting heat back to the body.',
    },
    {
      'name': 'First Aid Manual',
      'description':
          'Step-by-step instructions for handling emergencies correctly.',
      'category': 'Other',
      'icon': Icons.menu_book,
      'color': Color(0xffDCE5EA),
      'iconColor': Color(0xff607D8B),
      'lastUpdated': '2026-06-16',
      'tips': 'Keep it accessible and familiarise yourself with the content.',
    },
  ];

  List<Map<String, Object>> get _filteredItems {
    return _kitItems.where((item) {
      final name = item['name'].toString().toLowerCase();
      final description = item['description'].toString().toLowerCase();
      final category = item['category'].toString();
      final searchText = _searchText.toLowerCase();

      final categoryMatched =
          _selectedCategory == 'All' || category == _selectedCategory;
      final searchMatched =
          searchText.isEmpty ||
          name.contains(searchText) ||
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
      backgroundColor: const Color(0xffFAFAFA), // same as guide
      body: SafeArea(
        child: Column(
          children: [
            // ---------- App Bar (exactly like guide) ----------
            Container(
              height: 56,
              color: const Color(0xffE53935),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: kWhiteColor,
                  ),
                  const Expanded(
                    child: Text(
                      'First Aid Kit',
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
            // ---------- Search (same as guide) ----------
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
                  hintText: 'Search items...',
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
            // ---------- Category Chips (same as guide) ----------
            SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return _KitCategoryChip(
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
            // ---------- Item List (matches guide card style) ----------
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _KitCard(
                          name: item['name'].toString(),
                          description: item['description'].toString(),
                          category: item['category'].toString(),
                          icon: item['icon'] as IconData,
                          color: item['color'] as Color,
                          iconColor: item['iconColor'] as Color,
                          lastUpdated: item['lastUpdated'].toString(),
                          tips: item['tips']?.toString() ?? '',
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor: kBlackColor.withValues(alpha: 0.42),
                              builder: (_) => _KitPopup(
                                name: item['name'].toString(),
                                description: item['description'].toString(),
                                category: item['category'].toString(),
                                icon: item['icon'] as IconData,
                                color: item['color'] as Color,
                                iconColor: item['iconColor'] as Color,
                                lastUpdated: item['lastUpdated'].toString(),
                                tips: item['tips']?.toString() ?? '',
                              ),
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

// ---------- Category Chip (exactly like guide's _CategoryButton) ----------
class _KitCategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _KitCategoryChip({
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

// ---------- Item Card (identical to _GuideCard) ----------
class _KitCard extends StatelessWidget {
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String lastUpdated;
  final String tips;
  final VoidCallback onTap;

  const _KitCard({
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.lastUpdated,
    required this.tips,
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
                    name,
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
                  Row(
                    children: [
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
                      const SizedBox(width: 8),
                      Text(
                        'Updated: ${_formatDate(lastUpdated)}',
                        style: TextStyle(
                          color: kBlackColor.withValues(alpha: 0.35),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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

// ---------- Popup Dialog (glass-morphism, same as guide) ----------
class _KitPopup extends StatelessWidget {
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String lastUpdated;
  final String tips;

  const _KitPopup({
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.lastUpdated,
    required this.tips,
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
                // ----- Header -----
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
                              name,
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
                            const SizedBox(height: 3),
                            Text(
                              'Updated: ${_formatDate(lastUpdated)}',
                              style: TextStyle(
                                color: kBlackColor.withValues(alpha: 0.4),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        color: kBlackColor.withValues(alpha: 0.62),
                      ),
                    ],
                  ),
                ),
                // ----- Content -----
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
                      if (tips.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _SectionHeader(
                          icon: Icons.lightbulb_outline,
                          title: 'Tip',
                          color: iconColor,
                        ),
                        const SizedBox(height: 10),
                        _TipTile(text: tips, accentColor: iconColor),
                      ],
                      const SizedBox(height: 6),
                      _ActionSection(
                        title: 'Remember',
                        icon: Icons.check_circle,
                        items: const [
                          'Always check expiry dates.',
                          'Keep the kit out of children\'s reach.',
                          'Replace used items promptly.',
                        ],
                        color: const Color(0xff2E7D32),
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

// ---------- Reusable sub-widgets (copied from guide) ----------
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

class _TipTile extends StatelessWidget {
  final String text;
  final Color accentColor;

  const _TipTile({required this.text, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: accentColor, size: 20),
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
