import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Models/partnerModel.dart';
import 'package:coexist_gaming/Repositiory/eventRepository.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/initialPage.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsClass extends StatefulWidget {
  RewardsClass({Key key}) : super(key: key);

  @override
  _RewardsClassState createState() => _RewardsClassState();
}

class _RewardsClassState extends State<RewardsClass> {
  List<String> rewards = List<String>();
  List<String> rewards2 = List<String>();
  String stage = "";
  bool categoryTap = false;
  List<Rewards> rewardsList = List<Rewards>();
  List<String> rewardIds = List<String>();
  String userID = "";
  var points = 0;
  bool isRedeemed = false;
  @override
  void initState() {
    super.initState();

    getUserDetail();
    rewards = [
      "FOOD & BEVERAGE",
      "TRANSPORTATION",
      "RETAILERS",
      "ENTERTAINMENT",
      "ELECTRONICS",
      "FITNESS",
      "ARTS"
    ];

    rewards2 = [
      "FREE LYFT RIDES TO COEXIST GAME HOUSE",
      "REDEEM 1,000 ROBUX ON ROBLOX ",
      "FREE LYFT RIDES TO COEXIST GAME HOUSE",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: [
            _loadBgImage(),
            //  _loadBgImage(viewportConstraints),
            Constants.isGuestLogin ? _builtGuestWidget() : _buildMainWidget(),
            SafeArea(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: heading())),
          ]));
    });
  }

  Widget _loadBgImage() {
    return stage != ""
        ? CachedNetworkImage(
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
          )
        : Container();
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  getUserDetail() {
    getuserID().then((id) {
      userID = id;
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          if (value["StageImage"] != null) {
            stage = value['StageImage'];
          } else {
            stage = "";
          }
          if (value["points"] != null) {
            points = value['points'];
          } else {
            points = 0;
          }
        });
      });

      EventRepository.getUsersRedeemedIDs(id).then((value) {
        value.snapshots().listen((event) {
          event.docs.forEach((element) {
            if (element.exists) {
              var obj = element["reward_id"];
              rewardIds.add(obj);
            }
          });
        });
      });
    });
  }

  getRewards(String type) {
    rewardsList = [];
    EventRepository.getRewards(
      type,
    ).then((value) {
      value.snapshots().listen((event) {
        event.docs.forEach((element) {
          if (element.exists) {
            bool hasId = rewardIds.contains(element.id);
            if (!hasId) {
              var obj = Rewards(
                  rid: element.id,
                  rdescription: element["description"],
                  rimage: element["image"],
                  rname: element["name"],
                  rpoints: element["points"],
                  rtype: element["type"],
                  isReedem: false);
              rewardsList.add(obj);
            }
          }
        });
      });
      setState(() {
        categoryTap = true;
      });
    });
    // print(rewardsList);
  }

  Widget _buildMainWidget() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: categoryTap ? addCardView() : addListView()));
  }

  Widget _builtGuestWidget() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please login with credentials to use this feature of app.',
                  style: Constants.kTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 48,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    onPressed: () {
                      logout();
                    },
                    color: Colors.pink,
                    textColor: Colors.white,
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.MontserratFont),
                    ),
                  ),
                ),
              ],
            )));
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USERID);
    var auth = Auth();
    auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => InitialPage()));
  }

  heading() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4527A0),
                const Color(0xFF7520A2),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "REWARDS",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.w500),
              ),
            )));
  }

  addListView() {
    return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: rewards.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xFFDE2D5D),
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                            child: Text(
                          rewards[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              fontFamily: Constants.PrimaryFont),
                        ))),
                    onTap: () {
                      getRewards(rewards[index]);
                    },
                  ));
            }));
  }

  addCardView() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.80,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: rewardsList.length + 1,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                  padding: EdgeInsets.all(10),
                  child: index != rewardsList.length
                      ? Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF0296B5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl: rewardsList[index].rimage,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          rewardsList[index]
                                              .rdescription
                                              .toUpperCase(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: Constants.PrimaryFont,
                                              fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    height: 40,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      onPressed: () {
                                        if (!rewardsList[index].isReedem) {
                                          updateRewardsPoints(
                                              rewardsList[index].rpoints,
                                              rewardsList[index].rid,
                                              rewardsList[index]);
                                        }
                                      },
                                      color: Color(0xFFDE2D5D),
                                      textColor: Colors.white,
                                      child: Text(
                                        rewardsList[index].isReedem
                                            ? "DONE"
                                            : "REEDEM",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: Constants.PrimaryFont),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : rewardsList.length == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "NO REWARDS FOUND",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: Constants.PrimaryFont,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                IconButton(
                                  icon: Image.asset('assets/back.png'),
                                  iconSize: 50,
                                  onPressed: () {
                                    setState(() {
                                      categoryTap = false;
                                    });
                                  },
                                )
                              ],
                            )
                          : IconButton(
                              icon: Image.asset('assets/back.png'),
                              iconSize: 50,
                              onPressed: () {
                                setState(() {
                                  categoryTap = false;
                                });
                              },
                            ));
            }));
  }

  updateRewardsPoints(rewardpoint, id, Rewards reward) {
    if (points >= rewardpoint) {
      var totalpoints = points - rewardpoint;
      setState(() {
        reward.isReedem = true;
      });
      OnboardingRepository.updateUserPoints(totalpoints, userID);
      updateRewardsRedeem(id);
    } else {
      Fluttertoast.showToast(
          msg: "You dont have enough points to redeem this reward.");
    }
  }

  updateRewardsRedeem(id) {
    Map<String, dynamic> dict = {
      "reward_id": id,
      "addedOn": DateTime.now(),
      "Userid": userID,
    };
    EventRepository.updateRewardsRdeem(dict);
    StateProvider _stateProvider = StateProvider();
    _stateProvider.notify(ObserverState.UPDATEPROFILE, null);
  }
}
