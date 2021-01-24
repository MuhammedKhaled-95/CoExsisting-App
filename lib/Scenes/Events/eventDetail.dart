import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coexist_gaming/Models/eventModel.dart';
import 'package:coexist_gaming/Repositiory/eventRepository.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/SupportingClass/overlaynotification/lib/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailClass extends StatefulWidget {
  final String eventId;
  EventDetailClass(this.eventId);
  static const routeName = '/EventDetailClass';
  @override
  _EventDetailClassState createState() => _EventDetailClassState();
}

class _EventDetailClassState extends State<EventDetailClass> {
  EventsModelClass event = EventsModelClass();
  var time = "";
  var userID = "";
  String stage = "";
  int status = 0;
  int points = 0;
  var startDate;
  var endDate;
  bool firstRsvp = false;
  var eventsCount = 0;
  var classCount = 0;
  int _current = 0;
  @override
  void initState() {
    super.initState();
    getUserDetail();

    DateTime date = DateTime.now();
    startDate = getDate(date.subtract(Duration(days: date.weekday - 1)));
    endDate =
        getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));

    print(
        'Start of week: ${getDate(date.subtract(Duration(days: date.weekday - 1)))}');
    print(
        'End of week: ${getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)))}');
    EventRepository.getEvent(widget.eventId).then((value) {
      setState(() {
        this.event = value;
        var format = new DateFormat('E,MMM d h:mma');
        var startdate = format.format(this.event.eventstartTime.toLocal());
        var enddate = format.format(this.event.eventendTime.toLocal());
        time = startdate + " - " + enddate;
      });
    });
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  getUserDetail() {
    getuserID().then((id) {
      userID = id;
      EventRepository.getEventRSVPStatus(id, widget.eventId).then((value) {
        value.snapshots().listen((event) {
          event.docs.forEach((element) {
            setState(() {
              print(element["status"]);
              status = element["status"];
            });
          });
        });
      });
      EventRepository.getEventIDs(userID).then((value) {
        value.snapshots().listen((event) {
          if (event.docs.length == 0) {
            firstRsvp = true;
          } else {
            firstRsvp = false;
            //event.docs.forEach((element) {});
          }
        });
      });

      EventRepository.getEventDates(startDate, endDate).then((value) {
        value.snapshots().listen((event) {
          event.docs.forEach((element) {
            print(element["eventtype"]);
            if (element["eventtype"] == "Class") {
              classCount = classCount + 1;
            } else {
              eventsCount = eventsCount + 1;
            }
          });
        });
      });

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: Stack(children: [
          _loadBgImage(),
          event.eventid != null
              ? _buildMainWidget()
              : Positioned.fill(
                  child: Align(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                )),
        ]));
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

  Widget _buildMainWidget() {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Center(
              child: Column(
            children: <Widget>[
              heading(event.eventtype.toUpperCase()),
              space(),
              space(),
              space(), //15
              addSlider(event.eventimage), // 147
              space(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(event.eventimage.length)),
              space(), //10
              addEventName(), // 25
              space(),
              space(), //10
              addEventTime(), //50
              space(),
              space(),
              space(),
              space(), //20
              Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 480,
                      minWidth: double.infinity),
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: addEventDesription(),
                  )),
              space(),
              space(),
              addRSVPButton(), //50
            ],
          ))),
    );
  }

  space() {
    return SizedBox(
      height: 5,
    );
  }

  addSlider(eventimage) {
    return CarouselSlider.builder(
      itemCount: eventimage.length,
      itemBuilder: (context, index) {
        var event = eventimage[index];
        return addEventImage(event);
      },
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.20,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
    );
  }

  List<Widget> _buildPageIndicator(int count) {
    List<Widget> list = [];
    for (int i = 0; i < count; i++) {
      list.add(i == _current ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 8.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFFBEBEBE),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  addEventImage(event) {
    return CachedNetworkImage(
      height: 147,
      imageUrl: event,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  methodRSVPButton() async {
    if (firstRsvp) {
      points = points + 50;

      //2.Rsvp for your first class (50 points)
      if (event.eventtype == "Class") {
        updateRewardsTable(Constants.RSVPFirstClass, 50, points);
        Fluttertoast.showToast(msg: Constants.RSVPFirstClass_desc);
      } else {
        //4.Rsvp for your first event (50 points)
        updateRewardsTable(Constants.RSVPFirstEvent, 50, points);
        Fluttertoast.showToast(msg: Constants.RSVPFirstEvent_desc);
      }
    } else {
      //7.Rsvp/Attend 3 classes and 3 events in one week (150)
      if (eventsCount >= 3 && classCount == 2 ||
          eventsCount == 2 && classCount >= 3) {
        points = points + 150;
        updateRewardsTable("3_classes_3_event_1week", 150, points);
        Fluttertoast.showToast(
            msg:
                "Rsvp/Attend 3 classes and 3 events in one week (150 points).");
      } else {
      
        if (event.eventtype == "Class") {
          
          //Rsvp for 3 classes in one week
          if (classCount == 2) {
            points = points + 50;
            updateRewardsTable("RSVP_3_Classes", 50, points);
            Fluttertoast.showToast(
                msg: "Rsvp for 3 classes in one week (50 points).");
          
          } else if (classCount == 0) {
            //2.Rsvp for your first class (50 points)
            points = points + 50;
            updateRewardsTable("RSVPFirstClass", 50, points);
            Fluttertoast.showToast(
                msg: "Rsvp for your first class (50 points)");
       
          } else {
            //3.Rsvp for a class (10 points)
            points = points + 10;
            updateRewardsTable("RSVPClass", 10, points);
            Fluttertoast.showToast(msg: "Rsvp for a class (10 points)");
          }
        
        } else {
          //6.Rsvp for every weekly event and attend (50 points)
          if (eventsCount == 0) {
            points = points + 50;
            updateRewardsTable("weekly_event", 50, points);
            Fluttertoast.showToast(
                msg: "Rsvp for every weekly event and attend (50 points)");
          }
        }
      }
    }
    Timer(Duration(seconds: 2), () {
      EventRepository.rSVPEvent(userID, event.eventid, event.eventtype);
      setState(() {
        status = 1;
      });
    });
  }

  updateRewardsTable(String rewardName, int points, int totalpoints) {
    OnboardingRepository.updateUserPoints(totalpoints, userID);
    final Map<String, dynamic> dict = <String, dynamic>{
      Parameters.UserID: userID,
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

  addRSVPButton() {
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
          width: MediaQuery.of(context).size.width / 3,
          height: 49,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            onPressed: () {
              if (status == 0) {
                methodRSVPButton();
              }
            },
            color: Color(0xFFDE2D5D),
            textColor: Colors.white,
            child: Text(
              status == 0 ? "RSVP" : "Done",
              style: TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
            ),
          ),
        ),
      ],
    );
  }

  addEventName() {
    return Center(
        child: Text(
      event.eventname != null ? event.eventname.toUpperCase() : "",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontWeight: FontWeight.w500),
    ));
  }

  addEventDesription() {
    return Text(
      event.eventdescription,
      overflow: TextOverflow.ellipsis,
      maxLines: 100,
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontFamily: Constants.PrimaryFont),
    );
  }

  addEventTime() {
    return Container(
        color: Colors.white.withOpacity(0.3),
        width: MediaQuery.of(context).size.width,
        height: 55,
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  "assets/events.webp",
                  width: 24,
                  height: 24,
                ),
                Expanded(
                  child: Text(
                    time != null ? time : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontFamily: Constants.PrimaryFont,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )));
  }

  heading(String str) {
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
                str,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.w500),
              ),
            )));
  }
}
