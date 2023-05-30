import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/providers/role.dart';
import 'package:recovery_app/widgets/my_drawer/my_drawer.dart';

class AddAgent extends StatefulWidget {
  const AddAgent({super.key});
  static const routeName = '/add_agent';

  @override
  State<AddAgent> createState() => _AddAgentState();
}

class _AddAgentState extends State<AddAgent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _agentName = '';
  String? _agentEmail = '';
  String? _agentPassword = '';

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  var _isLoading = false;
  String? _selectedRadioOption = 'Agent';
  final _auth = FirebaseAuth.instance;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occured :('),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Okay',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('User Added Successfully.'),
        content: const Text(
            'You will be redirected to Login page, Please Login Again.'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();

              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Okay',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    UserCredential addAgentResult;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      addAgentResult = await _auth.createUserWithEmailAndPassword(
          email: _agentEmail!, password: _agentPassword!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(addAgentResult.user!.uid)
          .set({
        'Name': _agentName,
        'Email': _agentEmail,
        'Role': _selectedRadioOption as String,
        'testing': false,
        'isBanned': false,
      });

      _showSuccessDialog();
      // Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      _showErrorDialog(e.message.toString());
    } catch (error) {
      // print(error);
      var errorMessage = 'Could not add user. Please try again later.';
      if (error.toString().contains('email-already-in-use')) {
        errorMessage =
            'The email address is already in use by another account.';
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final role = Provider.of<Role>(context, listen: false).role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Agent'),
      ),
      body: Container(
        height: 420,
        width: deviceSize.width * 0.9,
        constraints: BoxConstraints(maxHeight: deviceSize.height * 0.75),
        decoration: BoxDecoration(
          color: myBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: myBoxShadow,
        ),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FittedBox(
                alignment: Alignment.center,
                child: Text(
                  'ENTER USER DETAILS',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: const ValueKey('userName'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please Enter atleast 4 characters.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (newValue) {
                        _agentName = newValue;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('email'),
                      // this makes sure that when state changes,
                      // values don't ump from one tesxt formfield to another
                      validator: (value) {
                        if (value!.isEmpty ||
                            !value.contains('@gmail.com') ||
                            !value.contains('.')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                      ),
                      focusNode: _emailFocusNode,
                      onSaved: (value) {
                        _agentEmail = value;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('password'),

                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Passwords must be at least 7 Characters long.';
                        }
                        return null;
                      },
                      focusNode: _passwordFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true, // For hiding Text entered by User
                      onSaved: (value) {
                        _agentPassword = value;
                        FocusScope.of(context).unfocus();
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: 10),
                    Container(
                      // width: deviceSize.width * 0.85,
                      height: 50,
                      constraints:
                          BoxConstraints(maxWidth: deviceSize.width * 0.85),
                      decoration: BoxDecoration(),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Agent'),
                              value: 'Agent',
                              groupValue: _selectedRadioOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRadioOption = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Admin'),
                              value: 'Admin',
                              groupValue: _selectedRadioOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRadioOption = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   // mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     RadioListTile<String>(
                    //       title: const Text('Agent'),
                    //       value: 'Agent',
                    //       groupValue: _selectedRadioOption,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           _selectedRadioOption = value;
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   constraints: BoxConstraints(
                    //     maxWidth: deviceSize.width * 0.6,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       RadioListTile<String>(
                    //         title: const Text('Agent'),
                    //         value: 'Agent',
                    //         groupValue: _selectedRadioOption,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _selectedRadioOption = value;
                    //           });
                    //         },
                    //       ),
                    //       RadioListTile<String>(
                    //         title: const Text('Admin'),
                    //         value: 'Admin',
                    //         groupValue: _selectedRadioOption,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _selectedRadioOption = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Row(
                    //     children: [
                    //       RadioListTile<String>(
                    //         title: const Text('Agent'),
                    //         value: 'Agent',
                    //         groupValue: _selectedRadioOption,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _selectedRadioOption = value;
                    //           });
                    //         },
                    //       ),
                    //       RadioListTile<String>(
                    //         title: const Text('Admin'),
                    //         value: 'Admin',
                    //         groupValue: _selectedRadioOption,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _selectedRadioOption = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submit,
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
                            child: const Text('Add User'),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
