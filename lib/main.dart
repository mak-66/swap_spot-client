import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import 'ware_containers.dart';
import 'upload_ware_page.dart';
import 'trade_page.dart';
import 'ware_page.dart';
import 'market_page.dart';

//TODO: Figure out the app icon

//Creates the pocketbase handle
const pbURL = "https://swap-spot.pockethost.io/";
var pBase = PocketBase(pbURL);

//Creates the handle for the user
late RecordModel user;

void main() {
  runApp(const MyApp());
}

Future<void> getUser(String userID) async {
  try {
    user = await pBase.collection('users').getOne(userID);
    loadUser(pBase, user);
    debugPrint(user.toString());
  } catch (e) {
    debugPrint('Error fetching user: \n$e');
  }
}

Future<void> printWare(String wareID) async {
  try {
    var record = await pBase.collection('Market_Wares').getOne(wareID);

    // Print owner's username
    debugPrint('Owner Username: ${record.getDataValue<String>('Owner_Username')}');
  } catch (e) {
    debugPrint('Error fetching record: \n$e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwapSpot App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 126, 79, 208)),
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

  Future<void> _login() async {
    // Perform login operation using Pocketbase
    String username = _userController.text;
    String password = _passwordController.text;
    try {
      //throws an error if login information isn't good
      await pBase.collection("users").authWithPassword(username, password);
      //prints if authdata was good
      if (pBase.authStore.isValid) {
        debugPrint("logging in as $username (${pBase.authStore.model.id})");
        //fetches a record of the user after they have been validated
        await getUser(pBase.authStore.model.id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(title: username, pBase: pBase, user: user)));
      }
      //pushes context to the home page
    } catch (e) {
      // Handles login error
      debugPrint('Error Logging in (User: $username || Pass: $password): \n$e');
      setState(() {
        _loginText = 'Error logging in. Please try again.';
      });
      _userController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to SwapSpot v0.2'),
      ),
      body: Padding(
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
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
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
  int _selectedPageIndex = 0;

  static final List<Widget> _pages = <Widget>[
    TradePage(),
    MarketPage(),
    UploadWare(pBase: pBase, user: user),
    WarePage(),
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
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: const Color.fromARGB(255, 88, 87, 87),
        currentIndex: _selectedPageIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
