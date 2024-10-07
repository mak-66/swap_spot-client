import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:swap_spot/pages/upload_ware_page.dart';
import '../ware_containers.dart';

// TODO: Update page when uploadWarePage returns

class WarePage extends StatefulWidget {
  //displays the wares currently put on the market
  const WarePage({super.key, required this.pBase, required this.user});
  final PocketBase pBase;
  final RecordModel user;

  @override
  State<WarePage> createState() => _WarePageState();
}

class _WarePageState extends State<WarePage> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  // Callback to refresh the wares list
  void _refreshWares() {
    setState(() {
      // Logic to refresh the wares list (e.g., fetch from backend)
      // For example, fetch new wares from the server
      debugPrint('Wares list updated!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wares'),
      ),
      body: Center(
          child: ListView.builder(
        //scrollable list containing tiles containing info on each ware
        itemCount: wares.length,
        itemBuilder: (context, index) {
          final ware = wares[index];
          return Padding(padding: const EdgeInsets.all(15), child: ware.returnListTile());
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadWarePage(
                        pBase: widget.pBase, user: widget.user, onWareCreated: _refreshWares)),
              ),
          child: const Icon(Icons.add)),
    );
  }
}
