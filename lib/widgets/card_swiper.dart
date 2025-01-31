import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_match/providers/auth_provider.dart';
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

  List<Map<String, dynamic>> offers = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    QuerySnapshot<Map<String, dynamic>> proposedOffersQuery;
    if (offers.isNotEmpty) {
      proposedOffersQuery = await FirebaseFirestore.instance
        .collection("offers")
        .where("userType", isEqualTo: lookingFor)
        .orderBy("uid")
        .startAfter([offers.last["uid"]])
        .limit(3)
        .get();
    } else {
      proposedOffersQuery = await FirebaseFirestore.instance
        .collection("offers")
        .where("userType", isEqualTo: lookingFor)
        .orderBy("uid")
        .limit(3)
        .get();
    }
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
              child: (offers.length >= 2)
                ? CardSwiper(
                  controller: _controller,
                  cardsCount: offers.length,
                  isLoop: false,
                  backCardOffset: const Offset(0, 35),
                  numberOfCardsDisplayed: 2,
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

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {



    if (direction == CardSwiperDirection.top) {
      Future.delayed(const Duration(microseconds: 50), () {
        _controller.undo();
      });
      _openDetailsPage(offers[previousIndex]);
    }

    if (currentIndex == null || currentIndex == offers.length - 1) {
      _fetchCards();
    }

    // debugPrint(
    //   'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    // );
    return true;
  }

  // bool _onUndo(
  //   int? previousIndex,
  //   int currentIndex,
  //   CardSwiperDirection direction,
  // ) {
  //   debugPrint(
  //     'The card $currentIndex was undod from the ${direction.name}',
  //   );
  //   return true;
  // }
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
            image: NetworkImage("https://picsum.photos/seed/new_picsum0/400/600"),
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
                "${offerData["uid"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
  
}
