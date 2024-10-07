import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../ware_containers.dart';

// ignore: must_be_immutable
class TradePage extends StatelessWidget {
  //Page containing potential trades (matches)
  // const TradePage({super.key});
  TradePage({super.key, required this.pBase, required this.user});

  final PocketBase pBase;
  final RecordModel user;

  //declares the current match handle outside of build to allow access by _displayTradeProfile
  Match match = reciprocatedMatches[0];

  late BuildContext
      tradePageContext; //handles the context in order for _displayTradeProfile to work properly in displaying an alert dialog

  //creates a list of reciprocated matches from the matches list
  @override
  Widget build(BuildContext context) {
    tradePageContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Openings'),
      ),
      body: Center(
          child: ListView.builder(
        //scrollable list containing tiles containing info on each ware
        itemCount: reciprocatedMatches.length,
        itemBuilder: (context, index) {
          match = reciprocatedMatches[index];
          return _returnTradeCard(match);
        },
      )),
    );
  }

  Card _returnTradeCard(Match match) {
    //returns the trade card of a particular match to be displayed on the trade page
    //Might consider changing this to a method for the match object in ware_containers
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 100, height: 100, child: Image.network(match.bidWare.imageURL)),
          const SizedBox(width: 10), //spacing
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(match.bidder),
              Text(style: const TextStyle(fontWeight: FontWeight.bold), match.bidWare.name)
            ],
          ),
          const SizedBox(width: 10), //spacing
          ElevatedButton(onPressed: _displayTradeProfile, child: const Icon(Icons.person_search)),
          const SizedBox(width: 10), //spacing
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(match.owner),
              Text(style: const TextStyle(fontWeight: FontWeight.bold), match.ownWare.name)
            ],
          ),
          const SizedBox(width: 10), //spacing
          SizedBox(width: 100, height: 100, child: Image.network(match.ownWare.imageURL)),
        ],
      ),
    );
  }

  Future<void> _displayTradeProfile() async {
    //async function to display the trade profile of the selected match.
    //determines who the other party's id is
    String traderID;
    if (match.ownWare.ownerID == user.id) {
      traderID = match.bidWare.ownerID;
    } else {
      traderID = match.ownWare.ownerID;
    }
    //fetch other party's info from the server
    debugPrint("Fetching info on user with ID $traderID");
    RecordModel trader = await pBase.collection('users').getOne(traderID);
    debugPrint(trader.toString());

    showDialog(
      context: tradePageContext,
      builder: (BuildContext tradePageContext) => AlertDialog(
        title: Text("${trader.getStringValue("username")}'s trade profile"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Contact: ${trader.getStringValue("Contact")}"),
              Text("Contact Platform: ${trader.getStringValue("Contact_Platform")}"),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Text(trader.getStringValue("Bio"))
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(tradePageContext), child: const Text("Ok"))
        ],
      ),
    );
  }
}
