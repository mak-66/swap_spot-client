import 'package:flutter/material.dart';
import 'ware_containers.dart';

class TradePage extends StatelessWidget {
  //Page containing potential trades (matches)
  // const TradePage({super.key});
  const TradePage({super.key});

  //creates a list of reciprocated matches from the matches list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Openings'),
      ),
      body: Center(
          child: ListView.builder(
        //scrollable list containing tiles containing info on each ware
        itemCount: reciprocatedMatches.length,
        itemBuilder: (context, index) {
          final Match match = reciprocatedMatches[index];
          return Padding(padding: const EdgeInsets.all(15), child: match.returnTile());
        },
      )),
    );
  }
}
