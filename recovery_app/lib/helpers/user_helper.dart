import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static List<String> _docIDs = [];

  static Future<void> _getDocId() async {
    await _db.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              // print(element.reference);
              _docIDs.add(element.reference.id);
            },
          ),
        );
  }

  static saveuser(User? user) async {
    Map<String, dynamic> userData = {
      'Name': user!.displayName,
      'Email': user.email,
      'Role': 'Agent',
    };

    final userRef = _db.collection('users').doc(user.uid);
    // print(userRef.id);
    await _getDocId();
    if (_docIDs.contains(userRef.id)) {
      //update
    } else {}
    // if ((await userRef.get()).exists) {
    //   // update anything if needed
    //   print('exists');
    // } else {
    //   print('not exists');
    //   await userRef.set(userData);
    // }
  }
}
