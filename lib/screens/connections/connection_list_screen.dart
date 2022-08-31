import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:itavero_mobile/provider/connection_provider.dart';
import 'package:itavero_mobile/screens/connections/connection_create_screen.dart';
import 'package:provider/provider.dart';

class ConnectionListScreen extends StatefulWidget {
  const ConnectionListScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionListScreen> createState() => _ConnectionListScreenState();
}

class _ConnectionListScreenState extends State<ConnectionListScreen> {
  @override
  Widget build(BuildContext context) {
    final connectionProvider =
        Provider.of<ConnectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verbindungen'),
      ),
      body: connectionProvider.items.isEmpty
          ? const Center(
              child: Text(
                  'Aktuell sind keine Verbindungen vorhanden.\n Mit dem + können Sie eine neue \nVerbindung anlegen.'),
            )
          : ListView.builder(
              itemCount: connectionProvider.items.length,
              itemBuilder: (context, index) {
                final connectionItem = connectionProvider.items[index];
                return Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: ValueKey(index),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (context) {},
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Bearbeiten',
                      ),
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          connectionProvider.remove(connectionItem);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '${connectionItem.name} wurde gelöscht.')));
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: ListTile(
                    onTap: () {
                      connectionProvider.setAktivConnection(connectionItem);
                      Navigator.pop(context);
                      },
                      title: Center(
                          child: Row(children: [Text(
                          'Name: ${connectionItem.name}\n(Slide left/right)'),
                           connectionProvider.aktivConnection==connectionItem?  const Icon(Icons.check,size: 50,color: Colors.green,):Text('')],)
                      )
                )
                );
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
