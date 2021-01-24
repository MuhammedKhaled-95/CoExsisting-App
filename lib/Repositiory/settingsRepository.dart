import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';

class SettingsRepository {
  static updatePushSettings(String userID, bool isPushNotification) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.isPushNotificationEnabled: isPushNotification});
  }

  static updateEmailSettings(String userID, bool isEnableNotification) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.isEmailNotificationEnabled: isEnableNotification});
  }

  static updateTextSettings(String userID, bool isEnableNotification) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.isTextNotificationEnabled: isEnableNotification});
  }

  static updateSocialSettings(String userID, bool isEnableNotification) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.shareSocialEnabled: isEnableNotification});
  }

  static updateSquadInviteSettings(String userID, bool isEnableNotification) {
    FirebaseFirestore.instance
        .collection(FirestorePath.users())
        .doc(userID)
        .update({Parameters.allowSquadInvites: isEnableNotification});
  }
}
