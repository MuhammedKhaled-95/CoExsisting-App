import 'package:coexist_gaming/Scenes/AuthenticationScreens/memberLoginAction.dart';
import 'package:coexist_gaming/Scenes/Home/baseTabbarClass.dart';
import 'package:coexist_gaming/Scenes/Onboarding/welcomePage.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:flutter/services.dart';

class InitialPage extends StatefulWidget {
  static const routeName = '/InitialPage';
  InitialPage({this.auth});
  final BaseAuth auth;
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  var auth = new Auth();
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
        },
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.darken),
                  image: AssetImage("assets/bg.webp"),
                  fit: BoxFit.cover,
                ),
              ),
              child: _buildMainWidget()),
        ));
  }

  guestLogin() {
    Constants.isGuestLogin = true;
    auth.signInAnonymously().then((value) {
      switch (value) {
        case "Success":
          Navigator.pushNamed(context, BasetabbarClass.routeName);
          break;
        default:
          showMyDialog("Alert", "Something went wrong", context);
      }
    });
  }

  Widget _buildMainWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 60, 40, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/logo.png"),
          Spacer(),
          Text(
            "Coexisting is a vibe.",
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont),
          ),
          Text(
            "Get into it.",
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 168,
            height: 49,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () {
                Constants.isGuestLogin = false;
                Navigator.pushNamed(context, MemberLoginActionClass.routeName,
                    arguments: widget.auth);
              },
              color: Colors.white,
              textColor: Colors.black,
              child: Text(
                "I'm a Member",
                style:
                    TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 201,
            height: 49,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Colors.white)),
              color: Colors.transparent,
              textColor: Colors.white,
              onPressed: () {
                guestLogin();
              },
              child: Text(
                "Continue as Guest",
                style: TextStyle(
                    fontSize: 16.0, fontFamily: Constants.PrimaryFont),
              ),
            ),
          )
        ],
      ),
    );
  }
}
