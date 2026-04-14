import 'package:aidme/widgets/custombutton.dart';
import 'package:flutter/material.dart';

class Mentalmainpage extends StatelessWidget {
  const Mentalmainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDBF8F2),
      appBar: AppBar(
        title: Text("Mental Health"),
        backgroundColor: Color(0xffDBF8F2),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: Text(
              "Mental First Aid",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
            ),
          ),
          SizedBox(height: 30),
          Image.asset("assets/images/mainmentalpage.png", width: 300),
          SizedBox(height: 30),
          Text(
            "We’re here to help you to feel better... ",

            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Mentalmainpage(),
                  ),
                );
              },
              child: Custombutton(
                buttonName: "Start",
                buttonColor: Color(0xff3FBBBB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
