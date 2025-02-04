import 'package:firebase_core/firebase_core.dart';
import 'package:flat_match/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:flat_match/services/auth_service.dart';
import 'package:flat_match/providers/auth_provider.dart';

// Generate a mock for AuthService
class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {
  @override
  String get uid => '12345';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensures the Flutter framework is set up for tests

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  late AuthProvider authProvider;
  late MockAuthService mockAuthService;
  late MockUser mockUser;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    authProvider = AuthProvider();
  });

  test('Initial state should be logged out', () {
    expect(authProvider.isLoggedIn, false);
    expect(authProvider.uid, isNull);
  });

  test('Sign up updates user state', () async {
    when(mockAuthService.signUp("1@seeker.pl", "123123")).thenAnswer((_) async => mockUser);

    await authProvider.signUp('test@example.com', 'password123');

    expect(authProvider.isLoggedIn, true);
    expect(authProvider.uid, '12345');
  });

  test('Log in updates user state', () async {
    when(mockAuthService.logIn("1@seeker.pl", "123123")).thenAnswer((_) async => mockUser);

    await authProvider.logIn('test@example.com', 'password123');

    expect(authProvider.isLoggedIn, true);
    expect(authProvider.uid, '12345');
  });

  test('Log out clears user state', () async {
    when(mockAuthService.logOut()).thenAnswer((_) async {});
    authProvider.logOut();

    expect(authProvider.isLoggedIn, false);
    expect(authProvider.uid, isNull);
  });
}