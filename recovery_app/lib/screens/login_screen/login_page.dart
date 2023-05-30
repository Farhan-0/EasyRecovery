import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String? email,
    String? password,
    // String? username,
    // bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      _emailFocusNode.unfocus();
      _passwordFocusNode.unfocus();
      await Future.delayed(const Duration(seconds: 2));
      // await Future.delayed(const Duration(seconds: 5));
      trigSuccess?.change(true);

      authResult = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      // print('logged in');
    } on FirebaseAuthException catch (error) {
      trigSuccess?.change(false);
      trigFail?.change(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Error Occured'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          duration: Duration(seconds: 5),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      trigFail?.change(true);

      var message = "An error occured, please check your credentials";
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      trigFail?.change(true);

      setState(() {
        _isLoading = false;
      });
      // print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String? _userEmail;
  String? _userPassword;
  final _isLogin = true;
  String validEmail = "Dandi@gmail.com";
  String validPassword = "12345";

  /// input form controller
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    _emailFocusNode.addListener(emailFocus);
    _passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(emailFocus);
    _passwordFocusNode.removeListener(passwordFocus);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(_emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(_passwordFocusNode.hasFocus);
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // this will close the softkeyboard
    if (isValid) {
      _formKey.currentState!.save(); // this will trigger onSaved
      _submitAuthForm(
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
    // print("Build Called Again");
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Container(
              //   height: 64,
              //   width: 64,
              //   padding: const EdgeInsets.all(16),
              //   decoration: const BoxDecoration(
              //     color: Colors.white,
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Image(
              //     image: AssetImage("assets/login_components/rive_logo.png"),
              //   ),
              // ),
              // const SizedBox(height: 32),
              FittedBox(
                child: Text(
                  "E A S Y   R E C O V E R Y",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 250,
                width: 250,
                child: RiveAnimation.asset(
                  "assets/login_components/login-teddy.riv",
                  fit: BoxFit.fitHeight,
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,

                      /// from rive, you can see it in rive editor
                      "Login Machine",
                    );
                    if (controller == null) return;

                    artboard.addController(controller!);
                    isChecking = controller?.findInput("isChecking");
                    numLook = controller?.findInput("numLook");
                    isHandsUp = controller?.findInput("isHandsUp");
                    trigSuccess = controller?.findInput("trigSuccess");
                    trigFail = controller?.findInput("trigFail");
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E2EA),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          key: ValueKey('email'),
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Email",
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                          onChanged: (value) {
                            numLook?.change(value.length.toDouble());
                          },
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.contains('@gmail.com') ||
                                !value.contains('.')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) => _userEmail = newValue,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          key: const ValueKey('password'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Passwords must be at least 7 Characters long.';
                            }
                            return null;
                          },
                          focusNode: _passwordFocusNode,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Password",
                          ),
                          obscureText: true,
                          style: Theme.of(context).textTheme.titleMedium,
                          onSaved: (value) {
                            _userPassword = value;
                          },
                          onFieldSubmitted: (value) {
                            _trySubmit();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // loginButton(_trySubmit(), _isLoading),
                      if (_isLoading) CircularProgressIndicator(),
                      if (!_isLoading)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            shadowColor: Colors.deepPurple[400],
                            elevation: 3.0,
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _trySubmit,
                          // onPressed: () {
                          //   // print('btton presed');
                          //   // Navigator.of(context).push(MaterialPageRoute(builder: builder))
                          //   VehicleDetailScreen();
                          // },
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 64,
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       _emailFocusNode.unfocus();
                      //       _passwordFocusNode.unfocus();

                      //       final email = _emailController.text;
                      //       final password = _passwordController.text;

                      //       showLoadingDialog(context);
                      //       await Future.delayed(
                      //         const Duration(milliseconds: 2000),
                      //       );
                      //       if (mounted) Navigator.pop(context);

                      //       if (email == validEmail &&
                      //           password == validPassword) {
                      //         trigSuccess?.change(true);
                      //       } else {
                      //         trigFail?.change(true);
                      //       }
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(16),
                      //       ),
                      //     ),
                      //     child: const Text("Login"),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
