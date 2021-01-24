import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Repositiory/eventRepository.dart';
import 'package:coexist_gaming/Scenes/Events/eventDetail.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class EventsClass extends StatefulWidget {
  EventsClass({Key key}) : super(key: key);
  static const routeName = '/EventsClass';
  @override
  _EventsClassState createState() => _EventsClassState();
}

enum CalendarViews { dates, months, year }

class _EventsClassState extends State<EventsClass> {
  List<MonthModal> monthList = List<MonthModal>();
  List<CategoryModal> categories = List<CategoryModal>();
  List<EventListModal> eventList = List<EventListModal>();
  List<MapEntry> events = List<MapEntry>();
  List<String> eventIds = List<String>();
  List<EventIdModel> eventIdmodel = List<EventIdModel>();
  List<MonthModal> list = List<MonthModal>();
  bool dataLoad = false;
  bool dataMonthload = false;
  int year;
  int selectedyear;
  String category;
  DateTime _currentDateTime;

  int month;
  @override
  void initState() {
    super.initState();
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);

    year = date.year;
    selectedyear = date.year;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   setState(() => _getCalendar());
    // });
    print(date.month);
    month = date.month;
    getUserDetail();
    monthList = [
      MonthModal(title: "Jan", isSelected: false, number: 1, year: year),
      MonthModal(title: "feb", isSelected: false, number: 2, year: year),
      MonthModal(title: "march", isSelected: false, number: 3, year: year),
      MonthModal(title: "april", isSelected: false, number: 4, year: year),
      MonthModal(title: "may", isSelected: false, number: 5, year: year),
      MonthModal(title: "June", isSelected: false, number: 6, year: year),
      MonthModal(title: "July", isSelected: false, number: 7, year: year),
      MonthModal(title: "Aug", isSelected: false, number: 8, year: year),
      MonthModal(title: "Sept", isSelected: false, number: 9, year: year),
      MonthModal(title: "Oct", isSelected: false, number: 10, year: year),
      MonthModal(title: "Nov", isSelected: true, number: 11, year: year),
      MonthModal(title: "Dec", isSelected: false, number: 12, year: year),
    ];

    setState(() {
      dataMonthload = false;
      var varList = false;
      int itemss = 0;
      for (int i = 0; i < 24; i++) {
        print("data i :- " + i.toString());
        int j = 0;
        if (i > 11) {
          j = i - 12;
        } else {
          j = i;
        }
        print("j :- " + j.toString());
        print("varList :- " + varList.toString());
        if (_currentDateTime.month.toString() ==
                monthList[j].number.toString() ||
            varList) {
          if (itemss < 12) {
            itemss = itemss + 1;
            if (i >= 12) {
              final date = DateTime.now();
              year = date.year + 1;
              print(year);
              monthList[j].year = year;
              list.add(monthList[j]);
              print("MONTHSSSS:" + monthList[j].title);
            } else {
              final date = DateTime.now();
              year = date.year;
              if (monthList[j].number == date.month) {
                monthList[j].isSelected = true;
              }
              monthList[j].year = year;
              list.add(monthList[j]);
              print(year);
            }
            varList = true;
          }
        }
      }
      dataMonthload = true;
    });
    category = "All";
    categories = [
      CategoryModal(title: "All", isSelected: true, color: Colors.white),
      CategoryModal(title: "Esports", isSelected: false, color: Colors.blue),
      CategoryModal(
          title: "Workshops", isSelected: false, color: Colors.purple),
      CategoryModal(title: "Gamehouse", isSelected: false, color: Colors.green),
      CategoryModal(title: "Filter", isSelected: false, color: Colors.red),
    ];
  }

  getUserDetail() {
    getuserID().then((id) {
      EventRepository.getEventIDs(id).then((value) {
        value.snapshots().listen((event) {
          setState(() {
            dataLoad = true;
          });
          eventIdmodel = [];
          eventIds = [];
          event.docs.forEach((element) {
            if (element["eventid"] != null) {
              eventIds.add(element["eventid"]);
              print(eventIds);
              var obj = EventIdModel(
                  id: element.id,
                  isBookmarks: element["is_bookmark"],
                  eventid: element["eventid"]);
              eventIdmodel.add(obj);
            }
          });

          if (eventIds.isNotEmpty) {
            eventList = [];
            EventRepository.getEventList(
                    eventIds, month, selectedyear, category)
                .then((value) {
              value.snapshots().listen((event) {
                eventList = [];
                events = [];
                event.docs.forEach((element) {
                  if (element.exists) {
                    Timestamp t = element["startTime"];
                    DateTime d = t.toDate();
                    print(element["name"] + " " + d.toString());
                    final DateFormat formatter = DateFormat('MMMM dd');
                    final String formatted = formatter.format(d);
                    for (var i = 0; i < eventIdmodel.length; i++) {
                      if (element["id"] == eventIdmodel[i].eventid) {
                        var obj = EventListModal(
                            id: element["id"],
                            name: element["name"],
                            startTime: element["startTime"],
                            endTime: element["endTime"],
                            image: element["image"],
                            type: element["type"],
                            url: element["url"],
                            description: element["description"],
                            date: formatted,
                            isBookmark: eventIdmodel[i].isBookmarks,
                            eventAtenddeeId: eventIdmodel[i].id);
                        eventList.add(obj);
                      }
                    }
                  }
                });
                print(eventList.length);
                setState(() {
                  if (eventList.isNotEmpty) {
                    dataLoad = false;
                    var newMap = groupBy(eventList, (obj) => obj.date);
                    newMap.entries.forEach((e) => events.add(e));
                    print(events.length);
                    dataLoad = true;
                  } else {
                    events = [];
                    //dataLoad = false;
                  }
                });
              });
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D1D),
      body: _buildMainWidget(),
    );
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  updateBookmark(String id, bool isBookamrk, EventListModal event) {
    EventRepository.selectBookmark(id, isBookamrk);
    setState(() {
      event.isBookmark = isBookamrk;
    });
  }

  Widget _buildMainWidget() {
    return SingleChildScrollView(
        child: SafeArea(
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            children: <Widget>[
              addMonthList(),
              space(),
              addCategoryList(),
              space(),
              space(),
              dataLoad
                  ? events.isNotEmpty
                      ? addListView()
                      : Container()
                  : CircularProgressIndicator()
            ],
          )),
    ));
  }

  addListView() {
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: events.length,
            itemBuilder: (BuildContext ctxt, int index) {
              MapEntry event = events[index];
              return Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    heading(event.key),
                    SizedBox(height: 20),
                    addColumn(event.value),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }));
  }

  heading(String str) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(str,
            style: TextStyle(
                fontSize: 20,
                fontFamily: Constants.PrimaryFont,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      color: Color(0xFF2D2D2D),
    );
  }

  addColumn(List<EventListModal> eventvalues) {
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: eventvalues.length,
            itemBuilder: (BuildContext ctxt, int index) {
              EventListModal event = eventvalues[index];
              var format = new DateFormat('E,MMM d h:mma');
              var startdate = format.format(event.startTime.toDate().toLocal());
              var enddate = format.format(event.endTime.toDate().toLocal());
              var time = startdate + " - " + enddate;
              return Container(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 60,
                                    color: Color(0xFFC603FF),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            child: Text(event.name,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        Constants.PrimaryFont,
                                                    color: Colors.white))),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          child: Text(time,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      Constants.PrimaryFont,
                                                  color: Colors.white)),
                                        ),
                                        Text(event.type,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                    Constants.PrimaryFont,
                                                color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailClass(event.id),
                                  ));
                            },
                          ),
                          Row(children: <Widget>[
                            InkWell(
                              child: event.isBookmark
                                  ? Image.asset(
                                      "assets/selectedBookmark.webp",
                                      width: 41,
                                      height: 41,
                                    )
                                  : Image.asset(
                                      "assets/bookmark.webp",
                                      width: 41,
                                      height: 41,
                                    ),
                              onTap: () {
                                if (event.isBookmark) {
                                  updateBookmark(
                                      event.eventAtenddeeId, false, event);
                                } else {
                                  updateBookmark(
                                      event.eventAtenddeeId, true, event);
                                }
                              },
                            ),
                            InkWell(
                              child: Image.asset(
                                "assets/arrow.webp",
                                width: 20,
                                height: 20,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailClass(event.id),
                                    ));
                              },
                            ),
                          ])
                        ])),
              );
            }));
  }

  space() {
    return SizedBox(
      height: 5,
    );
  }

  addMonthList() {
    return dataMonthload
        ? Container(
            height: 55,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: list[index].isSelected
                                  ? Color(0xFF047E69)
                                  : Color(0xFF3E3E3E)),
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Center(
                              child: Text(list[index].title,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Constants.PrimaryFont,
                                      color: Colors.white)),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          list.forEach((element) {
                            element.isSelected = false;
                          });
                          month = list[index].number;
                          selectedyear = list[index].year;
                          getUserDetail();
                          list[index].isSelected = true;
                        });
                      });
                }))
        : Container();
  }

  addCategoryList() {
    return Container(
        height: 45,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: categories[index].isSelected
                              ? Color(0xFF047E69)
                              : Color(0xFF3E3E3E)),
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Center(
                            child: Row(
                          children: <Widget>[
                            index != 0
                                ? new Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: new BoxDecoration(
                                      color: categories[index].color,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(),
                            index != 0
                                ? SizedBox(
                                    width: 2,
                                  )
                                : SizedBox.shrink(),
                            Text(categories[index].title,
                                style: TextStyle(
                                    fontSize: index == 0 ? 17 : 10,
                                    fontFamily: Constants.PrimaryFont,
                                    color: Colors.white)),
                          ],
                        )),
                      )),
                  onTap: () {
                    setState(() {
                      categories.forEach((element) {
                        element.isSelected = false;
                      });
                      category = categories[index].title;
                      categories[index].isSelected = true;
                      getUserDetail();
                    });
                  });
            }));
  }
}

class MonthModal {
  String title;
  bool isSelected;
  int number;
  int year;
  MonthModal({this.title, this.isSelected = false, this.number, this.year});
}

class CategoryModal {
  String title;
  bool isSelected;
  Color color;
  CategoryModal({this.title, this.isSelected = false, this.color});
}

class EventListModal {
  String id;
  List image;
  String description;
  Timestamp startTime;
  Timestamp endTime;
  String name;
  String type;
  String url;
  String date;
  bool isBookmark;
  String eventAtenddeeId;

  EventListModal(
      {this.id,
      this.image,
      this.description,
      this.startTime,
      this.endTime,
      this.name,
      this.type,
      this.url,
      this.date,
      this.isBookmark,
      this.eventAtenddeeId});
}

class EventIdModel {
  String eventid;
  bool isBookmarks;
  String id;

  EventIdModel({this.id, this.isBookmarks, this.eventid});
}
