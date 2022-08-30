import 'package:flutter/material.dart';
import 'package:itavero_mobile/provider/connection_provider.dart';
import 'package:itavero_mobile/views/connections/connection_list_view.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Center(child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConnectionListView()),
        ).then((value) => setState(() {}));
      },
      child: Text("Aktive Verbindung: ${Provider.of<ConnectionProvider>(context).aktivConnection.name}\n"
          "${Provider.of<ConnectionProvider>(context).items.length} Verbindungen vorhanden \n\n(Klick mich)" ),
    ),
    );
  }
}
