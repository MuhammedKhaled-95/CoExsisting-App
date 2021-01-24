import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInClass extends StatefulWidget {
  CheckInClass({Key key}) : super(key: key);
  static const routeName = '/CheckInClass';
  @override
  _CheckInClassState createState() => _CheckInClassState();
}

class _CheckInClassState extends State<CheckInClass> {
  var userID = "";
  String stage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserID().then((id) {
      setState(() {
        userID = id;
      });
    });
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: new AppBar(
          leading: new Container(),
          backgroundColor: Colors.transparent,
          title: Image.asset(
            "assets/logo.png",
            width: MediaQuery.of(context).size.width * 0.30,
            fit: BoxFit.cover,
          ),
          elevation: 0,
        ),
        backgroundColor: Color(0xFF1D1D1D),
        body: Stack(
            children: [_loadBgImage(), addContainer(), _buildMainWidget()]));
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  _buildMainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
            child: userID != "" ? addQRCode() : Container()),
        SizedBox(
          height: 30,
        ),
        addbackButton()
      ],
    );
  }

  getUserDetail() {
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          if (value["StageImage"] != null) {
            stage = value['StageImage'];
          } else {
            stage = "";
          }
        });
      });
    });
  }

  Widget _loadBgImage() {
    return stage != ""
        ? CachedNetworkImage(
            imageUrl: stage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.darken),
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : Container();
  }

  addContainer() {
    return Center(
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height * 0.30 + 30,
        width: MediaQuery.of(context).size.height * 0.30 + 30,
      ),
    );
  }

  addbackButton() {
    return IconButton(
      icon: Image.asset('assets/back.png'),
      iconSize: 50,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  addQRCode() {
    return Center(
        child: Container(
      color: Colors.white,
      child: QrImage(
        data: userID,
        version: QrVersions.auto,
        size: MediaQuery.of(context).size.height * 0.30,
        gapless: false,
        embeddedImage: AssetImage('assets/logo.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(100, 40),
        ),
      ),
    ));
  }
}
