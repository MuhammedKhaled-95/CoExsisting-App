import 'dart:ui';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/Onboarding/onboardingClass.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class UsernameClass extends StatefulWidget {
  static const routeName = '/UsernameClass';
  final bool isFromEdit;
  final Function onBearAction;
  final String userName;

  UsernameClass(this.isFromEdit, this.userName, this.onBearAction);

  @override
  _UsernameClassState createState() => _UsernameClassState();
}

class _UsernameClassState extends State<UsernameClass> {
  final _formKey = GlobalKey<FormState>();
  String userID = "";
  TextEditingController username = TextEditingController();

  @override
  void initState() {
    super.initState();
    getuserID().then((id) {
      userID = id;
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          if (value['Username'] != "null") {
            username.text = value['Username'];
            print(value['Username']);
            saveUsername(username.text);
          }
        });
      });
    });
  }

  saveUsername(String str) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USERNAME, str);
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  saveMethod() {
    OnboardingRepository.updateUsername(username.text, userID);
    Navigator.pop(context, "dataLoadding");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF5378C1),
        body: Stack(children: [
          _loadBgImage(),
          SingleChildScrollView(
            child: _buildMainWidget(),
          )
        ]));
  }

  Widget _buildMainWidget() {
    return new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget.isFromEdit
                      ? Positioned(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: new Align(
                                alignment: FractionalOffset.topLeft,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              )))
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Enter Your ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontFamily: Constants.PrimaryFont,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Username",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontFamily: Constants.PrimaryFont,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Username';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            widget.onBearAction(text);
                          },
                          controller: username,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: Constants.MontserratFont,
                              fontWeight: FontWeight.w600),
                          autocorrect: true,
                          decoration: InputDecoration(
                            hintText: 'UserName',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ))),
                  widget.isFromEdit
                      ? Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: 49,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  saveMethod();
                                }
                              },
                              color: Color(0xFF05821A),
                              textColor: Colors.white,
                              child: Text(
                                "DONE",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: Constants.PrimaryFont),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            )));
  }

  Widget _loadBgImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/usernameBg.webp"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
