import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'ware_containers.dart';

Future<RecordModel> getUser(PocketBase pBase, String userID) async {
  //gets the user recordModel from the server and also calls loadUser, fetching all wares,
  //matches, and market wares available to the user
  try {
    final Stopwatch getUserStopwatch = Stopwatch()..start();
    RecordModel user = await pBase.collection('users').getOne(userID);
    //runs list of three loading functions, waiting for the slowest to complete (THIS IS AMAZING)
    await Future.wait([
      //TODO: fetch market IDs user is member of function
      loadMatches(pBase, user),
      loadWares(pBase, user),
      loadMarket(pBase, user),
    ]);
    //TODO: add potential matches into market wares as well
    debugPrint("Finished loading from server in ${getUserStopwatch.elapsedMilliseconds}ms.");
    getUserStopwatch.stop();
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
  final Stopwatch loadWaresStopwatch = Stopwatch()..start();
  Ware newWare;
  //fetch a record containing all user owned wares
  try {
    final wareRecords =
        await pBase.collection('Market_Wares').getFullList(filter: 'Owner = "${user.id}"');

    // debugPrint("- - - - Fetching Wares - - - -\n");
    //adds the wares into the wares list
    for (var curWare in wareRecords) {
      //doing assignment shenanigans to print out the newWare being added
      newWare = Ware(
          curWare.id,
          user.getStringValue('name'),
          user.id,
          curWare.getStringValue('Name'),
          curWare.getStringValue('Description'),
          curWare.created,
          curWare.getStringValue('Image_URL'));
      wares.add(newWare);
      // newWare.debugPrintSelf();
    }
    debugPrint("Loaded user wares in ${loadWaresStopwatch.elapsedMilliseconds}ms.");
    loadWaresStopwatch.stop();
    return;
  } catch (e) {
    debugPrint("Error fetching user wares: $e");
  }
}

Future<void> loadMarket(PocketBase pBase, RecordModel user) async {
  //loads the open market of wares
  //TODO: make filter based on user parties
  marketWares.clear();
  final Stopwatch loadMarketStopwatch = Stopwatch()..start();
  Ware newMarketWare;
  try {
    final marketWareRecords =
        //fetches all wares not owned by user, TODO: make this filter based on party
        await pBase.collection('Market_Wares').getFullList(filter: 'Owner != "${user.id}"');
    //adds the wares into the wares list
    // debugPrint("- - - - Fetching Market - - - -\n");
    for (var curWare in marketWareRecords) {
      //doing assignment shenanigans to print out the newMarketWare being added
      newMarketWare = Ware(
          curWare.id,
          "Open Market", //filler for owner name
          curWare.getStringValue('Owner'), //owner id
          curWare.getStringValue('Name'), //ware name
          curWare.getStringValue('Description'),
          curWare.created,
          curWare.getStringValue('Image_URL'));
      marketWares.add(newMarketWare);
      // newMarketWare.debugPrintSelf();
    }
    debugPrint("Loaded market in ${loadMarketStopwatch.elapsedMilliseconds}ms.");
    loadMarketStopwatch.stop();
    return;
  } catch (e) {
    debugPrint("Error fetching market wares: $e");
  }
}

Future<void> loadMatches(PocketBase pBase, RecordModel user) async {
  reciprocatedMatches.clear();
  matches.clear();
  try {
    final Stopwatch loadMatchesStopwatch = Stopwatch()..start();
    final matchRecords =
        //fetches all RECIPROCATED matches involving the user
        await pBase.collection('Potential_Matches').getFullList(
            expand: 'Init_Ware, Rec_Ware',
            filter: '(Initiator = "${user.id}" || Receiver = "${user.id}")');

    if (matchRecords.isNotEmpty) {
      //Parallelized to take only as long as the longest match fetch
      matches = await Future.wait([
        for (int i = 0; i < matchRecords.length; i++)
          _futureFetchMatch(pBase, user, matchRecords[i])
      ]);
    }
    reciprocatedMatches = matches.where((x) => x.reciprocated).toList();
    debugPrint("Loaded matches in ${loadMatchesStopwatch.elapsedMilliseconds}ms.");
    loadMatchesStopwatch.stop();
    return;
    // for (Match x in matches) {
    //   x.debugPrintSelf();
    // }
  } catch (e) {
    debugPrint("Error fetching matches: $e");
  }
}

Future<Match> _futureFetchMatch(PocketBase pBase, RecordModel user, RecordModel curMatch) async {
  //represents the wares belonging to the initiator and receiver -> create the local match object
  Ware initWare; //the ware being created
  RecordModel? initHandle; //the recordmodel of the ware as stored by the server
  Ware recWare;
  RecordModel? recHandle;

  RecordModel traderInfo; //info of the non-current-user in the match

  Match newMatch;

  String initName; //name of initiator
  String recName; //name of receiver

  //get handles onto the ware information
  initHandle = curMatch.expand['Init_Ware']?.first;
  recHandle = curMatch.expand['Rec_Ware']?.first;
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
  //define the initWare based on info from the initHandle
  if (initHandle != null && recHandle != null) {
    initWare = Ware(
        initHandle.id,
        initName,
        initHandle.getStringValue('Owner'),
        initHandle.getStringValue('Name'),
        initHandle.getStringValue('Description'),
        initHandle.created,
        initHandle.getStringValue('Image_URL'));
    //define the recWare based on recHandle
    recWare = Ware(
        recHandle.id,
        recName,
        recHandle.getStringValue('Owner'),
        recHandle.getStringValue('Name'),
        recHandle.getStringValue('Description'),
        recHandle.created,
        recHandle.getStringValue('Image_URL'));

    newMatch = Match(curMatch.id, initWare, recWare);
    if (curMatch.getBoolValue('Reciprocated')) {
      // debugPrint("Creating reciprocated match with ID: ${curMatch.id}\n");
      // newMatch.debugPrintSelf();
      newMatch.reciprocated = true;
    } else {
      // debugPrint("Creating pending match with ID: ${curMatch.id}\n");
    }
    return newMatch;
  } else {
    // one of the handles is null
    throw 'user_loading.dart -> _futureFetchMatches(): initHandle or recHandle was null';
  }
}
