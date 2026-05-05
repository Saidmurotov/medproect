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
  
  // Firebase initialization
  await Firebase.initializeApp();
  
  // Notification service initialization
  await NotificationService().init();
  
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
}
