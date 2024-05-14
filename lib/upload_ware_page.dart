import 'package:flutter/material.dart';
import 'ware_containers.dart';

class UploadWare extends StatefulWidget {
  //The page displayed when a user tries to create a new ware posting
  const UploadWare({super.key});

  @override
  State<UploadWare> createState() => _UploadWareState();
}

class _UploadWareState extends State<UploadWare> {
  final myName = TextEditingController();
  final myDescription = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myName.dispose();
    myDescription.dispose();
    super.dispose();
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
              wares.add(Ware(myName.text,
                  myDescription.text)); //TODO: implement add images

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
