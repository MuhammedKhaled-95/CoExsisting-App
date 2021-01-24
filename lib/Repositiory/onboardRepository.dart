import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Models/avatarModel.dart';
import 'package:coexist_gaming/Models/partnerModel.dart';
import 'package:coexist_gaming/Models/stageModel.dart';
import 'package:coexist_gaming/Models/userModel.dart';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';

class OnboardingRepository {
  static Future<List<AvatarModelClass>> readData() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.avatars())
        .get();
    HashMap<String, AvatarModelClass> eventsHashMap =
        new HashMap<String, AvatarModelClass>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(element.id,
          () => new AvatarModelClass(name: element['Avatar_Image']));
    });
    return eventsHashMap.values.toList();
  }

  static Future<List<StageModelClass>> readStageData() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.stages())
        .get();
    HashMap<String, StageModelClass> eventsHashMap =
        new HashMap<String, StageModelClass>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
          element.id, () => new StageModelClass(name: element['stage_image']));
    });
    return eventsHashMap.values.toList();
  }

  static Future<List<ControllerModelClass>> getControllers() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.controllers())
        .get();
    HashMap<String, ControllerModelClass> eventsHashMap =
        new HashMap<String, ControllerModelClass>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
          element.id, () => new ControllerModelClass(name: element['image']));
    });
    return eventsHashMap.values.toList();
  }

  static Future<List<UserModelClass>> getMembers() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .get();
    HashMap<String, UserModelClass> eventsHashMap =
        new HashMap<String, UserModelClass>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
          element.id,
          () => UserModelClass(
              userId: element[UserModelClass.userid],
              avatarImage: element[UserModelClass.avatarimage],
              userName: element[UserModelClass.username],
              weaponImage: element[UserModelClass.weaponimage],
              stageImage: element[UserModelClass.stageimage],
              instaId: element[UserModelClass.instaid],
              xboxId: element[UserModelClass.xboxid],
              nintendoId: element[UserModelClass.nintendoid],
              twitchId: element[UserModelClass.twitchid],
              twitterId: element[UserModelClass.twitterid],
              favArry: element[UserModelClass.favArray],
              psnId: element[UserModelClass.psnid],
              facebookId: element[UserModelClass.facebookid]));
    });
    return eventsHashMap.values.toList();
  }

  static updateUsername(String name, String userID) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.Username: name});
  }

  static updateUserPoints(int points, String userID) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.points: points});
  }

  static updateAvatar(String name, String userID) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.AvatarImg: name});
  }

  static updateStage(String name, String userID) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.StageImg: name});
  }

  static updateWeapon(String name, String userID) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.WeaponImg: name});
  }

  static updateAccounts(String userID, Map<String, dynamic> dict) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update(dict);
  }

  static Future<dynamic> updateRewardsPoints(Map<String, dynamic> dict) async {
    var obj = await FirebaseFirestore.instance
        .collection(FirestorePath.rewardedPoints())
        .add(dict);
    return obj;
  }

  static updateFavFiveGames(List<dynamic> dict, String userID) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({"favArray": dict});
  }

  static Future<dynamic> getUser(String userID) async {
    DocumentSnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .get();
    var user = eventsQuery.data();
    return user;
  }

  static Future<dynamic> getUsers(List userIDs) async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .where("Userid", whereIn: userIDs)
        .get();
    var user = eventsQuery.docs;
    return user;
  }

  static Future<dynamic> getPartnersList() async {
    QuerySnapshot eventsQuery = await FirebaseFirestore.instance
        .collection(FirestorePath.partners())
        .get();

    HashMap<String, Partners> eventsHashMap = new HashMap<String, Partners>();

    eventsQuery.docs.forEach((element) {
      eventsHashMap.putIfAbsent(
          element.id, () => Partners.fromMap(element.data()));
    });

    return eventsHashMap.values.toList();
  }
}
