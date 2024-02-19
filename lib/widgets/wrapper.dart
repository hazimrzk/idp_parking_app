import 'package:flutter/material.dart';
import 'package:idp_parking_app/pages/home.dart';
import 'package:idp_parking_app/pages/signIn.dart';
import 'package:idp_parking_app/services/authService.dart';
import 'package:idp_parking_app/services/userModel.dart';
import 'package:provider/provider.dart';

import '../uiElements.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authServiceProvided = Provider.of<AuthService>(context);
    return StreamBuilder<UserAccount?>(
      stream: authServiceProvided.user,
      builder: (_, AsyncSnapshot<UserAccount?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserAccount? user = snapshot.data;
          return user == null ? SignInPage() : Home();
        } else {
          return Scaffold(
            backgroundColor: uiColorBackground,
            extendBodyBehindAppBar: true,
            body: Center(child: CircularProgressIndicator(),),
          );
        }
      },
    );
  }
}


