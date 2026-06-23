import 'package:aidme/constants/colors.dart';
import 'package:aidme/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _callEmergencyContact() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('emergencyContact1Phone') ?? '';
    if (number.isEmpty) {
      _showMessage('No emergency contact found');
      return;
    }
    final uri = Uri.parse('tel:$number');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showMessage('Could not launch phone dialer');
    }
  }

  Future<void> _shareLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final number = prefs.getString('emergencyContact1Phone') ?? '';
      if (number.isEmpty) {
        _showMessage('No emergency contact found');
        return;
      }

      if (!mounted) return;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Please turn on GPS');
        return;
      }

      if (!mounted) return;

      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        final granted = await _showDialog(
          'Location Permission Needed',
          'We need your location to share it with your emergency contact.'
          '\n\nTap Allow to continue.',
          confirmText: 'Allow',
          cancelText: 'Deny',
        );
        if (!granted || !mounted) return;

        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied) return;
        if (newPermission == LocationPermission.deniedForever) {
          _showMessage('Location permission permanently denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage('Location permission permanently denied');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final mapsUrl =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';
      final smsUri = Uri.parse(
        'sms:$number?body=I need help! My location: $mapsUrl',
      );
      await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showMessage('Could not send location: $e');
    }
  }

  Future<bool> _showDialog(
    String title,
    String message, {
    String confirmText = 'OK',
    String? cancelText,
  }) async {
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
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
                          onTap: _callEmergencyContact,
                        ),
                        const SizedBox(height: 12),
                        _EmergencyOptionButton(
                          title: 'Share Location',
                          icon: Icons.location_on,
                          onTap: _shareLocation,
                        ),
                        const SizedBox(height: 14),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            GestureDetector(
              onTap: _toggleButton,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffBB3F3F).withValues(alpha: 0.15),
                      border: Border.all(
                        color: const Color(0xffBB3F3F).withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isOpen
                        ? const Icon(
                            Icons.close,
                            key: ValueKey('close'),
                            color: Color(0xffBB3F3F),
                            size: 28,
                          )
                        : Image.asset(
                            'assets/images/emer.png',
                            key: const ValueKey('emer'),
                            width: 44,
                            height: 44,
                          ),
                  ),
                ],
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
