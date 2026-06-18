import 'package:aidme/pages/home_page.dart';
import 'package:aidme/pages/onboarding_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  final bool showMainScreen;

  const Wrapper({super.key, required this.showMainScreen});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.showMainScreen ? const HomePage() : OnboardingPage();
    ;
  }
}
