import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_card.dart';
import '../../widgets/form_hints.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _gender = 'male';
  bool _isLoading = false;
  String _emailValue = '';
  String _passwordValue = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppColors.softShadow,
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16),
          ),
        ),
        title: Text(l10n.registration, style: AppTextStyles.h3),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            // --- Card 1: Personal Info ---
            _SectionTitle(title: '👤  ${l10n.personalInfo}'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  CustomTextField(
                    label: l10n.firstName,
                    controller: _firstNameController,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: l10n.lastName,
                    controller: _lastNameController,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  // Gender selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.gender, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _GenderButton(
                              label: l10n.male,
                              icon: Icons.male_rounded,
                              isSelected: _gender == 'male',
                              onTap: () => setState(() => _gender = 'male'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GenderButton(
                              label: l10n.female,
                              icon: Icons.female_rounded,
                              isSelected: _gender == 'female',
                              onTap: () => setState(() => _gender = 'female'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Card 2: Body Info ---
            _SectionTitle(title: '📊  ${l10n.bodyIndicators}'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  CustomTextField(
                    label: l10n.age,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.cake_outlined,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: l10n.height,
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.height_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: l10n.weight,
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.monitor_weight_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Card 3: Account ---
            _SectionTitle(title: '🔐  ${l10n.accountInfo}'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  // Email with real-time validation
                  CustomTextField(
                    label: l10n.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    onChanged: (value) => setState(() => _emailValue = value),
                    bottomWidget: EmailValidationHint(email: _emailValue),
                  ),

                  const SizedBox(height: 16),

                  // Password with visibility toggle + strength hint
                  CustomTextField(
                    label: l10n.password,
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    onChanged: (value) =>
                        setState(() => _passwordValue = value),
                    bottomWidget: PasswordStrengthHint(
                      password: _passwordValue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Fixed bottom button
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: CustomButton(
          text: l10n.continueBtn,
          isLoading: _isLoading,
          icon: Icons.arrow_forward_rounded,
          onPressed: _register,
        ),
      ),
    );
  }

  void _register() async {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final scaffoldMsg = ScaffoldMessenger.of(context);

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final authService = AuthService();
        final user = await authService.register(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          age: int.tryParse(_ageController.text) ?? 0,
          gender: _gender,
          height: double.tryParse(_heightController.text) ?? 0,
          weight: double.tryParse(_weightController.text) ?? 0,
        );

        if (user != null && mounted) {
          await Provider.of<UserProvider>(
            context,
            listen: false,
          ).loadUser(user.uid);
          if (mounted) {
            navigator.pushReplacementNamed('/home');
          }
        }
      } catch (e) {
        if (mounted) {
          String message = l10n.errorUnknown;
          String errorString = e.toString().toLowerCase();

          if (errorString.contains('email-already-in-use')) {
            message = l10n.errorEmailInUse;
          } else if (errorString.contains('weak-password')) {
            message = l10n.errorWeakPassword;
          } else if (errorString.contains('network-request-failed')) {
            message = l10n.errorNetwork;
          } else if (errorString.contains('invalid-email')) {
            message = l10n.errorInvalidEmail;
          }

          scaffoldMsg.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(message)),
                ],
              ),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(title, style: AppTextStyles.labelBold.copyWith(fontSize: 14)),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
