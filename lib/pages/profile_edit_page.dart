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
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _contactPlatformController;
  late TextEditingController _bioController;
  //creates a formkey unique to this profile edit form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.getStringValue("username"));
    _nameController = TextEditingController(text: widget.user.getStringValue("name"));
    _contactController = TextEditingController(text: widget.user.getStringValue("Contact"));
    _contactPlatformController =
        TextEditingController(text: widget.user.getStringValue("Contact_Platform"));
    _bioController = TextEditingController(text: widget.user.getStringValue("Bio"));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _contactPlatformController.dispose();
    _bioController.dispose();
    super.dispose();
  }

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
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 180, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              isDense: true,
                              labelText: "Username",
                              // hintText: widget.user.getStringValue("username")
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[a-zA-Z]+(_[a-zA-Z]+)*').hasMatch(value)) {
                                //for future me
                                //^[letter]+ : (starts with [at least one letter])
                                //(_[char class]+)* : (_[at least one letter]) 0 or more times
                                return 'Enter a valid username';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _nameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Display Name",
                                hintText: widget.user.getStringValue("name")),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a display name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _contactController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Contact",
                                hintText: widget.user.getStringValue("Contact")),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a preferred contact';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _contactPlatformController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Contact Platform",
                                hintText: widget.user.getStringValue("Contact_Platform")),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the platform of your contact';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Bio'),
                        TextFormField(
                          controller: _bioController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 10,
                          decoration: InputDecoration(
                              hintMaxLines: 10,
                              isDense: true,
                              labelText: "Bio",
                              hintText: widget.user.getStringValue("Bio")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a Bio';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: _clear, child: const Text("Reset")),
                        ElevatedButton(onPressed: _saveProfile, child: const Text("Save")),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

// TODO: Implement button methods
  void _saveProfile() {}

  void _clear() {}
}
