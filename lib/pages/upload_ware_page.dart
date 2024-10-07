import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../ware_containers.dart';
import '../user_loading.dart';

class UploadWare extends StatefulWidget {
  //The page displayed when a user tries to create a new ware posting
  const UploadWare({super.key, required this.pBase, required this.user});

  //local handles for the pocketbase and the user
  final PocketBase pBase;
  final RecordModel user;

  @override
  State<UploadWare> createState() => _UploadWareState();
}

class _UploadWareState extends State<UploadWare> {
  final myName = TextEditingController();
  final myDescription = TextEditingController();
  //TODO: Change from a URL to an actual image
  final myImageURL = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myName.dispose();
    myDescription.dispose();
    myImageURL.dispose();
    super.dispose();
  }

  Future<void> _createWare() async {
    //updates the database and the local wares list with the new Ware
    final wareInfo = <String, dynamic>{
      "Owner": widget.user.id,
      "Name": myName.text,
      "Description": myDescription.text,
      "Image_URL": myImageURL.text
    };
    debugPrint(wareInfo.toString());

    final wareRecord = await widget.pBase.collection('Market_Wares').create(body: wareInfo);

    //fetches the served decided id for the ware
    //TODO: look into deciding id s for the server? seems like a can of worms
    wares.add(Ware(wareRecord.getStringValue('id'), widget.user.getStringValue('name'),
        widget.user.id, myName.text, myDescription.text, wareRecord.created, myImageURL.text));

    loadWares(widget.pBase, widget.user);
  }

  @override
  Widget build(BuildContext context) {
    //prompts the user for information
    //TODO: add way to upload images for the ware
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload New Ware'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: myImageURL,
                decoration: const InputDecoration(hintText: "Image URL"),
                maxLines: 1,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: myName,
                decoration: const InputDecoration(hintText: "Name"),
                maxLines: 1,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: myDescription,
                decoration: const InputDecoration(hintText: "Description"),
              )),
          ElevatedButton(
            onPressed: () {
              _createWare();
              //gives feedback
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Ware Created'),
                      content: Text('The ware has been successfully created.'),
                    );
                  });

              //resets page
              myName.text = "";
              myDescription.text = "";
            },
            child: const Text('Submit'),
          ),
        ],
      )),
    );
  }
}