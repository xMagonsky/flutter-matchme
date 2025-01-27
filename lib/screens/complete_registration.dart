import 'package:flutter/material.dart';


class CompleteRegistration extends StatelessWidget {
  const CompleteRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete registration"), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          children: [
            Text("Complete registration!"),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/");
              },
              child: const Text("Back?"),
            ),
          ],)
      ),
    );
  }
}