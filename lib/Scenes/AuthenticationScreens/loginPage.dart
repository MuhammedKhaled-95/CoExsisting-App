import 'dart:ui';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/Home/baseTabbarClass.dart';
import 'package:coexist_gaming/Scenes/Onboarding/chooseAvatar.dart';
import 'package:coexist_gaming/Scenes/Onboarding/onboardingClass.dart';
import 'package:coexist_gaming/Scenes/Onboarding/welcomePage.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class LoginClass extends StatefulWidget {
  static const routeName = '/LoginClass';

  LoginClass({Key key}) : super(key: key);
  @override
  _LoginClassState createState() => _LoginClassState();
}

class _LoginClassState extends State<LoginClass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var auth = new Auth();

  @override
  void initState() {
    super.initState();
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

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

  validateAndsave() {
    if (_formKey.currentState.validate()) {
      print(_emailController.text);
      print(_passwordController.text);
      auth
          .signIn(_emailController.text, _passwordController.text)
          .then((value) {
        print(value);
        switch (value) {
          case "Success":
            getuserID().then((user) {
              auth.updateFCMToken();
              OnboardingRepository.getUser(user).then((value) {
                if (value != null) {
                  if (value["Username"] == null ||
                      value["AvatarImage"] == null ||
                      value["StageImage"] == null ||
                      value["WeaponImage"] == null ||
                      value["favArray"] == null) {
                    Navigator.pushNamed(context, WelcomePage.routeName);
                  } else {
                    Navigator.pushNamed(context, BasetabbarClass.routeName);
                  }
                } else {
                  Navigator.pushNamed(context, WelcomePage.routeName);
                }
              });
            });
            break;
          case "Email_Not_Verified":
            showMyDialog("Alert", VERIFY_MAIL_STRING, context);
            break;
          default:
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
              SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Email.';
                        }
                        return null;
                      },
                      controller: _emailController,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: Constants.MontserratFont,
                          fontWeight: FontWeight.w600),
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Password.';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: Constants.MontserratFont,
                          fontWeight: FontWeight.w600),
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                    validateAndsave();
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
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Text(
                  "By continuing, you agree to accept our Privacy Policy & Terms of Service.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: Constants.MontserratFont,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {},
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

class BackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/blurBg.webp"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
