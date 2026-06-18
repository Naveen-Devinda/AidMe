import 'package:aidme/constants/colors.dart';
import 'package:flutter/material.dart';

class EmergencyToggleButton extends StatefulWidget {
  const EmergencyToggleButton({super.key});

  @override
  State<EmergencyToggleButton> createState() => _EmergencyToggleButtonState();
}

class _EmergencyToggleButtonState extends State<EmergencyToggleButton> {
  bool _isOpen = false;

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
    return Positioned(
      right: 18,
      bottom: 24,
      child: SafeArea(
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
            FloatingActionButton(
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
          ],
        ),
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
