import 'package:flutter/material.dart';

class Button2 extends StatelessWidget {
  final String buttoName;
  final Color buttonColor;
  final double fontSize;
  final Color fontColor;
  final String imageUrl;

  const Button2({
    super.key,
    required this.buttoName,
    required this.buttonColor,
    required this.fontSize,
    required this.fontColor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: 700,

      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(100),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            imageUrl,
            width: 40,
            height: 40,
            color: Color(0xf0FFFFFF),
          ),
          Text(
            buttoName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }
}
