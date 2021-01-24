import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Models/squadModel.dart';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';

class SquadRepository {
  static Future<String> createSquad(dynamic dict) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection(FirestorePath.createSquads())
        .add(dict);
    print(docRef.id);
    return docRef.id;
  }

  static joinSquad(String docID, var memberIds) {
    FirebaseFirestore.instance
        .collection(FirestorePath.createSquads())
        .doc(docID)
        .update({
      Parameters.membersId: FieldValue.arrayUnion([memberIds])
    });
  }

  static addNotification(Map<String, dynamic> dict) {
    FirebaseFirestore.instance
        .collection(FirestorePath.notifications())
        .add(dict);
  }

  static Future<QuerySnapshot> getNotifications(String userid) async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.notifications())
        .where('inviteeId', isEqualTo: userid)
        .where('isRead', isEqualTo: false)
        .get();
    return eventsQuery;
  }

  static updateNotificationReadStatus(String docId) async {
    FirebaseFirestore.instance
        .collection(FirestorePath.notifications())
        .doc(docId)
        .update({Parameters.isRead: true});
  }

  static clearAllNotifcation(String userId) async {
    DocumentReference docRef;
    var response = await FirebaseFirestore.instance
        .collection(FirestorePath.notifications())
        .where('inviteeId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    var batch = FirebaseFirestore.instance.batch();

    response.docs.forEach((doc) {
      docRef = FirebaseFirestore.instance
          .collection(FirestorePath.notifications())
          .doc(doc.id);
      batch.update(docRef, {Parameters.isRead: true});
    });
    batch.commit().then((a) {
      print('updated all documents inside Collection');
    });
  }

  static Future<SquadModelClass> getSquad(String squadID) async {
    DocumentSnapshot element = await FirebaseFirestore.instance
        .collection(FirestorePath.createSquads())
        .doc(squadID)
        .get();

    var obj = new SquadModelClass(
      ownerID: element[SquadModelClass.ownerId],
      timee: element[SquadModelClass.time],
      squadname: element[SquadModelClass.squadName],
      duraton: element[SquadModelClass.duration],
      timeestamp: element[SquadModelClass.timestamp],
      datee: element[SquadModelClass.date],
      members: element[SquadModelClass.membersId],
      gamel: element[SquadModelClass.game] != null
          ? GameSquad.fromMap(element[SquadModelClass.game])
          : null,
    );
    return obj;
  }

  static Future<Query> getMySquadIDs(String id) async {
    var obj = FirebaseFirestore.instance
        .collection(FirestorePath.createSquads())
        .where("ownerId", isEqualTo: id);
    return obj;
  }

  static Future<List<SquadModelClass>> getAllSquads(
      DocumentSnapshot lastDocument) async {
    QuerySnapshot eventsQuery;
    if (lastDocument == null) {
      eventsQuery = await FirebaseFirestore.instance
          .collection(FirestorePath.createSquads())
          .limit(10)
          .get();
    } else {
      eventsQuery = await FirebaseFirestore.instance
          .collection(FirestorePath.createSquads())
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }

    HashMap<String, SquadModelClass> eventsHashMap =
        new HashMap<String, SquadModelClass>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
        element.id,
        () => SquadModelClass(
          ownerID: element[SquadModelClass.ownerId],
          timee: element[SquadModelClass.time],
          squadname: element[SquadModelClass.squadName],
          duraton: element[SquadModelClass.duration],
          timeestamp: element[SquadModelClass.timestamp],
          datee: element[SquadModelClass.date],
          members: element[SquadModelClass.membersId],
          gamel: element[SquadModelClass.game] != null
              ? GameSquad.fromMap(element[SquadModelClass.game])
              : null,
        ),
      );
    });
    return eventsHashMap.values.toList();
  }
}
