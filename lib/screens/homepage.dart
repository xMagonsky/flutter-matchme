import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flat_match/providers/auth_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = {};

  Future<void> _getUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userUid = authProvider.uid;

    final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(userUid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final Map<String, dynamic> data = docSnapshot.data()!;
      setState(() {
        userData["test"] = data["test"];
      });
    }

    if (userData["test"] == "1") {
      Navigator.pushNamed(context, "/complete-registration", arguments: _getUserData);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page"), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          children: [
            Text("Home Page - ${userData["test"]}"),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () => authProvider.logOut(),
            ),
          ],
        ),
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
