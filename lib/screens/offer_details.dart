import 'package:flat_match/widgets/apartament_info.dart';
import 'package:flat_match/widgets/person_info.dart';
import 'package:flutter/material.dart';


class OfferDetails extends StatelessWidget {
  final Map<String, dynamic> userData;

  const OfferDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final String userType = userData['userType'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
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
        child: Center( 
          child: userType == 'Seeker'
            ? PersonInfo(userData: userData)
            : PageView(
              children: [
                ApartmentInfo(userData: userData),
                PersonInfo(userData: userData),
              ],
            )
        )
      ) 
    );
  }
}
