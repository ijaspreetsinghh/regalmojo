import 'package:flutter/material.dart';
import 'package:regalmojo/Screens/ForgotPassword/forgot_password.dart';
import 'package:regalmojo/Screens/Login/Login.dart';
import 'package:regalmojo/Screens/Profile/profile.dart';
import 'constants.dart';
import 'Screens/Register/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return App();
  }
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          AppLoading();

          return MyMaterialApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return AppLoading();
      },
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RegisterPage.id,
      routes: {
        Profile.id: (context) => Profile(),
        RegisterPage.id: (context) => RegisterPage(),
        Login.id: (context) => Login(),
        ForgotPassword.id: (context) => ForgotPassword(),
      },
      debugShowCheckedModeBanner: false,
      color: kPrimaryColor,
      theme: ThemeData().copyWith(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: kBackgroundColor,
      ),
    );
  }
}

class AppLoading extends StatefulWidget {
  @override
  _AppLoadingState createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
