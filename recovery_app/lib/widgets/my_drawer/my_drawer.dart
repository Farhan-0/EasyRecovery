import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/providers/role.dart';
import 'package:recovery_app/screens/remove_user/remove_user.dart';
import 'package:recovery_app/widgets/my_drawer/components/my_list_tile.dart';

import '../../screens/add_agent/add_agent.dart';

class MyDrawer extends StatelessWidget {
  // final
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Role>(context, listen: false).role;
    return Drawer(
      backgroundColor: Colors.purple[600],
      child: Column(
        children: [
          // header
          DrawerHeader(
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 72,
            ),
          ),

          // home
          MyListTile(
            icon: Icons.home_rounded,
            text: 'H O M E',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Add profile page

          // Add agent
          if (role == 'SuperAdmin')
            // if (role == 'Admin')
            MyListTile(
              icon: Icons.person_add_alt_rounded,
              text: 'A D D    U S E R',
              onTap: () {
                // pop meny drawer
                Navigator.pop(context);

                // go to add agent screen
                Navigator.of(context).pushNamed(AddAgent.routeName);
              },
            ),
          // Delete agent
          // if (role == 'SuperAdmin')
          if (role == 'SuperAdmin')
            MyListTile(
              icon: Icons.person_remove_rounded,
              text: 'R E M O V E    U S E R',
              onTap: () {
                // pop meny drawer
                Navigator.pop(context);

                // go to add agent screen
                Navigator.of(context).pushNamed(RemoveUser.routeName);
              },
            ),
          Spacer(),
          // logout
          MyListTile(
            icon: Icons.logout_outlined,
            text: 'L O G O U T',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
          SizedBox(height: 64),
        ],
      ),
    );
  }
}
