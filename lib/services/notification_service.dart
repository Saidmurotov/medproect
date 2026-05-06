import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:medproect/core/navigation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  static const String _channelId = 'medication_reminders_high';
  static const String _channelName = 'Dori eslatmalari';
  static const String _channelDesc = 'Muhim dori eslatmalari';

  bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> init() async {
    if (_isInitialized) return;

    if (!_isSupportedPlatform) {
      _isInitialized = true;
      debugPrint('NotificationService skipped on unsupported platform.');
      return;
    }

    tz.initializeTimeZones();
    final String timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));

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

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationTapped,
    );

    await _createNotificationChannel();
    _isInitialized = true;
    debugPrint('✅ NotificationService initialized. Timezone: $timezoneName');
  }

  Future<void> _createNotificationChannel() async {
    if (!_isSupportedPlatform) return;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    debugPrint('✅ Notification channel created: $_channelId');
  }

  Future<bool> requestPermissionsIfNeeded() async {
    if (!_isSupportedPlatform) return false;

    if (Platform.isAndroid) {
      final notifStatus = await Permission.notification.request();
      debugPrint('📋 Notification permission: $notifStatus');

      if (notifStatus.isDenied || notifStatus.isPermanentlyDenied) {
        debugPrint('❌ Notification permission denied!');
        return false;
      }

      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        final exactAlarmGranted = await androidPlugin
            .requestExactAlarmsPermission();
        debugPrint('📋 Exact alarm permission: $exactAlarmGranted');
      }

      return true;
    }

    if (Platform.isIOS) {
      final granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    return false;
  }

  Future<void> scheduleMedicationReminder({
    required int id,
    required String medicationName,
    required String dosage,
    required TimeOfDay time,
  }) async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    final scheduledTime = _nextInstanceOfTime(time);

    await _notificationsPlugin.zonedSchedule(
      id,
      '💊 Dori vaqti!',
      '$medicationName - $dosage',
      scheduledTime,
      _buildNotificationDetails(medicationName),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'medication_$id',
    );

    debugPrint('✅ Reminder scheduled for $medicationName at $time');
  }

  Future<void> scheduleMedicationReminderForDays({
    required int baseId,
    required String medicationName,
    required String dosage,
    required TimeOfDay time,
    required List<int> daysOfWeek,
  }) async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    for (final day in daysOfWeek) {
      final id = baseId * 10 + day;
      final scheduledTime = _nextInstanceOfTimeOnDay(time, day);

      await _notificationsPlugin.zonedSchedule(
        id,
        '💊 Dori vaqti!',
        '$medicationName - $dosage',
        scheduledTime,
        _buildNotificationDetails(medicationName),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'medication_${baseId}_day_$day',
      );
    }

    debugPrint('✅ Reminders scheduled for days: $daysOfWeek');
  }

  Future<void> showImmediateTestNotification() async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    await _notificationsPlugin.show(
      9999,
      '🔔 Test Notification',
      'Notification ishlayapti! ✅',
      _buildNotificationDetails('Test'),
      payload: 'test',
    );

    debugPrint('✅ Immediate test notification sent!');
  }

  Future<void> showScheduledTestNotification() async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));

    await _notificationsPlugin.zonedSchedule(
      9998,
      '⏰ Rejalashtirilgan Test',
      '10 soniyadan keyin keldi! ✅',
      scheduledTime,
      _buildNotificationDetails('Test'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'test_scheduled',
    );

    debugPrint(
      '✅ Scheduled test notification for: ${scheduledTime.toString()}',
    );
  }

  Future<void> cancelMedicationReminder(int id) async {
    if (!_isSupportedPlatform) return;

    await _notificationsPlugin.cancel(id);
    debugPrint('🗑️  Cancelled notification: $id');
  }

  Future<void> cancelAllReminders() async {
    if (!_isSupportedPlatform) return;

    await _notificationsPlugin.cancelAll();
    debugPrint('🗑️  All notifications cancelled');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isSupportedPlatform) return [];

    return await _notificationsPlugin.pendingNotificationRequests();
  }

  Future<void> debugPermissionStates() async {
    if (!_isSupportedPlatform) {
      debugPrint('Notification debug skipped on unsupported platform.');
      return;
    }

    final notifStatus = await Permission.notification.status;
    debugPrint('=== NOTIFICATION DEBUG ===');
    debugPrint('📋 Notification permission: $notifStatus');
    debugPrint('🕐 Current timezone: ${tz.local.name}');
    debugPrint('🕐 Current local time: ${tz.TZDateTime.now(tz.local)}');

    final pending = await getPendingNotifications();
    debugPrint('📬 Pending notifications: ${pending.length}');
    for (final p in pending) {
      debugPrint('  - ID: ${p.id}, Title: ${p.title}, Body: ${p.body}');
    }

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final areEnabled = await androidPlugin.areNotificationsEnabled();
      debugPrint('📱 Android notifications enabled: $areEnabled');
    }
    debugPrint('==========================');
  }

  NotificationDetails _buildNotificationDetails(String tag) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high, // high, not max
        priority: Priority.high,
        ticker: tag,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: false, // Turned off
        category: AndroidNotificationCategory.reminder, // reminder, not alarm
        visibility: NotificationVisibility.public,
        styleInformation: const BigTextStyleInformation(''),
        autoCancel: true, // Dismiss on tap
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTimeOnDay(TimeOfDay time, int dayOfWeek) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);

    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) await init();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');

    // Navigate to medications page on tap
    navigatorKey.currentState?.pushNamed('/medications');
  }

  /// RESTORED: Added for backward compatibility or direct access if needed
  Future<void> showSettings() async {
    await openAppSettings();
  }
}

@pragma('vm:entry-point')
void _onBackgroundNotificationTapped(NotificationResponse response) {
  debugPrint('🔔 Background notification tapped: ${response.payload}');
}
