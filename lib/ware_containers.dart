import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

var errorImageURL =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnF5Ip7CNRSfeynWCl1uNBFhWtA_cKW-dNrQ&s";

List<Ware> wares = <Ware>[];
List<Match> matches = <Match>[];
List<Ware> marketWares = <Ware>[];

class Ware {
  //defines the Ware class, a class that symbolizes an object for trade
  //TODO: include way to contain images (Currently only the link)
  late String ownerName;
  late String ownerID;
  late String name;
  late String description;
  late String imageURL;

  Ware(this.ownerName, this.ownerID, this.name, this.description, this.imageURL);

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
      trailing: SizedBox(height: 60, width: 60, child: Image.network(imageURL)),
    );
  }

  Container returnContainer() {
    //returns a container with the information of the ware
    //for use with the swipable market
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: const Color.fromARGB(255, 212, 210, 210),
          border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(ownerID),
          Text(name),
          Text(description),
          SizedBox(width: 100, height: 100, child: Image.network(imageURL))
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
