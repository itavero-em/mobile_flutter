import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';

import '../../main.dart';


class ConnectionEditScreen extends StatefulWidget {
  final ConnectionModel connectionModel;

  const ConnectionEditScreen({Key? key, required this.connectionModel}) : super(key: key);

  @override
  State<ConnectionEditScreen> createState() => _ConnectionCreateView();
}

class _ConnectionCreateView extends State<ConnectionEditScreen> {

  late TextEditingController _nameCtrl;
  late TextEditingController _urlCtrl;

  @override
  Widget build(BuildContext context) {

    _nameCtrl = TextEditingController(text: widget.connectionModel.name);
    _urlCtrl = TextEditingController(text: widget.connectionModel.url);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verbindung bearbeiten'),
          backgroundColor: ItaveroMobile.itacolor,
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
                  prefixIcon: Icon(Icons.abc),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),TextField(
              controller: _urlCtrl,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'URL',
                  helperText: 'Url eingeben',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            ElevatedButton(
                onPressed: () {
                  widget.connectionModel.name=_nameCtrl.text;
                  widget.connectionModel.url=_urlCtrl.text;
                  Provider.of<SettingsProvider>(context, listen: false).modifyVerbindung(widget.connectionModel);
                  Navigator.pop(context);
                },
                child: const Text('Speichere Verbindung'))
          ],
        ),
      ),
    );
  }
}
