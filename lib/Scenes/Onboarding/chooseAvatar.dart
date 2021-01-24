import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coexist_gaming/Models/avatarModel.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarClass extends StatefulWidget {
  static const routeName = '/AvatarClass';

  final Function callback;

  AvatarClass(this.callback);

  @override
  _AvatarClassState createState() => _AvatarClassState();
}

class _AvatarClassState extends State<AvatarClass> {
  List<AvatarModelClass> avatars = [];
  String selectImage = "";
  String username = "USERNAME";
  PageController pageController;

  bool onchange = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1, viewportFraction: 0.8);
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          username = value['Username'];
        });
      });
    });

    OnboardingRepository.readData().then((List<AvatarModelClass> avatars) {
      setState(() {
        this.avatars = avatars;
      });
    });
  }

  saveAvatar() {
    getuserID().then((value) {
      print(selectImage);
      OnboardingRepository.updateAvatar(selectImage, value);
      if (widget.callback != null) {
        widget.callback(2);
      } else {
        Navigator.pop(context, "dataLoadding");
      }
    });
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
          _loadBgImage(),
          _buildMainWidget(),
        ]));
  }

  Widget _buildMainWidget() {
    return new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "$username",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFFC4C5C7),
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "SELECT YOUR AVATAR",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 20,
              ),
              avatars.length != 0
                  ?
                  // PageView.builder(
                  //         itemCount: avatars.length,
                  //         controller: pageController,
                  //         itemBuilder: (context, position) {
                  //           return imageSlider(position);
                  //         })
                  Container(
                      child: CarouselSlider.builder(
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              onchange = true;
                              selectImage = avatars[index].name;
                            });
                          },
                          enlargeCenterPage: false,
                          height: MediaQuery.of(context).size.height * 0.30,
                          enableInfiniteScroll: true),
                      itemCount: avatars.length,
                      itemBuilder: (context, index) {
                        AvatarModelClass avatar = avatars[index];
                        print("index :- " + index.toString());
                        if (!onchange) {
                          selectImage = avatars[0].name;
                        }
                        return Container(
                            child: CachedNetworkImage(
                          imageUrl: avatar.name,
                        ));
                      },
                    ))
                  : Container(),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                height: 49,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    saveAvatar();
                  },
                  color: Color(0xFF059A7B),
                  textColor: Colors.white,
                  child: Text(
                    "SELECT",
                    style: TextStyle(
                        fontSize: 16, fontFamily: Constants.PrimaryFont),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _loadBgImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/blurBg.webp"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  imageSlider(int index) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget) {
        return Center(
          child: SizedBox(
            height: 200,
            width: 300,
            child: widget,
          ),
        );
      },
      child: Container(
        child: Image.network(
          avatars[index].name,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
