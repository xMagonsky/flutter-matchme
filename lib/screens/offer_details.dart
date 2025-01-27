import 'package:flutter/material.dart';


class OfferDetails extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const OfferDetails({required this.userInfo, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details page")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
            Text(userInfo.toString()),
          ],
        ),
      )
    );
  }
}