import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessageListItem extends StatelessWidget {
  final DocumentSnapshot messageSnapshot;
  var currentUserEmail;
  final Animation animation;
  ChatMessageListItem(
      {this.messageSnapshot, this.animation, this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: currentUserEmail == messageSnapshot['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot['senderName'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot['imageUrl'] != null
                  ? new Image.network(
                      messageSnapshot['imageUrl'],
                      width: 250.0,
                    )
                  : new Text(messageSnapshot['text'],
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(messageSnapshot['senderPhotoUrl']),
              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(messageSnapshot['senderPhotoUrl']),
              )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot['senderName'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot['imageUrl'] != null
                  ? new Image.network(
                      messageSnapshot['imageUrl'],
                      width: 250.0,
                    )
                  : new Text(messageSnapshot['text'],
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    ];
  }
}
