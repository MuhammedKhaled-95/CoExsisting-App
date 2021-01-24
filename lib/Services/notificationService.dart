import 'dart:convert';
import 'dart:io';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/SupportingClass/overlaynotification/lib/overlay_support.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isPushNotificationEnable = true;
  bool istextNotication = true;
  bool allowSquadInvite = true;

  Future initialise() async {
    if (Platform.isIOS) iOS_Permission();
    _fcm.getToken().then((token) {
      print('token : ' + token.toString());
      setToken(token);
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var data = message['aps'] ?? message;
        var alert = data['alert'] ?? message;
        String notificationTitle = alert['body'];
        var category = message["gcm.notification.category"];
        print("category" + category);
        if (category == "3") {
          String squadId = message["gcm.notification.squadId"];
          if (Constants.isOnNotificationClass &&
              Constants.isSQUADID == squadId) {
            StateProvider _stateProvider = StateProvider();
            _stateProvider.notify(ObserverState.UpdateChatData, null);
          } else {
            showSimpleNotification(
                Text("COEXIST GAMING" + "\n" + notificationTitle),
                background: Colors.white,
                notification: message);
          }
        } else {
          showSimpleNotification(
              Text("COEXIST GAMING" + "\n" + notificationTitle),
              background: Colors.white,
              notification: message);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Future.delayed(const Duration(seconds: 8), () {
          _serialiseAndNavigate(message);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _serialiseAndNavigate(message);
      },
    );
    //getUserDetail();
  }

  // getUserDetail() {
  //   getuserID().then((id) {
  //     OnboardingRepository.getUser(id).then((value) {
  //       isPushNotificationEnable = value[Parameters.isPushNotificationEnabled];
  //       allowSquadInvite = value[Parameters.allowSquadInvites];
  //       istextNotication = value[Parameters.isTextNotificationEnabled];
  //     });
  //   });
  // }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  void iOS_Permission() async {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FCMTOKEN, token.toString());
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    print("messsaggge" + message.toString());
    var category = message["gcm.notification.category"];
    print("category" + category);
    if (category == "1") {
      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.Notifications, null);
    }
    if (category == "3") {
      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.NEWMESSAGE, message);
    }
  }
}
