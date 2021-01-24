import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'loginPage.dart';

class ForgotPasswordClass extends StatefulWidget {
  static const routeName = '/ForgotPasswordClass';
  ForgotPasswordClass({Key key}) : super(key: key);
  @override
  _ForgotPasswordClassState createState() => _ForgotPasswordClassState();
}

class _ForgotPasswordClassState extends State<ForgotPasswordClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          BackgroundWidget(),
          SingleChildScrollView(
            child: _buildMainWidget(),
          )
        ]));
  }

  Widget _buildMainWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 60, 30, 40),
      child: Column(
        children: <Widget>[
          Image.asset("assets/logo.png",
              width: MediaQuery.of(context).size.width - 20),
          SizedBox(height: 30),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: Constants.MontserratFont,
                      fontWeight: FontWeight.w600),
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Current Password',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: Constants.MontserratFont,
                      fontWeight: FontWeight.w600),
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: Constants.MontserratFont,
                      fontWeight: FontWeight.w600),
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ))),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {},
              color: Constants.buttonRedColor,
              textColor: Colors.white,
              child: Text(
                "UPDATE PASSWORD",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constants.MontserratFont),
              ),
            ),
          ),
          SizedBox(height: 20),
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
