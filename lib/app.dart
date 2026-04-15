import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/language_provider.dart';
import 'l10n/app_localizations.dart';
import 'core/navigation.dart';

class DGIHealthApp extends StatelessWidget {
  final String initialRoute;
  const DGIHealthApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'DGI Health',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('uz'), Locale('ru')],
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        return ConnectivityBannerWrapper(child: child!);
      },
    );
  }
}

class ConnectivityBannerWrapper extends StatelessWidget {
  final Widget child;
  const ConnectivityBannerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            final connectivity = snapshot.data;
            final isOffline =
                connectivity != null &&
                connectivity.contains(ConnectivityResult.none);

            if (!isOffline) return const SizedBox.shrink();

            return Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Material(
                child: Container(
                  color: Colors.orange.shade800,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        "Offline rejim yoqilgan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
