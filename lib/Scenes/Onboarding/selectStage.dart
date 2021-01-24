import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coexist_gaming/Models/stageModel.dart';

import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class SelectStageClass extends StatefulWidget {
  static const routeName = '/SelectStageClass';
  final Function callback;
  SelectStageClass(this.callback);

  @override
  State<StatefulWidget> createState() {
    return _SelectStageClassState();
  }
}

class _SelectStageClassState extends State<SelectStageClass> {
  int _current = 0;
  List<StageModelClass> stages = [];
  String username = "USERNAME";
  String avatar;
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
        });
      });
    });

    OnboardingRepository.readStageData().then((value) {
      setState(() {
        this.stages = value;
      });
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  saveStage() {
    getuserID().then((value) {
      print(selectImage);
      OnboardingRepository.updateStage(selectImage, value);
      if (widget.callback != null) {
        widget.callback(2);
      } else {
        Navigator.pop(context, "dataLoadding");
      }
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
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
    for (int i = 0; i < stages.length; i++) {
      list.add(i == _current ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D1D),
      body: Stack(children: <Widget>[
        stages.length != 0
            ? Column(children: [
                CarouselSlider.builder(
                  itemCount: stages.length,
                  itemBuilder: (context, index) {
                    if (!onchange) {
                      selectImage = stages[0].name;
                    }
                    return _loadBgImage(stages[index].name);
                  },
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          onchange = true;
                          _current = index;
                          selectImage = stages[index].name;
                        });
                      }),
                ),
              ])
            : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar != null
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
                  "CHOOSE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  "YOUR STAGE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 60),
                Text(
                  "SWIPE FOR OPTIONS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 60),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator()),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: 49,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      saveStage();
                    },
                    color: Color(0xFF05821A),
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

  Widget _loadBgImage(String img) {
    return CachedNetworkImage(
      imageUrl: img,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.darken),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
