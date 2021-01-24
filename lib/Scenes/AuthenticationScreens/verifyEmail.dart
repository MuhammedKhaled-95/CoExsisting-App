import 'dart:ui';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'loginPage.dart';

class VerifyEmailClass extends StatefulWidget {
  static const routeName = '/VerifyEmailClass';
  VerifyEmailClass({this.auth});
  final BaseAuth auth;

  @override
  _VerifyEmailClassState createState() => _VerifyEmailClassState();
}

class _VerifyEmailClassState extends State<VerifyEmailClass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = "";
  String _password = "";
  var auth;

  @override
  Widget build(BuildContext context) {
    // auth = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          BackgroundWidget(),
          SingleChildScrollView(
            child: _buildMainWidget(),
          )
        ]));
  }

  @override
  void initState() {
    super.initState();
    auth = Auth();
  }

  validateAndsave() {
    if (_formKey.currentState.validate()) {
      _email = _emailController.text;
      _password = _passwordController.text;
      auth.signUp(_email, _password).then((value) {
        if (value == "Success") {
          verifyDialog("Verify your account", VERIFY_MAIL_STRING);
        } else {
          showMyDialog("Alert", value, context);
        }
      });
    }
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
              SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      style: textfeildStyle,
                      controller: _emailController,
                      validator: (value) =>
                          value.isEmpty ? "Email can't be empty" : null,
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                      style: textfeildStyle,
                      obscureText: true,
                      validator: (value) =>
                          value.isEmpty ? "Please enter Password" : null,
                      controller: _passwordController,
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
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () {
                    validateAndsave();
                  },
                  color: Constants.buttonRedColor,
                  textColor: Colors.white,
                  child: Text(
                    "JOIN US",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: Constants.MontserratFont),
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
        ));
  }

  verifyDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    msg,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: PrimaryFont,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: PrimaryFont,
                          fontSize: 18.0,
                        ),
                      ),
                      color: Colors.pink,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
