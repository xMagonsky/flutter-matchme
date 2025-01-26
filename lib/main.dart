import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

import 'package:flat_match/screens/authentication/signup.dart';
import 'package:flat_match/screens/authentication/login.dart';
import 'package:flat_match/screens/homepage.dart';
import 'package:flat_match/screens/complete_registration.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlatMatch());
}

class FlatMatch extends StatelessWidget {
  const FlatMatch({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: "Flat Match",
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: "/",
        routes: {
          "/": (context) => const AuthWrapper(),
          "/login": (context) => const LoginScreen(),
          "/signup": (context) => const Signup(),
          "/home": (context) => const HomePage(),
        },
        // Dynamic route handler:
        onGenerateRoute: (settings) {
          if (settings.name == '/complete-registration') {
            final callback = settings.arguments as VoidCallback;

            return MaterialPageRoute(
              builder: (context) => CompleteRegistration(
                updateUserCallback: callback,
              ),
            );
          }
          return null; // Defer to routes table if not handled here
        },
      )
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", ModalRoute.withName('/'));
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/login", ModalRoute.withName('/'));
      }
    });

    return const Center(child: CircularProgressIndicator());
  }
}
