import 'package:flutter/material.dart';
import 'ware_containers.dart';

class TradePage extends StatelessWidget {
  //Page containing potential trades (matches)
  // const TradePage({super.key});
  const TradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Openings'),
      ),
      body: Center(
          child: ListView.builder(
        //scrollable list containing tiles containing info on each ware
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final Match match = matches[index];
          return Padding(padding: const EdgeInsets.all(15), child: match.returnTile());
        },
      )),
    );
  }
}
