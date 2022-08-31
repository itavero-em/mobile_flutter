import 'package:flutter/material.dart';
import 'package:itavero_mobile/provider/connection_provider.dart';
import 'package:itavero_mobile/screens/connections/connection_list_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConnectionListScreen()),
        ).then((value) => setState(() {}));
      },
      child: Text("Aktive Verbindung: ${Provider.of<ConnectionProvider>(context).aktivConnection.name}\n"
          "${Provider.of<ConnectionProvider>(context).items.length} Verbindungen vorhanden \n\n(Klick mich)" ),
    ),
    );
  }
}
