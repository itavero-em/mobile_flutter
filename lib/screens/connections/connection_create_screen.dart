import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ConnectionCreateScreen extends StatefulWidget {
  const ConnectionCreateScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionCreateScreen> createState() => _ConnectionCreateView();
}

class _ConnectionCreateView extends State<ConnectionCreateScreen> {
  final TextEditingController _nameCtrl = TextEditingController(text: '');
  final TextEditingController _urlCtrl = TextEditingController(text: '');

  bool isButtonSaveActive = false;



  @override
  void initState() {
    _nameCtrl.addListener(() {
      final isButtonSaveActiveCheck =
          _nameCtrl.text.isNotEmpty && _urlCtrl.text.isNotEmpty;

      setState(() {
        isButtonSaveActive = isButtonSaveActiveCheck;
      });
    });

    _urlCtrl.addListener(() {
      final isButtonSaveActiveCheck =
          _urlCtrl.text.isNotEmpty && _urlCtrl.text.isNotEmpty;

      setState(() {
        isButtonSaveActive = isButtonSaveActiveCheck;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erstelle eine Verbindung'),
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
            ),
            TextField(
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
                onPressed: isButtonSaveActive
                    ? () {
                        final connectionModel = ConnectionModel(
                            name: _nameCtrl.text, url: _urlCtrl.text);
                        Provider.of<SettingsProvider>(context, listen: false)
                            .addVerbindung(connectionModel);
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Erstelle Verbindung'))
          ],
        ),
      ),
    );
  }
}
