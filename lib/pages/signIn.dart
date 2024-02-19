import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idp_parking_app/services/authService.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  //Variables
  String givenEmail = "";
  String givenPassword = "";

  //Forms, validators, & controllers
  int pageIndex = 0;
  bool isValidAndProceed = false;
  bool isReadyToDismissLoadingIndicator = false;

  final _signInFormKey = GlobalKey<FormState>();

  // String? emailValidator(String? inputEmail) {
  //   if(inputEmail == null || !validator.email(inputEmail)) {return "Enter a valid email";}
  //   else {return null;}
  // }
  // String? passwordValidator(String? inputPlate) {
  //   if(inputPlate == null || !validator.mediumPassword(inputPlate)) {return "Password is not strong";}
  //   else {return null;}  }

  final PageController pageController = PageController(initialPage: 0,);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      //resizeToAvoidBottomInset: false,
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Form(
            key: _signInFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: uiPaddingTop,),
                Padding(
                  padding: uiPaddingUSides,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Icon(
                      Icons.local_parking,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: uiPaddingUSides,
                  child: Text('Smart Payment Parking System',
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(padding: uiPaddingTop),
                Padding(
                  padding: uiPaddingUSides,
                  child: Card(
                    elevation: uiElevation,
                    shape: uiCardShape,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(padding: uiPaddingTop),
                        Padding(
                          padding: uiPaddingAll,
                          child: Text("EMAIL"),
                        ),
                        Padding(
                          padding: uiPaddingUSides,
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: uiFieldDecoration,
                          ),
                        ),
                        Padding(
                          padding: uiPaddingAll,
                          child: Text("PASSWORD"),
                        ),
                        Padding(
                          padding: uiPaddingUSides,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: uiFieldDecoration,),
                        ),
                        Padding(padding: uiPaddingTop),
                        Padding(
                          padding: uiPaddingUSides,
                          child: TextButton(
                            onPressed: () async {
                              isReadyToDismissLoadingIndicator = false;
                              showDialog(context: context, barrierColor: Colors.transparent, builder: (BuildContext context) {return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: CupertinoActivityIndicator(),
                                );});
                              try {
                                await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
                                setState(() {isReadyToDismissLoadingIndicator = true;});
                              } on FirebaseAuthException catch (e) {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.message!),
                                      actions: [
                                        TextButton(
                                            onPressed: () {Navigator.pop(context);},
                                            child: Text("OK"))
                                      ],
                                    )
                                );}
                              if(isReadyToDismissLoadingIndicator) {Navigator.pop(context);};
                            },
                            child: Text("Log in"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(padding: uiPaddingTop),
                Padding(
                  padding: uiPaddingUSides,
                  child: Card(
                    elevation: uiElevation,
                    shape: uiCardShape,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(padding: uiPaddingTop),
                        Padding(
                          padding: uiPaddingUSides,
                          child: Text(
                            'Do not have an account? Create a profile now.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: uiPaddingUSides,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signUp');
                            },
                            child: Text("Sign up"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
