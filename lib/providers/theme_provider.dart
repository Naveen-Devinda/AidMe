import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  double _fontScale = 1.0;
  Color _accentColor = const Color(0xffE53935);

  ThemeMode get themeMode => _themeMode;
  double get fontScale => _fontScale;
  Color get accentColor => _accentColor;

  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode =
        prefs.getBool('darkMode') == true ? ThemeMode.dark : ThemeMode.light;
    _fontScale = prefs.getDouble('fontScale') ?? 1.0;
    final savedColor = prefs.getInt('accentColor');
    if (savedColor != null) {
      _accentColor = Color.fromARGB(
        (savedColor >> 24) & 0xFF,
        (savedColor >> 16) & 0xFF,
        (savedColor >> 8) & 0xFF,
        savedColor & 0xFF,
      );
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    notifyListeners();
  }

  Future<void> setFontScale(double scale) async {
    _fontScale = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontScale', scale);
    notifyListeners();
  }

  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', color.toARGB32());
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        fontFamily: 'Inter',
        brightness: Brightness.light,
        colorSchemeSeed: _accentColor,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffFFF7F7),
        appBarTheme: AppBarTheme(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: _buildTextTheme(Brightness.light),
      );

  ThemeData get darkTheme => ThemeData(
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        colorSchemeSeed: _accentColor,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: _buildTextTheme(Brightness.dark),
      );

  TextTheme _buildTextTheme(Brightness brightness) {
    return ThemeData(brightness: brightness).textTheme.apply(
          fontSizeDelta: (_fontScale - 1.0) * 4,
        );
  }
}
