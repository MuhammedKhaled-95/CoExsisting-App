import 'dart:async';
import 'dart:convert';
import 'package:coexist_gaming/Models/FavFiveModel.dart';
import 'package:coexist_gaming/Models/searchgameModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

class WebserviceClass {
  static Future<GamesModelClass> fetchGames(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return GamesModelClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<SearchGameModel> searchGames(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return SearchGameModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<Map<String, dynamic>> sendAndRetrieveMessage(
      String token, String body, String type, Map<String, dynamic> dict) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    final String serverToken = Constants.FirebaseServerKey;
    http.Response response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': dict,
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
    print(response.body);
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }
}

enum NotificaionCategory { INVITE, NEW_MESSAGE, EVENT_STARTED }
