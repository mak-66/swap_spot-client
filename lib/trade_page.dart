import 'package:flutter/material.dart';
import 'ware_containers.dart';

class TradePage extends StatelessWidget {
  //Page containing potential trades (matches)
  // const TradePage({super.key});
  const TradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trades'),
      ),
      body: Center(
          child: ListView.builder(
        //scrollable list containing tiles containing info on each ware
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final Match match = matches[index];
          return Padding(
            padding: const EdgeInsets.all(15),
            child: ListTile(
              //tile definition
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              //tileColor: Color.fromARGB(255, 91, 89, 89),
              //title: Text("Tradeoffer $index"),
              leading: Column(
                children: [Text(match.bidWare.name), Text(match.bidWare.description)],
              ),
              trailing: Column(
                children: [Text(match.ownWare.name), Text(match.ownWare.description)],
              ),
              subtitle: Text("Bidder: ${match.bidder}"),
            ),
          );
        },
      )),
    );
  }
}
