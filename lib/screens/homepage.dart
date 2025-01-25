import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkDataCompleteness();
  }

  Future<void> _checkDataCompleteness() async {
    final bool isDataComplete = await _isUserDataComplete();

    if (!isDataComplete) {
      if (!mounted) return;
      Navigator.pushNamed(context, '/complete-registration');
    }
  }

  Future<bool> _isUserDataComplete() async {
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


// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final authProvider = Provider.of<AuthProvider>(context);

//     return Column(children: [
//       Text("Home screen"),
//       ElevatedButton(
//         onPressed: () async {
//           try {
//             // await authProvider.logOut();
//           } catch (e) {
//             if (!context.mounted) return;
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(e.toString())),
//             );
//           }
//         },
//         child: const Text('Logout'),
//       ),
//       ElevatedButton(
//         onPressed: () async {
//           Navigator.pushNamed(context, "/second");
//         },
//         child: const Text('Second screen'),
//       ),
//     ],);
//   }
// }
