import 'package:aidme/constants/colors.dart';
import 'package:aidme/models/coursel.dart';
import 'package:aidme/pages/mental_illness.dart';
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
    return Scaffold(
      backgroundColor: Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: Color(0xffDBF8F2),
        title: Text(
          "AidMe",
          style: TextStyle(
            color: Color(0xff98A9AA),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              }
            },
            icon: Icon(Icons.settings),
            iconSize: 30,
            color: Color(0xff98A9AA),
          ),
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MentalIllness(),
                  ),
                );
              },
              child: Button2(
                buttoName: "Mental FirstAid",
                buttonColor: Color(0xff3FBBBB),
                fontSize: 20,
                fontColor: kWhiteColor,
                imageUrl: 'assets/images/icons8-brain-64.png',
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Physicalmainpage(),
                  ),
                );
              },
              child: Button2(
                buttoName: "Physical FirstAid",
                buttonColor: Color(0xffBB3F3F),
                fontSize: 20,
                fontColor: kWhiteColor,
                imageUrl: 'assets/images/icons8-plus-50.png',
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(height: 210, child: CarouselScreen()),
        ],
      ),
    );
  }
}
