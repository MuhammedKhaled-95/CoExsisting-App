import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coexist_gaming/Models/eventModel.dart';
import 'package:coexist_gaming/Repositiory/eventRepository.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/Events/eventDetail.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import "package:collection/collection.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements StateListener {
  int _current = 0;
  List gradientcolors;
  List<EventsModelClass> events = [];
  var eventlist = [];
  String stage = "";

  var auth = Auth();

  _HomeState() {
    //create subscription here
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("UPDATE HOME WIDGET");
  }

  @override
  onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    //Do something when you detected a change
    if (state == ObserverState.LIST_CHANGED) {
      getUserDetail();
      print("ObserverState");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
    gradientcolors = [
      [
        const Color(0xFF4527A0),
        const Color(0xFF7520A2),
      ],
      [
        const Color(0xFF27489F),
        const Color(0xFF1F9A8E),
      ],
      [
        const Color(0xFFA02727),
        const Color(0xFFA2781F),
      ]
    ];
    EventRepository.getEventsData().then((value) {
      print(value);
      setState(() {
        this.events = value;
        var newMap = groupBy(this.events, (obj) => obj.eventtype);
        newMap.entries.forEach((e) => eventlist.add(e));
        print(eventlist);
      });
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
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
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10), child: addListView());
  }

  getUserDetail() {
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          if (value["StageImage"] != null) {
            stage = value['StageImage'];
          } else {
            stage = "";
          }
        });
      });
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  addListView() {
    return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: eventlist.length,
            itemBuilder: (BuildContext ctxt, int index) {
              MapEntry event = eventlist[index];
              int max = gradientcolors.length;
              var randIndex = Random().nextInt(max);
              return Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    heading(event.key, gradientcolors[randIndex]),
                    SizedBox(height: 20),
                    addSlider(event.value),
                    SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(event.value.length))
                  ],
                ),
              );
            }));
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
      height: 12.0,
      width: isActive ? 12.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFFBEBEBE),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  List<Widget> _buildPageIndicator(int count) {
    List<Widget> list = [];
    for (int i = 0; i < count; i++) {
      list.add(i == _current ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  addSlider(List<EventsModelClass> events) {
    return events.length != 0
        ? Column(children: [
            CarouselSlider.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                var event = events[index];
                return _loadControllerImage(event);
              },
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.20,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            )
          ])
        : Container();
  }

  heading(String str, List<Color> randomColor) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: randomColor,
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

  Widget _loadControllerImage(EventsModelClass event) {
    return InkWell(
        child: CachedNetworkImage(
          imageUrl: event.eventimage[0],
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        onTap: () {
          _navigateToEvent(event);
        });
  }

  _navigateToEvent(event) async {
    auth.getCurrentUser().then((value) {
      if (value.isAnonymous) {
        _launchInBrowser(event.eventurl);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailClass(event.eventid),
            ));
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
