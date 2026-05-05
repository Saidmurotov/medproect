import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/diet_tables.dart';
import '../../providers/user_provider.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final locale = Localizations.localeOf(context).languageCode;
    final isUz = locale == 'uz';

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tableId = DietConstants.diseaseToTable[user.diagnosis] ?? '№15';
    final diet = DietConstants.dietTables[tableId] ?? DietConstants.dietTables['№15']!;

    final allowed = isUz ? diet.allowedUz : diet.allowedRu;
    final forbidden = isUz ? diet.forbiddenUz : diet.forbiddenRu;
    final description = isUz ? diet.descriptionUz : diet.descriptionRu;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isUz ? 'Mening parhezim' : 'Моя диета', style: AppTextStyles.h3),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUz ? 'Tashxis:' : 'Диагноз:',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.diagnosis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${isUz ? 'Parhez stoli:' : 'Диетический стол:'} $tableId',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Allowed Section
            _buildSection(
              title: isUz ? 'MUMKIN ✅' : 'МОЖНО ✅',
              items: allowed,
              color: AppColors.success,
              bgColor: AppColors.successLight,
            ),

            const SizedBox(height: 20),

            // Forbidden Section
            _buildSection(
              title: isUz ? 'MUMKIN EMAS ❌' : 'НЕЛЬЗЯ ❌',
              items: forbidden,
              color: AppColors.danger,
              bgColor: AppColors.dangerLight,
            ),
            
            const SizedBox(height: 40),
            
            // Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isUz 
                        ? 'Eslatma: Har doim shifokoringiz bilan maslahatlashing.'
                        : 'Примечание: Всегда консультируйтесь с лечащим врачом.',
                      style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
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

  Widget _buildSection({
    required String title,
    required List<String> items,
    required Color color,
    required Color bgColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              item,
              style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
