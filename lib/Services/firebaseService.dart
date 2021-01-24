import 'dart:async';
import 'dart:io';
import 'package:coexist_gaming/Services/firestorePath.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<dynamic> signUp(String email, String password);
  Future<User> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
  Future<String> signInAnonymously();
  Future<void> updateFCMToken();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> signIn(String email, String password) async {
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user.emailVerified) {
        saveUserID(user.uid);
        firestore
            .collection(FirestorePath.users())
            .doc(user.uid)
            .get()
            .then((docSnapshot) => {
                  if (docSnapshot.exists) {update(user)} else {add(user)}
                });

        return "Success";
      } else {
        user.sendEmailVerification();
        return "Email_Not_Verified";
      }
    } catch (e) {
      return getMessageFromErrorCode(e.code);
    }
  }

  update(User user) {
    firestore.collection(FirestorePath.users()).doc(user.uid).update({
      Parameters.Email: user.email,
      Parameters.UserID: user.uid,
      Parameters.isGuestLogin: false,
      Parameters.isPushNotificationEnabled: true,
      Parameters.isTextNotificationEnabled: true,
      Parameters.isEmailNotificationEnabled: true,
      Parameters.allowSquadInvites: true,
      Parameters.shareSocialEnabled: true,
    });
  }

  add(User user) {
    firestore.collection(FirestorePath.users()).doc(user.uid).set({
      Parameters.Email: user.email,
      Parameters.UserID: user.uid,
      Parameters.points: 0,
      Parameters.isGuestLogin: false,
      Parameters.isPushNotificationEnabled: true,
      Parameters.isTextNotificationEnabled: true,
      Parameters.isEmailNotificationEnabled: true,
      Parameters.allowSquadInvites: true,
      Parameters.shareSocialEnabled: true,
    });
  }

  Future<String> signInAnonymously() async {
    try {
      User user = (await _firebaseAuth.signInAnonymously()).user;
      print(user.isAnonymous);
      saveUserID(user.uid);
      DateTime now = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var fcmToken = prefs.get(FCMTOKEN);
      var str = "guest_" + now.millisecondsSinceEpoch.toString();
      firestore.collection(FirestorePath.users()).doc(user.uid).set({
        Parameters.Email: "",
        Parameters.UserID: user.uid,
        Parameters.AvatarImg:
            "https://firebasestorage.googleapis.com/v0/b/coexist-gaming.appspot.com/o/Avatars%2FAvatar6.png?alt=media&token=d7a97b23-dbdf-4f7c-88af-3935bfd0aaf4",
        Parameters.Username: str,
        Parameters.WeaponImg: "",
        Parameters.StageImg:
            "https://firebasestorage.googleapis.com/v0/b/coexist-gaming.appspot.com/o/Stages%2FStage2.png?alt=media&token=d5da81f6-b70a-4049-97f8-cd0fde93738a",
        "favArray": [],
        'token': fcmToken,
        'tokencreatedAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem,
        Parameters.isGuestLogin: true,
        Parameters.points: 0,
        Parameters.isPushNotificationEnabled: true,
        Parameters.isTextNotificationEnabled: true,
        Parameters.isEmailNotificationEnabled: true,
        Parameters.allowSquadInvites: true,
        Parameters.shareSocialEnabled: false,
      });
      return "Success";
    } catch (e) {
      return getMessageFromErrorCode(e.code);
    }
  }

  saveUserID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USERID, userID);
  }

  String getMessageFromErrorCode(dynamic e) {
    switch (e) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already taken.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No account found with this email";
        break;
      default:
        return "Login failed. Please try again.";
        break;
    }
  }

  Future<dynamic> signUp(String email, String password) async {
    User user;
    try {
      user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      print(user);
      await user.sendEmailVerification();
      return "Success";
    } catch (error) {
      return getMessageFromErrorCode(error.code);
    }
  }

  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  Future<void> updateFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.get(USERID);
    var fcmToken = prefs.get(FCMTOKEN);

    if (fcmToken != null) {
      firestore.collection(FirestorePath.users()).doc(userID).update({
        'token': fcmToken,
        'tokencreatedAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem
      });
    }
  }
}
