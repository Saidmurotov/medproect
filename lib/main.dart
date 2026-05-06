import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/medication_provider.dart';
import 'providers/language_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final startupError = await _initializeCriticalServices();
  if (startupError != null) {
    runApp(_StartupErrorApp(message: startupError));
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MedProectApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeDeferredServices();
  });
}

Future<String?> _initializeCriticalServices() async {
  try {
    await Firebase.initializeApp();
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
    return 'Firebase ulanishi sozlanmagan yoki ishga tushmadi.';
  }

  return null;
}

Future<void> _initializeDeferredServices() async {
  try {
    await NotificationService().init();
  } catch (e, stackTrace) {
    debugPrint('Notification initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class _StartupErrorApp extends StatelessWidget {
  final String message;

  const _StartupErrorApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Ilovani ishga tushirib bo\'lmadi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
