import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/user_provider.dart';
import 'providers/medication_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  // Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("❌ Firebase init failed: $e");
  }

  // 2. Initialize Notifications BEFORE runApp()
  final notificationService = NotificationService();
  try {
    // This calls initialize() on the plugin and sets up timezones
    await notificationService.init();

    // Request permissions (essential for Android 13+)
    await notificationService.requestPermissionsIfNeeded();

    debugPrint("✅ Notifications initialized successfully");
  } catch (e) {
    debugPrint("⚠️ Notification init error: $e");
  }

  // 3. Start the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()..init()),
      ],
      child: const DGIHealthApp(initialRoute: '/login'),
    ),
  );
}
