import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Role with ChangeNotifier {
  String _role = 'Agent';
  String _name = '';
  bool _isBanned = false;
  Map<String, dynamic> data = {};

  String get role {
    return _role;
  }

  String get name {
    return _name;
  }

  bool get checkBanned {
    return _isBanned;
  }

  Future<void> getRole() async {
    _isBanned = false;
    final user = FirebaseAuth.instance.currentUser;
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    _role = data['Role'];
    _name = data['Name'];
    _isBanned = data['isBanned'];
    // notifyListeners();
  }
}
