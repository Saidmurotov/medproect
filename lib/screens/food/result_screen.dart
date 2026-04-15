import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../models/food_result_model.dart';

/// Gemini tahlil natijasini ko'rsatib, Firestore ga saqlash imkonini beruvchi ekran.
class ResultScreen extends StatefulWidget {
  final File image;
  final FoodResultModel result;

  const ResultScreen({
    super.key,
    required this.image,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;

  /// Firestore ga saqlash — foodLogs collection
  Future<void> _saveToFirestore() async {
    setState(() => _isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Foydalanuvchi tizimga kirmagan');

      await FirebaseFirestore.instance
          .collection('foodLogs')
          .add(widget.result.toFirestore(uid));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Muvaffaqiyatli saqlandi!'),
            ],
          ),
          backgroundColor: AppColors.success,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, widget.result);
    } catch (e) {
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xato: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tahlil Natijasi', style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Olingan rasm
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                widget.image,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Ovqat nomi + porsiya
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.foodName ?? 'Nomalum ovqat',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  if (r.portion != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      r.portion!,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Makrolar grid: 2x2
            Row(
              children: [
                _MacroCard(
                  label: 'Kaloriya',
                  value: '${r.calories}',
                  unit: 'kkal',
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFF97316),
                  bgColor: const Color(0xFFFFF7ED),
                ),
                const SizedBox(width: 10),
                _MacroCard(
                  label: 'Oqsil',
                  value: r.protein.toStringAsFixed(1),
                  unit: 'g',
                  icon: Icons.fitness_center_rounded,
                  color: AppColors.primary,
                  bgColor: AppColors.primarySurface,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _MacroCard(
                  label: 'Yog\'',
                  value: r.fat.toStringAsFixed(1),
                  unit: 'g',
                  icon: Icons.water_drop_rounded,
                  color: AppColors.danger,
                  bgColor: AppColors.dangerLight,
                ),
                const SizedBox(width: 10),
                _MacroCard(
                  label: 'Uglevod',
                  value: r.carbs.toStringAsFixed(1),
                  unit: 'g',
                  icon: Icons.grain_rounded,
                  color: AppColors.success,
                  bgColor: AppColors.successLight,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Saqlash tugmasi
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveToFirestore,
              icon: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(_isSaving ? 'Saqlanmoqda...' : 'Saqlash'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),

            const SizedBox(height: 12),

            // Bekor qilish
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Qayta olish'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Makro qiymatini ko'rsatish uchun kichik karta
class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
