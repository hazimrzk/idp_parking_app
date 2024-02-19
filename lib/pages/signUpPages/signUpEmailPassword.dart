import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';

class SignUpEmailPassword extends StatefulWidget {
  const SignUpEmailPassword({Key? key}) : super(key: key);

  @override
  State<SignUpEmailPassword> createState() => _SignUpEmailPasswordState();
}

class _SignUpEmailPasswordState extends State<SignUpEmailPassword> {
  // late PageController inheritedController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: uiPaddingTop,),

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
                    child: TextField(
                      decoration: uiFieldDecoration,
                    ),
                  ),
                  Padding(
                    padding: uiPaddingAll,
                    child: Text("PASSWORD"),
                  ),
                  Padding(
                    padding: uiPaddingUSides,
                    child: TextField(
                      obscureText: true,
                      decoration: uiFieldDecoration,),
                  ),
                  Padding(
                    padding: uiPaddingAll,
                    child: Text("CONFIRM PASSWORD"),
                  ),
                  Padding(
                    padding: uiPaddingUSides,
                    child: TextField(
                      obscureText: true,
                      decoration: uiFieldDecoration,),
                  ),

                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingUSides,
                    child: TextButton(
                      onPressed: () {
                        // verify form and create account
                        //pageController.animateToPage

                      },
                      child: Text("Create Account"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
