import 'package:flutter/material.dart';
import 'package:recovery_app/constants.dart';

class AuthForm extends StatefulWidget {
  // const AuthForm({super.key});
  final bool _isLoading;
  final void Function(
    String? email,
    String? password,
    // String? username,
    // bool isLogin,
    BuildContext ctx,
  ) submitFn;

  const AuthForm(this.submitFn, this._isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String? _userEmail = "";
  // String? _userName = "";
  String? _userPassword = "";
  var _isLogin = true;
  final _passwordFocusNode = FocusNode();

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // this will close the softkeyboard
    if (isValid) {
      _formKey.currentState!.save(); // this will trigger onSaved
      widget.submitFn(
        _userEmail!.trim(),
        _userPassword!.trim(),
        // _userName!.trim(),
        // _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        // color: Colors.transparent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    // onFieldSubmitted: (value) { implement later
                    //   Focus.of(widget.ctx).requestFocus(_passwordFocusNode);
                    // },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),

                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Passwords must be at least 7 Characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true, // For hiding Text entered by User
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    // focusNode: _passwordFocusNode, implement later
                    // onFieldSubmitted: (_) => _trySubmit(),
                  ),
                  const SizedBox(height: 15),
                  // loginButton(_trySubmit()),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 30),
                  //     shadowColor: Colors.deepPurple[400],
                  //     elevation: 3.0,
                  //     backgroundColor: Colors.purple,
                  //     foregroundColor: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  //   onPressed: _trySubmit,
                  //   // onPressed: () {
                  //   //   // print('btton presed');
                  //   //   // Navigator.of(context).push(MaterialPageRoute(builder: builder))
                  //   //   VehicleDetailScreen();
                  //   // },
                  //   child: widget._isLoading
                  //       ? CircularProgressIndicator(
                  //           color: Colors.white,
                  //         )
                  //       : Text(
                  //           'Login',
                  //         ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
