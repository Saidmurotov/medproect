import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/symptoms/add_symptom_screen.dart';
import '../screens/profile/monthly_report_screen.dart';
import '../screens/medications/medications_screen.dart';
import '../screens/medications/add_edit_medication_screen.dart';
import '../models/medication_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addSymptom = '/add-symptom';
  static const String report = '/report';
  static const String medications = '/medications';
  static const String addMedication = '/add-medication';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegistrationScreen(),
    home: (context) => const HomeScreen(),
    addSymptom: (context) => const AddSymptomScreen(),
    report: (context) => const MonthlyReportScreen(),
    medications: (context) => const MedicationsScreen(),
    addMedication: (context) {
      final med = ModalRoute.of(context)?.settings.arguments as Medication?;
      return AddEditMedicationScreen(medication: med);
    },
  };
}
