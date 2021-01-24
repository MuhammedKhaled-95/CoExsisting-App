import 'package:coexist_gaming/Scenes/Onboarding/onboardingClass.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:flutter/services.dart';

class WelcomePage extends StatefulWidget {
  static const routeName = '/WelcomePage';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
        },
        child: Scaffold(
            backgroundColor: Color(0xFF020E87),
            body: Stack(children: [
              _loadBgImage(),
              Center(
                child: _buildMainWidget(),
              )
            ])));
  }

  Widget _loadBgImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/welcome.webp"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMainWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 60, 40, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Text(
            "Welcome",
            style: TextStyle(
                fontSize: 50.0,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont),
          ),
          SizedBox(height: 25),
          Text(
            " Coexisting is an art,",
            style: TextStyle(
                fontSize: 22.0,
                color: Constants.buttonBlueColor,
                fontFamily: Constants.PrimaryFont),
          ),
          Text(
            "and it starts right here",
            style: TextStyle(
                fontSize: 22.0,
                color: Constants.buttonBlueColor,
                fontFamily: Constants.PrimaryFont),
          ),
          SizedBox(height: 35),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 + 20,
            height: 49,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, OnboardingClass.routeName);
              },
              color: Constants.buttonBlueColor,
              textColor: Colors.white,
              child: Text(
                "Choose Your Loadout",
                style:
                    TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
