import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/providers/role.dart';
import 'package:recovery_app/screens/animation_screen/splash_screen.dart';
import 'package:recovery_app/screens/agent_screen/widgets/user_body.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _check = true;

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<Role>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(roleProvider.role),
        actions: [
          DropdownButton(
            underline: Container(color: Colors.transparent),
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdendtifier) async {
              if (itemIdendtifier == 'logout') {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: UserBody(roleProvider),
    );
  }
}
