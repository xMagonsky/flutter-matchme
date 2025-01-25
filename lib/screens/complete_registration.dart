import 'package:flutter/material.dart';


class CompleteRegistration extends StatelessWidget {
  final dynamic updateUserCallback;

  const CompleteRegistration({super.key, required this.updateUserCallback});

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
                updateUserCallback();
                Navigator.pop(context);
              },
              child: const Text("Back?"),
            ),
          ],)
      ),
    );
  }
}