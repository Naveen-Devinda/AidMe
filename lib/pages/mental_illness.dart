import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/mental_illness_details.dart';
import 'package:flutter/material.dart';

class MentalIllness extends StatefulWidget {
  const MentalIllness({super.key});

  @override
  State<MentalIllness> createState() => _MentalIllnessState();
}

class _MentalIllnessState extends State<MentalIllness> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<Map<String, String>> _illnesses = const [
    {'name': 'Anxiety Disorder', 'description': 'Too much fear or worry'},
    {'name': 'Depression', 'description': 'Feeling very sad, empty or tired'},
    {'name': 'Stress Disorder', 'description': 'Sudden stress overload'},
    {'name': 'Panic Disorder', 'description': 'Sudden strong fear attacks'},
    {'name': 'Insomnia', 'description': 'Trouble sleeping'},
    {'name': 'Anger Disorder', 'description': 'Trouble controlling anger'},
    {'name': 'Emotional Numbness', 'description': 'No feelings or emotions'},
    {
      'name': 'Social Anxiety',
      'description': 'Fear of people or social groups',
    },
  ];

  List<Map<String, String>> get _filteredIllnesses {
    if (_searchText.isEmpty) {
      return _illnesses;
    }

    return _illnesses
        .where(
          (illness) => illness['name']!.toLowerCase().contains(
            _searchText.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                const SizedBox(height: 20),
                const Text(
                  'Mental First Aid',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Type here.....',
                    hintStyle: TextStyle(
                      color: kBlackColor.withValues(alpha: 0.35),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color(0xff3FBBBB),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: kWhiteColor.withValues(alpha: 0.45),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xff3FBBBB),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xff3FBBBB),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _filteredIllnesses.isEmpty
                      ? const Center(
                          child: Text(
                            'No result found',
                            style: TextStyle(
                              color: kBlackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: _filteredIllnesses.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 18,
                                crossAxisSpacing: 18,
                                childAspectRatio: 0.95,
                              ),
                          itemBuilder: (context, index) {
                            final illness = _filteredIllnesses[index];

                            return _IllnessCard(
                              name: illness['name']!,
                              description: illness['description']!,
                              isSelected: index == 1 && _searchText.isEmpty,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MentalIllnessDetails(
                                      title: illness['name']!,
                                      description: illness['description']!,
                                    ),
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
        ),
      ),
    );
  }
}

class _IllnessCard extends StatelessWidget {
  final String name;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _IllnessCard({
    required this.name,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kBlackColor.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
