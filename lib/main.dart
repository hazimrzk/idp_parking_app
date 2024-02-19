import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:idp_parking_app/pages/settings.dart';
import 'package:idp_parking_app/pages/signIn.dart';
import 'package:idp_parking_app/pages/signUp.dart';
import 'package:idp_parking_app/pages/wallet.dart';
import 'package:idp_parking_app/services/authService.dart';
import 'package:idp_parking_app/widgets/wrapper.dart';
import 'pages/home.dart';
import 'pages/history.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider<AuthService>(create: (_) => AuthService()),
      Provider<FirebaseDatabase>(create: (_) => FirebaseDatabase.instance),
    ],
    child: MaterialApp(
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
        '/history': (context) => History(),
        '/settings': (context) => Settings(),
        // '/wallet': (context) => WalletV2(),
        '/home': (context) => Home(),
        '/signIn': (context) => SignInPage(),
        '/signUp': (context) => SignUpPage(),
      },
    ),
  ));
}