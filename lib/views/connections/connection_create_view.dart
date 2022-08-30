import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/provider/connection_provider.dart';
import 'package:provider/provider.dart';


class ConnectionCreateView extends StatefulWidget {
  const ConnectionCreateView({Key? key}) : super(key: key);

  @override
  State<ConnectionCreateView> createState() => _ConnectionCreateView();
}

class _ConnectionCreateView extends State<ConnectionCreateView> {
  TextEditingController _nameCtrl = TextEditingController(text: '');
  TextEditingController _urlCtrl = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Erstelle eine Verbindung'),
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
                  final newClass = ConnectionModel(name: _nameCtrl.text,url: _urlCtrl.text);
                  Provider.of<ConnectionProvider>(context).add(newClass);
                  Navigator.pop(context);
                },
                child: const Text('Erstelle Verbindung'))
          ],
        ),
      ),
    );
  }
}
