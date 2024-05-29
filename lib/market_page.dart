import 'package:flutter/material.dart';
import 'ware_containers.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final CardSwiperController cardController = CardSwiperController();

  List<Container> cards = marketWares.map((mWare) => mWare.returnContainer()).toList();
  // List<Container> cards = <Container>[
  //   marketWares[0].returnContainer(),
  //   marketWares[1].returnContainer(),
  //   marketWares[2].returnContainer(),
  //   marketWares[3].returnContainer(),
  //   marketWares[4].returnContainer(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Market'),
        ),
        body: Column(
          children: [
            Flexible(
              //Contains a cardswiper, a framework for swipable, tinder-like cards
              child: CardSwiper(
                controller: cardController,
                allowedSwipeDirection: const AllowedSwipeDirection.only(right: true, left: true),
                cardsCount: cards.length,
                onSwipe: _cardSwiped,
                isLoop: false,
                cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
              ),
            ),
          ],
        ));
  }

  //I hate dart function convention
  Future<bool> _cardSwiped(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    if (direction.name == "right") {
      //if user liked the ware
      Ware? selectedWare = await showDialog<Ware>(
          //pop up a dialog prompting the user for what they would offer
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select a Ware to Offer'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: wares.map((ware) {
                    return ListTile(
                      title: Text(ware.name),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onTap: () {
                        Navigator.pop(context, ware); // Return the selected ware
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          });
      //Create a check to see if the match already exists
      //exists -> move to messaging process, else create "pending" match
      debugPrint(
          'Match created: (${marketWares[previousIndex].ownerName}, ${marketWares[previousIndex].name}) + (${selectedWare?.ownerName}, ${selectedWare?.name})');
      //TODO:for testing purposes,
      return true;
    }
    return true;
  }
}
