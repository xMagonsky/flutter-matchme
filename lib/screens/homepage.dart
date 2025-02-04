import 'package:flat_match/screens/chats.dart';
import 'package:flat_match/screens/user_filters.dart';
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

  bool showFilters = false;

  Future<void> _getUserData() async {
    print("GET SUER DATA");
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(authProvider.uid).get();
    final data = docSnapshot.data();

    if (data == null || data["name"] == null) {
      if (mounted) Navigator.pushReplacementNamed(context, "/complete-registration");
      return;
    }
        userData = data;
    if (mounted) {
      setState(() {
      });
    }
}

  @override
  void initState() {
    super.initState();
    _getUserData();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    FirebaseFirestore.instance.collection("offers").doc(authProvider.uid).snapshots().listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (mounted) {
        setState(() {
        });}
          if (data?["userType"] == "Seeker") {
            showFilters = true;
          } else {
            showFilters = false;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    bool wide = false;
    width > 1000 ? wide = true : wide = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("MatchMe"),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SafeArea( child: 
        Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            ),
          ),

        child: Row(
          children: [
            if (wide)
              SizedBox(
                width: showFilters ? width * 0.26 : width * 0.32,
                child: Chats(),
              ),
            SizedBox(
              width: wide ? (showFilters ? width * 0.44 : width * 0.68) : width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (!wide)
                              Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 32.0,
                                  icon: const Icon(Icons.chat),
                                  tooltip: 'Chats',
                                  onPressed: () => Navigator.pushNamed(context, "/chats"),
                                ),
                              ),
                            if (showFilters && !wide)
                              Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 32.0,
                                  icon: const Icon(Icons.filter_alt),
                                  tooltip: 'Filters',
                                  onPressed: () => Navigator.pushNamed(context, "/user-filters"),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 32.0,
                                icon: const Icon(Icons.person),
                                tooltip: 'Settings',
                                onPressed: () => Navigator.pushNamed(context, "/user-settings"),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 32.0,
                                icon: const Icon(Icons.logout),
                                tooltip: 'Logout',
                                onPressed: () => authProvider.logOut(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Swiping(),
                ],
              ),
            ),
            if (wide && showFilters)
              SizedBox(
                width: width * 0.30,
                child: UserFilters(),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
