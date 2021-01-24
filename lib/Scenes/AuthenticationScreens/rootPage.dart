import 'dart:async';

import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/initialPage.dart';
import 'package:coexist_gaming/Scenes/Home/baseTabbarClass.dart';
import 'package:coexist_gaming/Scenes/Onboarding/welcomePage.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/Services/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOADOUT_SET,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  static const routeName = '/RootPage';
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus;
  PushNotificationService _pushNotificationService;

  @override
  void initState() {
    super.initState();
    _pushNotificationService = PushNotificationService();
    initalise();
    Timer(
        Duration(seconds: 3),
        () => getuserID().then((user) {
              if (user != null) {
                OnboardingRepository.getUser(user).then((value) {
                  if (value != null) {
                    if (value[Parameters.isGuestLogin] == true) {
                      Constants.isGuestLogin = true;
                    } else {
                      Constants.isGuestLogin = false;
                    }
                    if (value["Username"] == null ||
                        value["AvatarImage"] == null ||
                        value["StageImage"] == null ||
                        value["WeaponImage"] == null ||
                        value["favArray"] == null) {
                      Navigator.pushNamed(context, WelcomePage.routeName);
                      authStatus = AuthStatus.LOADOUT_SET;
                    } else {
                      Navigator.pushNamed(context, BasetabbarClass.routeName);
                      authStatus = AuthStatus.LOGGED_IN;
                    }
                  } else {
                    Navigator.pushNamed(context, WelcomePage.routeName);
                    authStatus = AuthStatus.LOADOUT_SET;
                  }
                });
              } else {
                Navigator.pushNamed(context, InitialPage.routeName);
                authStatus = AuthStatus.NOT_LOGGED_IN;
              }
            }));
  }

  initalise() async {
    await _pushNotificationService.initialise();
    getuserID().then((user) {
      if (user != null) {
        widget.auth.updateFCMToken();
      } else {}
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        "assets/blurBg.webp",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    ));
  }
}
