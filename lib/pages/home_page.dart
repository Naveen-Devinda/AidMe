import 'package:aidme/constants/colors.dart';
import 'package:aidme/models/coursel.dart';
import 'package:aidme/pages/mental_assessment_screen.dart';
import 'package:aidme/pages/physicalmainpage.dart';
import 'package:aidme/pages/setting.dart';
import 'package:aidme/widgets/button2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        title: const Text(
          "AidMe",
          style: TextStyle(
            color: Color(0xff98A9AA),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
            },
            icon: const Icon(Icons.settings),
            iconSize: 30,
            color: const Color(0xff98A9AA),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          SizedBox(
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MentalAssessmentScreen(),
                ),
              ),
              child: Button2(
                buttoName: "Mental FirstAid",
                buttonColor: const Color(0xff3FBBBB),
                fontSize: 22,
                fontColor: kWhiteColor,
                imageUrl: 'assets/images/icons8-brain-64.png',
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Physicalmainpage()),
              ),
              child: Button2(
                buttoName: "Physical FirstAid",
                buttonColor: const Color(0xffBB3F3F),
                fontSize: 22,
                fontColor: kWhiteColor,
                imageUrl: 'assets/images/icons8-plus-50.png',
              ),
            ),
          ),
          const SizedBox(height: 60),
          SizedBox(height: 180, child: const CarouselScreen()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
