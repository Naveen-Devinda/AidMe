import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/create_acc.dart';
import 'package:aidme/pages/home_page.dart';
import 'package:aidme/services/user_services.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await UserServices.loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final profile = await UserServices.fetchUserProfile();
      if (profile != null) {
        await UserServices.saveProfileToLocal(profile);
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      _showMessage(UserServices.friendlyAuthError(error));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _googleLogin() async {
    setState(() {
      _googleLoading = true;
    });

    try {
      final credential = await UserServices.signInWithGoogle();
      if (credential == null) return;

      final profile = await UserServices.fetchUserProfile();
      if (profile != null) {
        await UserServices.saveProfileToLocal(profile);
      } else if (credential.user != null) {
        await UserServices.updateProfileInFirestore({
          'name': credential.user!.displayName ?? 'User',
          'email': credential.user!.email ?? '',
        });
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      _showMessage(UserServices.friendlyAuthError(error));
    } finally {
      if (mounted) {
        setState(() {
          _googleLoading = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !_isValidEmail(email)) {
      _showMessage('Enter your email first to reset your password.');
      return;
    }

    try {
      await UserServices.sendPasswordResetEmail(email);
      _showMessage('Password reset email sent.');
    } catch (error) {
      _showMessage(UserServices.friendlyAuthError(error));
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 128,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kBlackColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue your AidMe care profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kBlackColor.withValues(alpha: 0.62),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_isValidEmail(email)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return 'Please enter your password';
                      }
                      if ((value ?? '').length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: const Text('Forgotten password?'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE53935),
                      foregroundColor: kWhiteColor,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kWhiteColor,
                            ),
                          )
                        : const Icon(Icons.login),
                    label: Text(
                      _isLoading ? 'Logging in...' : 'Login',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _googleLoading ? null : _googleLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kBlackColor,
                      minimumSize: const Size.fromHeight(52),
                      side: BorderSide(
                        color: kBlackColor.withValues(alpha: 0.14),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_googleLoading)
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Container(
                            height: 24,
                            width: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kBlackColor.withValues(alpha: 0.12),
                              ),
                            ),
                            child: const Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xff4285F4),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Text(
                          _googleLoading
                              ? 'Opening Google...'
                              : 'Continue with Google',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAcc(),
                        ),
                      );
                    },
                    child: const Text(
                      'create a new user account',
                      style: TextStyle(
                        color: Color(0xff1565C0),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?) validator;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: kWhiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: kBlackColor.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffE53935), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffC62828)),
        ),
      ),
    );
  }
}
