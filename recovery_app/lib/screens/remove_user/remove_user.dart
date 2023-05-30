import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/models/user.dart';
import 'package:recovery_app/providers/auth.dart';
import 'package:recovery_app/screens/remove_user/widgets/email_drop_down_button.dart';
import 'package:recovery_app/screens/remove_user/widgets/name_drop_down_button.dart';

import '../../constants.dart';

class RemoveUser extends StatefulWidget {
  static const routeName = '/remove_user';
  const RemoveUser({super.key});

  @override
  State<RemoveUser> createState() => _RemoveUserState();
}

class _RemoveUserState extends State<RemoveUser> {
  String selectedName = '';

  void _deleteUser(Auth authProvider, BuildContext context) async {
    final name = authProvider.selectedNameToBeDeleted;
    final email = authProvider.selectedEmailToBeDeleted;
    final user = await authProvider.getUserToBeDeleted(name, email);
    _displayConfirmationDialog(context, authProvider, user);
  }

  void _displayConfirmationDialog(
      BuildContext context, Auth authProvider, MyUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deleting User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('Name ->'),
                  SizedBox(width: 5),
                  Text(user.name as String),
                ],
              ),
              Row(
                children: [
                  Text('Email ->'),
                  SizedBox(width: 5),
                  FittedBox(child: Text(user.email as String)),
                ],
              ),
              Row(
                children: [
                  Text('Role ->'),
                  SizedBox(width: 5),
                  Text(user.role as String),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white),
              child: Text(
                'C O N F I R M',
              ),
              onPressed: () async {
                bool deleted = false;
                if (user.role == 'SuperAdmin') {
                  // scaffold messenger cannot delete
                  // Navigator.of(context).pop();
                } else {
                  final uID = authProvider.selectedUIDToBeDeleted;
                  deleted = await authProvider.disableUserAccount(uID, user);
                }
                Navigator.pop(context);
                _showMessage(context, deleted);
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(BuildContext context, bool deleted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: deleted ? Colors.red[600] : myPrimaryColor,
        content:
            deleted ? Text('User Deleted Successfully.') : Text('NOT Deleted!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove User'),
      ),
      body: Consumer<Auth>(
        builder: (context, auth, child) => Container(
          height: 380,
          width: deviceSize.width * 0.9,
          constraints: BoxConstraints(maxHeight: deviceSize.height * 0.5),
          decoration: BoxDecoration(
            color: myBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: myBoxShadow,
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FittedBox(
                  alignment: Alignment.center,
                  child: Text(
                    'SELECT USER',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: Color.fromRGBO(84, 84, 84, 0.827),
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        'N A M E',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Spacer(),
                    // SizedBox(width: 2),
                    Flexible(
                      flex: 2,
                      child: Container(
                        // margin: EdgeInsets.only(left: 8),
                        // width: 300,
                        padding: const EdgeInsets.all(myDefaultPadding / 2),
                        decoration: BoxDecoration(
                          color: myBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(5, 5),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                            maxWidth: deviceSize.width * 0.85, minWidth: 100),
                        child: NameDropDownButton(title: 'Name'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      // fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        'E M A I L ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Spacer(),
                    // SizedBox(width: 2),
                    Flexible(
                      flex: 2,
                      child: Container(
                        // margin: EdgeInsets.only(left: 8),
                        // width: 100,
                        padding: const EdgeInsets.all(myDefaultPadding / 2),
                        decoration: BoxDecoration(
                          color: myBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(5, 5),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        constraints:
                            BoxConstraints(maxWidth: deviceSize.width * 0.85),
                        child: EmailDropDownButton(title: 'Email'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Center(
                  child: ElevatedButton(
                    child: Text('D E L E T E'),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      backgroundColor:
                          // Theme.of(context).colorScheme.primary,
                          Colors.purple,
                    ),
                    onPressed: () {
                      _deleteUser(auth, context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
