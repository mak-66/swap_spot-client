import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'ware_containers.dart';

Future<RecordModel> getUser(PocketBase pBase, String userID) async {
  //gets the user recordModel from the server and also calls loadUser, fetching all wares,
  //matches, and market wares available to the user
  try {
    RecordModel user = await pBase.collection('users').getOne(userID);
    //runs list of three loading functions, waiting for the slowest to complete (THIS IS AMAZING)
    await Future.wait([
      loadMatches(pBase, user),
      loadWares(pBase, user),
      loadMarket(pBase, user),
    ]);
    debugPrint(user.toString());
    return user;
  } catch (e) {
    debugPrint('Error fetching user: \n$e');
    return RecordModel();
  }
}

Future<void> loadWares(PocketBase pBase, RecordModel user) async {
  //sets the local wares list to reflect what is on pBase
  wares.clear();
  //fetch a record containing all user owned wares
  try {
    final wareRecords =
        await pBase.collection('Market_Wares').getFullList(filter: 'Owner = "${user.id}"');
    //adds the wares into the wares list
    for (var curWare in wareRecords) {
      wares.add(Ware(user.getStringValue('name'), user.id, curWare.getStringValue('Name'),
          curWare.getStringValue('Description'), curWare.getStringValue('Image_URL')));
    }
  } catch (e) {
    debugPrint("Error fetching user wares: $e");
  }
}

Future<void> loadMarket(PocketBase pBase, RecordModel user) async {
  //loads the open market of wares
  //TODO: make filter based on user parties
  marketWares.clear();
  try {
    final marketWareRecords =
        //fetches all wares not owned by user, TODO: make this filter based on party
        await pBase.collection('Market_Wares').getFullList(filter: 'Owner != "${user.id}"');
    //adds the wares into the wares list
    // debugPrint("PRINTING MARKET:::\n ${marketWareRecords.toString()}");
    for (var curWare in marketWareRecords) {
      marketWares.add(Ware(
          "Open Market", //filler for owner name
          curWare.getStringValue('Owner'), //owner id
          curWare.getStringValue('Name'), //ware name
          curWare.getStringValue('Description'),
          curWare.getStringValue('Image_URL')));
    }
  } catch (e) {
    debugPrint("Error fetching market wares: $e");
  }
}

Future<void> loadMatches(PocketBase pBase, RecordModel user) async {
  matches.clear();
  try {
    final matchRecords =
        //fetches all RECIPROCATED matches involving the user
        await pBase.collection('Potential_Matches').getFullList(
            expand: 'Init_Ware, Rec_Ware',
            filter: 'Reciprocated = true && (Initiator = "${user.id}" || Receiver = "${user.id}")');

    // debugPrint("PRINTING MATCHES:::\n ${matchRecords.toString()}\n");
    // debugPrint("Init_Ware: ${matchRecords.first.expand['Init_Ware']}\n");
    // debugPrint(
    //     "Initer: ${matchRecords.first.getStringValue('Initiator')} or ${matchRecords.first.expand['Init_Ware']?.last.getStringValue('Owner')}");
    // debugPrint("Rec_Ware: ${matchRecords.first.expand['Rec_Ware']}");

    if (matchRecords.isNotEmpty) {
      //TODO: make for loop concurrently request from the server for optimization
      //represents the wares belonging to the initiator and receiver
      Ware initWare; //the ware being created
      var initHandle; //the recordmodel of the ware as stored by the server
      Ware recWare;
      var recHandle;

      RecordModel traderInfo; //info of the non-current-user in the match

      String initName; //name of initiator
      String recName; //name of receiver
      for (var curMatch in matchRecords) {
        //get handles onto the ware information
        initHandle = curMatch.expand['Init_Ware']?.first;
        recHandle = curMatch.expand['Rec_Ware']?.first;
        // debugPrint('initHandle: $initHandle is of type ${initHandle.runtimeType}');
        // debugPrint('recHandle: $recHandle is of type ${initHandle.runtimeType}');
        //gets the info of the other member("trader") of the match
        if (curMatch.getStringValue('Initiator') == user.id) {
          //if the user was the initiator of the trade, get the profile of the receiver
          traderInfo = await pBase.collection('users').getOne(curMatch.getStringValue('Receiver'));
          //sets names accordingly
          initName = user.getStringValue('name');
          recName = traderInfo.getStringValue('Name');
        } else {
          //get the profile of the initiator
          traderInfo = await pBase.collection('users').getOne(curMatch.getStringValue('Initiator'));
          //set names accordingly
          initName = traderInfo.getStringValue('Name');
          recName = user.getStringValue('name');
        }
        // debugPrint("\nTraderInfo: $traderInfo");
        //define the initWare based on info from the initHandle
        initWare = Ware(
            initName,
            initHandle.getStringValue('Owner'),
            initHandle.getStringValue('Name'),
            initHandle.getStringValue('Description'),
            initHandle.getStringValue('Image_URL'));
        //define the recWare based on recHandle
        recWare = Ware(recName, recHandle.getStringValue('Owner'), recHandle.getStringValue('Name'),
            recHandle.getStringValue('Description'), recHandle.getStringValue('Image_URL'));
        matches.add(Match(initWare, recWare));
      }
    }
  } catch (e) {
    debugPrint("Error fetching matches: $e");
  }
}
