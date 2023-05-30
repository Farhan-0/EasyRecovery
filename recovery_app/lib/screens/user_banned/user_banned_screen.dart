import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserBannedScreen extends StatelessWidget {
  const UserBannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: 200,
        height: 100,
        child: Column(
          children: [
            Text('User has been Deleted'),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 211, 16, 12)),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('Close'),
            ),
          ],
        ),
      )),
    );
  }
}
