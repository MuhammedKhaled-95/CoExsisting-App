import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Services/Webservice.dart';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:coexist_gaming/chat/ChatMessageListItem.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

final analytics = new FirebaseAnalytics();

var currentUserEmail;
var _scaffoldContext;

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';
  final String squadID;
  final String squadName;
  final bool isFromNotifcation;
  final List squadMembers;

  ChatScreen(
      this.squadID, this.squadName, this.isFromNotifcation, this.squadMembers);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> implements StateListener {
  final TextEditingController _textEditingController =
      new TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isComposingMessage = false;
  bool isLoad = false;

  ChatScreenState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  Query get query => FirebaseFirestore.instance
      .collection(FirestorePath.messages())
      .where("squadId", isEqualTo: squadID);

  String username = "USERNAME";
  String userid = "";
  String avatar;
  String email;
  String squadName = "";
  String squadID = "";
  var fcmTokens = [];
  var memebersId = [];

  @override
  void initState() {
    super.initState();

    if (widget.isFromNotifcation) {
      memebersId = widget.squadMembers;
    } else {
      this
          .widget
          .squadMembers
          .forEach((location) => memebersId.add(location["memberId"]));
    }

    print(memebersId);

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    _scrollController = ScrollController();
    getuserID().then((id) {
      userid = id;
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          username = value['Username'];
          avatar = value['AvatarImage'];
          email = value["Email"];
        });
      });
    });

    getTokens();
    Timer(
        Duration(milliseconds: 50),
        () => _scrollController
            ?.jumpTo(_scrollController.position.maxScrollExtent)
        // () => _scrollController.animateTo(
        //     _scrollController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 330),
        //     curve: Curves.ease),
        );
    squadID = widget.squadID;
    setState(() {
      isLoad = true;
      squadName = widget.squadName;
    });
    Constants.isSQUADID = squadID;
    Constants.isOnNotificationClass = true;
  }

  getTokens() {
    OnboardingRepository.getUsers(memebersId).then((value) {
      for (var val in value) {
        if (val["Userid"] != userid) {
          if (val[Parameters.isTextNotificationEnabled]) {
            fcmTokens.add(val["token"]);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(milliseconds: 220),
      () => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 220),
          curve: Curves.ease),
    );
    return new Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
          title: new Text(squadName),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          leading: Container(),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.pop(context);
                  Constants.isOnNotificationClass = false;
                })
          ],
        ),
        body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: new Container(
              child: new Column(
                children: <Widget>[
                  new Flexible(
                    child: new FirestoreAnimatedList(
                      query: query,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      reverse: false,
                      onLoaded: (snapshot) =>
                          print("Received on list: ${snapshot.docs.length}"),
                      itemBuilder: (BuildContext context,
                          DocumentSnapshot messageSnapshot,
                          Animation<double> animation,
                          int index) {
                        print(messageSnapshot);

                        return new ChatMessageListItem(
                          messageSnapshot: messageSnapshot,
                          animation: animation,
                          currentUserEmail: email,
                        );
                      },
                    ),
                  ),
                  new Divider(height: 1.0),
                  new Container(
                    decoration:
                        new BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                  new Builder(builder: (BuildContext context) {
                    _scaffoldContext = context;
                    return new Container(width: 0.0, height: 0.0);
                  })
                ],
              ),
              decoration: Theme.of(context).platform == TargetPlatform.iOS
                  ? new BoxDecoration(
                      border: new Border(
                          top: new BorderSide(
                      color: Colors.grey[200],
                    )))
                  : null,
            )));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    final maxLines = 5;
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              // new Container(
              //   margin: new EdgeInsets.symmetric(horizontal: 4.0),
              //   child: new IconButton(
              //       icon: new Icon(
              //         Icons.photo_camera,
              //         color: Theme.of(context).accentColor,
              //       ),
              //       onPressed: () async {
              //         // File imageFile = await ImagePicker.pickImage();
              //         //   int timestamp = new DateTime.now().millisecondsSinceEpoch;
              //         //  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
              //         //       .instance
              //         //       .ref()
              //         //       .child("img_" + timestamp.toString() + ".jpg");
              //         //   StorageUploadTask uploadTask =
              //         //       storageReference.put(imageFile);
              //         //   Uri downloadUrl = (await uploadTask.future).downloadUrl;
              //         //   _sendMessage(
              //         //       messageText: null, imageUrl: downloadUrl.toString());
              //       }),
              // ),
              new Flexible(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 15),
                child: new TextField(
                  minLines: 1,
                  maxLines: maxLines,
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              )),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    //await _ensureLoggedIn();
    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    var time = Timestamp.now().microsecondsSinceEpoch.toString();
    FirebaseFirestore.instance.collection('messages').doc(time).set({
      'text': messageText,
      'email': email,
      'imageUrl': imageUrl,
      'senderName': username,
      'senderPhotoUrl': avatar,
      'createdAt': DateTime.now(),
      'squadId': widget.squadID
    });
    analytics.logEvent(name: 'send_message');
    sendNotification();
  }

  sendNotification() {
    var str = username + " send message in " + squadName;
    var dict = <String, dynamic>{
      'body': str,
      'category': "3",
      "title": "COEXIST GAMING",
      'membersId': memebersId,
      'squadId': squadID,
      'squadName': squadName
    };
    for (var fcm in fcmTokens) {
      WebserviceClass.sendAndRetrieveMessage(fcm, str, "3", dict);
    }
  }

  @override
  void onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    if (state == ObserverState.UpdateChatData) {
      Timer(
          Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 100),
              curve: Curves.ease));
    }
  }
}

// Future chooseFile() async {
//    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
//      setState(() {
//        _image = image;
//      });
//    });
//  }

// Future<Null> _ensureLoggedIn() async {
//   GoogleSignInAccount signedInUser = googleSignIn.currentUser;
//   if (signedInUser == null)
//     signedInUser = await googleSignIn.signInSilently();
//   if (signedInUser == null) {
//     await googleSignIn.signIn();
//     analytics.logLogin();
//   }

// currentUserEmail = googleSignIn.currentUser.email;

// if (await auth.currentUser() == null) {
//   GoogleSignInAuthentication credentials =
//       await googleSignIn.currentUser.authentication;
//   await auth.signInWithGoogle(
//       idToken: credentials.idToken, accessToken: credentials.accessToken);
// }
//  }
//}
