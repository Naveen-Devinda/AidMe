import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xffE53935),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.medical_services_outlined,
                    size: 44, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text('AidMe', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(
                'v1.0.0',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 8),
              Text(
                'Latest version installed',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xffE53935)),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: const Column(
                  children: [
                    _InfoRow(icon: Icons.code, label: 'Version', value: '1.0.0+1'),
                    Divider(),
                    _InfoRow(icon: Icons.update, label: 'Build', value: '1'),
                    Divider(),
                    _InfoRow(icon: Icons.phone_android, label: 'Platform', value: 'Flutter 3.x'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xffE53935)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xff4A4A4A))),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xff1A1A1A))),
        ],
      ),
    );
  }
}
