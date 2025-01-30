import 'package:flat_match/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_match/widgets/update_user_data_form.dart';
import 'package:provider/provider.dart';


class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({super.key});

  @override
  State<CompleteRegistration> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {

  void onSubmit(Map<String, dynamic> userData) async {
    debugPrint(userData.toString());

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    userData["uid"] = authProvider.uid;
    DocumentReference docRef = await FirebaseFirestore.instance.collection('offers').add(userData);
    
    FirebaseFirestore.instance.collection('users').doc(authProvider.uid).update({"offerID": docRef.id});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Complete!')),
      );
    
      Navigator.pushReplacementNamed(context, '/');
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
