import 'package:flutter/material.dart';

var errorImageURL =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsuAz91VMk31tS5FlfEUghtFgHgZlMjL1lnIztR7tM9Q&s";

final wares = <Ware>[
  Ware("demo", "1", "1des", errorImageURL),
  Ware("demo", "2", "2des", errorImageURL),
  Ware("demo", "3", "3des", errorImageURL),
  Ware("demo", "4", "4des", errorImageURL),
  Ware("demo", "5", "5des", errorImageURL)
];

final marketWares = <Ware>[
  Ware("trader1", "1m", "1mdes", errorImageURL),
  Ware("trader1", "2m", "2mdes", errorImageURL),
  Ware("trader1", "3m", "3mdes", errorImageURL),
  Ware("trader1", "4m", "4mdes", errorImageURL),
  Ware("trader1", "5m", "5mdes", errorImageURL)
];

final neighborMatches = <Match>[];

final matches = <Match>[
  Match(Ware("Neighbor 1", "offer1", "offer1 description", errorImageURL), wares[0]),
  Match(Ware("Neighbor 2", "offer2", "offer2 description", errorImageURL), wares[3]),
  Match(Ware("Neighbor 3", "offer3", "offer3 description", errorImageURL), wares[4]),
];

class Ware {
  //defines the Ware class, a class that symbolizes an object for trade
  //TODO: include way to contain images (Currently only the link)
  late String ownerName;
  late String name;
  late String description;
  late String imageURL;

  Ware(this.ownerName, this.name, this.description, this.imageURL);

  ListTile returnListTile() {
    //returns a ListTile containing the info of the Ware
    //TODO: Integrate image display
    return ListTile(
      //tile definition
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      tileColor: const Color.fromARGB(255, 213, 209, 209),
      title: Text(name),
      subtitle: Text(description),
      trailing: SizedBox(height: 20, width: 20, child: Image.network(imageURL)),
    );
  }

  Container returnContainer() {
    //returns a container with the information of the ware
    //for use with the swipable market
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: const Color.fromARGB(255, 129, 129, 129),
          border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name),
          Text(description),
          SizedBox(width: 60, height: 60, child: Image.network(imageURL))
        ],
      ),
    );
  }
}

class Match {
  //defines the Match class, containing a potential trade between two users and a ware

  bool signed = false; // both parties "swiped right"

  late String bidder; //the name of the user who "swiped right" first
  late String owner;
  late Ware bidWare;
  late Ware ownWare;

  Match(this.bidWare, this.ownWare) {
    bidder = bidWare.ownerName;
    owner = ownWare.ownerName;
  }

  ListTile returnTile() {
    return ListTile(
      //tile definition
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      //tileColor: Color.fromARGB(255, 91, 89, 89),
      //title: Text("Tradeoffer $index"),
      leading: Column(
        children: [
          Text(bidder),
          Text(style: const TextStyle(fontWeight: FontWeight.bold), bidWare.name)
        ],
      ),
      trailing: Column(
        children: [
          Text(owner),
          Text(style: const TextStyle(fontWeight: FontWeight.bold), ownWare.name)
        ],
      ),
    );
  }
}
