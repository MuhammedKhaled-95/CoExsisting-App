import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Models/eventModel.dart';
import 'package:coexist_gaming/Models/userModel.dart';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';

class EventRepository {
  static Future<List<EventsModelClass>> getEventsData() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.events())
        .where("startTime", isGreaterThanOrEqualTo: new DateTime.now())
        .get();
    HashMap<String, EventsModelClass> eventsHashMap =
        new HashMap<String, EventsModelClass>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
          element.id,
          () => new EventsModelClass(
              eventname: element["name"],
              eventid: element["id"],
              eventdescription: element["description"],
              eventimage: element["image"],
              eventendTime: element["endTime"].toDate(),
              eventstartTime: element["startTime"].toDate(),
              eventtype: element["type"],
              eventurl: element["url"]));
    });
    return eventsHashMap.values.toList();
  }

  static Future<EventsModelClass> getEvent(String id) async {
    DocumentSnapshot element = await FirebaseFirestore.instance
        .collection(FirestorePath.events())
        .doc(id)
        .get();

    var obj = EventsModelClass(
        eventname: element["name"],
        eventid: element["id"],
        eventdescription: element["description"],
        eventimage: element["image"],
        eventendTime: element["endTime"].toDate(),
        eventstartTime: element["startTime"].toDate(),
        eventtype: element["type"],
        eventurl: element["url"]);

    return obj;
  }

  static rSVPEvent(String userID, String eventID, String eventType) {
    //1 = joined done
    //0  not joined
    FirebaseFirestore.instance.collection(FirestorePath.eventsAttendee()).add({
      Parameters.UserID: userID,
      Parameters.added_on: DateTime.now(),
      Parameters.is_bookmark: false,
      Parameters.status: 1,
      Parameters.eventtype: eventType,
      Parameters.EventID: eventID
    }).then((value) {
      print(value);
    });
  }

  static Future<Query> getEventRSVPStatus(String id, String eventid) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.eventsAttendee())
        .where(Parameters.UserID, isEqualTo: id)
        .where(Parameters.EventID, isEqualTo: eventid);
    return obj;
  }

  static selectBookmark(String eventAtenddeeId, bool isBookmark) {
    FirebaseFirestore.instance
        .collection(FirestorePath.eventsAttendee())
        .doc(eventAtenddeeId)
        .update({Parameters.is_bookmark: isBookmark});
  }

  static Future<Query> getEventIDs(String id) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.eventsAttendee())
        .where(Parameters.UserID, isEqualTo: id);
    //  .where("startTime", isGreaterThanOrEqualTo: new DateTime.now());
    return obj;
  }

  static Future<Query> getEventDates(var startDate, var endDate) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.eventsAttendee())
        .where(Parameters.added_on, isGreaterThanOrEqualTo: startDate)
        .where(Parameters.added_on, isLessThanOrEqualTo: endDate);
    return obj;
  }

  static Future<Query> getEventList(
      List<String> ids, int month, int year, String category) async {
    print(ids);
    var date = DateTime.now();
    print(date.month);
    if (category == "All") {
      var obj = FirebaseFirestore.instance
          .collection(FirestorePath.events())
          .where("id", whereIn: ids)
          .where("startTime",
              isGreaterThanOrEqualTo: new DateTime(year, month, 1))
          .where('startTime',
              isLessThanOrEqualTo: new DateTime(year, month + 1, 1))
          .orderBy('startTime', descending: true);
      return obj;
    } else {
      var obj = FirebaseFirestore.instance
          .collection(FirestorePath.events())
          .where("id", whereIn: ids)
          .where("startTime",
              isGreaterThanOrEqualTo: new DateTime(year, month, 1))
          .where('startTime',
              isLessThanOrEqualTo: new DateTime(year, month + 1, 1))
          .where('type', isEqualTo: category)
          .orderBy('startTime', descending: true);
      return obj;
    }
  }

  static Future<Query> getSearchUser(String name) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .where("Username",
            isGreaterThanOrEqualTo: name,
            isLessThan: name.substring(0, name.length - 1) +
                String.fromCharCode(name.codeUnitAt(name.length - 1) + 1));
    return obj;
  }

  static Future<List<UserModelClass>> getuserModelClass() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .get();

    HashMap<String, UserModelClass> eventsHashMap =
        new HashMap<String, UserModelClass>();

    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
          element.id,
          () => new UserModelClass(
                userId: element["Userid"],
                userName: element["Username"] != null
                    ? element["Username"]
                    : "UserName",
                fcmToken: element["token"] != null ? element["token"] : "",
                // stageImage:
                //     element["StageImage"] != null ? element["StageImage"] : "",
                avatarImage: element["AvatarImage"] != null
                    ? element["AvatarImage"]
                    : "",
                squadInviteEnable: element[Parameters.allowSquadInvites] != null
                    ? element[Parameters.allowSquadInvites]
                    : true,
                isPushEnable:
                    element[Parameters.isPushNotificationEnabled] != null
                        ? element[Parameters.isPushNotificationEnabled]
                        : true,
                // weaponImage: element["WeaponImage"] != null
                //     ? element["WeaponImage"]
                //     : "",
                // facebookId:
                //     element["facebookID"] != null ? element["facebookID"] : "",
                // instaId: element["instaID"] != null ? element["instaID"] : "",
                // nintendoId:
                //     element["nintendoID"] != null ? element["nintendoID"] : "",
                // psnId: element["psnID"] != null ? element["psnID"] : "",
                // twitchId:
                //     element["twitchID"] != null ? element["twitchID"] : "",
                // twitterId:
                //     element["twitterID"] != null ? element["twitterID"] : "",
                // xboxId: element["xboxID"] != null ? element["xboxID"] : "",
              ));
      // favArry: element["favArray"] != null ? element["favArray"] : []));
    });
    return eventsHashMap.values.length != 0
        ? eventsHashMap.values.toList()
        : [];
  }

  static Future<Query> getRewards(String type) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.rewardsList())
        .where("type", isEqualTo: type);
    return obj;
  }

  static Future<dynamic> updateRewardsRdeem(Map<String, dynamic> dict) async {
    var obj = await FirebaseFirestore.instance
        .collection(FirestorePath.rewardsRedeem())
        .add(dict);
    return obj;
  }

  static Future<Query> getUsersRedeemedIDs(String id) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.rewardsRedeem())
        .where(Parameters.UserID, isEqualTo: id);
    return obj;
  }
}

// List<EventsModelClass> events;
//   var date = DateTime.now();
//   var obj = FirebaseFirestore.instance
//       .collection(FirestorePath.events())
//       .where("id", whereIn: ids)
//       // .where('startTime',
//       //     isGreaterThanOrEqualTo: new DateTime(date.year, date.month, 1))
//       // .orderBy('startTime', descending: true)
//       .snapshots()
//       .map((event) {
//     return events = event.docs.map((e) {
//       return EventsModelClass.fromMap(e.data());
//     }).toList();
//   });
// }
