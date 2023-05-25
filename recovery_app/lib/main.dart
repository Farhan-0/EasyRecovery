import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/providers/vehicles.dart';
import 'package:recovery_app/screens/admin_screen/widgets/add_agent.dart';
import 'package:recovery_app/screens/admin_screen/admin_page.dart';
import 'package:recovery_app/screens/animation_screen/splash_screen.dart';
import 'package:recovery_app/screens/chasis_detail_screen.dart';
import 'package:recovery_app/screens/login_screen/login_page.dart';
import 'package:recovery_app/screens/search_result_screen/search_result.dart';
import 'package:recovery_app/screens/agent_screen/user_page.dart';
import 'package:recovery_app/screens/vehicle_detail_screen/vehicle_detail_screen.dart';
import 'firebase_options.dart';
import 'providers/role.dart';

void main() {
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (_) => const App(),
  //   ),
  // );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),

      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // print(snapshot.error);
          return const SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Loading();
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Role(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Vehicles(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recovery App',
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
            scaffoldBackgroundColor: myBackgroundColor,
            primarySwatch: myPrimaryColor,
            // fontFamily: GoogleFonts.lato().fontFamily,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 20),
              titleLarge: TextStyle(fontSize: 25),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        // home: StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (ctx, snapshot) {
        //     if (snapshot.hasData && snapshot.data != null) {
        //       return StreamBuilder(
        //         stream: FirebaseFirestore.instance
        //             .collection('users')
        //             .doc(snapshot.data!.uid)
        //             .snapshots(),
        //         builder: (ctx, snapshot) {
        //           if (snapshot.hasData && snapshot.data != null) {
        //             final user = snapshot.data!.data();
        //             if (user!['Role'] == 'Admin') {
        //               return const AdminScreen();
        //             } else {
        //               return const UserScreen();
        //               // return VehicleDetailScreen();
        //             }
        //           } else if (snapshot.connectionState ==
        //               ConnectionState.waiting) {
        //             return const SplashScreen();
        //           }
        //           // return Center(child: CircularProgressIndicator());
        //           return const SplashScreen();
        //         },
        //       );
        //     } else if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const SplashScreen();
        //     }

        //     return const LoginPage();
        //   },
        // ),
        home: Consumer<Role>(
          builder: (ctx, role, child) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return FutureBuilder(
                  future: role.getRole(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else {
                      if (role.role == 'Admin') {
                        return AdminScreen();
                      } else {
                        return UserScreen();
                      }
                    }
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              return const LoginPage();
            },
          ),
        ),
        routes: {
          VehicleDetailScreen.routeName: (ctx) => VehicleDetailScreen(),
          ChasisDetailScreen.routeName: (ctx) => const ChasisDetailScreen(),
          AddAgent.routeName: (ctx) => const AddAgent(),
          SearchResult.routeName: (ctx) => const SearchResult(),
        },
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Error Occured in initializing firestore')),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
