import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Models/squadModel.dart';
import 'package:coexist_gaming/Models/userModel.dart';
import 'package:coexist_gaming/Repositiory/eventRepository.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';

import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/chat/ChatScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Models/searchgameModel.dart';
import 'package:coexist_gaming/Repositiory/squadRepository.dart';
import 'package:coexist_gaming/Services/Webservice.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class SquadsClass extends StatefulWidget {
  SquadsClass({Key key}) : super(key: key);
  @override
  _SquadsClassState createState() => _SquadsClassState();
}

class _SquadsClassState extends State<SquadsClass> {
  final List<String> imgList = [
    "assets/calendar.webp",
    "assets/calendar.webp",
    "assets/calendar.webp",
  ];
  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  Results selectedGame = Results();
  String selectedSquadDate;
  String selectedTime;
  DateTime selectedTimestamp;
  String name;
  List<Results> _games = List();
  bool openSearchList = false;
  int min = 00;
  int hr = 1;
  int currenthr = 1;
  int currentMin = 00;
  int duration = 1;
  bool ishrButtonDisable = false;
  bool isAM = false;
  bool isNowButton = true;
  bool dataLoad = true;
  var loadData = false;
  int points = 0;

  List<UserModelClass> users = List<UserModelClass>();
  List<UserModelClass> selectedusers = List<UserModelClass>();
  List<SquadModelClass> squads = List<SquadModelClass>();
  List membersArray = List();

  String searchName = "";
  String squadID = "";
  String userId = "";
  String userAvatar = "";
  String userName = "";
  List<bool> isSelected = [true, false];

  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false; // track if products fetching
  bool hasMore = true;

  int squadCount = 0;

  @override
  void initState() {
    super.initState();
    setCurrentTime();
    getuserID().then((id) {
      userId = id;
      print("Userrrrrrrr kiii idddddd " + userId);
      OnboardingRepository.getUser(id).then((value) {
        userName = value['Username'];
        userAvatar = value['AvatarImage'];
        if (value["points"] != null) {
          points = value['points'];
        } else {
          points = 0;
        }
      });
    });
    //  var state = setState(() {

    //  });
    getUserSquads();
    getUsersSearchData();
    squadListGet();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        if (hasMore) {
          squadListGet();
        }
      }
    });
  }

  getUserSquads() {
    getuserID().then((id) {
      SquadRepository.getMySquadIDs(id).then((value) {
        value.snapshots().listen((event) {
          squadCount = event.docs.length;
          print(squadCount);
          event.docs.forEach((element) {});
        });
      });
    });
  }

  squadListGet() async {
    //loadData = false;
    if (!hasMore) {
      print('No More Products');

      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection(FirestorePath.createSquads())
          .limit(10)
          .get();
      //.get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection(FirestorePath.createSquads())
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }

    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    if (querySnapshot.docs.length > 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }

    HashMap<String, SquadModelClass> eventsHashMap =
        new HashMap<String, SquadModelClass>();
    querySnapshot.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
        element.id,
        () => SquadModelClass(
          squadID: element.id,
          ownerID: element[SquadModelClass.ownerId],
          timee: element[SquadModelClass.time],
          squadname: element[SquadModelClass.squadName],
          duraton: element[SquadModelClass.duration],
          timeestamp: element[SquadModelClass.timestamp],
          datee: element[SquadModelClass.date],
          members: element[SquadModelClass.membersId] != null
              ? element[SquadModelClass.membersId]
              : [],
          gamel: element[SquadModelClass.game] != null
              ? GameSquad.fromMap(element[SquadModelClass.game])
              : null,
        ),
      );
    });
    if (eventsHashMap.values.length != 0) {
      squads.addAll(eventsHashMap.values.toList());
      isLoading = false;
      update();
    }
  }

  update() {
    squads = squads.toSet().toList();
    setState(() {
      print("loadedddd dataaaaaa");
      loadData = true;
    });
  }

  // updateArray() async {
  //   for (var element in squads) {
  //     List<Member> _members = List();
  //     for (int i = 0; i < element.members.length; i++) {
  //       await OnboardingRepository.getUser(element.members[i]).then((value) {
  //         _members.add(
  //             Member(memberId: value["Userid"], name: value["AvatarImage"]));
  //       });
  //     }
  //     element.memberArry = _members;
  //   }
  //   setState(() {
  //     print("loadedddd dataaaaaa");
  //     loadData = true;
  //   });
  // }

  setCurrentTime() {
    var date = DateTime.now();
    hr = date.hour;
    min = date.minute;
    final dfHr = new DateFormat('hh');
    var hrtemp = dfHr.format(date);
    print(hrtemp);
    hr = int.parse(hrtemp);
    currenthr = hr;
    final dfMM = new DateFormat('mm');
    var mmtemp = dfMM.format(date);
    currentMin = int.parse(mmtemp);
    min = int.parse(mmtemp);
    final df = new DateFormat('a');
    var dfHrs = new DateFormat('MMMM dd,yyyy');
    var hrtemps = dfHrs.format(date);
    selectedSquadDate = hrtemps;
    var dftime = new DateFormat('hh:mm a');
    var time = dftime.format(date);
    selectedTime = time;
    selectedTimestamp = date;
    var temp = df.format(date);
    if (temp == "PM") {
      isAM = false;
    } else {
      isAM = true;
    }
  }

  getAllUsers(setModalState) {
    EventRepository.getuserModelClass().then((value) {
      setModalState(() {
        if (value.length != 0) {
          users = value;
        }
      });
    });
  }

  getUsersSearchData() {
    if (searchName == "" || searchName == null) {
      EventRepository.getuserModelClass().then((value) {
        setState(() {
          if (value.length != 0) {
            users = value;
          }
        });
      });
    } else {
      EventRepository.getSearchUser(searchName).then((value) {
        value.snapshots().listen((event) {
          setState(() {
            users = [];
            if (event.docs.length != 0) {
              event.docs.forEach((element) {
                print(element["token"]);
                var obj = UserModelClass(
                    userName: element["Username"],
                    userId: element["Userid"],
                    avatarImage: element["AvatarImage"],
                    fcmToken: element["token"],
                    isPushEnable: element[Parameters.isPushNotificationEnabled],
                    isUserSelected: false,
                    squadInviteEnable: element[Parameters.allowSquadInvites]);
                users.add(obj);
              });
            }
          });
        });
      });
    }
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 80, 10), child: _addButton()),
        backgroundColor: Colors.black,
        body: Stack(children: [
          _loadBgImage(),
          SafeArea(
            child: _buildMainWidget(),
          ),
          SafeArea(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: heading())),
        ]));
  }

  _showJoinMemberPage(SquadModelClass squad, String ownerImage) {
    bool isMember = false;
    for (var val in squad.members) {
      if (val["memberId"] == userId) {
        isMember = true;
        break;
      }
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.80,
                decoration: BoxDecoration(
                  color: Color(0xFF5525A1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _addRowName(squad, ownerImage),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ShaderMask(
                                    shaderCallback: (rect) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                      ).createShader(Rect.fromLTRB(
                                          0, 0, rect.width, rect.height));
                                    },
                                    blendMode: BlendMode.darken,
                                    child: squad.gamel.gameImage != null
                                        ? CachedNetworkImage(
                                            imageUrl: squad.gamel.gameImage,
                                            width: 93,
                                            height: 152,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(),
                                  ),
                                  Positioned.fill(
                                    bottom: 10,
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                            squad.gamel.gameName != null
                                                ? squad.gamel.gameName
                                                : "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _addtext(
                                        squad.datee, "assets/calendar.webp"),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _addtext(squad.timee, "assets/time.webp"),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _addSquadName(squad),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Positioned.fill(
                          bottom: 30,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: addJoinButton(isMember, squad.squadID,
                                squad.squadname, squad.members),
                          ))
                    ],
                  ),
                ));
          });
        });
  }

  addJoinButton(bool isMember, squadId, squadName, members) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Image.asset('assets/back.png'),
          iconSize: 48,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 49,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            onPressed: () {
              isMember
                  ? _naviagteToChat(context, squadId, squadName, members)
                  : _joinSquadMethod(squadId);
            },
            color: Color(0xFFDE2D5D),
            textColor: Colors.white,
            child: Text(
              isMember ? "CHAT" : "JOIN",
              style: TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
            ),
          ),
        ),
      ],
    );
  }

  _joinSquadMethod(squadId) {
    var member = Members(
        memberId: userId,
        memberName: userName,
        memberAvatr: userAvatar,
        isOwner: false);
    if (squadCount == 0 && Constants.isGuestLogin == true) {
      //Join a squad for the first time  as guest (50 points)
      points = points + 50;
      updateRewardsTable("First_Join_Squad", 50, points);
      Fluttertoast.showToast(
          msg: "Join a squad for the first time  as guest (50 points)");
    }

    SquadRepository.joinSquad(squadId, member.toJson());
    _refreshLocalGallery();
    Navigator.pop(context);
  }

  _addInviteMember(setModalState) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: BoxDecoration(
                color: Color(0xFF5525A1),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
              ),
              child: Padding(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.darken,
                              child:
                                  selectedGame.shortScreenshots[0].image != null
                                      ? CachedNetworkImage(
                                          imageUrl: selectedGame
                                              .shortScreenshots[0].image,
                                          width: 93,
                                          height: 152,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(),
                            ),
                            Positioned.fill(
                              bottom: 10,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                      selectedGame.name != null
                                          ? selectedGame.name
                                          : "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                              Text("SQUAD CREATED!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(nameController.text.toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xFFEF5DFF),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.PrimaryFont))
                            ]))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _addInviteSearchField(setModalState),
                    SizedBox(
                      width: 10,
                    ),
                    users.isNotEmpty
                        ? _addListView(setModalState)
                        : Container(),
                    SizedBox(
                      width: 5,
                    ),
                    addInviteButton(setModalState)
                  ],
                ),
                padding: EdgeInsets.all(20),
              ),
            );
          });
        });
  }

  Widget showMembers(SquadModelClass squad) {
    print(squad.members);

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: squad.members.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 40,
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: "${squad.members[index]["memberAavatar"]}",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _addtext(String text, String image) {
    return Row(
      children: <Widget>[
        Image.asset(image, width: 15, height: 15),
        SizedBox(
          width: 5,
        ),
        Text(text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: Constants.PrimaryFont))
      ],
    );
  }

  _addInviteSearchField(setModalState) {
    return new SizedBox(
      child: TextField(
        onChanged: (val) {
          setModalState(() {
            searchName = val;
          });
          getUsersSearchData();
        },
        style: new TextStyle(
            color: Colors.white, fontFamily: Constants.PrimaryFont),
        decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(28.0),
              ),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
            hintStyle: new TextStyle(
                color: Colors.white, fontFamily: Constants.PrimaryFont),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: "INVITE MEMBERS.....",
            fillColor: Color(0xFF6E32CC)),
      ),
      height: 50,
    );
  }

  _addRowName(SquadModelClass squad, String ownerImg) {
    return Row(
      children: <Widget>[
        ownerImg != ""
            ? CachedNetworkImage(imageUrl: ownerImg, width: 45, height: 45)
            : Container(),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(squad.squadname,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constants.PrimaryFont)))
      ],
    );
  }

  _addSquadName(SquadModelClass squad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("SQUAD",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: Constants.PrimaryFont)),
        showMembers(squad)
      ],
    );
  }

  _addListView(StateSetter setStateModel) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: "${users[index].avatarImage}",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${users[index].userName}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: Constants.PrimaryFont),
                        )
                      ],
                    ),
                    users[index].isUserSelected
                        ? Icon(
                            Icons.radio_button_checked,
                            color: Color(0xFFC2C1C1),
                          )
                        : Icon(
                            Icons.radio_button_unchecked,
                            color: Color(0xFFC2C1C1),
                          )
                  ],
                )),
            onTap: () {
              setStateModel(() {
                users[index].isUserSelected == true
                    ? users[index].isUserSelected = false
                    : users[index].isUserSelected = true;
                if (users[index].isUserSelected) {
                  selectedusers.add(users[index]);
                } else {
                  selectedusers.remove(users[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  addInviteButton(setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Image.asset('assets/back.png'),
          iconSize: 48,
          onPressed: () {
            initailizeData(setModalState);
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 49,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            onPressed: () {
              List<String> ids = [];
              selectedusers.forEach((location) => ids.add(location.userId));
              print(ids);
              var name = nameController.text.toUpperCase();
              if (ids.isNotEmpty) {
                //sendInvites(ids);
                //WebserviceClass.callOnFcmApiSendPushNotifications(ids);
                sendDeviceNotifaction(selectedusers, name);
              }
              initailizeData(setModalState);
              Navigator.pop(context);
            },
            color: Color(0xFFDE2D5D),
            textColor: Colors.white,
            child: Text(
              "INVITE",
              style: TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
            ),
          ),
        ),
      ],
    );
  }

  sendDeviceNotifaction(List<UserModelClass> selectedusers, String name) async {
    if (selectedusers.length >= 2) {
      points = points + 50;
      updateRewardsTable("Squad_more_2Members", 50, points);
      Fluttertoast.showToast(
          msg: "Create a squad (host) with 2 or more members(20 points)");
    }
    for (var val in selectedusers) {
      print(val.squadInviteEnable);
      if (val.squadInviteEnable) {
        var str = "INVITED TO JOIN " + name;
        print(val.fcmToken);
        var dicto = <String, dynamic>{
          'body': str,
          'category': "1",
          "title": "COEXIST GAMING",
        };
        WebserviceClass.sendAndRetrieveMessage(val.fcmToken, str, "1", dicto);
        var dict = {
          Parameters.notificationtype: "1",
          Parameters.notificationtitle: str,
          Parameters.inviteeId: val.userId,
          Parameters.squadId: squadID,
          Parameters.ownerId: userId,
          Parameters.timestamp: DateTime.now(),
          Parameters.isRead: false,
        };
        SquadRepository.addNotification(dict);
      }
    }
  }

  initailizeData(setModalState) {
    selectedTime = "";
    selectedGame = Results();
    selectedSquadDate = "";
    selectedusers = [];
    isSelected = [true, false];
    setCurrentTime();
    isNowButton = true;
    duration = 1;
    nameController.text = "";
    searchController.text = "";
    name = "";
    users = [];
  }

  sendInvites(List<String> memberIds) {
    memberIds.add(userId);
    SquadRepository.joinSquad(squadID, memberIds);
  }

  addDateButton(int btnNo) {
    print(btnNo);
    if (btnNo == 0) {
      var date = DateTime.now();
      var dfHr = new DateFormat('MMMM dd,yyyy');
      var hrtemp = dfHr.format(date);
      selectedSquadDate = hrtemp;
      selectedDate = DateTime.now();
      var dftime = new DateFormat('hh:mm a');
      var time = dftime.format(date);
      selectedTime = time;
      selectedTimestamp = date;
    } else if (btnNo == 1) {
      selectedDate = null;
      // var date = DateTime.now();
      // var timeStmp = new DateTime(date.year + 1, date.month, date.day, hr, min);
      // selectedTimestamp = timeStmp;
      // var dfHr = new DateFormat('MMMM dd,yyyy');
      // var hrtemp = dfHr.format(timeStmp);

      if (selectedDate == null) {
        selectedSquadDate = "";
      } else {
        var dfHr = new DateFormat('MMMM dd,yyyy');
        var hrtemp = dfHr.format(selectedDate);
        selectedSquadDate = hrtemp;
        var timestamp = new DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, hr, min);
        var dftime = new DateFormat('hh:mm a');
        var time = dftime.format(timestamp);
        selectedTime = time;
      }
    } else {
      var dfHr = new DateFormat('MMMM dd,yyyy');
      var hrtemp = dfHr.format(selectedDate);
      selectedSquadDate = hrtemp;
      var timestamp = new DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, hr, min);
      selectedTimestamp = timestamp;
      var dftime = new DateFormat('hh:mm a');
      var time = dftime.format(timestamp);
      selectedTime = time;
    }
  }

  _openSearchList(StateSetter setModalState) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFF5525A1),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                addGameLabel(setModalState),
                SizedBox(height: 10),
                searchWidget(setModalState),
                SizedBox(height: 10),
                dataLoad
                    ? _games.isNotEmpty
                        ? showgames(setModalState)
                        : Container()
                    : Center(child: CircularProgressIndicator()),
              ],
            )));
  }

  Widget showgames(StateSetter setModalState) {
    return Expanded(
      child: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (BuildContext context, int index) {
          var game = _games[index];
          return InkWell(
            child: Container(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: game.backgroundImage != null
                        ? CachedNetworkImage(
                            imageUrl: game.backgroundImage,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50)
                        : Container(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text(
                    game.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: Constants.PrimaryFont,
                        fontSize: 18),
                  ))
                ],
              ),
            ),
            onTap: () {
              setModalState(() {
                selectedGame = game;
                searchController.text = game.name;
                openSearchList = false;
              });
            },
          );
        },
      ),
    );
  }

  searchWidget(setModalState) {
    return new SizedBox(
      child: TextField(
        onChanged: (val) {
          setModalState(() {
            name = val;
          });
          getSearchData(setModalState);
        },
        style: new TextStyle(color: Colors.white),
        decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(28.0),
              ),
              borderSide: BorderSide(color: Color(0xFF6E32CC)),
            ),
            filled: true,
            hintStyle: new TextStyle(
                color: Colors.white, fontFamily: Constants.PrimaryFont),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: "Search..",
            fillColor: Color(0xFF6E32CC)),
      ),
      height: 50,
    );
  }

  _addButton() {
    return SizedBox(
      width: 194,
      height: 49,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setModalState) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFF5525A1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                      ),
                      child: !openSearchList
                          ? createpageWidget(setModalState)
                          : _openSearchList(setModalState));
                });
              },
            );
          },
          color: Color(0xFFDE2D5D),
          textColor: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/plusCircle.webp",
                width: 21,
                height: 21,
              ),
              SizedBox(width: 10),
              Text(
                "SQUAD UP",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constants.PrimaryFont),
              ),
            ],
          )),
    );
  }

  Widget createpageWidget(StateSetter setModalState) {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('SQUAD UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  new SizedBox(
                    child: new TextFormField(
                      controller: nameController,
                      validator: (value) =>
                          value.isEmpty ? "Please enter squad name." : null,
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: Constants.PrimaryFont),
                      decoration: new InputDecoration(
                          helperText: ' ',
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(28.0),
                            ),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(
                              color: Colors.white,
                              fontFamily: Constants.PrimaryFont),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          hintText: "Enter Squad Name",
                          fillColor: Color(0xFF6E32CC)),
                    ),
                    height: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset("assets/calendar.webp",
                          width: 15, height: 15),
                      SizedBox(
                        width: 5,
                      ),
                      Text("DATE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.PrimaryFont))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: isSelected[0]
                                  ? BorderSide(color: Colors.white)
                                  : BorderSide(color: Color(0xFF5525A1))),
                          onPressed: () {
                            addDateButton(0);

                            setModalState(() {
                              setCurrentTime();
                              isNowButton = true;
                              isSelected[0] = true;
                              isSelected[1] = false;
                              //isSelected[2] = false;
                            });
                          },
                          color: Color(0xFF5525A1),
                          textColor: Colors.white,
                          child: Text(
                            "NOW",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: Constants.PrimaryFont),
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: isSelected[1]
                                  ? BorderSide(color: Colors.white)
                                  : BorderSide(color: Color(0xFF5525A1))),
                          onPressed: () {
                            addDateButton(1);
                            setModalState(() {
                              isNowButton = false;
                              isSelected[1] = true;
                              isSelected[0] = false;
                              // isSelected[2] = false;
                            });
                          },
                          color: Color(0xFF5525A1),
                          textColor: Colors.black,
                          child: Text(
                            "SOON",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: Constants.PrimaryFont),
                          ),
                        ),
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              // side: isSelected[2]
                              //   ? BorderSide(color: Colors.white)
                              // : BorderSide(color: Color(0xFF5525A1))
                            ),
                            onPressed: () {
                              _selectDate(context, setModalState);
                              setModalState(() {
                                isNowButton = false;
                                isSelected[1] = true;
                                isSelected[0] = false;
                                // isSelected[2] = true;
                              });
                            },
                            color: Color(0xFF8E47FF),
                            textColor: Colors.black,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  selectedDate != null
                                      ? "${selectedDate.toLocal()}"
                                          .split(' ')[0]
                                      : "SELECT DATE",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: Constants.PrimaryFont),
                                ),
                                Image.asset(
                                  "assets/downarrow.webp",
                                  height: 10,
                                  width: 10,
                                ),
                              ],
                            )),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[],
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset("assets/time.webp",
                                width: 15, height: 15),
                            SizedBox(
                              width: 5,
                            ),
                            Text("TIME",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: Constants.PrimaryFont))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset("assets/time.webp",
                                width: 15, height: 15),
                            SizedBox(
                              width: 5,
                            ),
                            Text("DURATION",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: Constants.PrimaryFont))
                          ],
                        ),
                      ]),
                  SizedBox(height: 10),
                  addTimeWidget(setModalState),
                  SizedBox(height: 20),
                  addGameLabelWidet(),
                  SizedBox(height: 10),
                  addGameSearchField(setModalState),
                  SizedBox(height: 10),
                  selectedGame.name != null ? addGameImage() : Container(),
                  SizedBox(height: 10),
                  addCreateButton(setModalState)
                ],
              ),
            )));
  }

  addCreateButton(setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Image.asset('assets/back.png'),
          iconSize: 48,
          onPressed: () {
            initailizeData(setModalState);
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 49,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            onPressed: () {
              //  _naviagteToChat(context);
              createSquad(setModalState);
              // var ids = ["PSAxcQ7YlDQ1LMJF1LXty5rmkP42"];
              // WebserviceClass.callOnFcmApiSendPushNotifications(ids);
            },
            color: Color(0xFFDE2D5D),
            textColor: Colors.white,
            child: Text(
              "CREATE",
              style: TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
            ),
          ),
        ),
      ],
    );
  }

  updateRewardsTable(String rewardName, int points, int totalpoints) {
    OnboardingRepository.updateUserPoints(totalpoints, userId);
    final Map<String, dynamic> dict = <String, dynamic>{
      Parameters.UserID: userId,
      Parameters.points: points,
      Parameters.added_on: DateTime.now(),
      Parameters.rewardName: rewardName
    };
    print(dict);
    OnboardingRepository.updateRewardsPoints(dict).then((value) {
      print("points added");
      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.UPDATEPROFILE, null);
    });
  }

  createSquad(setModalState) {
    if (_formKey.currentState.validate()) {
      if (searchController.text == "") {
        Fluttertoast.showToast(msg: "Please select Game.");
      } else {
        if (squadCount == 0) {
          //Create a squad for the first time (20 points)
          points = points + 20;
          updateRewardsTable("First_Squad", 20, points);
          Fluttertoast.showToast(
              msg: "Create a squad for the first time (20 points)");
        }
        membersArray = [];
        membersArray.add(Members(
                memberId: userId,
                memberName: userName,
                memberAvatr: userAvatar,
                isOwner: true)
            .toJson());
        print("membersArray" + membersArray.toString());

        if (selectedSquadDate == "") {
          Fluttertoast.showToast(msg: "Select Date first");
          return;
        }
        var dict = {
          Parameters.squadName: nameController.text,
          Parameters.ownerId: userId,
          Parameters.duration: duration.toString(),
          Parameters.date: selectedSquadDate,
          Parameters.time: selectedTime,
          Parameters.timestamp: selectedTimestamp,
          Parameters.membersId: membersArray,
          Parameters.game: {
            Parameters.gameId: selectedGame.id,
            Parameters.gameImage: selectedGame.shortScreenshots[0].image != null
                ? selectedGame.shortScreenshots[0].image
                : selectedGame.backgroundImage,
            Parameters.gameName: selectedGame.name
          }
        };

        print(dict);
        SquadRepository.createSquad(dict).then((value) {
          squadID = value;
          _refreshLocalGallery();
        });
        getAllUsers(setModalState);
        Navigator.pop(context);
        _addInviteMember(setModalState);
      }
    }
  }

  var timeout = const Duration(seconds: 10);
  static const ms = const Duration(milliseconds: 1);
  var durationo;

  startTimeout([int milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    durationo = duration;
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    print(durationo);
  }

  getSearchData(setModalState) {
    // var counter = 5;
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   counter = counter - 1;
    //   print(counter);
    //   if (counter == 0) {
    //     timer = null;
    //     print("Yeah, this line is printed after 3 second");
    //   } else {
    //   }
    // });
    _games = [];
    WebserviceClass.searchGames(Constants.FavFiveApi + "?search=" + name)
        .then((value) {
      setModalState(() {
        _games = value.results;
      });
    });
  }

  addGameSearchField(StateSetter setModalState) {
    return new SizedBox(
      child: InkWell(
        child: TextFormField(
          enabled: false,
          controller: searchController,
          style: new TextStyle(color: Colors.white),
          decoration: new InputDecoration(
              prefixIcon: new Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(28.0),
                ),
                borderSide: BorderSide(color: Color(0xFF6E32CC)),
              ),
              filled: true,
              helperText: ' ',
              hintStyle: new TextStyle(
                  color: Colors.white, fontFamily: Constants.PrimaryFont),
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: "Search..",
              fillColor: Color(0xFF6E32CC)),
        ),
        onTap: () {
          setModalState(() {
            openSearchList = true;
          });
        },
      ),
      height: 80,
    );
  }

  addGameImage() {
    return Center(
        child: SizedBox(
      height: 152,
      width: 95,
      child: Stack(
        children: <Widget>[
          ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: selectedGame.shortScreenshots[0].image != null
                    ? CachedNetworkImage(
                        imageUrl: selectedGame.shortScreenshots[0].image != null
                            ? selectedGame.shortScreenshots[0].image
                            : selectedGame.backgroundImage,
                        width: 95,
                        height: 152,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              )),
          Positioned.fill(
            bottom: 10,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(selectedGame.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ))),
          )
        ],
      ),
    ));
  }

  addGameLabel(StateSetter setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset("assets/gameIcon.webp", width: 15, height: 15),
            SizedBox(
              width: 5,
            ),
            Text("GAME",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: Constants.PrimaryFont)),
          ],
        ),
        IconButton(
            icon: Image.asset(
              "assets/back.png",
              width: 20,
              height: 20,
            ),
            onPressed: () {
              setModalState(() {
                openSearchList = false;
              });
            })
      ],
    );
  }

  addGameLabelWidet() {
    return Row(
      children: <Widget>[
        Image.asset("assets/gameIcon.webp", width: 15, height: 15),
        SizedBox(
          width: 5,
        ),
        Text("GAME",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: Constants.PrimaryFont)),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context, setModalState) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setModalState(() {
        selectedDate = picked;
      });
    addDateButton(2);
  }

  Widget _buildMainWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 80, 10, 10),
      child: loadData
          ? new RefreshIndicator(
              child: addGridView(),
              onRefresh: _refreshLocalGallery,
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator())),
    );
  }

  Future<Null> _refreshLocalGallery() async {
    print('refreshing stocks...');
    loadData = false;
    lastDocument = null;
    squads = [];
    hasMore = true;
    isLoading = false;
    squadListGet();
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
                "SQUADS",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.w500),
              ),
            )));
  }

  Widget _loadBgImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
          image: AssetImage("assets/blurBg.webp"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  addTimeWidget(StateSetter setModalState) {
    return Center(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(minWidth: 75),
          decoration: BoxDecoration(
            color: Color(0xFF702CDC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Image.asset(
                  "assets/uparrow.webp",
                  color: Colors.white,
                  height: 13,
                  width: 13,
                ),
                onTap: () {
                  //  addDateButton(2);

                  setModalState(() {
                    isSelected[0] = false;
                    isSelected[1] = true;
                    isNowButton = false;
                    if (hr < 12) {
                      hr = hr + 1;
                    }
                    if (hr > 12) {
                      hr = 1;
                    }
                  });
                },
              ),
              Text(
                "$hr h",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Image.asset(
                  "assets/downarrow.webp",
                  color: isNowButton ? Colors.white : Colors.white,
                  height: 13,
                  width: 13,
                ),
                onTap: () {
                  //addDateButton(2);
                  setModalState(() {
                    isNowButton = false;
                    isSelected[0] = false;
                    isSelected[1] = true;
                    if (isNowButton) {
                      // if (hr > 0 && hr > currenthr) {
                      //   hr = hr - 1;
                      // } else {}
                    } else {
                      if (hr > 0) {
                        hr = hr - 1;
                      }
                    }
                  });
                },
              )
            ],
          ),
          height: 85,
        ),
        Container(
          // color: Color(0xFF702CDC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                ":",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          height: 85,
        ),
        Container(
          constraints: BoxConstraints(minWidth: 75),
          decoration: BoxDecoration(
            color: Color(0xFF702CDC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    // addDateButton(2);

                    setModalState(() {
                      isSelected[0] = false;
                      isSelected[1] = true;
                      if (min < 60) {
                        min = min + 1;
                      }
                    });
                  },
                  child: Image.asset(
                    "assets/uparrow.webp",
                    color: isNowButton ? Colors.white : Colors.white,
                    height: 13,
                    width: 13,
                  )),
              Text(
                "$min m",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Image.asset(
                  "assets/downarrow.webp",
                  color: isNowButton ? Colors.white : Colors.white,
                  height: 13,
                  width: 13,
                ),
                onTap: () {
                  //addDateButton(2);
                  setModalState(() {
                    isSelected[0] = false;
                    isSelected[1] = true;
                    isNowButton = false;
                    if (!isNowButton) {
                      if (min > 0) {
                        min = min - 1;
                      }
                    } else {
                      // if (min > 0 && min > currentMin) {
                      //   min = min - 1;
                      // } else {}
                    }
                  });
                },
              ),
            ],
          ),
          height: 85,
        ),
        Container(
          constraints: BoxConstraints(minWidth: 50),
          decoration: BoxDecoration(
            color: Color(0xFF702CDC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Text(
                  "AM",
                  style: TextStyle(
                      fontSize: 22,
                      color: isAM ? Colors.white : Color(0xFF5525A1),
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  //addDateButton(2);

                  if (!isNowButton) {
                    setModalState(() {
                      isSelected[0] = false;
                      isSelected[1] = true;
                      isAM = true;
                    });
                  }
                },
              ),
              InkWell(
                  child: Text(
                    "PM",
                    style: TextStyle(
                        fontSize: 22,
                        color: isAM ? Color(0xFF5525A1) : Colors.white,
                        fontFamily: Constants.PrimaryFont,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // addDateButton(2);
                    setModalState(() {
                      isSelected[0] = false;
                      isSelected[1] = true;
                      if (!isNowButton) {
                        isAM = false;
                      }
                    });
                  }),
            ],
          ),
          height: 85,
        ),
        Container(
          constraints: BoxConstraints(minWidth: 80),
          decoration: BoxDecoration(
            color: Color(0xFF702CDC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Image.asset(
                  "assets/uparrow.webp",
                  height: 13,
                  width: 13,
                ),
                onTap: () {
                  setModalState(() {
                    duration = duration + 1;
                  });
                },
              ),
              Text(
                "$duration h",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Image.asset(
                  "assets/downarrow.webp",
                  height: 13,
                  width: 13,
                ),
                onTap: () {
                  setModalState(() {
                    if (duration > 1) {
                      duration = duration - 1;
                    }
                  });
                },
              ),
            ],
          ),
          height: 85,
        ),
      ],
    ));
  }

  Widget showUsers(List members) {
    if (members.length > 1) {
      members.insert(1, members.removeAt(0));
      print("SWAPPINGGG" + members.toString());
    }

    return Container(
        height: 40,
        width: double.infinity,
        child: members.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: members.length > 3 ? 3 : members.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: index == 1 ? 40 : 30,
                    width: index == 1 ? 40 : 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: "${members[index]["memberAavatar"]}",
                            height: members[index]["isOwner"] == true ? 40 : 30,
                            width: members[index]["isOwner"] == true ? 40 : 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Container());
  }

  Widget addGridView() {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return squads.length != 0
        ? GridView.count(
            controller: _scrollController,
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: (itemWidth / itemHeight),
            children: List.generate(squads.length, (index) {
              var squad = squads[index];
              return GridTile(
                  child: InkWell(
                child: Container(
                    child: Column(
                  children: <Widget>[
                    showUsers(squad.members),
                    Expanded(
                        child: Stack(
                      children: <Widget>[
                        Container(
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: CachedNetworkImage(
                              imageUrl: squad.gamel.gameImage,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                        ),
                        Positioned.fill(
                            top: 8,
                            left: 8,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 25,
                                height: 25,
                                child: Center(
                                    child: Text(
                                  squad.members.length.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black),
                              ),
                            )),
                        Positioned.fill(
                            top: 12,
                            right: 10,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                              ),
                            )),
                        Positioned.fill(
                          bottom: 20,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  squad.gamel.gameName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.PrimaryFont,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Text(
                                      squad.squadname,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: Constants.PrimaryFont,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                )),
                onTap: () {
                  var ownerImage = "";
                  for (var val in squad.members) {
                    if (val["isOwner"] == true) {
                      ownerImage = val["memberAavatar"];
                      break;
                    }
                  }
                  _showJoinMemberPage(squad, ownerImage);
                },
              ));
            }),
          )
        : Container();
  }

  _naviagteToChat(context, squadId, squadname, members) {
    print(squadId);
    print(squadname);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatScreen(squadId, squadname, false, members)),
    );
  }
}
