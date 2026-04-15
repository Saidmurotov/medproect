import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/medication_model.dart';
import '../../providers/medication_provider.dart';
import '../../core/constants/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final Medication? medication;
  const AddEditMedicationScreen({super.key, this.medication});

  @override
  State<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  late ScheduleType _scheduleType;
  late List<String> _times;
  late List<int> _daysOfWeek;
  late bool _reminderEnabled;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    _nameController = TextEditingController(text: med?.name ?? '');
    _doseController = TextEditingController(text: med?.dose ?? '');
    _scheduleType = med?.scheduleType ?? ScheduleType.daily;
    _times = med != null ? List.from(med.times) : ["09:00"];
    _daysOfWeek = med != null
        ? List.from(med.daysOfWeek)
        : [1, 2, 3, 4, 5, 6, 7];
    _reminderEnabled = med?.reminderEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(int index) async {
    final currentParts = _times[index].split(':');
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(currentParts[0]),
        minute: int.parse(currentParts[1]),
      ),
    );
    if (picked != null) {
      setState(() {
        _times[index] =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medProvider = Provider.of<MedicationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.medication == null ? l10n.addMedication : l10n.editMedication,
        ),
        actions: [
          if (widget.medication != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          children: [
            _buildSection(l10n.personalInfo, [
              CustomTextField(
                label: l10n.medName,
                hint: l10n.medNameHint,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: l10n.dosage,
                hint: l10n.dosageHint,
                controller: _doseController,
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection(l10n.schedule, [
              _buildDropdown(l10n),
              if (_scheduleType == ScheduleType.custom) ...[
                const SizedBox(height: 16),
                _buildDayPicker(l10n),
              ],
            ]),
            const SizedBox(height: 16),
            _buildSection(l10n.reminders, [
              ..._times.asMap().entries.map(
                (entry) => _buildTimeItem(entry.key, l10n),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _times.add("09:00")),
                icon: const Icon(Icons.add),
                label: Text(l10n.addTime),
              ),
              const Divider(),
              SwitchListTile(
                title: Text(
                  l10n.reminders,
                  style: const TextStyle(fontSize: 15),
                ),
                value: _reminderEnabled,
                onChanged: (val) => setState(() => _reminderEnabled = val),
              ),
            ]),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: CustomButton(
          text: l10n.save,
          isLoading: medProvider.isLoading,
          onPressed: () => _save(medProvider),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<ScheduleType>(
      initialValue: _scheduleType,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      items: [
        DropdownMenuItem(value: ScheduleType.daily, child: Text(l10n.daily)),
        DropdownMenuItem(
          value: ScheduleType.custom,
          child: Text(l10n.customDays),
        ),
        DropdownMenuItem(value: ScheduleType.prn, child: Text(l10n.prn)),
      ],
      onChanged: (val) => setState(() => _scheduleType = val!),
    );
  }

  Widget _buildDayPicker(AppLocalizations l10n) {
    final days = [
      {'val': 1, 'label': l10n.mon},
      {'val': 2, 'label': l10n.tue},
      {'val': 3, 'label': l10n.wed},
      {'val': 4, 'label': l10n.thu},
      {'val': 5, 'label': l10n.fri},
      {'val': 6, 'label': l10n.sat},
      {'val': 7, 'label': l10n.sun},
    ];
    return Wrap(
      spacing: 8,
      children: days.map((day) {
        final isSelected = _daysOfWeek.contains(day['val']);
        return FilterChip(
          label: Text(day['label'] as String),
          selected: isSelected,
          onSelected: (val) {
            setState(() {
              if (val) {
                _daysOfWeek.add(day['val'] as int);
              } else {
                _daysOfWeek.remove(day['val'] as int);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTimeItem(int index, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              _times[index],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(index),
          ),
        ),
        if (_times.length > 1)
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
            onPressed: () => setState(() => _times.removeAt(index)),
          ),
      ],
    );
  }

  Future<void> _save(MedicationProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_nameController.text.isEmpty) return;

    final med = Medication(
      id: widget.medication?.id ?? const Uuid().v4(),
      name: _nameController.text,
      dose: _doseController.text,
      scheduleType: _scheduleType,
      times: _times,
      daysOfWeek: _daysOfWeek,
      reminderEnabled: _reminderEnabled,
      createdAt: widget.medication?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.medication == null) {
        await provider.addMedication(med);
      } else {
        await provider.updateMedication(med);
      }

      if (!mounted) return;

      scaffoldMessenger.showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
      navigator.pop();
    } catch (e) {
      // If we are here, Firestore write failed, but Notification was scheduled locally.
      debugPrint("Save error caught: $e");

      if (mounted) {
        String errorMsg = l10n.errorUnknown;
        final errStr = e.toString().toLowerCase();

        if (errStr.contains('unable to resolve host') ||
            errStr.contains('unavailable') ||
            errStr.contains('network')) {
          errorMsg =
              "Internet mavjud emas. Eslatma telefonda saqlandi va bildirishnoma chiqadi. Tarmoq tiklanganda ma'lumotlar bulutga yuboriladi.";
        }

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            duration: const Duration(seconds: 6),
            backgroundColor: Colors.orange.shade800,
            action: SnackBarAction(
              label: "Tushunarli",
              textColor: Colors.white,
              onPressed: () {
                if (mounted) navigator.pop();
              },
            ),
          ),
        );

        // Final pop to exit screen since it's saved locally/cached by Firestore offline
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) navigator.pop();
        });
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Provider.of<MedicationProvider>(
                context,
                listen: false,
              ).deleteMedication(widget.medication!.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
