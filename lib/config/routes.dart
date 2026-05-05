import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/symptoms/add_symptom_screen.dart';
import '../screens/profile/monthly_report_screen.dart';
import '../screens/medications/medications_screen.dart';
import '../screens/medications/add_edit_medication_screen.dart';
import '../screens/food/camera_screen.dart';
import '../screens/food/diet_screen.dart';
import '../models/medication_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addSymptom = '/add-symptom';
  static const String report = '/report';
  static const String medications = '/medications';
  static const String addMedication = '/add-medication';
  static const String foodCamera = '/food-camera';
  static const String diet = '/diet';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addSymptom:
        return MaterialPageRoute(builder: (_) => const AddSymptomScreen());
      case report:
        return MaterialPageRoute(builder: (_) => const MonthlyReportScreen());
      case medications:
        return MaterialPageRoute(builder: (_) => const MedicationsScreen());
      case addMedication:
        final med = settings.arguments as Medication?;
        return MaterialPageRoute(
          builder: (_) => AddEditMedicationScreen(medication: med),
        );
      case foodCamera:
        return MaterialPageRoute(builder: (_) => const CameraScreen());
      case diet:
        return MaterialPageRoute(builder: (_) => const DietScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
