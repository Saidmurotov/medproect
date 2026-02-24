import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/medication_provider.dart';
import '../../core/constants/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../models/medication_model.dart';

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
    // Basic check for MVP: logic to show banner if needed
    // In a real app, we'd check current status
    setState(() {
      _showPermissionBanner = true;
    });
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
            tooltip: "MIUI Sozlamalari",
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
            if (todayMeds.isEmpty)
              _buildEmptyState(l10n)
            else
              ...todayMeds.map(
                (item) => _buildTodayItem(item, medProvider, l10n),
              ),

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
      bottomNavigationBar: const AppBottomNavBar(
        currentIndex: 3,
      ), // We'll update the nav index
    );
  }

  Widget _buildPermissionBanner(AppLocalizations l10n) {
    return AppCard(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notificationPermissionBanner,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final provider = Provider.of<MedicationProvider>(
                      context,
                      listen: false,
                    );
                    await provider.requestPermissions();
                    setState(() => _showPermissionBanner = false);
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
    );
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

    return Padding(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${item.time} • ${item.medication.dose ?? ''}",
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: taken,
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
                    "${med.dose ?? ''} • ${med.times.join(', ')}",
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text("Xiaomi Sozlamalari"),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bildirishnomalar vaqtida chiqishi uchun quyidagilarni bajaring:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text("1. Ilova belgisini bosib turing -> 'App Info'"),
              SizedBox(height: 4),
              Text("2. 'Autostart' (Avtopusk) yoqing"),
              SizedBox(height: 4),
              Text("3. 'Battery Saver' -> 'No Restrictions'"),
              SizedBox(height: 4),
              Text("4. 'Other Permissions' -> 'Display pop-up windows'"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tushunarli"),
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
