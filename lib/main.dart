import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/resources/auth.dart';
import 'package:passwordmanager/screens/homePage.dart';
import 'package:passwordmanager/screens/passwordsScreen.dart';
import 'package:passwordmanager/screens/signInPage.dart';
import 'package:provider/provider.dart';
import './screens/signInPage.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Password Manager',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SignInPage();
          },
        ),
        routes: {
          "/home": (context) => HomePage(),
          "/savedPasses": (context) => PasswordsScreen(),
        },
      ),
    );
  }
}
