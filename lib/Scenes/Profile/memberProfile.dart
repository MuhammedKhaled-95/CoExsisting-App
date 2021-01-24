import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

class MemberProfile extends StatefulWidget {
  static const routeName = '/MemberProfile';
  final String memberId;
  MemberProfile(this.memberId);
  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  TextEditingController _xboxController = TextEditingController();
  TextEditingController _psnController = TextEditingController();
  TextEditingController _instaController = TextEditingController();
  TextEditingController _nintendoController = TextEditingController();
  TextEditingController _twitchController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  int points = 0;
  String stage = "";
  String username = "USERNAME";
  String avatar = "";
  String weapon = "";
  List _favFiveList = List();
  bool shareAccounts = true;
  bool isMemeberGuest = false;
  var dataLoad = false;
  @override
  void initState() {
    super.initState();
    _favFiveList = List();
    dataLoad = false;
    getUserDetail();
  }

  getUserDetail() {
    print(widget.memberId);

    OnboardingRepository.getUser(widget.memberId).then((value) {
      setState(() {
        dataLoad = true;
        if (value["Username"] != null) {
          username = value['Username'];
        } else {
          username = "USERNAME";
        }

        if (value["AvatarImage"] != null) {
          avatar = value['AvatarImage'];
        } else {
          avatar = "";
        }

        if (value["StageImage"] != null) {
          stage = value['StageImage'];
        } else {
          stage = "";
        }

        if (value["WeaponImage"] != null) {
          weapon = value['WeaponImage'];
        } else {
          weapon = "";
        }

        if (value["favArray"] != null) {
          _favFiveList = value['favArray'];
        } else {
          _favFiveList = [];
        }
        if (value["points"] != null) {
          points = value['points'];
        } else {
          points = 0;
        }
        if (value[Parameters.shareSocialEnabled] != null) {
          shareAccounts = value[Parameters.shareSocialEnabled];
        }

        if (value[Parameters.isGuestLogin] != null) {
          isMemeberGuest = value[Parameters.isGuestLogin];
        }

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
          _facebookController.text = value["facebookID"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D1D1D),
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text("MEMBERS", style: Constants.navigationTitleStyle),
          leading: IconButton(
            icon: Image.asset(
              "assets/back.png",
              width: 33,
              height: 33,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(children: [
          _loadBgImage(),
          _buildMainWidget(),
        ]));
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

  Widget _buildMainWidget() {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Center(
              child: dataLoad
                  ? Column(
                      children: <Widget>[
                        space(),
                        space(),
                        addUserName(),
                        space(),
                        space(),
                        space(),
                        addAvatar(),
                        space(),
                        space(),
                        space(),
                        space(),
                        addCoins(),
                        space(),
                        space(),
                        space(),
                        space(),
                        space(),
                        changeStageWidget(),
                        space(),
                        space(),
                        space(),
                        space(),
                        space(),
                        space(),
                        !isMemeberGuest ? changeWeaponWidget() : Container(),
                        space(),
                        space(),
                        !isMemeberGuest ? selectedWeapon() : Container(),
                        space(),
                        space(),
                        !isMemeberGuest ? editfavFive() : Container(),
                        space(),
                        space(),
                        !isMemeberGuest ? addListView() : Container(),
                        space(),
                        space(),
                        shareAccounts ? addAccounts() : Container()
                      ],
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: Center(child: CircularProgressIndicator())),
            )));
  }

  space() {
    return SizedBox(
      height: 5,
    );
  }

  addAccounts() {
    return Column(
      children: <Widget>[
        addXboxTextFeild(_xboxController, "Xbox Live GameTag...",
            Color(0xFF36930F), "assets/xbox.webp"),
        SizedBox(
          height: 20,
        ),
        addXboxTextFeild(_psnController, "PSN Username...", Color(0xFF0082C9),
            "assets/PSN.webp"),
        SizedBox(
          height: 20,
        ),
        addXboxTextFeild(_nintendoController, "Nintendo Switch Friend Code...",
            Color(0xFFD40716), "assets/nintendo.webp"),
        SizedBox(
          height: 20,
        ),
        addXboxTextFeild(_twitchController, "Twitch Username...",
            Color(0xFF6340A4), "assets/twitch.webp"),
        SizedBox(
          height: 20,
        ),
        addXboxTextFeild(_instaController, "Instagram...", Color(0xFFDE2E58),
            "assets/instagram.webp"),
        SizedBox(
          height: 20,
        ),
        addXboxTextFeild(_twitterController, "Twitter...", Color(0xFF2CA7E0),
            "assets/twitter.webp"),
        SizedBox(
          height: 20,
        ),
        addXboxTextFeild(_facebookController, "Facebook...", Color(0xFF3B5998),
            "assets/facebook.webp"),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget addXboxTextFeild(TextEditingController controller, String hint,
      Color color, String image) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            image,
            width: 50,
            height: 50,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 90,
              height: 48,
              child: new TextField(
                style: new TextStyle(
                    fontFamily: Constants.PrimaryFont,
                    fontSize: 16,
                    color: Colors.white),
                controller: controller,
                readOnly: true,
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

  addUserName() {
    return InkWell(
      child: Text(
        "$username",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 30,
            color: Color(0xFFC4C5C7),
            //fontFamily: Constants.PrimaryFont,
            fontWeight: FontWeight.normal),
      ),
      onTap: () {},
    );
  }

  addCoins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/coin.webp", width: 36, height: 36),
        SizedBox(
          width: 10,
        ),
        Text(
          "$points",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: Constants.PrimaryFont,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  addAvatar() {
    return Container(
        decoration: new BoxDecoration(
          border: Border.all(width: 5, color: Colors.grey),
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: avatar != ""
                ? CachedNetworkImage(
                    imageUrl: "$avatar",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )
                : Container(
                    width: 100,
                    height: 100,
                  )));
  }

  changeStageWidget() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
              height: 46,
              decoration: new BoxDecoration(
                color: Color(0xFF076A95),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(145.0),
                    bottomLeft: Radius.circular(145.0)),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PRO MEMBER",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: Constants.PrimaryFont,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            "assets/gameController.webp",
            fit: BoxFit.cover,
            height: 52,
            width: 40,
          ),
        ),
      ],
    );
  }

  changeWeaponWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFFA02B27),
                const Color(0xFFA26E21),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "WEAPON OF CHOICE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }

  selectedWeapon() {
    return weapon != ""
        ? CachedNetworkImage(
            imageUrl: "$weapon",
            width: MediaQuery.of(context).size.width * 0.70,
            height: 150,
          )
        : Container();
  }

  addListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 120.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _favFiveList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.darken,
                  child: _favFiveList[index]["image"] != null
                      ? CachedNetworkImage(
                          imageUrl: _favFiveList[index]["image"],
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height)
                      : Container(),
                ),
                width: MediaQuery.of(context).size.width / 6,
                //  height: 120,
              ),
            );
          }),
    );
  }

  editfavFive() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4527A0),
                const Color(0xFF7520A2),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "FAVE FIVE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
