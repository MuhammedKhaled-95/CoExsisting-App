import 'package:carousel_slider/carousel_slider.dart';
import 'package:coexist_gaming/Models/stageModel.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SelectControllerClass extends StatefulWidget {
  static const routeName = '/SelectControllerClass';
  final Function callback;
  SelectControllerClass(this.callback);
  @override
  State<StatefulWidget> createState() {
    return _SelectControllerState();
  }
}

class _SelectControllerState extends State<SelectControllerClass> {
  int _current = 0;
  List<Widget> imageSliders = [];
  List<ControllerModelClass> controllers = [];
  String stage = "";
  String username = "USERNAME";
  String avatar = "";
  bool onchange = false;
  String selectImage = "";

  @override
  void initState() {
    super.initState();
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          username = value['Username'];
          avatar = value['AvatarImage'];
          stage = value['StageImage'];
          print(stage);
        });
      });
    });
    OnboardingRepository.getControllers().then((value) {
      setState(() {
        this.controllers = value;
      });
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  saveWeapon() {
    getuserID().then((value) {
      print(selectImage);
      OnboardingRepository.updateWeapon(selectImage, value);
      if (widget.callback != null) {
        widget.callback(2);
      } else {
        Navigator.pop(context, "dataLoadding");
      }
    });
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 40.0 : 40.0,
      decoration: BoxDecoration(
        color:
            isActive ? Color(0xFFDBDBDB) : Color(0xFF949090).withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < controllers.length; i++) {
      list.add(i == _current ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: <Widget>[
        stage != "" ? _loadBgImage() : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar != ""
                    ? Container(
                        width: 100,
                        height: 100,
                        child: CachedNetworkImage(imageUrl: avatar),
                      )
                    : Container(),
                Text(
                  "$username",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFFC4C5C7),
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  "CHOOSE YOUR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  "WEAPON",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 30),
                controllers.length != 0
                    ? Column(children: [
                        CarouselSlider.builder(
                          itemCount: controllers.length,
                          itemBuilder: (context, index) {
                            if (!onchange) {
                              selectImage = controllers[0].name;
                            }
                            return _loadControllerImage(
                                controllers[index].name);
                          },
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              height: MediaQuery.of(context).size.height * 0.20,
                              //viewportFraction: 1.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  onchange = true;
                                  _current = index;
                                  selectImage = controllers[index].name;
                                });
                              }),
                        ),
                      ])
                    : Container(),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator()),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: 49,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      saveWeapon();
                    },
                    color: _current == controllers.length - 1
                        ? Color(0xFFB40000)
                        : Color(0xFF05821A),
                    textColor: Colors.white,
                    child: Text(
                      "SELECT",
                      style: TextStyle(
                          fontSize: 16, fontFamily: Constants.PrimaryFont),
                    ),
                  ),
                ),
              ]),
        )
      ]),
    );
  }

  Widget _loadControllerImage(String img) {
    return CachedNetworkImage(
      imageUrl: img,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _loadBgImage() {
    return CachedNetworkImage(
      imageUrl: stage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.darken),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
