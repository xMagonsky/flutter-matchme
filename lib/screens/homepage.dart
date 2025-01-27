import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flat_match/providers/auth_provider.dart';
import 'package:flat_match/widgets/card_swiper.dart';


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
      Navigator.pushReplacementNamed(context, "/complete-registration");
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
            Swiping(),
          ],
        ),
      ),
    );
  }
}
