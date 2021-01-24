import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

class AboutClass extends StatefulWidget {
  static const routeName = '/AboutClass';
  AboutClass({Key key}) : super(key: key);

  @override
  _AboutClassState createState() => _AboutClassState();
}

class _AboutClassState extends State<AboutClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D1D1D),
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            "ABOUT",
            style: Constants.navigationTitleStyle,
          ),
          leading: IconButton(
            icon: Image.asset(
              "assets/back.png",
              width: 33,
              height: 33,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addAboutText(),
              space(),
              addversion(),
              space(),
              addtermsText(),
              space(),
              addprivacyText(),
              space(),
              addSupportText()
            ],
          ),
        ));
  }

  addAboutText() {
    return Text("ABOUT",
        style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.PrimaryFont,
            fontSize: 18,
            fontWeight: FontWeight.bold));
  }

  space() {
    return SizedBox(
      height: 15,
    );
  }

  addversion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[addVersionText(), addVersionNo()],
    );
  }

  addVersionText() {
    return Text("VERSION",
        style: TextStyle(
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontSize: 18,
        ));
  }

  addVersionNo() {
    return Text("1.0.0",
        style: TextStyle(
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontSize: 18,
        ));
  }

  addtermsText() {
    return Text("TERMS AND CONDITIONS",
        style: TextStyle(
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontSize: 18,
        ));
  }

  addprivacyText() {
    return Text("PRIVACY POLICY",
        style: TextStyle(
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontSize: 18,
        ));
  }

  addSupportText() {
    return Text("SUPPORT",
        style: TextStyle(
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontSize: 18,
        ));
  }
}
