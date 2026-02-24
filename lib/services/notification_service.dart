import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import '../models/medication_model.dart';
import 'dart:io';

/// MIUI (Xiaomi/Redmi) Optimization Checklist:
/// 1. App Info -> Autostart: ENABLED
/// 2. App Info -> Battery Saver: NO RESTRICTIONS
/// 3. Recents Menu: Long press app -> Lock icon (Locked in memory)
/// 4. App Info -> Permissions -> Allow background activity: ENABLED
/// 5. Developer Options -> Turn off MIUI Optimization (Last resort)

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'medication_alarm_v4';
  static const String _channelName = 'Dori Eslatmalari (Muhim)';
  static const String _channelDesc =
      'Dori ichish vaqti haqida qat\'iy vaqtda xabar beradi';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // 1. Timezone initialization with robust fallback
    tz_data.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("✅ NotificationService: Timezone Set: $timeZoneName");
    } catch (e) {
      debugPrint(
        "⚠️ NotificationService: Timezone Error: $e. Using Asia/Tashkent fallback.",
      );
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Tashkent'));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('UTC'));
        debugPrint("❌ NotificationService: Fell back to UTC.");
      }
    }

    // 2. Platform settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 3. Initialize plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(
          "🔔 NotificationService: Notification Clicked: ${details.payload}",
        );
      },
    );

    // 4. Create MIUI-hardened notification channel
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
          enableLights: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
        );
        await androidPlugin.createNotificationChannel(channel);
        debugPrint(
          "✅ NotificationService: Android Notification Channel Created: $_channelId",
        );
      }
    }

    _initialized = true;
    await debugPermissionStates();
  }

  /// Comprehensive Permission Requests (Android 12/13/14+)
  Future<void> requestPermissionsIfNeeded() async {
    // A. Notification Permission (Android 13+)
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        debugPrint(
          "🔔 NotificationService: Notification permission request: $result",
        );
      }
    }

    // B. Exact Alarm Permission (Android 12+)
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      bool? canSchedule = await androidPlugin?.canScheduleExactNotifications();
      debugPrint(
        "⏰ NotificationService: Can schedule exact alarm: $canSchedule",
      );

      if (canSchedule == false) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  Future<void> debugPermissionStates() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final bool? canSchedule = await androidPlugin
        ?.canScheduleExactNotifications();
    final bool isNotificationEnabled = await Permission.notification.isGranted;
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    debugPrint("╔══════════════════════════════════╗");
    debugPrint("║    NOTIFICATION DEBUG STATUS     ║");
    debugPrint("╠══════════════════════════════════╣");
    debugPrint("║ Current Local Time: $now");
    debugPrint("║ Notifications Granted: $isNotificationEnabled");
    debugPrint("║ Exact Alarm Granted: $canSchedule");
    debugPrint("║ Channel ID: $_channelId");
    debugPrint("╚══════════════════════════════════╝");
  }

  /// Main scheduling method
  Future<void> scheduleMedicationNotification(Medication med) async {
    await cancelMedicationNotification(med.id);

    if (!med.reminderEnabled || med.scheduleType == ScheduleType.prn) {
      debugPrint(
        "⏭️ NotificationService: Skipping scheduling for: ${med.name}",
      );
      return;
    }

    for (int i = 0; i < med.times.length; i++) {
      final timeStr = med.times[i];
      final id = _generateNotificationId(med.id, i);

      if (med.scheduleType == ScheduleType.daily) {
        await _schedule(
          id: id,
          title: "💊 ${med.name}",
          body: "${med.name} vaqti bo'ldi: ${med.dose ?? ''}",
          timeStr: timeStr,
          repeatDaily: true,
        );
      } else if (med.scheduleType == ScheduleType.custom) {
        for (int day in med.daysOfWeek) {
          final customId = _generateNotificationId(med.id, i * 10 + day);
          await _schedule(
            id: customId,
            title: "💊 ${med.name}",
            body: "${med.name} vaqti bo'ldi: ${med.dose ?? ''}",
            timeStr: timeStr,
            targetWeekday: day,
          );
        }
      }
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required String timeStr,
    bool repeatDaily = false,
    int? targetWeekday,
  }) async {
    final parts = timeStr.split(':');
    if (parts.length != 2) {
      debugPrint("❌ NotificationService: Invalid time format: $timeStr");
      return;
    }
    final int hour = int.tryParse(parts[0]) ?? 0;
    final int minute = int.tryParse(parts[1]) ?? 0;

    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

    if (targetWeekday != null) {
      int tries = 0;
      while (scheduledDate.weekday != targetWeekday && tries < 8) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
        tries++;
      }
    }

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final duration = scheduledDate.difference(now);
    debugPrint(
      "📅 NotificationService: Scheduling ID $id at $scheduledDate (In ${duration.inMinutes} mins, ${duration.inSeconds % 60} secs) (Repeat: $repeatDaily)",
    );

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        autoCancel: true,
        fullScreenIntent: false,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: repeatDaily
            ? DateTimeComponents.time
            : (targetWeekday != null
                  ? DateTimeComponents.dayOfWeekAndTime
                  : null),
      );
      debugPrint("✅ NotificationService: Scheduled EXACT (ID: $id)");
    } catch (e) {
      debugPrint(
        "⚠️ NotificationService: Exact failed ($e), falling back to INEXACT...",
      );
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: repeatDaily
              ? DateTimeComponents.time
              : (targetWeekday != null
                    ? DateTimeComponents.dayOfWeekAndTime
                    : null),
        );
        debugPrint("✅ NotificationService: Scheduled INEXACT (ID: $id)");
      } catch (e2) {
        debugPrint(
          "❌ NotificationService: Both scheduling methods failed: $e2",
        );
      }
    }
  }

  Future<void> cancelMedicationNotification(String medId) async {
    for (int i = 0; i < 100; i++) {
      await _notificationsPlugin.cancel(_generateNotificationId(medId, i));
    }
  }

  int _generateNotificationId(String medId, int index) {
    // Use a more stable hash to avoid collisions
    int hash = 0;
    for (int i = 0; i < medId.length; i++) {
      hash = 31 * hash + medId.codeUnitAt(i);
    }
    return (hash.abs() % 900000) + index;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    debugPrint("🗑️ All notifications cancelled");
  }
}
