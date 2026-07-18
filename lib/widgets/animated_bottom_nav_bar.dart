import 'package:flutter/material.dart';
import 'package:aidme/pages/home_page.dart';
import 'package:aidme/pages/quiz_page.dart';
import 'package:aidme/pages/rewards_page.dart';
import 'package:aidme/pages/setting.dart';

/// A bottom navigation bar with shifting animation.
///
/// This widget manages the selected tab state and displays the corresponding
/// page. The shifting animation is achieved by using the built‑in
/// `BottomNavigationBarType.shifting` and wrapping the page body in an
/// `AnimatedSwitcher` for a smooth transition.
class AnimatedBottomNavBar extends StatefulWidget {
  const AnimatedBottomNavBar({super.key});

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    QuizPage(),
    RewardsPage(),
    Setting(),
  ];

  static const List<BottomNavigationBarItem> _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
      backgroundColor: Color(0xff3FBBBB),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.quiz),
      label: 'Quiz',
      backgroundColor: Color(0xff2C6E6E),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.card_giftcard),
      label: 'Rewards',
      backgroundColor: Color(0xff3FBBBB),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
      backgroundColor: Color(0xff2C6E6E),
    ),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }
}
