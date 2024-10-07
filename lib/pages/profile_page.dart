import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'profile_edit_page.dart';

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("username: ${widget.user.getStringValue("username")}"),
                      Text("name: ${widget.user.getStringValue("name")}"),
                      Text("markets: ${widget.user.getListValue("Markets")}"),
                      Text("Contact: ${widget.user.getStringValue("Contact")}"),
                      Text("Contact Platform: ${widget.user.getStringValue("Contact_Platform")}"),
                    ],
                  ),
                  // TODO: implement edit button and page
                  const Spacer(flex: 3),
                  ElevatedButton(
                      onPressed: _pushProfileEdit, child: const Icon(Icons.edit, size: 10)),
                  const Spacer(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [const Text('Bio'), Text(widget.user.getStringValue('Bio'))],
              )
            ],
          ),
        ));
  }

  void _pushProfileEdit() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              ProfileEditPage(pBase: widget.pBase, user: widget.user),
        ));
  }
}
