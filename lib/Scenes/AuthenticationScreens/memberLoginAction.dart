import 'dart:ui';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/verifyEmail.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'loginPage.dart';

class MemberLoginActionClass extends StatefulWidget {
  static const routeName = '/MemberLoginActionClass';
  MemberLoginActionClass({this.auth});
  final BaseAuth auth;
  @override
  _MemberLoginActionClassState createState() => _MemberLoginActionClassState();
}

class _MemberLoginActionClassState extends State<MemberLoginActionClass> {
  var auth = new Auth();
  @override
  Widget build(BuildContext context) {
    auth = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          BackgroundWidget(),
          _buildMainWidget(),
        ]));
  }

  Widget _buildMainWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 60, 40, 40),
      child: Column(
        children: <Widget>[
          Image.asset("assets/logo.png"),
          SizedBox(height: 40),
          Text(
            "Not a member.",
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 5),
          InkWell(
            child: Text(
              "Learn More.",
              style: TextStyle(
                  fontSize: 13.0,
                  color: Constants.pistaGreenColor,
                  fontFamily: Constants.PrimaryFont),
            ),
            onTap: () {},
          ),
          SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 + 20,
            height: 49,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, VerifyEmailClass.routeName,
                    arguments: auth);
              },
              color: Colors.white,
              textColor: Colors.black,
              child: Text(
                "First time logging in",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 + 20,
            height: 49,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Colors.white)),
              color: Colors.transparent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, LoginClass.routeName);
              },
              child: Text(
                "Returning Member",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 5),
          IconButton(
            icon: Image.asset('assets/back.png'),
            iconSize: 50,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
