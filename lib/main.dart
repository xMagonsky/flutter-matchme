import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'package:flat_match/screens/login_screen.dart';

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
          "/home": (context) => const HomePageT(),
          "/second": (context) => const SecondScreen(),
          "/test": (context) => Test(),
        }
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


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(children: [
      Text("Home screen"),
      ElevatedButton(
        onPressed: () async {
          try {
            await authProvider.logOut();
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        child: const Text('Logout'),
      ),
      ElevatedButton(
        onPressed: () async {
          Navigator.pushNamed(context, "/second");
        },
        child: const Text('Second screen'),
      ),
    ],);
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(children: [
      Text("Home screen second"),
      ElevatedButton(
        onPressed: () async {
          try {
            await authProvider.logOut();
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        child: const Text('Logout'),
      ),
    ],);
  }
}





class HomePageT extends StatefulWidget {
  const HomePageT({super.key});

  @override
  State<HomePageT> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageT> {
  @override
  void initState() {
    super.initState();
    _checkDataCompleteness();
  }

  Future<void> _checkDataCompleteness() async {
    // Example condition checking if user data is complete
    final bool isDataComplete = await _isUserDataComplete();

    if (!isDataComplete) {
      // Immediately redirect to '/completedata'
      Navigator.pushNamed(context, '/test');
    }
  }

  Future<bool> _isUserDataComplete() async {
    // Replace with your logic for checking data completeness
    // e.g., calling a service, checking shared prefs, etc.
    // For demonstration, let’s just return false:
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}



class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Test123"));
  }
}
