import 'package:flat_match/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Chats page")),
      body: StreamBuilder<DocumentSnapshot>(
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

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/chat", arguments: {"name": chats[index]}),
                  child: Text("Chat ID: ${chats[index]}"),
                )
              );
            },
          );
        },
      ),
    );
  }
}