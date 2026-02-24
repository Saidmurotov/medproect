import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/form_hints.dart';
import '../../widgets/language_toggle.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _emailValue = '';
  String _passwordValue = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              // Language toggle
              const Align(
                alignment: Alignment.centerRight,
                child: LanguageToggle(),
              ),
              const SizedBox(height: 24),

              // Logo / Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                l10n.appTitle,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.primary,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 6),
              Text('Sog\'ligingizni kuzating', style: AppTextStyles.bodyMedium),

              const SizedBox(height: 48),

              // Login Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.login, style: AppTextStyles.h3),
                    const SizedBox(height: 20),

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

                    const SizedBox(height: 28),
                    CustomButton(
                      text: l10n.login,
                      isLoading: _isLoading,
                      icon: Icons.login_rounded,
                      onPressed: _login,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noAccount, style: AppTextStyles.bodyMedium),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      l10n.registration,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError(l10n.errorEmptyFields);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final user = await authService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null && mounted) {
        await Provider.of<UserProvider>(
          context,
          listen: false,
        ).loadUser(user.uid);
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        String message = l10n.errorInvalidCredentials;
        String errorString = e.toString().toLowerCase();

        if (errorString.contains('network-request-failed')) {
          message = l10n.errorNetwork;
        } else if (errorString.contains('user-not-found')) {
          message = "Foydalanuvchi topilmadi";
        } else if (errorString.contains('wrong-password')) {
          message = "Parol noto'g'ri";
        } else if (errorString.contains('too-many-requests')) {
          message = "Urinishlar ko'payib ketdi. Birozdan so'ng harakat qiling";
        }

        _showError(message);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
