import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Repositiory/settingsRepository.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/initialPage.dart';
import 'package:coexist_gaming/Scenes/Onboarding/shareAccount.dart';
import 'package:coexist_gaming/Scenes/Profile/editProfile.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsClass extends StatefulWidget {
  SettingsClass({Key key}) : super(key: key);
  static const routeName = '/SettingsClass';
  @override
  _SettingsClassState createState() => _SettingsClassState();
}

class _SettingsClassState extends State<SettingsClass> {
  bool isPushSwitched = false;
  bool isEmailswitched = false;
  bool isTextSwitched = false;
  bool isSocialSwitch = false;
  bool isSquadSwitch = false;
  var userID = "";

  @override
  void initState() {
    super.initState();
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        userID = id;
        setState(() {
          isPushSwitched = value[Parameters.isPushNotificationEnabled];
          isEmailswitched = value[Parameters.isEmailNotificationEnabled];
          isTextSwitched = value[Parameters.isTextNotificationEnabled];
          isSocialSwitch = value[Parameters.shareSocialEnabled];
          isSquadSwitch = value[Parameters.allowSquadInvites];
        });
      });
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D1D),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D2D2D),
        title: Text(
          "SETTINGS",
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
            addHeadings("NOTIFICATIONS"),
            addPushSwitch(),
            addEmailSwitch(),
            addTextSwitch(),
            space(),
            space(),
            space(),
            space(),
            addHeadings("PRIVACY SETTINGS"),
            addSocailSwitch(),
            allowSquadSwitch(),
            space(),
            space(),
            space(),
            space(),
            addHeadings("ACOUNT SETTINGS"),
            space(),
            space(),
            space(),
            space(),
            addSubheading("EDIT SOCIAL ACCOUNTS"),
            // space(),
            // space(),
            // space(),
            // space(),
            // addSubheading("CHANGE PASSWORD"),
            space(),
            space(),
            space(),
            space(),
            addSubheading("LOGOUT"),
          ],
        ),
      ),
    );
  }

  addHeadings(String str) {
    return Text(str,
        style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.PrimaryFont,
            fontSize: 18,
            fontWeight: FontWeight.bold));
  }

  addSubheading(String str) {
    return InkWell(
      child: Text(str,
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.PrimaryFont,
            fontSize: 18,
          )),
      onTap: () {
        if (str == "CHANGE PASSWORD") {
          if (Constants.isGuestLogin) {
            Fluttertoast.showToast(msg: "Please login to access this feature.");
          } else {
            Navigator.pushNamed(context, '/ForgotPasswordClass');
          }
        } else if (str == "LOGOUT") {
          logoutDialog("LOGOUT", "Are you sure you want to Logout?");
        } else if (str == "EDIT SOCIAL ACCOUNTS") {
          if (Constants.isGuestLogin) {
            Fluttertoast.showToast(msg: "Please login to access this feature.");
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShareAccountClass(null),
                ));
          }
        }
      },
    );
  }

  space() {
    return SizedBox(
      height: 5,
    );
  }

  addPushSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        addSubheading("PUSH NOTIFICATION"),
        Switch(
          value: isPushSwitched,
          onChanged: (value) {
            setState(() {
              isPushSwitched = value;
              print(isPushSwitched);
              SettingsRepository.updatePushSettings(userID, value);
            });
          },
          inactiveTrackColor: Color(0xFF414141),
          activeTrackColor: Color(0xFF414141),
          activeColor: Color(0xFF04F894),
        ),
      ],
    );
  }

  addEmailSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        addSubheading("EMAIL NOTIFICATION"),
        Switch(
          value: isEmailswitched,
          onChanged: (value) {
            setState(() {
              isEmailswitched = value;
              print(isEmailswitched);
              SettingsRepository.updateEmailSettings(userID, value);
            });
          },
          inactiveTrackColor: Color(0xFF414141),
          activeTrackColor: Color(0xFF414141),
          activeColor: Color(0xFF04F894),
        ),
      ],
    );
  }

  addTextSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        addSubheading("TEXT NOTIFICATION"),
        Switch(
          value: isTextSwitched,
          onChanged: (value) {
            setState(() {
              isTextSwitched = value;
              print(isTextSwitched);
              SettingsRepository.updateTextSettings(userID, value);
            });
          },
          inactiveTrackColor: Color(0xFF414141),
          activeTrackColor: Color(0xFF414141),
          activeColor: Color(0xFF04F894),
        ),
      ],
    );
  }

  addSocailSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        addSubheading("SHARE SOCIAL WITH MEMBERS"),
        Switch(
          value: isSocialSwitch,
          onChanged: (value) {
            if (!Constants.isGuestLogin) {
              setState(() {
                isSocialSwitch = value;
                print(isSocialSwitch);
                SettingsRepository.updateSocialSettings(userID, value);
              });
            } else {
              Fluttertoast.showToast(
                  msg: "Please login to access this feature.");
            }
          },
          inactiveTrackColor: Color(0xFF414141),
          activeTrackColor: Color(0xFF414141),
          activeColor: Color(0xFF04F894),
        ),
      ],
    );
  }

  allowSquadSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        addSubheading("ALLOW SQUAD INVITES"),
        Switch(
          value: isSquadSwitch,
          onChanged: (value) {
            setState(() {
              isSquadSwitch = value;
              print(isSquadSwitch);
              SettingsRepository.updateSquadInviteSettings(userID, value);
            });
          },
          inactiveTrackColor: Color(0xFF414141),
          activeTrackColor: Color(0xFF414141),
          activeColor: Color(0xFF04F894),
        ),
      ],
    );
  }

  logoutDialog(String title, String msg) async {
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
                      fontFamily: Constants.PrimaryFont,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 48,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: Constants.PrimaryFont,
                              fontSize: 18.0,
                            ),
                          ),
                          color: Colors.pink,
                          onPressed: () {
                            logout();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: Constants.PrimaryFont,
                              fontSize: 18.0,
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USERID);
    var auth = Auth();
    auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => InitialPage()));
  }
}
