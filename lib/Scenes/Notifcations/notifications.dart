import 'package:coexist_gaming/Models/squadModel.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Repositiory/squadRepository.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class NotifcationClass extends StatefulWidget {
  NotifcationClass({Key key}) : super(key: key);
  static const routeName = '/NotifcationClass';
  @override
  _NotifcationClassState createState() => _NotifcationClassState();
}

class _NotifcationClassState extends State<NotifcationClass> {
  List notifications = List();

  var userID = "";
  var avatar = "";
  var username = "";

  @override
  void initState() {
    super.initState();
    getuserID().then((id) {
      userID = id;
      OnboardingRepository.getUser(id).then((value) {
        username = value['Username'];
        avatar = value['AvatarImage'];
      });
      getNotificatios(id);
    });
  }

  getNotificatios(id) {
    SquadRepository.getNotifications(id).then((value) {
      print(value.docs);
      setState(() {
        notifications = value.docs;
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
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            "Notifications",
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
        backgroundColor: Color(0xFF000000),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[heading(), addListView(), addClearButton()],
            )));
  }

  addClearButton() {
    return Padding(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        height: 48,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.white, width: 2)),
          color: Colors.transparent,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              notifications = [];
              clearNotifcations();
            });
          },
          child: Text(
            "CLEAR ALL",
            style: TextStyle(fontSize: 16.0, fontFamily: Constants.PrimaryFont),
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 50),
    );
  }

  clearNotifcations() {
    SquadRepository.clearAllNotifcation(userID);
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
                "NOTIFICATIONS",
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
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: notifications.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color:
                            index == 1 ? Color(0xFF8C17B5) : Color(0xFF1770B5),
                        borderRadius: BorderRadius.circular(10)),
                    child: addNotificationType(notifications[index])));
          }),
    );
  }

  addNotificationType(notification) {
    if (notification["type"] == "1") {
      return addInviteNotifaction(notification);
    } else if (notification["type"] == "2") {
      return addNewEventNotification(notification);
    } else {
      return addLiveNotification();
    }
  }

  addLiveNotification() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              "assets/squad.webp",
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            new Expanded(
              child: Text(
                "BROTHAMAN'S SQUAD IS LIVE ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: Constants.PrimaryFont),
              ),
            ),
          ],
        ));
  }

  addNewEventNotification(notification) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              "assets/calendar2.webp",
              width: 29,
              height: 29,
            ),
            SizedBox(width: 10),
            new Expanded(
              child: Text(
                notification["title"],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: Constants.PrimaryFont),
              ),
            ),
          ],
        ));
  }

  addInviteNotifaction(notification) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              "assets/squad.webp",
              width: 40,
              height: 40,
            ),
            SizedBox(width: 5),
            new Expanded(
              child: Text(
                notification["title"],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: Constants.PrimaryFont),
              ),
            ),
            Row(
              children: <Widget>[
                InkWell(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: InkWell(
                      child: Image.asset("assets/redCross.webp"),
                    ),
                  ),
                  onTap: () {
                    rejectNotificationMethod(notification);
                  },
                ),
                InkWell(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: InkWell(
                      child: Image.asset("assets/greenTick.webp"),
                    ),
                  ),
                  onTap: () {
                    acceptedNotificationMethod(notification);
                  },
                )
              ],
            )
          ],
        ));
  }

  acceptedNotificationMethod(notification) {
    var member = Members(
        memberId: userID,
        memberName: username,
        memberAvatr: avatar,
        isOwner: false);
    SquadRepository.joinSquad(notification["squadId"], member.toJson());
    print("IDD" + notification.id);
    SquadRepository.updateNotificationReadStatus(notification.id);
    getNotificatios(userID);
  }

  rejectNotificationMethod(notification) {
    SquadRepository.updateNotificationReadStatus(notification.id);
    getNotificatios(userID);
  }
}
