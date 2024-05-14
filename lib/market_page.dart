import 'dart:html';

import 'package:flutter/material.dart';
import 'ware_containers.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final CardSwiperController cardController = CardSwiperController();

  List<Container> cards = marketWares.map((mWare) => mWare.returnContainer()).toList();
  // List<Container> cards = <Container>[
  //   marketWares[0].returnContainer(),
  //   marketWares[1].returnContainer(),
  //   marketWares[2].returnContainer(),
  //   marketWares[3].returnContainer(),
  //   marketWares[4].returnContainer(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Market'),
        ),
        body: Flexible(
          child: CardSwiper(
            controller: cardController,
            cardsCount: cards.length,
            cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
          ),
        ));
  }
}
