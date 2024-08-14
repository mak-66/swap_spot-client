import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:swap_spot/main.dart';
import 'package:swap_spot/user_loading.dart';
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
  Future<bool> _cardSwiped(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    if (direction.name == "right") {
      //if user liked the ware
      //NOTE: This casts the result of the dialog and so may introduce complications. Need to verify that the user selected something.
      List<Ware> selectedWares = await promptOffer() as List<Ware>;

      //selectedWares now contains the wares the user would trade for the selected market ware

      Ware selectedMarketWare = marketWares[previousIndex];
      // selectedMarketWare now contains the market ware the user swiped right on

      bool matchMade = false;
      bool found;
      for (Ware ware in selectedWares) {
        debugPrint(
            "\n----processing swipe----\nWareID: ${ware.ID}\nSelectedID: ${selectedMarketWare.ID}");
        //check to see if the match already exists
        found = false;
        for (Match match in matches) {
          if ((ware.ID == match.bidWare.ID && selectedMarketWare.ID == match.ownWare.ID) ||
              (ware.ID == match.ownWare.ID && selectedMarketWare.ID == match.bidWare.ID)) {
            matchMade = true; //marks that the entire swipe has had at least one match
            found = true;
            //the match already exists -> change match.reciprocated to true, update everything
            match.reciprocated = true;
            debugPrint("Found existing match: ${match.ID}");
            final body = <String, dynamic>{"Reciprocated": true}; //defines the message
            await pBase.collection("Potential_Matches").update(match.ID, body: body);
          }
        }
        if (found == false) {
          debugPrint("Not found, creating....");
          //Create potential match in pocketbase, then fetch its ID to create the local match object
          final body = <String, dynamic>{
            "Initiator": user.id,
            "Init_Ware": ware.ID,
            "Receiver": selectedMarketWare.ownerID,
            "Rec_Ware": selectedMarketWare.ID,
            "Reciprocated": false
          };
          //creates the match in pocketbase while also fetching the new recordmodel, allowing access of the ID
          await pBase.collection('Potential_Matches').create(body: body);

          //creates the local match object and adds it to the list
          // Match newMatch = Match(newMatchRecord.id, ware, selectedMarketWare);
          // matches.add(newMatch);
        }
      }
      loadMatches(pBase, user);
      if (matchMade) {
        //Shows simple alert that a match was made
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(content: Text("Matched!"), actions: <Widget>[
                TextButton(onPressed: Navigator.of(context).pop, child: Text("Ok!"))
              ]);
            });
      }
    }
    return true;
  }

  Future<List<Ware>?> promptOffer() async {
    return await showDialog<List<Ware>>(
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
  }
}
