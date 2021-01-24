library constants;

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

const String PrimaryFont = "Glacial Indifference";
const String MontserratFont = "Montserrat";

const PrimaryColor = Color(0xFF576ED6);
const pistaGreenColor = Color(0xFF00FFDC);
const buttonRedColor = Color(0xFF8B0023);
const buttonBlueColor = Color(0xFF2D68DE);
const PrimaryBlackColor = Color(0xFF161616);

const String RSVPFirstClass = "RSVPFirstClass";
const String RSVPFirstClass_desc = "Rsvp for your first class (50 points).";
const String RSVPFirstEvent = "RSVPFirstEvent";
const String RSVPFirstEvent_desc = "Rsvp for your first event (50 points).";

var isOnNotificationClass = false;
var isSQUADID = "";
bool isGuestLogin = false;

const FavFiveApi = "https://api.rawg.io/api/games";

const FirebaseServerKey =
    "AAAAVvXn6Zw:APA91bEzPGJmQw6d8Rl8Ua3peQtRRS37hq09RsnZxJjl3zEBtj_ozQSl9ilGt_UvMYMPBve7iP9d2tqyIrtbI79g6eJ8SPVHm5IYzLyHlldjv_MXEfavjzuf8WHLm97KHUfpnr3Ik9BS";
final kTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: PrimaryFont,
  fontSize: 26.0,
  height: 1.5,
);

final navigationTitleStyle = TextStyle(
    color: Colors.white,
    fontFamily: PrimaryFont,
    fontSize: 24.0,
    fontWeight: FontWeight.w600);

final textfeildStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: MontserratFont,
    fontWeight: FontWeight.w600);

Future<void> showMyDialog(
    String title, String msg, BuildContext context) async {
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
                    },
                  ),
                ),
              ],
            ),
          ));
    },
  );
}
