import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'loginPage.dart';

class NewPasswordClass extends StatefulWidget {
  static const routeName = '/NewPasswordClass';
  NewPasswordClass({Key key}) : super(key: key);
  @override
  _NewPasswordClassState createState() => _NewPasswordClassState();
}

class _NewPasswordClassState extends State<NewPasswordClass> {
  final _formKey = GlobalKey<FormState>();

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
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 60, 30, 40),
          child: Column(
            children: <Widget>[
              Image.asset("assets/logo.png",
                  width: MediaQuery.of(context).size.width - 20),
              SizedBox(height: 40),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: Constants.MontserratFont,
                          fontWeight: FontWeight.w600),
                      autocorrect: true,
                      obscureText: true,
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
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: Constants.MontserratFont,
                          fontWeight: FontWeight.w600),
                      autocorrect: true,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please confirm Password';
                        }
                        return null;
                      },
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
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.pushNamed(context, '/WelcomePage');
                    }
                  },
                  color: Constants.buttonRedColor,
                  textColor: Colors.white,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: Constants.MontserratFont),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
