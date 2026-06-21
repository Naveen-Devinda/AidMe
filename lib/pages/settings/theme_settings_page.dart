import 'package:aidme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Theme')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          _card(
            context,
            children: [
              SwitchListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Toggle dark/light theme'),
                value: themeProvider.isDark,
                activeThumbColor: const Color(0xffE53935),
                onChanged: (_) => themeProvider.toggleDarkMode(),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text(
            'Accent Color',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children:
                      [
                        Color(0xffE53935),
                        Color(0xff3FBBBB),
                        Color(0xff1565C0),
                        Color(0xff2E7D32),
                        Color(0xff6A1B9A),
                        Color(0xffE65100),
                        Color(0xffFDD835),
                        Color(0xff000000),
                      ].map((c) {
                        final isSelected =
                            themeProvider.accentColor.toARGB32() ==
                            c.toARGB32();
                        return GestureDetector(
                          onTap: () => themeProvider.setAccentColor(c),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: c.withValues(alpha: 0.6),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 22,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext ctx, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(ctx).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),
      child: Column(children: children),
    );
  }
}
