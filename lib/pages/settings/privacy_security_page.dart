import 'package:aidme/pages/login.dart';
import 'package:aidme/services/user_services.dart';
import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  void _showChangePasswordDialog() {
    final currentPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    final confirmPwdCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPwdCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Current Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPwdCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'New Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPwdCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirm New Password', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (newPwdCtrl.text.length < 6) {
                        _msg('Password must be at least 6 characters');
                        return;
                      }
                      if (newPwdCtrl.text != confirmPwdCtrl.text) {
                        _msg('Passwords do not match');
                        return;
                      }
                      setDState(() => isLoading = true);
                      try {
                        await UserServices.changePassword(
                            currentPwdCtrl.text, newPwdCtrl.text);
                        if (ctx.mounted) Navigator.pop(ctx);
                        _msg('Password changed successfully');
                      } catch (e) {
                        _msg('Failed: ${e.toString()}');
                      }
                    },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE53935),
                  foregroundColor: Colors.white),
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final emailCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This action is irreversible. All your data will be permanently deleted.',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                    labelText: 'Enter your email to confirm',
                    border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final user = UserServices.currentUser;
                      if (emailCtrl.text.trim() != user?.email) {
                        _msg('Email does not match your account email');
                        return;
                      }
                      setDState(() => isLoading = true);
                      try {
                        await UserServices.deleteAccount(emailCtrl.text.trim());
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        _msg('Failed: ${e.toString()}');
                      }
                    },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white),
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Delete Forever'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyAgreement() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy Agreement'),
        content: const SingleChildScrollView(
          child: Text("""Privacy Agreement

Last updated: June 2026

1. Information Collection
We collect personal information you provide during registration including name, email, date of birth, gender, phone number, blood group, height, weight, chronic diseases, and emergency contacts.

2. Data Usage
Your data is used solely to provide first-aid assistance and emergency contact features within the AidMe application.

3. Data Storage
Your personal data is stored securely in Firebase Firestore. We implement reasonable security measures to protect your information.

4. Data Sharing
We do not share your personal data with third parties except when required by law or with your explicit consent.

5. Your Rights
You may request deletion of your account and associated data at any time through the app settings.

6. Changes to This Policy
We may update this privacy agreement from time to time. Users will be notified of any material changes.

7. Contact
For questions about this agreement, please contact us through the app's feedback section."""),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _msg(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          _tile(Icons.lock_outline, 'Change Password', 'Update your account password',
              _showChangePasswordDialog),
          const SizedBox(height: 8),
          _tile(Icons.delete_forever_outlined, 'Delete Account',
              'Permanently remove your account', _showDeleteAccountDialog),
          const SizedBox(height: 24),
          _tile(Icons.description_outlined, 'Privacy Agreement',
              'Read our privacy policy', _showPrivacyAgreement),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xffE53935), size: 24),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.chevron_right),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        onTap: onTap,
      ),
    );
  }
}
