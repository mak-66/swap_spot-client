import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'main.dart';

//TODO: set up email server to verify user emails (Sendinblue) -> verify the entire account

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.pBase});
  final PocketBase pBase;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _registrationText = "Please fill in the details to register.";
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      //if the formkey indicates that its fields are all valid
      String username = _usernameController.text;
      String email = _emailController.text;
      String phoneNumber = _phoneController.text;
      String password = _passwordController.text;
      String passwordConfirm = _passwordConfirmController.text;

      setState(() {
        _isLoading = true; // Start loading
      });

      RecordModel publicProfileRecord = await widget.pBase
          .collection('Public_Profiles')
          .create(body: {'Name': username, 'Contact': phoneNumber});

      try {
        await widget.pBase.collection('users').create(body: {
          'username': username,
          'name': username,
          'email': email,
          'Profile': publicProfileRecord.id,
          'Phone_Number': phoneNumber,
          'password': password,
          'passwordConfirm': passwordConfirm,
        });

        //prompts pBase to send a verification email prompt
        //TODO: modify the verification process from clicking sketchy email link -> confirm codes
        await pBase.collection('users').requestVerification(email);

        setState(() {
          _registrationText = 'Registration successful! Please log in.';
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _registrationText = 'Error during registration. Please try again. (Error: $e)';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register on SwapSpot v0.3'),
      ),
      body: _isLoading //if it is loading
          ? const Center(child: CircularProgressIndicator()) //then put a loading indicator
          : Padding(
              //else, do this
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_registrationText),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an phone number';
                        } else if (!RegExp(r'^(\(\d{3}\)\s?|\d{3}[-.\s]?)?\d{3}[-.\s]?\d{4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordConfirmController,
                      decoration: const InputDecoration(labelText: 'Retype Your Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
