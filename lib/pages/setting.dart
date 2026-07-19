import 'dart:convert';

import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/history_page.dart';
import 'package:aidme/pages/login.dart';
import 'package:aidme/pages/settings/about_page.dart';
import 'package:aidme/pages/settings/help_feedback_page.dart';
import 'package:aidme/pages/settings/privacy_security_page.dart';
import 'package:aidme/pages/settings/profile_management_page.dart';
import 'package:aidme/pages/settings/theme_settings_page.dart';
import 'package:aidme/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _name = '';
  String _email = '';
  String? _profilePicBase64;

  @override
  void initState() {
    super.initState();
    _loadLocal();
  }

  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLocal = (prefs.getString('username') ?? '').isNotEmpty;
    if (!hasLocal) {
      final profile = await UserServices.fetchUserProfile();
      if (profile != null) await UserServices.saveProfileToLocal(profile);
    }
    final r = await SharedPreferences.getInstance();
    setState(() {
      _name = r.getString('username') ?? '';
      _email = r.getString('email') ?? '';
      _profilePicBase64 = r.getString('profilePic');
    });
  }

  void _applyFsData(Map<String, dynamic>? data) {
    if (data == null) return;
    final newName = data['name'] ?? _name;
    final newEmail = data['email'] ?? _email;
    if (newName == _name && newEmail == _email) return;
    setState(() {
      _name = newName;
      _email = newEmail;
    });
  }

  Future<void> _pickProfilePic() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final b64 = base64Encode(bytes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePic', b64);

    final user = UserServices.currentUser;
    if (user != null) {
      try {
        await UserServices.updateProfileInFirestore({'profilePic': b64});
      } catch (_) {}
    }

    setState(() => _profilePicBase64 = b64);
    _msg('Profile picture updated');
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await UserServices.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _msg(String s) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(title: const Text('Settings')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: UserServices.streamUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _applyFsData(snapshot.data!.data());
            });
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              _profileCard(),
              const SizedBox(height: 24),
              _menuItem(
                Icons.person_outline,
                'Profile Management',
                'View & manage your details',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileManagementPage(),
                    ),
                  );
                },
              ),
              _menuItem(
                Icons.palette_outlined,
                'Theme',
                'Dark mode, font size, colors',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ThemeSettingsPage(),
                    ),
                  );
                },
              ),
              _menuItem(
                Icons.history,
                'History',
                'Recent mental & physical sessions',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryPage(),
                    ),
                  );
                },
              ),
              _menuItem(
                Icons.lock_outline,
                'Privacy & Security',
                'Password, account, privacy',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacySecurityPage(),
                    ),
                  );
                },
              ),
              _menuItem(
                Icons.help_outline,
                'Help & Feedback',
                'FAQs & support',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpFeedbackPage()),
                  );
                },
              ),
              _menuItem(Icons.info_outline, 'About', 'App version & info', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                );
              }),
              const SizedBox(height: 32),
              _logoutButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickProfilePic,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xffE53935),
                  backgroundImage: _profilePicBase64 != null
                      ? MemoryImage(base64Decode(_profilePicBase64!))
                      : null,
                  child: _profilePicBase64 == null
                      ? Text(
                          _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xffE53935),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xffE53935)),
            onPressed: _showEditProfileDialog,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } 

  // Show dialog to edit name and email
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final newEmail = emailController.text.trim();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('username', newName);
              await prefs.setString('email', newEmail);
              final user = UserServices.currentUser;
              if (user != null) {
                try {
                  await UserServices.updateProfileInFirestore({
                    'name': newName,
                    'email': newEmail,
                  });
                } catch (_) {}
              }
              setState(() {
                _name = newName;
                _email = newEmail;
              });
              _msg('Profile updated');
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xffE53935), size: 26),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xffE53935)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        onTap: onTap,
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xffE53935),
          side: const BorderSide(color: Color(0xffE53935)),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
