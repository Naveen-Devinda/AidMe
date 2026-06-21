import 'package:aidme/constants/colors.dart';
import 'package:aidme/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileManagementPage extends StatelessWidget {
  const ProfileManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(title: const Text('Profile Management')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: UserServices.streamUserProfile(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              _sectionTitle('Personal Information'),
              const SizedBox(height: 8),
              _infoTile(Icons.person_outline, 'Name', data['name'] ?? '', () => _editField(context, 'name', data['name'] ?? '')),
              _infoTile(Icons.email_outlined, 'Email', data['email'] ?? '', null),
              _infoTile(Icons.calendar_month_outlined, 'Date of Birth', data['dob'] ?? '', () => _editDob(context, data['dob'] ?? '')),
              _infoTile(Icons.person_outline, 'Gender', data['gender'] ?? '', () => _editGender(context, data['gender'] ?? '')),
              _infoTile(Icons.phone_outlined, 'Phone', data['phone'] ?? '', () => _editField(context, 'phone', data['phone'] ?? '')),
              const SizedBox(height: 24),
              _sectionTitle('Medical Information'),
              const SizedBox(height: 8),
              _infoTile(Icons.bloodtype_outlined, 'Blood Group', data['bloodGroup'] ?? '', () => _editBloodGroup(context, data['bloodGroup'] ?? '')),
              _infoTile(Icons.height, 'Height', data['height'] != null ? '${data['height']} cm' : '', () => _editField(context, 'height', data['height'] ?? '')),
              _infoTile(Icons.monitor_weight_outlined, 'Weight', data['weight'] != null ? '${data['weight']} kg' : '', () => _editField(context, 'weight', data['weight'] ?? '')),
              _infoTile(Icons.health_and_safety_outlined, 'Chronic Diseases',
                  (data['chronicDiseases'] as List?)?.join(', ') ?? 'None',
                  () => _editDiseases(context, (data['chronicDiseases'] as List?)?.cast<String>() ?? [])),
              const SizedBox(height: 12),
              const Text('Emergency Contacts',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xff4A4A4A))),
              const SizedBox(height: 6),
              ..._buildEmergencyContacts(context, (data['emergencyContacts'] as List?) ?? []),
            ],
          );
        },
      ),
    );
  }

  void _snack(BuildContext c, String m) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

  void _editField(BuildContext c, String field, String current) {
    if (field == 'email') return;
    final controller = TextEditingController(text: current);
    final label = field[0].toUpperCase() + field.substring(1);
    showDialog(
      context: c,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final v = controller.text.trim();
              if (v.isEmpty) return;
              await UserServices.updateProfileInFirestore({field: v});
              _snack(c, 'Updated successfully');
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE53935), foregroundColor: kWhiteColor),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editDob(BuildContext c, String current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: c,
      initialDate: current.isNotEmpty ? DateTime.parse(current) : DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      await UserServices.updateProfileInFirestore({'dob': '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}'});
      _snack(c, 'Updated successfully');
    }
  }

  void _editGender(BuildContext c, String current) {
    final options = ['Male', 'Female', 'Other'];
    showModalBottomSheet(
      context: c,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Gender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ...options.map((g) => ListTile(
                leading: Icon(current == g ? Icons.radio_button_checked : Icons.radio_button_off, color: const Color(0xffE53935)),
                title: Text(g, style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  UserServices.updateProfileInFirestore({'gender': g});
                  Navigator.pop(ctx);
                  _snack(c, 'Updated successfully');
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _editBloodGroup(BuildContext c, String current) {
    final groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    showModalBottomSheet(
      context: c,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Blood Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ...groups.map((g) => ListTile(
                leading: Icon(current == g ? Icons.radio_button_checked : Icons.radio_button_off, color: const Color(0xffE53935)),
                title: Text(g, style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  UserServices.updateProfileInFirestore({'bloodGroup': g});
                  Navigator.pop(ctx);
                  _snack(c, 'Updated successfully');
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _editDiseases(BuildContext c, List<String> current) {
    final tempList = List<String>.from(current);
    final controller = TextEditingController();
    showModalBottomSheet(
      context: c,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chronic Diseases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Type disease...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        final v = controller.text.trim();
                        if (v.isNotEmpty && !tempList.contains(v)) {
                          setSheetState(() => tempList.add(v));
                          controller.clear();
                        }
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xffE53935), foregroundColor: kWhiteColor),
                    ),
                  ],
                ),
                if (tempList.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: tempList.map((d) => Chip(
                      label: Text(d, style: const TextStyle(fontWeight: FontWeight.w600)),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => setSheetState(() => tempList.remove(d)),
                      backgroundColor: const Color(0xffFDE3E2),
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await UserServices.updateProfileInFirestore({'chronicDiseases': tempList});
                      _snack(c, 'Updated successfully');
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE53935), foregroundColor: kWhiteColor,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmergencyContacts(BuildContext c, List contacts) {
    return List.generate(3, (i) {
      final contact = i < contacts.length ? contacts[i] as Map? : null;
      final name = contact?['name'] ?? '';
      final phone = contact?['phone'] ?? '';
      return GestureDetector(
        onTap: () => _editEmergencyContact(c, i, contacts),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xffE53935).withValues(alpha: 0.1),
                child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xffE53935))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.isNotEmpty ? name : 'Not set',
                        style: TextStyle(fontWeight: FontWeight.w600, color: name.isNotEmpty ? const Color(0xff1A1A1A) : Colors.grey)),
                    if (phone.isNotEmpty)
                      Text(phone, style: const TextStyle(fontSize: 13, color: Color(0xff6A6A6A))),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, size: 18, color: Color(0xffE53935)),
            ],
          ),
        ),
      );
    });
  }

  void _editEmergencyContact(BuildContext c, int index, List currentContacts) {
    final contacts = currentContacts.map((e) => Map<String, String>.from(e as Map)).toList();
    while (contacts.length < 3) { contacts.add({'name': '', 'phone': ''}); }
    final nameCtrl = TextEditingController(text: contacts[index]['name']);
    final phoneCtrl = TextEditingController(text: contacts[index]['phone']);

    showDialog(
      context: c,
      builder: (ctx) => AlertDialog(
        title: Text('Contact ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              contacts[index] = {'name': nameCtrl.text.trim(), 'phone': phoneCtrl.text.trim()};
              await UserServices.updateProfileInFirestore({'emergencyContacts': contacts});
              _snack(c, 'Updated successfully');
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE53935), foregroundColor: kWhiteColor),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xff1A1A1A)));
  }

  Widget _infoTile(IconData icon, String label, String value, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xffE53935), size: 22),
        title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xff4A4A4A))),
        subtitle: Text(
          value.isEmpty ? 'Not set' : value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: value.isEmpty ? Colors.black.withValues(alpha: 0.3) : const Color(0xff1A1A1A)),
        ),
        trailing: onTap != null ? const Icon(Icons.edit_outlined, size: 18, color: Color(0xffE53935)) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        onTap: onTap,
      ),
    );
  }
}
