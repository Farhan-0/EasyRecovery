import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleData with ChangeNotifier {
  List<List<dynamic>> _list = [];
  List<List<dynamic>> _selectedList = [];

  List<List<dynamic>> get selectedList {
    return [..._selectedList];
  }

  void searchWithVehicleNumber(String value) {
    // List<Vehicle> ans = [];
    _selectedList.clear();
    if (value.isEmpty) {
      // print('empty');
      return;
    }
    for (var element in _list) {
      if (element[8].toString().contains(value)) {
        _selectedList.add(element);
      }
    }
    notifyListeners();
  }
}
