import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'ware_containers.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key, required this.pBase, required this.user});

  final PocketBase pBase;
  final RecordModel user;

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final CardSwiperController cardController = CardSwiperController();

  //defines the cards as the marketwares interspersed with the potential matches
  List<Container> cards = marketWares.map((mWare) => mWare.returnContainer()).toList();

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
  //TODO: make reactive to matches and create them if necessary
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
      List<Ware>? selectedWares = await showDialog<List<Ware>>(
          //pop up a dialog prompting the user for what wares they would offer
          context: context,
          builder: (BuildContext context) {
            List<Ware> tempSelectedWares = [];
            return StatefulBuilder(
              //builds the checkbox list to choose from personal wares
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text('Select a Ware to Offer'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: wares.map((ware) {
                        return CheckboxListTile(
                          title: Text(ware.name),
                          value: tempSelectedWares.contains(ware),
                          onChanged: (bool? isSelected) {
                            setState(() {
                              if (isSelected == true) {
                                tempSelectedWares.add(ware);
                              } else {
                                tempSelectedWares.remove(ware);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context, tempSelectedWares); // Return the selected wares
                      },
                    ),
                  ],
                );
              },
            );
          });

      //selectedWares now contains the wares the user would trade for the selected market ware

      Ware selectedMarketWare = marketWares[previousIndex];
      // selectedMarketWare now contains the market ware the user swiped right on

      if (selectedWares != null) {
        bool found = false;
        for (Ware ware in selectedWares) {
          //check to see if the match already exists
          for (Match match in matches) {
            if ((ware == match.bidWare && selectedMarketWare == match.ownWare) ||
                (ware == match.ownWare && selectedMarketWare == match.bidWare)) {
              found = true;
              //the match already exists -> change match.reciprocated to true, update everything
            }
          }
          if (found == false) {
            //match does not exist yet -> create new potential match
          }
          found = false;
        }
      }

      //exists -> move to messaging process, else create "pending" match

      //TODO:for testing purposes,
      return true;
    }
    return true;
  }
}
