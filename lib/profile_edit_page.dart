import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, required this.pBase, required this.user});

  final PocketBase pBase;
  final RecordModel user;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _contactPlatformController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  //creates a formkey unique to this profile edit form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [Text("Edit Profile"), Icon(Icons.construction)],
          ),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: "Username",
                            hintText: widget.user.getStringValue("username")),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // they didn't want to change the username
                            // or maybe I want to make the default value the original, and initialize the controller with the original as well?
                          } else if (!RegExp(r'^[a-zA-Z]+(_[a-zA-Z]+)*').hasMatch(value)) {
                            //for future me
                            //^[letter]+ : (starts with [at least one letter])
                            //(_[char class]+)* : (_[at least one letter]) 0 or more times
                            return 'Enter a valid username (Letters split by single underscores)';
                          }
                          return null;
                        },
                      ),
                      Text("name: ${widget.user.getStringValue("name")}"),
                      Text("markets: ${widget.user.getListValue("Markets")}"),
                      Text("Contact: ${widget.user.getStringValue("Contact")}"),
                      Text("Contact Platform: ${widget.user.getStringValue("Contact_Platform")}"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [const Text('Bio'), Text(widget.user.getStringValue('Bio'))],
                  )
                ],
              ),
            )));
  }
}
