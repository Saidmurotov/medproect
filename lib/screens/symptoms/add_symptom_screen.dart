import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../models/symptom_model.dart';
import '../../providers/user_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../l10n/app_localizations.dart';
import '../../services/symptom_logic_service.dart';

class AddSymptomScreen extends StatefulWidget {
  const AddSymptomScreen({super.key});

  @override
  State<AddSymptomScreen> createState() => _AddSymptomScreenState();
}

class _AddSymptomScreenState extends State<AddSymptomScreen> {
  final Set<String> _selectedSymptoms = {};
  double _painLevel = 5;
  final TextEditingController _commentController = TextEditingController();
  bool _isSaving = false;

  // Symptom chip data
  static const List<Map<String, dynamic>> _symptoms = [
    {'key': 'headache', 'emoji': '🤕'},
    {'key': 'stomachache', 'emoji': '🤢'},
    {'key': 'dizziness', 'emoji': '💫'},
    {'key': 'nausea', 'emoji': '😰'},
    {'key': 'fever', 'emoji': '🔥'},
    {'key': 'breathlessness', 'emoji': '🫁'},
    {'key': 'chest_pain', 'emoji': '🫀'},
    {'key': 'constipation', 'emoji': '😣'},
    {'key': 'diarrhea', 'emoji': '😖'},
    {'key': 'belching', 'emoji': '😤'},
  ];

  @override
  void dispose() {
    _commentController.dispose();
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
        title: Text(l10n.symptoms, style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Text(
              l10n.symptomsQuestion,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Symptom Chips
            AppCard(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _symptoms.map((s) {
                  final isSelected = _selectedSymptoms.contains(s['key']);
                  return _SymptomChip(
                    label: _getSymptomName(s['key'] as String, l10n),
                    emoji: s['emoji'] as String,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSymptoms.remove(s['key']);
                        } else {
                          _selectedSymptoms.add(s['key'] as String);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Pain Level Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.painLevel, style: AppTextStyles.labelBold),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPainColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_painLevel.toInt()}/10',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _getPainColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Scale numbers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(10, (i) {
                      final isActive = i + 1 <= _painLevel;
                      return Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? _getPainColor()
                              : AppColors.textTertiary,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 2),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: _getPainColor(),
                      inactiveTrackColor: _getPainColor().withValues(
                        alpha: 0.12,
                      ),
                      thumbColor: _getPainColor(),
                      overlayColor: _getPainColor().withValues(alpha: 0.1),
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                    ),
                    child: Slider(
                      value: _painLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (val) => setState(() => _painLevel = val),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DYNAMIC ADVICE (Emergency or Info)
            if (_selectedSymptoms.isNotEmpty) ...[
              _buildAdviceCard(context),
              const SizedBox(height: 20),
            ],

            // Optional Note
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📝  ${l10n.additionalNote}',
                    style: AppTextStyles.labelBold,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.noteHint,
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
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

      // Sticky bottom button
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: l10n.save,
              isLoading: _isSaving,
              icon: Icons.check_rounded,
              onPressed: _saveSymptom,
            ),
            const SizedBox(height: 4),
            const AppBottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Color _getPainColor() {
    if (_painLevel <= 3) return AppColors.success;
    if (_painLevel <= 6) return AppColors.warning;
    return AppColors.danger;
  }

  String _getSymptomName(String key, AppLocalizations l10n) {
    switch (key) {
      case 'headache':
        return l10n.headache;
      case 'stomachache':
        return l10n.stomachache;
      case 'dizziness':
        return l10n.dizziness;
      case 'nausea':
        return l10n.nausea;
      case 'fever':
        return l10n.fever;
      case 'constipation':
        return l10n.constipation;
      case 'diarrhea':
        return l10n.diarrhea;
      case 'belching':
        return l10n.belching;
      case 'breathlessness':
        return l10n.breathlessnessSymptom;
      case 'chest_pain':
        return l10n.chestPainSymptom;
      default:
        return '';
    }
  }

  Widget _buildAdviceCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final advice = SymptomLogicService.getAdvice(
      context: context,
      selectedSymptoms: _selectedSymptoms.toList(),
      painLevel: _painLevel.toInt(),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: advice.isEmergency
            ? AppColors.danger.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: advice.isEmergency
              ? AppColors.danger.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                advice.isEmergency
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline_rounded,
                color: advice.isEmergency
                    ? AppColors.danger
                    : AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                advice.isEmergency ? l10n.emergencyAdvice : l10n.generalAdvice,
                style: AppTextStyles.labelBold.copyWith(
                  color: advice.isEmergency
                      ? AppColors.danger
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advice.advice,
            style: AppTextStyles.bodyMedium.copyWith(
              color: advice.isEmergency
                  ? AppColors.danger.withValues(alpha: 0.9)
                  : AppColors.textPrimary,
              fontWeight: advice.isEmergency
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _saveSymptom() async {
    final l10n = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return;

    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(l10n.symptomSelectError),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final symptom = SymptomModel(
      id: '',
      userId: user.id,
      symptoms: _selectedSymptoms.toList(),
      painLevel: _painLevel.toInt(),
      date: DateTime.now(),
    );

    try {
      final firestoreService = FirestoreService();
      await firestoreService.addSymptom(symptom);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(l10n.saveSuccess),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = 'Xatolik: $e';
        final errStr = e.toString().toLowerCase();

        if (errStr.contains('unable to resolve host') ||
            errStr.contains('unavailable') ||
            errStr.contains('network')) {
          errorMsg =
              "Internet mavjud emas. Ma'lumot telefonda saqlandi va tarmoq tiklanganda bulutga yuboriladi.";

          // Even with network error, we can consider it "saved" because Firestore handles it offline
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.orange.shade800,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
          Navigator.pop(context);
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _SymptomChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymptomChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
