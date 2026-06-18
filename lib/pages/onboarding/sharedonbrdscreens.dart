import 'package:flutter/material.dart';

class Sharedonbrdscreens extends StatelessWidget {
  final String title;
  final String imagepath;
  final String description;

  const Sharedonbrdscreens({
    super.key,
    required this.title,
    required this.imagepath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagepath, width: 300, fit: BoxFit.cover),

          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
