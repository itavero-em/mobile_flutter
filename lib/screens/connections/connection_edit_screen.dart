import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';


class ConnectionCreateScreen extends StatefulWidget {
  final ConnectionModel? connectionModel;

  const ConnectionCreateScreen({Key? key, this.connectionModel}) : super(key: key);

  @override
  State<ConnectionCreateScreen> createState() => _ConnectionCreateView(connectionModel);
}

class _ConnectionCreateView extends State<ConnectionCreateScreen> {
  final ConnectionModel? connectionModel;

  _ConnectionCreateView({this.connectionModel});

  TextEditingController _nameCtrl = TextEditingController(text: connectionModel.name);
  TextEditingController _urlCtrl = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verbindung bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Name',
                  helperText: 'Name der Verbindung eingeben',
                  prefixIcon: Icon(Icons.group),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),TextField(
              controller: _urlCtrl,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'URL',
                  helperText: 'Url eingeben',
                  prefixIcon: Icon(Icons.abc),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            ElevatedButton(
                onPressed: () {
                  final connectionModel = ConnectionModel(name: _nameCtrl.text,url: _urlCtrl.text);
                  Provider.of<SettingsProvider>(context, listen: false).addVerbindung(connectionModel);
                  Navigator.pop(context);
                },
                child: const Text('Erstelle Verbindung'))
          ],
        ),
      ),
    );
  }
}
