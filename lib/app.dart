import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/language_provider.dart';
import 'core/navigation.dart';

class MedProectApp extends StatelessWidget {
  const MedProectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'MedProect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: navigatorKey,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uz', ''),
        Locale('ru', ''),
      ],
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.login,
    );
  }
}
