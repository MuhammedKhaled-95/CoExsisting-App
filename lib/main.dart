import 'package:coexist_gaming/Scenes/AuthenticationScreens/forgotPassword.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/initialPage.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/loginPage.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/memberLoginAction.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/password.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/passwordVerify.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/rootPage.dart';
import 'package:coexist_gaming/Scenes/AuthenticationScreens/verifyEmail.dart';
import 'package:coexist_gaming/Scenes/Home/baseTabbarClass.dart';
import 'package:coexist_gaming/Scenes/Notifcations/notifications.dart';
import 'package:coexist_gaming/Scenes/Onboarding/chooseAvatar.dart';
import 'package:coexist_gaming/Scenes/Onboarding/favFive.dart';
import 'package:coexist_gaming/Scenes/Onboarding/onboardingClass.dart';
import 'package:coexist_gaming/Scenes/Onboarding/selectStage.dart';
import 'package:coexist_gaming/Scenes/Onboarding/username.dart';
import 'package:coexist_gaming/Scenes/Onboarding/welcomePage.dart';
import 'package:coexist_gaming/Scenes/Profile/Profile.dart';
import 'package:coexist_gaming/Scenes/Profile/checkIn.dart';
import 'package:coexist_gaming/Scenes/Profile/editProfile.dart';
import 'package:coexist_gaming/Scenes/Profile/memberProfile.dart';
import 'package:coexist_gaming/Scenes/Settings/about.dart';
import 'package:coexist_gaming/Scenes/Settings/partners.dart';
import 'package:coexist_gaming/Scenes/Settings/settings.dart';
import 'package:coexist_gaming/Scenes/SquadUp/members.dart';
import 'package:coexist_gaming/Services/firebaseService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Scenes/Onboarding/selectController.dart';
import 'SupportingClass/overlaynotification/lib/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(OverlaySupport(
      child: MaterialApp(
    initialRoute: RootPage.routeName,
    theme: ThemeData(primarySwatch: Colors.pink),
    debugShowCheckedModeBanner: false,
    routes: {
      RootPage.routeName: (context) => RootPage(auth: new Auth()),
      InitialPage.routeName: (context) => InitialPage(),
      MemberLoginActionClass.routeName: (context) => MemberLoginActionClass(),
      VerifyEmailClass.routeName: (context) => VerifyEmailClass(),
      NewPasswordClass.routeName: (context) => NewPasswordClass(),
      LoginClass.routeName: (context) => LoginClass(),
      PasswordVerifyClass.routeName: (context) => PasswordVerifyClass(),
      WelcomePage.routeName: (context) => WelcomePage(),
      OnboardingClass.routeName: (context) => OnboardingClass(),
      ForgotPasswordClass.routeName: (context) => ForgotPasswordClass(),
      EditProfileClass.routeName: (context) => EditProfileClass(),
      UsernameClass.routeName: (context) => UsernameClass(true, "", null),
      AvatarClass.routeName: (context) => AvatarClass(null),
      SelectStageClass.routeName: (context) => SelectStageClass(null),
      SelectControllerClass.routeName: (context) => SelectControllerClass(null),
      SelectFavFiveClass.routeName: (context) => SelectFavFiveClass(null),
      BasetabbarClass.routeName: (context) => BasetabbarClass(),
      CheckInClass.routeName: (context) => CheckInClass(),
      MembersClass.routeName: (context) => MembersClass(),
      ProfileClass.routeName: (context) => ProfileClass(),
      MemberProfile.routeName: (context) => MemberProfile(null),
      AboutClass.routeName: (context) => AboutClass(),
      PartnersClass.routeName: (context) => PartnersClass(),
      SettingsClass.routeName: (context) => SettingsClass(),
      NotifcationClass.routeName: (context) => NotifcationClass(),
    },
  )));
}
