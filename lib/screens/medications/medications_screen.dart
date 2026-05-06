import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/medication_provider.dart';
import '../../core/constants/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../models/medication_model.dart';
import '../../services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  bool _showPermissionBanner = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.notification.status;
    if (mounted) {
      setState(() {
        _showPermissionBanner = !status.isGranted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medProvider = Provider.of<MedicationProvider>(context);

    // Filter today's meds
    final todayMeds = _getTodayMeds(medProvider.medications);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.medications,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          // ℹ️ MIUI / Xiaomi Help
          IconButton(
            onPressed: () => _showMIUIHelpDialog(context),
            icon: const Icon(Icons.info_outline, color: Colors.orange),
            tooltip: l10n.miuiSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showPermissionBanner) _buildPermissionBanner(l10n),

            const SizedBox(height: 16),
            Text(
              l10n.todaySchedule,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Grouped today's meds
            ..._buildGroupedTodayMeds(todayMeds, medProvider, l10n),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.allMedications,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/add-medication'),
                  child: Text(l10n.addMedication),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...medProvider.medications.map(
              (med) => _buildMedicationListItem(med, l10n),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildPermissionBanner(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        color: AppColors.danger.withValues(alpha: 0.1),
        child: Row(
          children: [
            const Icon(
              Icons.notifications_off,
              color: AppColors.danger,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.notificationPermissionBanner,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final provider = Provider.of<MedicationProvider>(
                        context,
                        listen: false,
                      );
                      await provider.requestPermissions();
                      if (!mounted) return;
                      _checkPermissions();
                    },
                    child: Text(
                      l10n.setupNotifications,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => setState(() => _showPermissionBanner = false),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedTodayMeds(
    List<_TodayMedItem> todayMeds,
    MedicationProvider provider,
    AppLocalizations l10n,
  ) {
    if (todayMeds.isEmpty) {
      return [_buildEmptyState(l10n)];
    }

    final pendingMeds = todayMeds
        .where((m) => !provider.isTaken(m.medication.id, m.time))
        .toList();
    final takenMeds = todayMeds
        .where((m) => provider.isTaken(m.medication.id, m.time))
        .toList();

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.todaySchedule,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            _formattedDate(),
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (pendingMeds.isNotEmpty) ...[
        _buildGroupHeader(
          icon: '⏳',
          title: l10n.pending,
          count: pendingMeds.length,
          color: Colors.orange,
        ),
        ...pendingMeds.map((item) => _buildTodayItem(item, provider, l10n)),
      ],
      if (takenMeds.isNotEmpty) ...[
        const SizedBox(height: 12),
        _buildGroupHeader(
          icon: '✅',
          title: l10n.completed,
          count: takenMeds.length,
          color: Colors.green,
        ),
        ...takenMeds.map((item) => _buildTodayItem(item, provider, l10n)),
      ],
      if (pendingMeds.isEmpty && takenMeds.isNotEmpty)
        _buildAllDoneWidget(l10n),
    ];
  }

  Widget _buildGroupHeader({
    required String icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            '$title ($count)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(color: color.withValues(alpha: 0.3), thickness: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDoneWidget(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.allDoneTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  l10n.allDoneSubtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const days = [
      'Dushanba',
      'Seshanba',
      'Chorshanba',
      'Payshanba',
      'Juma',
      'Shanba',
      'Yakshanba',
    ];
    const months = [
      'Yan',
      'Fev',
      'Mar',
      'Apr',
      'May',
      'Iyn',
      'Iyl',
      'Avg',
      'Sen',
      'Okt',
      'Noy',
      'Dek',
    ];
    return '${now.day} ${months[now.month - 1]}, ${days[now.weekday - 1]}';
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            l10n.trackHealth,
            style: const TextStyle(color: AppColors.textTertiary),
          ),
        ),
      ),
    );
  }

  List<_TodayMedItem> _getTodayMeds(List<Medication> meds) {
    List<_TodayMedItem> items = [];
    final now = DateTime.now();
    final weekday = now.weekday;

    for (var med in meds) {
      bool isToday = false;
      if (med.scheduleType == ScheduleType.daily) {
        isToday = true;
      }
      if (med.scheduleType == ScheduleType.custom &&
          med.daysOfWeek.contains(weekday)) {
        isToday = true;
      }
      if (med.scheduleType == ScheduleType.prn) {
        isToday = true;
      }

      if (isToday) {
        for (var time in med.times) {
          items.add(_TodayMedItem(medication: med, time: time));
        }
      }
    }
    // Sort by time
    items.sort((a, b) => a.time.compareTo(b.time));
    return items;
  }

  Widget _buildTodayItem(
    _TodayMedItem item,
    MedicationProvider provider,
    AppLocalizations l10n,
  ) {
    final bool taken = provider.isTaken(item.medication.id, item.time);

    return Opacity(
      opacity: taken ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (taken ? Colors.green : AppColors.primary).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  taken ? Icons.check_circle : Icons.medication_outlined,
                  color: taken ? Colors.green : AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.medication.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: taken ? TextDecoration.lineThrough : null,
                        color: taken ? Colors.grey : Colors.black,
                      ),
                    ),
                    Text(
                      "${item.time} • ${item.medication.dose ?? ''}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: taken,
                activeColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (val) {
                  provider.toggleTaken(
                    item.medication.id,
                    item.time,
                    val ?? false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationListItem(Medication med, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "${med.dose ?? ''} - ${med.times.join(', ')}",
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${l10n.reminders}: ${med.reminderEnabled ? l10n.taken : l10n.notTaken}",
                    style: TextStyle(
                      color: med.reminderEnabled
                          ? AppColors.success
                          : AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.textTertiary,
                size: 20,
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                '/add-medication',
                arguments: med,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMIUIHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUz = Localizations.localeOf(context).languageCode == 'uz';
    final helpLines = isUz
        ? [
            'Bildirishnomalar vaqtida chiqishi uchun quyidagilarni bajaring:',
            '1. Ilova belgisini bosib turing -> App info',
            '2. Autostart ni yoqing',
            '3. Battery saver -> No restrictions',
            '4. Other permissions -> Display pop-up windows',
            'Agar ishlamasa, Developer options ichida MIUI optimization sozlamasini tekshiring.',
          ]
        : [
            'Чтобы напоминания приходили вовремя, проверьте настройки:',
            '1. Зажмите иконку приложения -> App info',
            '2. Включите Autostart',
            '3. Battery saver -> No restrictions',
            '4. Other permissions -> Display pop-up windows',
            'Если не работает, проверьте MIUI optimization в Developer options.',
          ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.miuiSettings),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: helpLines.asMap().entries.map((entry) {
              final isFirst = entry.key == 0;
              final isLast = entry.key == helpLines.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isFirst ? 12 : 6),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isLast ? Colors.orange : null,
                    fontWeight: isFirst || isLast
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              NotificationService().showSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.openSettings),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.understood),
          ),
        ],
      ),
    );
  }
}

class _TodayMedItem {
  final Medication medication;
  final String time;
  _TodayMedItem({required this.medication, required this.time});
}
