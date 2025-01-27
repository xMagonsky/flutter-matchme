import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flat_match/providers/auth_provider.dart';


class OfferDetails extends StatelessWidget {
  const OfferDetails({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page"), automaticallyImplyLeading: false),
      body: Center(
        child: Text("hello offer"),
        ),
    );
  }
}