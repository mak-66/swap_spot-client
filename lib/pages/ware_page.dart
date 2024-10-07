import 'package:flutter/material.dart';
import '../ware_containers.dart';

class WarePage extends StatelessWidget {
  //displays the wares currently put on the market
  const WarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wares'),
      ),
      body: Center(
          child: ListView.builder(
        //scrollable list containing tiles containing info on each ware
        itemCount: wares.length,
        itemBuilder: (context, index) {
          final ware = wares[index];
          return Padding(padding: const EdgeInsets.all(15), child: ware.returnListTile());
        },
      )),
    );
  }
}
