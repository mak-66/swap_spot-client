import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:swap_spot/profile_page.dart';

import 'registration_page.dart';
import 'upload_ware_page.dart';
import 'trade_page.dart';
import 'ware_page.dart';
import 'market_page.dart';
import 'user_loading.dart';

//TODO: Figure out the app icon
//TODO: make it so that users can only modify data pertaining to them

//Creates the pocketbase handle
const String pbURL = "https://swap-spot.pockethost.io/";
PocketBase pBase = PocketBase(pbURL);

//handle for user data
late RecordModel user;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwapSpot App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 156, 79, 208)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _loginText = "Please enter login data";
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _newUser() async {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => RegistrationPage(pBase: pBase),
        ));
  }

  Future<void> _login() async {
    // Perform login operation using Pocketbase, happens after user presses submit
    String username = _userController.text;
    String password = _passwordController.text;
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      pBase.authStore.clear(); // clears any previous user logged in
      //throws an error if login information isn't good
      await pBase.collection("users").authWithPassword(username, password);
      //prints if authdata was good
      if (pBase.authStore.isValid) {
        // debugPrint("logging in as $username (${pBase.authStore.model.id})");
        //fetches a record of the user after they have been validated and loads all relevant data
        user = await getUser(pBase, pBase.authStore.model.id);
        if (user.getBoolValue('verified')) {
          //if the user has been verified
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: "Logged in as $username", pBase: pBase, user: user)));
        } else {
          //else, display that they need to be verified
          setState(() {
            _loginText = 'Error logging in. User not verified';
            _isLoading = false;
          });
        }
      }
      //pushes context to the home page
    } catch (e) {
      // Handles login error
      debugPrint('Error Logging in (User: $username || Pass: $password): \n$e');
      setState(() {
        _loginText = 'Error logging in. Please try again. (Error: $e)';
        _isLoading = false;
      });
    }
    _userController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to SwapSpot v0.3'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_loginText),
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: _newUser, child: const Text('Register')),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.pBase, required this.user});
  final String title;
  final PocketBase pBase;
  final RecordModel user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //determines the starting page
  int _selectedPageIndex = 0;

  static final List<Widget> _pages = <Widget>[
    TradePage(pBase: pBase, user: user),
    MarketPage(pBase: pBase, user: user), //passes in the pocketbase and user for context
    UploadWare(pBase: pBase, user: user), //same here; necessary to update the server easily
    const WarePage(),
    ProfilePage(pBase: pBase, user: user)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Potential Trades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business),
            label: "Find new Matches",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Publish new Ware"),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: "Wares"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile")
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: const Color.fromARGB(255, 88, 87, 87),
        currentIndex: _selectedPageIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
