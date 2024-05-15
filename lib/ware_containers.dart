import 'package:flutter/material.dart';

final wares = <Ware>[
  Ware("1", "1des"),
  Ware("2", "2des"),
  Ware("3", "3des"),
  Ware("4", "4des"),
  Ware("5", "5des")
];

final marketWares = <Ware>[
  Ware("1m", "1mdes"),
  Ware("2m", "2mdes"),
  Ware("3m", "3mdes"),
  Ware("4m", "4mdes"),
  Ware("5m", "5mdes")
];

final neighborMatches = <Match>[];

final matches = <Match>[
  Match("Neighbor 1", Ware("offer1", "offer1 description"), wares[0]),
  Match("Neighbor 2", Ware("offer2", "offer2 description"), wares[3]),
  Match("Neighbor 3", Ware("offer3", "offer3 description"), wares[4]),
];

class Ware {
  //defines the Ware class, a class that symbolizes an object for trade
  //TODO: include way to contain images
  late String name;
  late String description;

  Ware(this.name, this.description);

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
    );
  }

  Container returnContainer() {
    //returns a container with the information of the ware
    //for use with the swipable market
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color.fromARGB(255, 129, 129, 129),
          border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(name), Text(description)],
      ),
    );
  }
}

class Match {
  //defines the Match class, containing a potential trade between two users and a ware
  String bidder = ""; //the name of the user who "swiped right"
  String owner = "";
  late Ware bidWare;
  late Ware ownWare;

  Match(this.bidder, this.bidWare, this.ownWare);
}
