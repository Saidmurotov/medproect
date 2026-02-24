import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
}
