import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class ShareAccountClass extends StatefulWidget {
  final Function callback;
  ShareAccountClass(this.callback);
  @override
  _ShareAccpuntClassState createState() => _ShareAccpuntClassState();
}

class _ShareAccpuntClassState extends State<ShareAccountClass> {
  TextEditingController _xboxController = TextEditingController();
  TextEditingController _psnController = TextEditingController();
  TextEditingController _nintendoController = TextEditingController();
  TextEditingController _twitchController = TextEditingController();
  TextEditingController _instaController = TextEditingController();
  TextEditingController _fbController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();

  String stage = "";
  String username = "USERNAME";
  String avatar = "";
  String weapon = "";
  bool fromEditPage = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.callback == null) {
      fromEditPage = true;
    } else {
      fromEditPage = false;
    }
    isLoading = true;
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          isLoading = false;
          username = value['Username'];
          avatar = value['AvatarImage'];
          stage = value['StageImage'];
          weapon = value["WeaponImage"];
          if (value["instaID"] != null) {
            _instaController.text = value["instaID"];
          }
          if (value["nintendoID"] != null) {
            _nintendoController.text = value["nintendoID"];
          }
          if (value["psnID"] != null) {
            _psnController.text = value["psnID"];
          }
          if (value["twitchID"] != null) {
            _twitchController.text = value["twitchID"];
          }
          if (value["twitterID"] != null) {
            _twitterController.text = value["twitterID"];
          }
          if (value["xboxID"] != null) {
            _xboxController.text = value["xboxID"];
          }
          if (value["facebookID"] != null) {
            _fbController.text = value["facebookID"];
          }
        });
      });
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          stage != "" ? _loadBgImage() : Container(),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _buildMainWidget(),
        ]));
  }

  Widget _loadBgImage() {
    return CachedNetworkImage(
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
    );
  }

  Widget _buildMainWidget() {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              avatar != ""
                  ? Container(
                      width: 65,
                      height: 65,
                      child: CachedNetworkImage(imageUrl: avatar),
                    )
                  : Container(),
              Expanded(
                child: Text(
                  '$username',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFFC4C5C7),
                      fontFamily: Constants.PrimaryFont,
                      fontWeight: FontWeight.normal),
                ),
              ),
              weapon != ""
                  ? Container(
                      width: 85,
                      height: 85,
                      child: CachedNetworkImage(imageUrl: weapon),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "SHARE ACCOUNTS",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontFamily: Constants.PrimaryFont,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  addXboxTextFeild(_xboxController, "Xbox Live GameTag...",
                      Color(0xFF36930F), "assets/xbox.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  addXboxTextFeild(_psnController, "PSN Username...",
                      Color(0xFF0082C9), "assets/PSN.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  addXboxTextFeild(
                      _nintendoController,
                      "Nintendo Switch Friend Code...",
                      Color(0xFFD40716),
                      "assets/nintendo.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  addXboxTextFeild(_twitchController, "Twitch Username...",
                      Color(0xFF6340A4), "assets/twitch.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  addXboxTextFeild(_instaController, "Instagram...",
                      Color(0xFFDE2E58), "assets/instagram.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  addXboxTextFeild(_twitterController, "Twitter...",
                      Color(0xFF2CA7E0), "assets/twitter.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  addXboxTextFeild(_fbController, "Facebook...",
                      Color(0xFF3B5998), "assets/facebook.webp"),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: 49,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        saveAccounts();
                      },
                      color: Color(0xFFB40000),
                      textColor: Colors.white,
                      child: Text(
                        fromEditPage ? "SAVE" : "NEXT",
                        style: TextStyle(
                            fontSize: 16, fontFamily: Constants.PrimaryFont),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  fromEditPage ? bottomButton() : Container()
                ],
              ))
        ],
      ),
    ));
  }

  bottomButton() {
    return new Align(
      alignment: FractionalOffset.bottomCenter,
      child: IconButton(
        icon: Image.asset('assets/back.png'),
        iconSize: 48,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  saveAccounts() {
    if (fromEditPage) {
      final Map<String, String> dictionary = {
        Parameters.xboxID: _xboxController.text,
        Parameters.psnID: _psnController.text,
        Parameters.facebookID: _fbController.text,
        Parameters.instaID: _instaController.text,
        Parameters.nintendoID: _nintendoController.text,
        Parameters.twitchID: _twitchController.text,
        Parameters.twitterID: _twitterController.text
      };
      update(dictionary);
    } else {
      final Map<String, dynamic> dictionary = {
        Parameters.xboxID: _xboxController.text,
        Parameters.psnID: _psnController.text,
        Parameters.facebookID: _fbController.text,
        Parameters.instaID: _instaController.text,
        Parameters.nintendoID: _nintendoController.text,
        Parameters.twitchID: _twitchController.text,
        Parameters.twitterID: _twitterController.text,
        Parameters.points: 50
      };
      update(dictionary);
      updateRwardsTable();
    }
  }

  updateRwardsTable() {
    getuserID().then((id) {
      final Map<String, dynamic> dict = {
        Parameters.UserID: id,
        Parameters.points: 50,
        Parameters.added_on: DateTime.now(),
        Parameters.rewardName: "ProfileComplete"
      };
      OnboardingRepository.updateRewardsPoints(dict)
          .then((value) => print("points added"));
    });
  }

  update(Map<String, dynamic> dictionary) {
    getuserID().then((id) {
      OnboardingRepository.updateAccounts(id, dictionary);
      !fromEditPage ? widget.callback(6) : Navigator.pop(context);
      if (fromEditPage) {
        StateProvider _stateProvider = StateProvider();
        _stateProvider.notify(ObserverState.UPDATEPROFILE, null);
      }
    });
  }

  Widget addXboxTextFeild(TextEditingController controller, String hint,
      Color color, String image) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            image,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 90,
              height: 48,
              child: new TextField(
                controller: controller,
                style: new TextStyle(
                    fontFamily: Constants.PrimaryFont,
                    fontSize: 16,
                    color: Colors.white),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintStyle: new TextStyle(
                      fontFamily: Constants.PrimaryFont,
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    hintText: hint,
                    fillColor: color),
              ))
        ]);
  }
}
