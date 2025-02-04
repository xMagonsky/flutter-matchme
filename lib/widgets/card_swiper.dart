import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_match/providers/auth_provider.dart';
import 'package:flat_match/utils/geopoint_range.dart';
import 'package:flat_match/widgets/match_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';

class Swiping extends StatefulWidget {
  const Swiping({super.key});

  @override
  State<Swiping> createState() => _SwipingState();
}

class _SwipingState extends State<Swiping> {
  final CardSwiperController _controller = CardSwiperController();
  late final StreamSubscription<DocumentSnapshot> _subscription;
  Map<String, dynamic>? _previousDataJson;

  List<Map<String, dynamic>> offers = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _subscription = FirebaseFirestore.instance.collection("offers").doc(authProvider.uid).snapshots().listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();

        if (data != null) {
          final Map<String, dynamic> newDataIgnoringAccepted = {...data};
          
          // Remove the 'accepted' field - dont want to update cards on change
          newDataIgnoringAccepted.remove('accepted');
          
          final currentDataJson = newDataIgnoringAccepted;

          if (_previousDataJson != currentDataJson) {
            offers = [];
            debugPrint("generating cards");
            _fetchCards();
            _previousDataJson = currentDataJson;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _subscription.cancel();
  }


  void _fetchCards() async {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final thisUserOfferDoc = await FirebaseFirestore.instance.collection("offers").doc(authProvider.uid).get();
    final thisUserOffer = thisUserOfferDoc.data();

    String lookingFor = (thisUserOffer?["userType"] == "Tenant") ? "Seeker" : "Tenant";

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection("offers")
      .where("userType", isEqualTo: lookingFor)
      .orderBy("uid")
      .limit(3);
    
    if (offers.isNotEmpty) {
        query = query.startAfter([offers.last["uid"]]);
    }

    if (thisUserOffer?["accepted"] != null) {  
      if (thisUserOffer?["accepted"].isNotEmpty) {
        query = query.where("uid", whereNotIn: thisUserOffer?["accepted"]);
      }
    }

    // add filters if a seeker
    if (thisUserOffer?["userType"] == "Seeker") {
      if (thisUserOffer?["petPreference"] == "Yes") {
        query = query.where("petPreference", isEqualTo: "Yes");
      }
      query = query.where("rentPrice", isLessThanOrEqualTo: thisUserOffer?["rentPriceLimit"]);

      final geo = geopointRange(thisUserOffer?["searchLocation"], thisUserOffer?["searchRange"]);
      query = query.where("apartamentLocation", isGreaterThan: geo["southWest"]);
      query = query.where("apartamentLocation", isLessThan: geo["northEast"]);
      print("hello");
    }
    

    QuerySnapshot<Map<String, dynamic>> proposedOffersQuery = await query.get();
    final proposedOffers = proposedOffersQuery.docs.map((doc) => doc.data()).toList();

    if(mounted) {
      setState(() {
      offers.addAll(proposedOffers);
      _isFetching = false;
    });

    //
    // DEBUG
    //
    final t1 = await FirebaseFirestore.instance
        .collection("offers")
        .where("userType", isEqualTo: lookingFor)
        .get();
    final tt = t1.docs.map((doc) => doc.data()).toList();
    debugPrint("all avalible offers: ${tt.length}");
    debugPrint("now proposed offers: ${proposedOffers.length}");
    debugPrint("now avalible offers: ${offers.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            SizedBox(
              height: 500,
              width: 400,
              child: (offers.isNotEmpty)
                ? CardSwiper(
                  controller: _controller,
                  cardsCount: offers.length,
                  isLoop: false,
                  backCardOffset: const Offset(0, 35),
                  numberOfCardsDisplayed: (offers.length == 1) ? 1 : 2,
                  allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true, up: true),
                  onSwipe: _onSwipe,
                  // onUndo: _onUndo,
                  cardBuilder: (
                    context, 
                    index, 
                    horizontalThresholdPercentage, 
                    verticalThresholdPercentage
                  ) => SwipingCard(offerData: offers[index], openDetailsCallback: _openDetailsPage,),
                ) 
                : Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "swipeLeft",
                    onPressed: () => _controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    heroTag: "swipeRight",
                    onPressed: () =>
                        _controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
          ],
        );
  }

  void _openDetailsPage(Map<String, dynamic> userData) {
    Navigator.pushNamed(context, "/offer-details", arguments: userData);
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) { 
    if (direction == CardSwiperDirection.top) {
      Future.delayed(const Duration(microseconds: 50), () {
        _controller.undo();
      });
      _openDetailsPage(offers[previousIndex]);
    }

    if (direction == CardSwiperDirection.right) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      DocumentReference docRef = FirebaseFirestore.instance.collection("offers").doc(authProvider.uid);

      // add user's accepted list
      docRef.set({
        "accepted": FieldValue.arrayUnion([offers[previousIndex]["uid"]]),
      }, SetOptions(merge: true));

      // check for a match
      Future(() async {
        final thisOfferDoc = await FirebaseFirestore.instance.collection("offers").doc(offers[previousIndex]["uid"]).get();
        final thisOffer = thisOfferDoc.data();
        if (thisOffer != null && thisOffer.containsKey("accepted")) {
          List acceptedList = thisOffer["accepted"];
          if (acceptedList.contains(authProvider.uid)) {
            // its a match!
            if(mounted) {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: MatchPopup(),
                ),
              );
            }
            FirebaseFirestore.instance.collection("users").doc(authProvider.uid).set({
              "chats": FieldValue.arrayUnion([offers[previousIndex]["uid"]]),
            }, SetOptions(merge: true));
            FirebaseFirestore.instance.collection("users").doc(offers[previousIndex]["uid"]).set({
              "chats": FieldValue.arrayUnion([authProvider.uid]),
            }, SetOptions(merge: true));
          }
        }
      });
    }

    if (currentIndex == null || currentIndex == offers.length - 1) {
      _fetchCards();
    }
    return true;
  }

}


class SwipingCard extends StatelessWidget {
  const SwipingCard({required this.offerData, required this.openDetailsCallback, super.key});

  final Map<String, dynamic> offerData;

  final Function openDetailsCallback;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openDetailsCallback(offerData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(((offerData["userType"] == "Tenant") ? offerData["apartamentImage"] : offerData["image"]) ?? "https://magonsky.scay.net/img/no-img.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Optional overlay or gradient
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ (offerData["userType"] == "Tenant") ? offerData["apartamentAddress"] : offerData["name"] + " " +  offerData["surname"] }",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
  
}
