import 'package:carousel_slider/carousel_slider.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/Onboarding/selectController.dart';
import 'package:coexist_gaming/Scenes/Onboarding/selectStage.dart';
import 'package:coexist_gaming/Scenes/Onboarding/shareAccount.dart';
import 'package:coexist_gaming/Scenes/Onboarding/username.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'chooseAvatar.dart';
import 'favFive.dart';

class OnboardingClass extends StatefulWidget {
  static const routeName = '/OnboardingClass';
  OnboardingClass({Key key}) : super(key: key);
  @override
  _OnboardingClassState createState() => _OnboardingClassState();
}

class _OnboardingClassState extends State<OnboardingClass> {
  int _currentIndex = 0;
  //List cardList =
  List cardList = [];
  String userID = "";
  final CarouselController _controller = CarouselController();
  AvatarClass _avatarClass;
  SelectStageClass _selectStageClass;
  SelectControllerClass _selectControllerClass;
  SelectFavFiveClass _favFiveClass;
  ShareAccountClass _shareAccountClass;
  var userNameText = "";
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  void hungryBear(String userName) {
    print("$userName is hungry");
    setState(() {
      userNameText = userName;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    getuserID().then((id) {
      userID = id;
    });

    getusername().then((name) {
      if (name != "null") {
        userNameText = name;
      } else {
        userNameText = "";
      }
    });

    _selectStageClass = SelectStageClass(callback);
    _avatarClass = AvatarClass(callback);
    _selectControllerClass = SelectControllerClass(callback);
    _favFiveClass = SelectFavFiveClass(callback);
    _shareAccountClass = ShareAccountClass(callback);

    cardList = [
      UsernameClass(
        false,
        "Mark",
        (babyBear) {
          hungryBear(babyBear);
        },
      ),
      _avatarClass,
      _selectStageClass,
      _selectControllerClass,
      _favFiveClass,
      _shareAccountClass
    ];
  }

  Future<String> getusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERNAME);
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  void callback(int id) {
    setState(() {
      if (id == 6) {
        Navigator.pushNamed(context, "/EditProfileClass", arguments: false);
      } else {
        _controller.nextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        bottomNavigationBar: Stack(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                    scrollPhysics: new NeverScrollableScrollPhysics(),
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        print("index : " + index.toString());
                        _currentIndex = index;
                      });
                    }),
                items: cardList.map((card) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      //height: MediaQuery.of(context).size.height*0.30,
                      child: Container(
                        color: Colors.white,
                        child: card,
                      ),
                    );
                  });
                }).toList(),
              ),
            ],
          ),
          Positioned(
            child: new Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(cardList, (index, url) {
                    return Container(
                      width: 15.0,
                      height: 15.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 50.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentIndex
                              ? Colors.white
                              : Colors.grey),
                    );
                  }),
                )),
          ),
          _currentIndex != 0
              ? Positioned(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                      child: new Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: IconButton(
                          icon: Image.asset('assets/back.png'),
                          iconSize: 48,
                          onPressed: () {
                            _controller.previousPage();
                          },
                        ),
                      )))
              : Container(),
          _currentIndex == 0
              ? Positioned(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                      child: new Align(
                        alignment: FractionalOffset.bottomRight,
                        child: IconButton(
                          icon: Image.asset('assets/next.png'),
                          iconSize: 48,
                          onPressed: () {
                            if (userNameText.toString().trim().toString() ==
                                "") {
                              Constants.showMyDialog(
                                  "alert", "Please Enter user name,", context);
                            } else {
                              _controller.nextPage();
                              OnboardingRepository.updateUsername(
                                  userNameText.toString(), userID);
                            }
                          },
                        ),
                      )))
              : Container(),
        ]),
      ),
    );
  }
}
