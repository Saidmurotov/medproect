import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../../services/food_ai_service.dart';
import '../../models/food_result_model.dart';
import 'result_screen.dart';

/// Foydalanuvchi ovqatni rasmga oladigan ekran.
/// Rasm → Gemini AI → ResultScreen
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isAnalyzing = false;
  String _statusText = '';

  /// Internet ulanishini tekshirish
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Kamerani ochib rasm olish
  Future<void> _openCamera() async {
    // Internet tekshiruvi
    if (!await _hasInternet()) {
      _showErrorDialog(
        'Internet aloqasi yo\'q',
        'AI tahlil uchun internet kerak. Iltimos, ulanib qayta urinib ko\'ring.',
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1024,
    );

    if (picked == null || !mounted) return;

    final imageFile = File(picked.path);

    setState(() {
      _isAnalyzing = true;
      _statusText = 'Rasm tahlil qilinmoqda...';
    });

    await _analyzeImage(imageFile);
  }

  /// Gemini API ga rasmni yuborish va natijani qayta ishlash
  Future<void> _analyzeImage(File imageFile) async {
    try {
      final jsonResult = await FoodAiService.analyzeFood(imageFile);
      final result = FoodResultModel.fromJson(jsonResult);

      if (!mounted) return;

      if (!result.isFood) {
        setState(() {
          _isAnalyzing = false;
        });
        _showNotFoodDialog(result.message);
      } else {
        setState(() => _isAnalyzing = false);
        _goToResultScreen(imageFile, result);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _statusText = '';
      });
      _showErrorDialog('Xato yuz berdi', e.toString());
    }
  }

  void _goToResultScreen(File image, FoodResultModel result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(image: image, result: result),
      ),
    );
  }

  void _showNotFoodDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.no_food_outlined, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Ovqat aniqlanmadi'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openCamera();
            },
            child: const Text('Qayta urinish'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            child: const Text('Bekor qilish'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Ovqat Skaneri',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isAnalyzing ? _buildAnalyzingView() : _buildReadyView(),
    );
  }

  Widget _buildAnalyzingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryLight,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI tahlil qilmoqda — 2–4 soniya',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 56,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Ovqatingizni rasmga oling',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gemini AI kaloriya, oqsil, yog\' va\nuglevodni avtomatik hisoblab beradi',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Camera button
            GestureDetector(
              onTap: _openCamera,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Rasmga olish',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Hint
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.white38, size: 14),
                SizedBox(width: 6),
                Text(
                  'Faqat ovqat rasmlari qabul qilinadi',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
