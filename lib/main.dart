import 'package:flat_match/widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

import 'package:flat_match/screens/chats.dart';
import 'package:flat_match/screens/authentication/signup.dart';
import 'package:flat_match/screens/authentication/login.dart';
import 'package:flat_match/screens/homepage.dart';
import 'package:flat_match/screens/complete_registration.dart';
import 'package:flat_match/screens/offer_details.dart';
import 'package:flat_match/screens/user_settings.dart';
import 'package:flat_match/screens/user_filters.dart';


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
            primarySwatch: Colors.purple,
          ),
          home: authProvider.isLoggedIn ? const HomePage() : const LoginScreen(),
          routes: {
            "/home": (context) => const HomePage(),
            "/login": (context) => const LoginScreen(),
            "/signup": (context) => const Signup(),
            "/complete-registration": (context) => const CompleteRegistration(),
            "/user-settings": (context) => const UserSettings(),
            "/chats": (context) => const ChatsScreen(),
            "/user-filters": (context) => const UserFiltersScreen(),
          },
          // Dynamic route handler:
          onGenerateRoute: (settings) {
            if (settings.name == '/offer-details') {
              final userInfo = settings.arguments as Map<String, dynamic>;

              return MaterialPageRoute(
                builder: (context) => OfferDetails(
                  userData: userInfo,
                ),
              );
            }
            if (settings.name == '/chat') {
              final chatterData = settings.arguments as Map<String, dynamic>;

              return MaterialPageRoute(
                builder: (context) => Chat(
                  chatterData: chatterData,
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
