import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:itavero_mobile/screens/connections/connection_create_screen.dart';
import 'package:itavero_mobile/screens/connections/connection_edit_screen.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ConnectionListScreen extends StatefulWidget {
  const ConnectionListScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionListScreen> createState() => _ConnectionListScreenState();
}

class _ConnectionListScreenState extends State<ConnectionListScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verbindungen'),
          backgroundColor: ItaveroMobile.itacolor,

      ),
      body: settingsProvider.verbindungen.isEmpty
          ? const Center(
              child: Text(
                  'Aktuell sind keine Verbindungen vorhanden.\n Mit dem + können Sie eine neue \nVerbindung anlegen.'),
            )
          : ListView.builder(
              itemCount: settingsProvider.verbindungen.length,
              itemBuilder: (context, index) {
                final connectionItem = settingsProvider.verbindungen[index];
                return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey(index),
                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      //dismissible: DismissiblePane(onDismissed: () {
                      //  print('SDSDDS');
                      //  }),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          // An action can be bigger than the others.
                          //flex: 2,
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConnectionEditScreen(
                                      connectionModel: connectionItem)),
                            ).then((value) => setState(() {}));
                          },
                          backgroundColor: Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Bearbeiten',
                        ),

                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            settingsProvider.removeVerbindung(connectionItem);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '${connectionItem.name} wurde gelöscht.')));
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'löschen',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: ListTile(
                        onTap: () {
                          settingsProvider.setAktivVerbindung(connectionItem);
                          Navigator.pop(context);
                        },
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectionEditScreen(
                                    connectionModel: connectionItem)),
                          ).then((value) => setState(() {}));
                        },
                        title: Center(
                            child: Row(
                          children: [
                            Text(
                                'Name: ${connectionItem.name}\n${connectionItem.url}'),
                            settingsProvider.settingsModel.aktiveVerbindung ==
                                    connectionItem
                                ? const Icon(
                                    Icons.check,
                                    size: 50,
                                    color: Colors.green,
                                  )
                                : Text('')
                          ],
                        ))));
              }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_classes_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConnectionCreateScreen()),
          ).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
