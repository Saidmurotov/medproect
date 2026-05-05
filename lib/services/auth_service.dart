import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Foydalanuvchi holatini kuzatish
  Stream<User?> get user => _auth.authStateChanges();

  // Ro'yxatdan o'tish (Email/Password bilan)
  Future<User?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required String gender,
    required double height,
    required double weight,
    required String diagnosis,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final newUser = UserModel(
          id: credential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          age: age,
          gender: gender,
          height: height,
          weight: weight,
          diagnosis: diagnosis,
          createdAt: DateTime.now(),
        );

        await _firestoreService.saveUser(newUser);
        return credential.user;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Xatoligi: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Noma\'lum xatolik: $e');
      rethrow;
    }
    return null;
  }

  // Kirish
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Login Xatoligi: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Kirishda noma\'lum xatolik: $e');
      rethrow;
    }
  }

  // Tizimdan chiqish
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
