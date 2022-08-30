import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:itavero_mobile/models/connection_model.dart';


class ConnectionProvider extends ChangeNotifier{
  final List<ConnectionModel> _items = [];
  ConnectionModel aktivConnection = ConnectionModel(name: "Keine Verbindung (Dummy URL)",url:"https://itavwdmz01.itavero.de:8443/web_erp/");

  UnmodifiableListView<ConnectionModel> get items => UnmodifiableListView(_items);

  void add(ConnectionModel newConnection){
    _items.add(newConnection);
    notifyListeners();
  }

  void remove(ConnectionModel removeConnection){
    _items.remove(removeConnection);
    notifyListeners();
  }

  void setAktivConnection(ConnectionModel connection){
    aktivConnection = connection;
    notifyListeners();
  }
}