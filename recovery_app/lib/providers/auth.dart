import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:convert';

import 'package:recovery_app/models/user.dart';

// import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  bool _authenticated = false;
  List<String> _userNames = [];
  List<String> _userEmails = [];
  String _selectedNameToBeDeleted = '';
  String _selectedEmailToBeDeleted = '';
  String _selectedUIDToBeDeleted = '';

  bool get isAuth {
    // print(_authenticated);
    return _authenticated;
  }

  List<String> get getUserNames {
    return [..._userNames];
  }

  List<String> get getUserEmails {
    return [..._userEmails];
  }

  String get selectedNameToBeDeleted {
    return _selectedNameToBeDeleted;
  }

  String get selectedEmailToBeDeleted {
    return _selectedEmailToBeDeleted;
  }

  String get selectedUIDToBeDeleted {
    return _selectedUIDToBeDeleted;
  }

  void setAuthenticated(bool value) {
    _authenticated = value;
    print(_authenticated);
    notifyListeners();
  }

  void setUserNameToBeDeleted(String name) {
    _selectedNameToBeDeleted = name;
    notifyListeners();
  }

  void setUserEmailToBeDeleted(String email) {
    _selectedEmailToBeDeleted = email;
    notifyListeners();
  }

  // Future<bool> disableAccount(String userEmail) async {
  //   bool ans = false;
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('Email', isEqualTo: userEmail)
  //         .get();

  //     final data = querySnapshot.docs[0].data();
  //     print(data);
  //     // return true;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return ans;
  // }

  Future<void> fetchNameOfUsers() async {
    try {
      _userNames.clear();
      // _userEmails.clear();
      // print('drop');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('testing', isEqualTo: false)
          .where('Role', isNotEqualTo: 'SuperAdmin')
          .where('isBanned', isEqualTo: false)
          .get();

      for (var element in querySnapshot.docs) {
        // print(element.data());
        _userNames.add(element.data()['Name']);
        // _userEmails.add(element.data()['Email']);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchEmailOfUsers() async {
    try {
      // _userNames.clear();
      _userEmails.clear();
      // print('drop');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('testing', isEqualTo: false)
          .where('isBanned', isEqualTo: false)
          // .where('Name', isEqualTo: _selectedNameToBeDeleted)
          .get();

      for (var element in querySnapshot.docs) {
        // print(element.data());
        // _userNames.add(element.data()['Name']);
        if (element.data()['Name'] == _selectedNameToBeDeleted) {
          _userEmails.add(element.data()['Email']);

          // print(_userEmails);
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<MyUser> getUserToBeDeleted(String name, String email) async {
    _selectedUIDToBeDeleted = '';
    var selectedUser = MyUser(name: '', email: '', role: '', testing: true);
    try {
      final querySanpshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: email)
          .where('Name', isEqualTo: name)
          .get();
      final data = querySanpshot.docs[0];
      _selectedUIDToBeDeleted = data.id;
      final user = MyUser(
        name: data['Name'],
        email: data['Email'],
        role: data['Role'],
        testing: data['testing'],
      );
      return user;
    } catch (e) {
      return selectedUser;
    }
  }

  Future<bool> disableUserAccount(String uid, MyUser user) async {
    try {
      // await FirebaseAuth.instance..updateUser(uid, disabled: true);
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'Name': user.name,
        'Email': user.email,
        'Role': user.role,
        'testing': user.testing,
        'isBanned': true,
      });
      await FirebaseFirestore.instance.collection('bannedUsers').doc(uid).set({
        'Name': user.name,
        'Email': user.email,
        'Role': user.role,
        'testing': user.testing,
        'isBanned': true,
      });
      return true;
      print('User account disabled successfully.');
    } catch (e) {
      print('Error disabling user account: $e');
      return false;
    }
  }
}
