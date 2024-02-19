import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authService.dart';
import '../uiElements.dart';

class Ready extends StatefulWidget {

  const Ready({Key? key, required this.createAccountData}) : super(key: key);
  final Map<String,dynamic> createAccountData;

  @override
  State<Ready> createState() => _ReadyState();
}

class _ReadyState extends State<Ready> {

  bool readyToShowDialog = false;

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final dbInstance = Provider.of<FirebaseDatabase>(context);

    Future<void> createNow() async {
      print('run createNow');
      print(widget.createAccountData);
      // if (get update from confirm details button)
      try {
        await authService.signUpWithEmailAndPassword(widget.createAccountData['email'], widget.createAccountData['password']);
        String uidPath =authService.uid!;
        print('doneRegister');

        final DatabaseReference userRef = dbInstance.ref('Users/');
        await userRef.update(
            { widget.createAccountData['plate']: {
              'uid' : uidPath,
              'email': widget.createAccountData['email'],
              'password': widget.createAccountData['password'],
              'username': widget.createAccountData['username'],
              'plate': widget.createAccountData['plate'],
              'paymentMethod' : widget.createAccountData['paymentMethod'],
              'cardNumber' : widget.createAccountData['cardNumber'],
              'ARAllowed' : widget.createAccountData['ARAllowed'],
              'ARAmount' : widget.createAccountData['ARAmount'],
              'ARTrigger' : widget.createAccountData['ARTrigger'],
              'balance': 10,
              'parkStatus': false,
              'parkLocation': "",
              'parkTime': 0,
            }}
        );

        print("doneSetData");

        final DatabaseReference emailRef = dbInstance.ref('RegisteredEmails/');
        await emailRef.update({ widget.createAccountData['plate']: widget.createAccountData['email'] });
        print("doneSetEmail");

        final DatabaseReference plateRef = dbInstance.ref('RegisteredPlates/');
        await plateRef.update({ widget.createAccountData['uid']: widget.createAccountData['plate'] });
        print("doneSetPlate");

      } on FirebaseAuthException catch (e) {
        print('failedCreate');
        showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("Error"),
              content: Text(e.message!),
              actions: [
                TextButton(
                    onPressed: () {Navigator.popUntil(context, ModalRoute.withName('/'));},
                    child: Text("OK"))
              ],
            )
        );
      }
    }

    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: uiColorTransparent,
        flexibleSpace: uiAppBarBlur,
        centerTitle: true,
        title: Text("Sign Up"),
      ),
      body: FutureBuilder(
        future: createNow(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ReadyScreen();
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}


class ReadyScreen extends StatelessWidget {
  const ReadyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(padding: uiPaddingTop,),

        Padding(padding: uiPaddingTop),
        Padding(
          padding: uiPaddingUSides,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('All Set!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: uiTextTitleL,
                ),
              ),
              Text('Your account is set up. Please enjoy our app.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: uiPaddingAll,
                child: TextButton(
                  child: Text('Go to Home'),
                  onPressed: () {Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(padding: uiPaddingTop,),
        Padding(
          padding: uiPaddingUSides,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: uiPaddingUSides,
                child: CupertinoActivityIndicator(),
              ),
              Padding(
                padding: uiPaddingUSides,
                child: Text("Setting up your account..."),
              ),
            ],
          ),
        ),
      ],
    );
  }
}