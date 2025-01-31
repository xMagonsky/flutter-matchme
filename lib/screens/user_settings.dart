import 'package:flat_match/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_match/widgets/update_user_data_form.dart';
import 'package:provider/provider.dart';


class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  void onSubmit(Map<String, dynamic> userData) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    userData["uid"] = authProvider.uid;
    await FirebaseFirestore.instance.collection("users").doc(authProvider.uid).update({
      "name": userData["name"],
      "surname": userData["surname"],
    });
    await FirebaseFirestore.instance.collection("offers").doc(authProvider.uid).set(userData);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Complete!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: UpdateUserDataForm(onSubmit: (data) => onSubmit(data)),
        ),
      ),
    );
  }
}
