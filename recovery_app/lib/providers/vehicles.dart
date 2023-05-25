import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class Vehicles with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  List<Vehicle> _selectedList = [];
  List<String> _selectedVehicleIds = [];
  String _selectedState = "";
  Vehicle? _selectedVehicle;
  String? _vehicleNumber;
  final List<String> _statesAvailable = [
    'BR',
    'CH',
    'PB',
    'DN',
    'UK',
    'CG',
    'DL',
    'GJ',
    'HR',
    'MH',
    'RJ',
  ];

  String get vehicleNumber {
    if (_vehicleNumber != null) {
      return _vehicleNumber!;
    } else {
      return '';
    }
  }

  List<Vehicle> get selectedList {
    return [..._selectedList];
  }

  List<String> get selectedVehicleIds {
    return [..._selectedVehicleIds];
  }

  Vehicle get selectedvehicle {
    return _selectedVehicle!;
  }

  void get emptySelectedVehicles {
    _selectedVehicleIds.clear();
    notifyListeners();
  }

  List<String> get listOfAvailableStates {
    return [..._statesAvailable];
  }

  void setVehicleNumber(String vehicleNumber) {
    _vehicleNumber = vehicleNumber;
    notifyListeners();
  }

  Future<void> getselectedVehicle(String vehicleId) async {
    try {
      if (_selectedState.isNotEmpty) {
        final testDataCollReff =
            FirebaseFirestore.instance.collection('testData');
        final vehicleNumberCollReff =
            testDataCollReff.doc(_selectedState).collection('suffixNumber');
        await vehicleNumberCollReff.doc(vehicleId).get().then((docSnapshot) {
          final vehicle = docSnapshot.data();
          // print(vehicle['VEH_NO']);
          _selectedVehicle = Vehicle(
            userName: vehicle!['CUST_NAME'],
            vehicleNumber: vehicleId,
            agrNo: vehicle['AGRNO'].toString(),
            chassisNumber: vehicle['CHASSINO'].toString(),
            engineNumber: vehicle['ENGINENO'].toString(),
            asset: vehicle['ASSET'],
            bomBuck: double.parse(vehicle['BOM_BUCK'].toString()),
            emiOs: double.parse(vehicle['EMI_OS'].toString()),
            total: double.parse(vehicle['Total Due'].toString()),
            brName: vehicle['BR_NAME'],
            company: vehicle['COMPANY'],
          );
        });
      }
    } catch (e) {
      // print('Error = $e');
    }
    notifyListeners();
  }

  Future<void> searchWithVehicleNumber(String value, String state) async {
    try {
      _selectedList.clear();
      _selectedState = state;
      _selectedVehicleIds.clear();

      // int val = int.parse(value);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('testData')
          .doc(state)
          .collection('suffixNumber')
          .where('searchElement', arrayContains: value)
          .limit(30)
          .get();

      for (var element in querySnapshot.docs) {
        if (element.id.contains(value)) {
          _selectedVehicleIds.add(element.id);
        }
      }
    } catch (e) {
      // print('Errror $e');
    }
    notifyListeners();
  }

  Future<bool> getStateVehicleList(String inputState) async {
    bool ans = false;
    try {
      final testDataCollReff =
          FirebaseFirestore.instance.collection('testData');
      await testDataCollReff.get().then((querySnapshot) {
        final list = querySnapshot.docs;
        ans = (list.any((element) => element.id == inputState));
        if (ans) _selectedState = inputState;
      });
    } catch (e) {
      // print(e);
    }
    return ans;
  }

  Future<String> searchWithChassisNumber(String chassisNumber) async {
    String vehicleId = '';
    try {
      for (var element in _statesAvailable) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('testData')
            .doc(element)
            .collection('suffixNumber')
            .where('CHASSINO', isEqualTo: chassisNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs[0].data();
          vehicleId = data['VEH_NO'];
          _selectedState = element;
          return (vehicleId);
        }
      }
      return 'NOT_FOUND';
    } catch (e) {
      // will Implement later
    }
    return vehicleId;
  }
}
