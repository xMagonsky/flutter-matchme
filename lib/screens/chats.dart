import 'package:flat_match/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters"),
        backgroundColor: Colors.purple[400],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Chats(),
      ),
    );
  }
}

class Chats extends StatelessWidget {
  const Chats({super.key});


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(authProvider.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
          return Center(child: Text("No chat data available"));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> chats = userData["chats"] ?? [];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white.withOpacity(0.9),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Your chats",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  (chats.isNotEmpty)
                  ? Expanded(
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {                        
                        return ListTile(
                          title: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, "/chat", arguments: {"name": "Chat"}),
                            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance.collection("users").doc(chats[index]).get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final data = snapshot.data!.data();
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // Choose your desired border color
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    "${data?["name"]} ${data?["surname"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0, // Adjust the font size as needed
                                    ),
                                  ),
                                );
                              }
                            )
                            ),
                        );
                      },
                    ),
                  )
                  : Text("You don't have any chats")
                ],
              ),              
            ),
          ),
        );
      },
    );
  }
}