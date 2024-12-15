import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    User? user = await _authService.signUp(email, password);
    setUser(user);
  }

  Future<void> logIn(String email, String password) async {
    User? user = await _authService.logIn(email, password);
    setUser(user);
  }

  Future<void> logOut() async {
    await _authService.logOut();
    setUser(null);
  }

  Stream<User?> get authState => _authService.authStateChanges;
}
