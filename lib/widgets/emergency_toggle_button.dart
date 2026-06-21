import 'package:aidme/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyToggleButton extends StatefulWidget {
  const EmergencyToggleButton({super.key});

  @override
  State<EmergencyToggleButton> createState() => _EmergencyToggleButtonState();
}

class _EmergencyToggleButtonState extends State<EmergencyToggleButton> {
  bool _isOpen = false;
  double _x = 0;
  double _y = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPosition());
  }

  Future<void> _initPosition() async {
    final size = MediaQuery.sizeOf(context);
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _x = prefs.getDouble('emergency_toggle_x') ?? size.width - 74;
      _y = prefs.getDouble('emergency_toggle_y') ?? size.height - 80;
      _loaded = true;
    });
  }

  Future<void> _savePosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('emergency_toggle_x', _x);
    await prefs.setDouble('emergency_toggle_y', _y);
  }

  void _toggleButton() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xffBB3F3F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);

    return Positioned(
      left: _x,
      top: _y,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _isOpen
                ? Column(
                    key: const ValueKey('emergency-buttons'),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _EmergencyOptionButton(
                        title: 'Call Emergency',
                        icon: Icons.call,
                        onTap: () {
                          _showMessage('Emergency call button clicked');
                        },
                      ),
                      const SizedBox(height: 12),
                      _EmergencyOptionButton(
                        title: 'Share Location',
                        icon: Icons.location_on,
                        onTap: () {
                          _showMessage('Share my location button clicked');
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _x = (_x + details.delta.dx).clamp(0, size.width - 56);
                _y = (_y + details.delta.dy).clamp(0, size.height - 56);
              });
            },
            onPanEnd: (_) => _savePosition(),
            child: FloatingActionButton(
              heroTag: 'emergency-toggle-button',
              onPressed: _toggleButton,
              backgroundColor: const Color(0xffBB3F3F),
              foregroundColor: kWhiteColor,
              elevation: 4,
              shape: const CircleBorder(),
              child: Icon(
                _isOpen ? Icons.close : Icons.warning_amber_rounded,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyOptionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _EmergencyOptionButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xffBB3F3F),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: kWhiteColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
