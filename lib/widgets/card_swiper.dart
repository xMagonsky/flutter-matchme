import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class Swiping extends StatefulWidget {
  const Swiping({super.key});

  @override
  State<Swiping> createState() => _SwipingState();
}

class _SwipingState extends State<Swiping> {
  final List<String> _images = [
    'https://picsum.photos/seed/picsum1/400/600',
    'https://picsum.photos/seed/picsum2/400/600',
    'https://picsum.photos/seed/picsum3/400/600',
    'https://picsum.photos/seed/picsum4/400/600',
    'https://picsum.photos/seed/picsum5/400/600',
  ];

  final CardSwiperController _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            SizedBox(
                height: 500,
                width: 400,
                child: CardSwiper(
                  controller: _controller,
                  cardsCount: _images.length,
                  isLoop: true,
                  backCardOffset: const Offset(0, 35),
                  numberOfCardsDisplayed: 2,
                  allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                  onSwipe: _onSwipe,
                  onUndo: _onUndo,
                  cardBuilder: (
                    context, 
                    index, 
                    horizontalThresholdPercentage, 
                    verticalThresholdPercentage
                  ) => SwipingCard(imageUrl: _images[index],),
                ),
              
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

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}


class SwipingCard extends StatelessWidget {
  const SwipingCard({required this.imageUrl, super.key});

  final String imageUrl;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("aaaqaaaaa"),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
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
                'Card Example',
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
