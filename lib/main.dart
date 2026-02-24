import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'providers/language_provider.dart';
import 'providers/user_provider.dart';
import 'providers/medication_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase with error handling
  try {
    await Firebase.initializeApp();
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("❌ Firebase init failed: $e");
    // App should still run offline with cached data
  }

  // 2. Initialize Notifications with Timezones
  final notificationService = NotificationService();
  try {
    await notificationService.init();
    await notificationService.requestPermissionsIfNeeded();
    debugPrint("✅ Notifications initialized");
  } catch (e) {
    debugPrint("⚠️ Notification init error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) {
            return UserProvider();
          },
        ),
        ChangeNotifierProvider(create: (_) => MedicationProvider()..init()),
      ],
      child: const MedProectApp(initialRoute: '/login'),
    ),
  );
}
