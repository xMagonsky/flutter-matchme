import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

import 'package:flat_match/screens/authentication/signup.dart';
import 'package:flat_match/screens/authentication/login.dart';
import 'package:flat_match/screens/homepage.dart';
import 'package:flat_match/screens/complete_registration.dart';
import 'package:flat_match/screens/offer_details.dart';
import 'package:flat_match/screens/user_settings.dart';


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
      child: Builder(builder: (context) {
        final authProvider = Provider.of<AuthProvider>(context);
        debugPrint("hello");

        return MaterialApp(
          title: "Flat Match",
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.red,
          ),
          home: authProvider.isLoggedIn ? const HomePage() : const LoginScreen(),
          routes: {
            "/home": (context) => const HomePage(),
            "/login": (context) => const LoginScreen(),
            "/signup": (context) => const Signup(),
            "/complete-registration": (context) => const CompleteRegistration(),
            "/user-settings": (context) => const UserSettings(),
          },
          // Dynamic route handler:
          onGenerateRoute: (settings) {
            if (settings.name == '/offer-details') {
              final userInfo = settings.arguments as Map<String, dynamic>;

              return MaterialPageRoute(
                builder: (context) => OfferDetails(
                  userInfo: userInfo,
                ),
              );
            }
            return null; // Defer to routes table if not handled here
          },
        );
      })
    );
  }
}
