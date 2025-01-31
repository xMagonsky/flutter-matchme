import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      debugPrint("State changed ${user?.uid}");
      _setUser(user);
    });
  }
  // Stream<User?> get authState => _authService.authStateChanges;

  String? get uid => _user?.uid;
  bool get isLoggedIn => _user != null;

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    User? user = await _authService.signUp(email, password);
    _setUser(user);
  }

  Future<void> logIn(String email, String password) async {
    User? user = await _authService.logIn(email, password);
    _setUser(user);
  }

  Future<void> logOut() async {
    await _authService.logOut();
    _setUser(null);
  }

}
