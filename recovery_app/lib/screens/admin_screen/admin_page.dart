import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/providers/role.dart';
import 'package:recovery_app/screens/admin_screen/widgets/add_agent.dart';
import 'package:recovery_app/screens/animation_screen/splash_screen.dart';

import '../../models/menu_item.dart';
import 'widgets/admin_body.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _check = true;
  bool _isLoading = false;

  // // @override
  // void didChangeDependencies() async {
  //   // TODO: implement didChangeDependencies
  //   if (_check) {
  //     _check = false;
  //     // setState(() {
  //     //   _isLoading = true;
  //     // });
  //     // await Provider.of<Role>(context, listen: false).getRole();
  //     await Future.delayed(const Duration(seconds: 5));
  //     // setState(() {
  //     //   _isLoading = false;
  //     // });
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    // final user = FirebaseAuth.instance.currentUser;
    // final userEmail = user!.email as String;
    final roleProvider = Provider.of<Role>(context, listen: false);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(roleProvider.role),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (selectedItem) => _onSelected(context, selectedItem),
            itemBuilder: (ctx) => [
              ...[
                const MenuItem(
                    menuText: 'Add Agent',
                    menuIcon: Icons.person_add_alt_rounded),
                const MenuItem(
                    menuText: 'Logout', menuIcon: Icons.exit_to_app_rounded),
              ].map(_buildMenuItem).toList(),
            ],
          ),
        ],
      ),
      body: AdminBody(roleProvider: roleProvider),
    );
  }

  PopupMenuItem<MenuItem> _buildMenuItem(MenuItem item) {
    return PopupMenuItem<MenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(
            item.menuIcon,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(item.menuText),
        ],
      ),
    );
  }

  Future<void> _onSelected(BuildContext context, MenuItem selectedItem) async {
    if (selectedItem.menuText == MenuItems.itemAddAgent.menuText) {
      Navigator.of(context).pushNamed(AddAgent.routeName);
    } else if (selectedItem.menuText == MenuItems.itemLogout.menuText) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
