import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A draggable [FloatingActionButton] that can be positioned by the user.
/// The position is persisted using [SharedPreferences].
class EmergencyButton extends StatefulWidget {
  const EmergencyButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  double _left = 0;
  double _top = 0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _left = prefs.getDouble('emergency_btn_left') ?? -1;
      _top = prefs.getDouble('emergency_btn_top') ?? -1;
      _isLoaded = true;
    });
  }

  Future<void> _savePosition(double left, double top) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('emergency_btn_left', left);
    await prefs.setDouble('emergency_btn_top', top);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox.shrink();

    // Default position (bottom right) if not set yet
    if (_left == -1 && _top == -1) {
      final size = MediaQuery.of(context).size;
      _left = size.width - 150; // approximate width of extended fab
      _top = size.height - 100;
    }

    return Positioned(
      left: _left,
      top: _top,
      child: Draggable(
        feedback: Material(
          color: Colors.transparent,
          child: _buildFab(opacity: 0.8),
        ),
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          // Adjust for status bar/app bar if needed, offset.dy is global
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          // Ensure it stays within screen bounds roughly
          final size = MediaQuery.of(context).size;
          double newLeft = details.offset.dx;
          double newTop = details.offset.dy;
          
          if (newLeft < 0) newLeft = 0;
          if (newLeft > size.width - 60) newLeft = size.width - 60;
          if (newTop < 50) newTop = 50; // avoid top notch/appbar
          if (newTop > size.height - 60) newTop = size.height - 60;

          setState(() {
            _left = newLeft;
            _top = newTop;
          });
          _savePosition(newLeft, newTop);
        },
        child: _buildFab(),
      ),
    );
  }

  Widget _buildFab({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: FloatingActionButton.extended(
        heroTag: 'emergency_btn',
        backgroundColor: Colors.redAccent,
        onPressed: widget.onPressed ?? () {},
        label: const Text('Emergency', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      ),
    );
  }
}

