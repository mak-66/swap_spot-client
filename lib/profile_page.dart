import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'ware_containers.dart';
import 'user_loading.dart';

//TODO: Allow for editing of user data from this profile page.

class ProfilePage extends StatefulWidget {
  //The page displayed when a user tries to create a new ware posting
  const ProfilePage({super.key, required this.pBase, required this.user});

  //local handles for the pocketbase and the user
  final PocketBase pBase;
  final RecordModel user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Theme.of(context).highlightColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("username: ${widget.user.getStringValue("username")}"),
                  Text("name: ${widget.user.getStringValue("name")}"),
                  Text("markets: ${widget.user.getListValue("Markets")}"),
                  Text("Phone #: ${widget.user.getStringValue("Phone_Number")}"),
                  Text("Preferred Contact: ${widget.user.getStringValue("preferred_contact")}"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [const Text('Bio'), Text(widget.user.getStringValue('Bio'))],
              )
            ],
          ),
        ));
  }
}
