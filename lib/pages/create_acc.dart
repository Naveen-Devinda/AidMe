import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/home_page.dart';
import 'package:aidme/services/user_services.dart';
import 'package:flutter/material.dart';

class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc> {
  final _pageController = PageController();
  final _loginFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();
  final _emergencyFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _diseaseController = TextEditingController();

  final List<TextEditingController> _emergencyNameControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _emergencyPhoneControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );

  final List<String> _bloodGroups = const [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final List<String> _illnessSuggestions = const [
    'Asthma',
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Epilepsy',
    'Kidney Disease',
    'Migraine',
    'Arthritis',
    'Anemia',
    'Allergy',
    'Depression',
    'Anxiety',
  ];

  final List<String> _chronicDiseases = [];
  String? _gender;
  DateTime? _dob;
  String? _bloodGroup;
  int _currentPage = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    final controllers = [
      _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
      _phoneController,
      _heightController,
      _weightController,
      _diseaseController,
      ..._emergencyNameControllers,
      ..._emergencyPhoneControllers,
    ];
    for (final controller in controllers) {
      controller.addListener(_refreshButton);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _diseaseController.dispose();
    for (final controller in _emergencyNameControllers) {
      controller.dispose();
    }
    for (final controller in _emergencyPhoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _refreshButton() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _isLoginStepReady {
    return _nameController.text.trim().isNotEmpty &&
        _isValidEmail(_emailController.text.trim()) &&
        _passwordController.text.length >= 6 &&
        _passwordController.text == _confirmPasswordController.text;
  }

  bool get _isPersonalStepReady {
    return _gender != null &&
        _dob != null &&
        _phoneController.text.trim().length >= 9 &&
        _bloodGroup != null &&
        _heightController.text.trim().isNotEmpty &&
        _weightController.text.trim().isNotEmpty &&
        _chronicDiseases.isNotEmpty;
  }

  bool get _isEmergencyStepReady {
    var filledContacts = 0;
    for (var i = 0; i < 3; i++) {
      final name = _emergencyNameControllers[i].text.trim();
      final phone = _emergencyPhoneControllers[i].text.trim();
      if (name.isNotEmpty && phone.length >= 9) {
        filledContacts++;
      }
    }
    return filledContacts >= 2;
  }

  bool get _canContinue {
    if (_currentPage == 0) {
      return _isLoginStepReady;
    }
    if (_currentPage == 1) {
      return _isPersonalStepReady;
    }
    return _isEmergencyStepReady && !_isRegistering;
  }

  Future<void> _nextStep() async {
    if (_currentPage == 0) {
      if (!(_loginFormKey.currentState?.validate() ?? false)) {
        return;
      }
      _goToPage(1);
      return;
    }

    if (_currentPage == 1) {
      if (!(_personalFormKey.currentState?.validate() ?? false) ||
          !_isPersonalStepReady) {
        _showMessage('Please complete all personal details.');
        return;
      }
      _goToPage(2);
      return;
    }

    if (!(_emergencyFormKey.currentState?.validate() ?? false) ||
        !_isEmergencyStepReady) {
      _showMessage('Please add at least 2 working emergency contacts.');
      return;
    }

    await _register();
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Future<void> _register() async {
    setState(() {
      _isRegistering = true;
    });

    try {
      await UserServices.registerWithEmail(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      await UserServices.storeRegistrationProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        gender: _gender!,
        dob: _formatDate(_dob!),
        phone: _phoneController.text.trim(),
        bloodGroup: _bloodGroup!,
        height: _heightController.text.trim(),
        weight: _weightController.text.trim(),
        chronicDiseases: _chronicDiseases,
        emergencyContacts: List.generate(3, (index) {
          return {
            'name': _emergencyNameControllers[index].text.trim(),
            'phone': _emergencyPhoneControllers[index].text.trim(),
          };
        }),
      );

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } catch (error) {
      _showMessage(UserServices.friendlyAuthError(error));
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  void _addDisease(String value) {
    final disease = value.trim();
    if (disease.isEmpty) {
      return;
    }
    final exists = _chronicDiseases.any(
      (item) => item.toLowerCase() == disease.toLowerCase(),
    );
    if (!exists) {
      setState(() {
        _chronicDiseases.add(disease);
      });
    }
    _diseaseController.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffE53935),
        foregroundColor: kWhiteColor,
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? const Color(0xffE53935)
                            : kBlackColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLoginDetailsPage(),
                  _buildPersonalDetailsPage(),
                  _buildEmergencyContactPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _goToPage(_currentPage - 1);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          foregroundColor: const Color(0xffE53935),
                          side: const BorderSide(color: Color(0xffE53935)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _canContinue ? _nextStep : null,
                      icon: _isRegistering
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kWhiteColor,
                              ),
                            )
                          : Icon(
                              _currentPage == 2
                                  ? Icons.person_add_alt
                                  : Icons.arrow_forward,
                            ),
                      label: Text(
                        _currentPage == 2
                            ? (_isRegistering ? 'Creating...' : 'Register')
                            : 'Next',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xffE53935),
                        foregroundColor: kWhiteColor,
                        disabledBackgroundColor: kBlackColor.withValues(
                          alpha: 0.14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
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

  Widget _buildLoginDetailsPage() {
    return _StepScaffold(
      title: 'Login Details',
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 92,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 18),
            _RegistrationTextField(
              controller: _nameController,
              label: 'Name',
              icon: Icons.person_outline,
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _RegistrationTextField(
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
            const SizedBox(height: 12),
            _RegistrationTextField(
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
                  return 'Please enter a password';
                }
                if ((value ?? '').length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _RegistrationTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock_reset,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsPage() {
    return _StepScaffold(
      title: 'Personal Details',
      child: Form(
        key: _personalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Gender'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _GenderOption(
                  value: 'Male',
                  selected: _gender == 'Male',
                  onTap: () => _setGender('Male'),
                ),
                _GenderOption(
                  value: 'Female',
                  selected: _gender == 'Female',
                  onTap: () => _setGender('Female'),
                ),
                _GenderOption(
                  value: 'Other',
                  selected: _gender == 'Other',
                  onTap: () => _setGender('Other'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PickerField(
              label: 'Date of Birth',
              value: _dob == null ? '' : _formatDate(_dob!),
              icon: Icons.calendar_month_outlined,
              onTap: _pickDob,
            ),
            const SizedBox(height: 12),
            _RegistrationTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if ((value ?? '').trim().length < 9) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _bloodGroup,
              decoration: _fieldDecoration(
                label: 'Blood Group',
                icon: Icons.bloodtype_outlined,
              ),
              items: _bloodGroups.map((group) {
                return DropdownMenuItem(value: group, child: Text(group));
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select your blood group';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _bloodGroup = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RegistrationTextField(
                    controller: _heightController,
                    label: 'Height',
                    icon: Icons.height,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RegistrationTextField(
                    controller: _weightController,
                    label: 'Weight',
                    icon: Icons.monitor_weight_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _FieldLabel('Chronic Disease'),
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.trim().toLowerCase();
                if (query.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _illnessSuggestions.where(
                  (illness) => illness.toLowerCase().contains(query),
                );
              },
              onSelected: _addDisease,
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                _diseaseController.text = controller.text;
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: _fieldDecoration(
                    label: 'Type disease name',
                    icon: Icons.health_and_safety_outlined,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _addDisease(controller.text);
                        controller.clear();
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    _addDisease(value);
                    controller.clear();
                  },
                );
              },
            ),
            if (_chronicDiseases.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Add at least one condition. Use "None" if not applicable.',
                  style: TextStyle(
                    color: kBlackColor.withValues(alpha: 0.58),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (_chronicDiseases.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _chronicDiseases.map((disease) {
                  return Chip(
                    label: Text(disease),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _chronicDiseases.remove(disease);
                      });
                    },
                    backgroundColor: const Color(0xffFDE3E2),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _setGender(String? value) {
    setState(() {
      _gender = value;
    });
  }

  Widget _buildEmergencyContactPage() {
    return _StepScaffold(
      title: 'Emergency Contact',
      description:
          'Please add minimum 2 working emergency numbers from your relative, cousin, or parents.',
      child: Form(
        key: _emergencyFormKey,
        child: Column(
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_emergency_outlined,
                        color: const Color(0xffE53935).withValues(alpha: 0.8),
                        size: 19,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Contact ${index + 1}',
                        style: const TextStyle(
                          color: kBlackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _RegistrationTextField(
                    controller: _emergencyNameControllers[index],
                    label: 'Name ${index + 1}',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (index < 2 && (value ?? '').trim().isEmpty) {
                        return 'Please enter contact name';
                      }
                      if ((value ?? '').trim().isEmpty &&
                          _emergencyPhoneControllers[index].text
                              .trim()
                              .isNotEmpty) {
                        return 'Please enter contact name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _RegistrationTextField(
                    controller: _emergencyPhoneControllers[index],
                    label: 'Phone Number ${index + 1}',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      final phone = (value ?? '').trim();
                      if (index < 2 && phone.length < 9) {
                        return 'Please enter a working phone number';
                      }
                      if (phone.isNotEmpty && phone.length < 9) {
                        return 'Please enter a working phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const _StepScaffold({
    required this.title,
    required this.child,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(
                color: kBlackColor.withValues(alpha: 0.62),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _RegistrationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?) validator;

  const _RegistrationTextField({
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
      decoration: _fieldDecoration(
        label: label,
        icon: icon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: InputDecorator(
        decoration: _fieldDecoration(label: label, icon: icon),
        child: Text(
          value.isEmpty ? 'Select $label' : value,
          style: TextStyle(
            color: value.isEmpty
                ? kBlackColor.withValues(alpha: 0.54)
                : kBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffE53935) : kWhiteColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected
                ? const Color(0xffE53935)
                : kBlackColor.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? kWhiteColor
                  : kBlackColor.withValues(alpha: 0.5),
              size: 18,
            ),
            const SizedBox(width: 7),
            Text(
              value,
              style: TextStyle(
                color: selected ? kWhiteColor : kBlackColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          color: kBlackColor,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration({
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
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
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xffC62828), width: 1.4),
    ),
  );
}
