import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants.dart';
import '../../providers/user_provider.dart';
import '../../widgets/bmi_card.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/medication_provider.dart';
import '../../widgets/language_toggle.dart';
import '../../services/firestore_service.dart';
import '../../widgets/symptom_advice_card.dart';
import '../../models/symptom_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<List<SymptomModel>>? _symptomsStream;
  Stream<int>? _caloriesStream;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  String? _activeUserId;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context).user;
    if (user != null && _activeUserId != user.id) {
      _activeUserId = user.id;
      _symptomsStream = FirestoreService().getSymptoms(user.id);
      _caloriesStream = FirestoreService().getTodayTotalCalories(user.id);
    }
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isOffline = result.contains(ConnectivityResult.none);
      });
    }
    // Listen for connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (mounted) {
        setState(() {
          _isOffline = results.contains(ConnectivityResult.none);
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Offline Banner
              if (_isOffline)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.errorNetwork,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        (user?.firstName.isNotEmpty == true
                                ? user!.firstName[0]
                                : 'A')
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.welcome}${user != null ? ", ${user.firstName}" : ""} 👋',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 2),
                        if (user != null)
                          Text(
                            'Sizning tashxisingiz: ${user.diagnosis}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          Text(l10n.trackHealth, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const LanguageToggle(),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).setUser(null);
                        Provider.of<MedicationProvider>(
                          context,
                          listen: false,
                        ).clear();
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).signOut();
                        if (!context.mounted) return;
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              if (user != null) BmiCard(bmi: user.bmi),

              const SizedBox(height: 16),

              // Bugungi Kaloriya Kartasi
              if (_caloriesStream != null)
                StreamBuilder<int>(
                  stream: _caloriesStream,
                  builder: (context, snapshot) {
                    final current = snapshot.data ?? 0;
                    const target = AppConstants.defaultDailyCalorieTarget;
                    final progress = (current / target).clamp(0.0, 1.0);

                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bugungi Kaloriya',
                                    style: AppTextStyles.labelBold,
                                  ),
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '$current',
                                          style: AppTextStyles.statMedium
                                              .copyWith(
                                                color: AppColors.primary,
                                              ),
                                        ),
                                        TextSpan(
                                          text: ' / $target kkal',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.bolt_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 12,
                              backgroundColor: AppColors.border.withValues(
                                alpha: 0.5,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0
                                    ? AppColors.danger
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                progress >= 1.0
                                    ? 'Norma bajarildi! 🎉'
                                    : 'Yana ${target - current} kkal kerak',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: progress >= 1.0
                                      ? AppColors.success
                                      : AppColors.textTertiary,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: AppTextStyles.label,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

              if (_symptomsStream != null)
                StreamBuilder<List<SymptomModel>>(
                  stream: _symptomsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final latestSymptom = snapshot.data!.first;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SymptomAdviceCard(latestSymptom: latestSymptom),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.height_rounded,
                      iconColor: AppColors.primary,
                      label: l10n.height,
                      value: '${user?.height.toInt() ?? 175}',
                      unit: 'sm',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.monitor_weight_outlined,
                      iconColor: AppColors.success,
                      label: l10n.weight,
                      value: '${user?.weight.toInt() ?? 72}',
                      unit: 'kg',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(l10n.quickActions, style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.favorite_rounded,
                      iconColor: AppColors.danger,
                      bgColor: AppColors.dangerLight,
                      label: l10n.addSymptom,
                      onTap: () => Navigator.pushNamed(context, '/add-symptom'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.restaurant_rounded,
                      iconColor: AppColors.success,
                      bgColor: AppColors.successLight,
                      label: 'Mening parhezim',
                      onTap: () => Navigator.pushNamed(context, '/diet'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.bar_chart_rounded,
                      iconColor: AppColors.primary,
                      bgColor: AppColors.primarySurface,
                      label: l10n.monthlySummary,
                      onTap: () => Navigator.pushNamed(context, '/report'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: value, style: AppTextStyles.statMedium),
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: iconColor.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
