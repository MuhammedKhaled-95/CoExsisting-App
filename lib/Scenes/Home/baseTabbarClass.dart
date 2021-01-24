import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/Events/eventlist.dart';
import 'package:coexist_gaming/Scenes/Notifcations/notifications.dart';
import 'package:coexist_gaming/Scenes/Profile/Profile.dart';
import 'package:coexist_gaming/Scenes/Rewards/reward.dart';
import 'package:coexist_gaming/Scenes/Settings/about.dart';
import 'package:coexist_gaming/Scenes/Settings/partners.dart';
import 'package:coexist_gaming/Scenes/Settings/settings.dart';
import 'package:coexist_gaming/Scenes/SquadUp/members.dart';
import 'package:coexist_gaming/Scenes/SquadUp/squads.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/chat/ChatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'dart:convert';

class BasetabbarClass extends StatefulWidget {
  BasetabbarClass({Key key}) : super(key: key);
  static const routeName = '/BasetabbarClass';
  @override
  _BasetabbarClassState createState() => _BasetabbarClassState();
}

class _BasetabbarClassState extends State<BasetabbarClass>
    implements StateListener {
  List<Widget> originalList;
  Map<int, bool> originalDic;
  List<Widget> listScreens;
  List<int> listScreensIndex;
  int tabIndex = 0;
  Color tabColor = Colors.white;
  Color selectedTabColor = Colors.white;
  String username = "USERNAME";
  String avatar = "";
  var auth = new Auth();
  User user;

  _BasetabbarClassState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    if (state == ObserverState.Notifications) {
      print("ObserverStateewwwewNotifcationClass");
      Navigator.pushNamed(context, NotifcationClass.routeName);
    }
    if (state == ObserverState.NEWMESSAGE) {
      print("ObserverStateewwwewNotifcationClass");
      String name = dict["gcm.notification.squadName"];
      String squadId = dict["gcm.notification.squadId"];
      var members = dict["gcm.notification.membersId"];
      List abc = json.decode(members);
      _naviagteToChat(squadId, name, abc, dict);
    }
  }

  _naviagteToChat(squadId, squadname, members, dict) {
    print(squadId);
    print(squadname);
    if (Constants.isOnNotificationClass) {
      print(Constants.isSQUADID);
      print(squadId);
      if (Constants.isSQUADID == squadId) {
      } else {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(squadId, squadname, true, members)),
          );
        });
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatScreen(squadId, squadname, true, members)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Constants.isOnNotificationClass = false;
    Constants.isSQUADID = "";
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          username = value['Username'];
          avatar = value['AvatarImage'] != null ? value['AvatarImage'] : "";
        });
      });
    });

    originalList = [
      Home(),
      EventsClass(),
      SquadsClass(),
      RewardsClass(),
      ProfileClass(),
    ];
    originalDic = {0: true, 1: false, 2: false, 3: false, 4: false, 5: false};
    listScreens = [originalList.first];
    listScreensIndex = [0];
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            title: Image.asset(
              "assets/logo.png",
              width: MediaQuery.of(context).size.width * 0.30,
              fit: BoxFit.cover,
            ),
            actions: <Widget>[
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset("assets/notification.webp",
                        width: 24, height: 27)),
                onTap: () {
                  Navigator.pushNamed(context, NotifcationClass.routeName);
                },
              )
            ],
            elevation: 0,
          ),
          drawer: Container(
              width: MediaQuery.of(context).size.width * 0.70,
              child: Drawer(
                  child: Container(
                color: Color(0xFF1D1D1D),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 140.0,
                      child: DrawerHeader(
                        child: Row(
                          children: <Widget>[
                            avatar != ""
                                ? CachedNetworkImage(
                                    imageUrl: avatar,
                                    width: 80,
                                    height: 80,
                                  )
                                : Container(),
                            Expanded(
                              child: Text(
                                "$username".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: Constants.PrimaryFont),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 44,
                          maxHeight: 44,
                        ),
                        child:
                            Image.asset('assets/squad.webp', fit: BoxFit.cover),
                      ),
                      title: Text('MEMBERS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: Constants.PrimaryFont)),
                      onTap: () {
                        Navigator.pushNamed(context, MembersClass.routeName);
                      },
                    ),
                    ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                          maxWidth: 40,
                          maxHeight: 40,
                        ),
                        child: Image.asset(
                          'assets/partner.webp',
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      title: Text('PARTNERS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: Constants.PrimaryFont)),
                      onTap: () {
                        Navigator.pushNamed(context, PartnersClass.routeName);
                      },
                    ),
                    ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 44,
                          maxHeight: 44,
                        ),
                        child:
                            Image.asset('assets/about.webp', fit: BoxFit.cover),
                      ),
                      title: Text('ABOUT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: Constants.PrimaryFont)),
                      onTap: () {
                        Navigator.pushNamed(context, AboutClass.routeName);
                      },
                    ),
                    ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 44,
                          maxHeight: 44,
                        ),
                        child: Image.asset('assets/settings.webp',
                            fit: BoxFit.cover),
                      ),
                      title: Text('SETTINGS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: Constants.PrimaryFont)),
                      onTap: () {
                        Navigator.pushNamed(context, SettingsClass.routeName);
                        // ...
                      },
                    ),
                  ],
                ),
              ))),
          body: IndexedStack(
              index: listScreensIndex.indexOf(tabIndex), children: listScreens),
          bottomNavigationBar: _buildTabBar(),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  void _selectedTab(int index) {
    if (originalDic[index] == false) {
      listScreensIndex.add(index);
      originalDic[index] = true;
      listScreensIndex.sort();
      listScreens = listScreensIndex.map((index) {
        return originalList[index];
      }).toList();
    }
    setState(() {
      tabIndex = index;
    });
  }

  Widget _buildTabBar() {
    var listItems = [
      BottomAppBarItem(
          iconData: ImageIcon(AssetImage('assets/home.webp')), text: 'Home'),
      BottomAppBarItem(
          iconData: ImageIcon(AssetImage('assets/events.webp')),
          text: 'Events'),
      BottomAppBarItem(
          iconData: ImageIcon(AssetImage(
            'assets/squad.webp',
          )),
          text: 'Squad Up'),
      BottomAppBarItem(
          iconData: ImageIcon(AssetImage('assets/rewards.webp')),
          text: 'Rewards'),
      BottomAppBarItem(
          iconData: ImageIcon(AssetImage('assets/profile.webp')),
          text: 'Profile'),
    ];

    var items = List.generate(listItems.length, (int index) {
      return _buildTabItem(
        item: listItems[index],
        index: index,
        onPressed: _selectedTab,
      );
    });

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: Constants.PrimaryBlackColor,
    );
  }

  Widget _buildTabItem({
    BottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    var color = tabIndex == index ? selectedTabColor : tabColor;
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: ImageIcon(
                  item.iconData.image,
                  color: Colors.white,
                )),
                SizedBox(
                  height: 5,
                ),
                Text(
                  item.text,
                  style: TextStyle(color: color, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomAppBarItem {
  BottomAppBarItem({this.iconData, this.text});
  ImageIcon iconData;
  String text;
}
