import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyServicesPage extends StatelessWidget {
  const EmergencyServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffE53935),
        elevation: 0,
        title: const Text(
          "Emergency Services",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Quick Access Numbers",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff5A7273),
            ),
          ),
          const SizedBox(height: 16),
          _buildEmergencyCard(
            context,
            title: "Police Emergency",
            subtitle: "For crime reporting & immediate danger",
            number: "119",
            icon: Icons.local_police,
            color: Colors.blue,
          ),
          _buildEmergencyCard(
            context,
            title: "Ambulance / Health",
            subtitle: "Medical emergencies & health crises",
            number: "110",
            icon: Icons.medical_services,
            color: Colors.red,
          ),
          _buildEmergencyCard(
            context,
            title: "Fire Department",
            subtitle: "Fire emergencies & rescue operations",
            number: "111",
            icon: Icons.fire_truck,
            color: Colors.orange,
          ),
          _buildEmergencyCard(
            context,
            title: "Disaster Management",
            subtitle: "Natural disasters & emergency relief",
            number: "117",
            icon: Icons.warning,
            color: Colors.amber,
          ),
          _buildEmergencyCard(
            context,
            title: "Tourist Police",
            subtitle: "Tourist assistance & safety",
            number: "1912",
            icon: Icons.card_travel,
            color: Colors.teal,
          ),
          _buildEmergencyCard(
            context,
            title: "Women & Child",
            subtitle: "Women & child helpline services",
            number: "1929",
            icon: Icons.female,
            color: Colors.purple,
          ),
          _buildEmergencyCard(
            context,
            title: "Mental Health",
            subtitle: "24/7 mental health support & counseling",
            number: "1926",
            icon: Icons.psychology,
            color: const Color(0xff3FBBBB),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xffE53935).withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xffE53935), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "These are Sri Lanka emergency numbers. Stay calm and provide clear information when calling.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String number,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff1A1A1A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        trailing: GestureDetector(
          onTap: () => _makePhoneCall(number),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
