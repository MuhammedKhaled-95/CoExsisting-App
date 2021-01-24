import 'package:coexist_gaming/Scenes/AuthenticationScreens/password.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'loginPage.dart';

class PasswordVerifyClass extends StatefulWidget {
  static const routeName = '/PasswordVerifyClass';
  PasswordVerifyClass({Key key}) : super(key: key);

  @override
  _PasswordVerifyClassState createState() => _PasswordVerifyClassState();
}

class _PasswordVerifyClassState extends State<PasswordVerifyClass> {
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
        child: Column(children: <Widget>[
          Image.asset("assets/logo.png",
              width: MediaQuery.of(context).size.width - 20),
          SizedBox(height: 40),
          Text(
            "We sent you a Verification email",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Flexible(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        children: List<Container>.generate(
                            4,
                            (int index) =>
                                Container(child: addPasswordTextFeilds()))),
                  ]),
            ),
          ),
          SizedBox(height: 40),
          Text(
            "Did not receive email?",
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 5),
          InkWell(
            child: Text(
              "RESEND",
              style: TextStyle(
                  fontSize: 13.0,
                  color: Constants.pistaGreenColor,
                  fontFamily: Constants.PrimaryFont),
            ),
            onTap: () {},
          ),
          SizedBox(height: 50),
          addVerifyButton(),
          SizedBox(height: 20),
          addBackIcon(context)
        ]));
  }

  Widget addPasswordTextFeilds() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: new Container(
        height: 30,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            color: Colors.transparent,
            border: new Border.all(
              width: 1.0,
              color: Colors.white24,
            ),
            borderRadius: new BorderRadius.circular(4.0)),
        child: new TextField(
          inputFormatters: [
//              LengthLimitingTextInputFormatter(1),
          ],
          textAlign: TextAlign.center,
          //controller: controller4,
          autofocus: false,
          enabled: false,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget addVerifyButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/NewPasswordClass');
        },
        color: Constants.buttonRedColor,
        textColor: Colors.white,
        child: Text(
          "VERIFY",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: Constants.MontserratFont),
        ),
      ),
    );
  }

  Widget addBackIcon(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/back.png'),
      iconSize: 50,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
