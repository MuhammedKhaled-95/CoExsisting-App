import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Scenes/Home/baseTabbarClass.dart';
import 'package:coexist_gaming/Scenes/Onboarding/chooseAvatar.dart';
import 'package:coexist_gaming/Scenes/Onboarding/favFive.dart';
import 'package:coexist_gaming/Scenes/Onboarding/selectController.dart';
import 'package:coexist_gaming/Scenes/Onboarding/selectStage.dart';
import 'package:coexist_gaming/Scenes/Onboarding/username.dart';
import 'package:coexist_gaming/Services/generalizedObserver.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileClass extends StatefulWidget {
  static const routeName = '/EditProfileClass';
  @override
  _EditProfileClassState createState() => _EditProfileClassState();
}

class _EditProfileClassState extends State<EditProfileClass> {
  List _favFiveList = List();
  TextEditingController _xboxController = TextEditingController();
  TextEditingController _psnController = TextEditingController();
  TextEditingController _instaController = TextEditingController();
  TextEditingController _nintendoController = TextEditingController();
  TextEditingController _twitchController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();

  bool fromProfile = false;
  String stage = "";
  String username = "USERNAME";
  String avatar = "";
  String weapon = "";
  int points = 0;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  getUserDetail() {
    getuserID().then((id) {
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
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

          if (value["points"] != null) {
            points = value['points'];
          } else {
            points = 0;
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
    });
  }

  @override
  void didUpdateWidget(EditProfileClass oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("oldddd widgetttt methid calllleddddddd");
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    final bool fromProfileArg = ModalRoute.of(context).settings.arguments;
    fromProfile = fromProfileArg;
    return Scaffold(
        backgroundColor: Color(0xFF1D1D1D),
        body: Stack(children: [
          stage != "" ? _loadBgImage() : Container(),
          _buildMainWidget(),
          fromProfile ? addBackButton() : Container()
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
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/logo.png",
                    width: MediaQuery.of(context).size.width * 0.30,
                  ),
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
                  space(),
                  changeStageWidget(),
                  space(),
                  space(),
                  space(),
                  space(),
                  space(),
                  space(),
                  changeWeaponWidget(),
                  space(),
                  space(),
                  weapon != "" ? selectedWeapon() : Container(),
                  space(),
                  space(),
                  editfavFive(),
                  space(),
                  space(),
                  _favFiveList.length != 0 ? addListView() : Container(),
                  space(),
                  space(),
                  fromProfile ? addAccounts() : Container(),
                  space(),
                  space(),
                  addCompleteButton(),
                  space(),
                  space(),
                  space(),
                  fromProfile ? Container() : bottomButton()
                ],
              ),
            )));
  }

  bottomButton() {
    return new Align(
      alignment: FractionalOffset.bottomLeft,
      child: IconButton(
        icon: Image.asset('assets/back.png'),
        iconSize: 48,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  addBackButton() {
    return Positioned(
        left: 0,
        top: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: IconButton(
            icon: Image.asset('assets/back.png'),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context, "datalaoding");
            },
          ),
        ));
  }

  space() {
    return SizedBox(
      height: 5,
    );
  }

  addCompleteButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      height: 49,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        onPressed: () {
          fromProfile
              ? Navigator.pop(context, "datalaoding")
              : Navigator.pushNamed(context, BasetabbarClass.routeName);
          if (fromProfile) {
            saveAccounts();
            StateProvider _stateProvider = StateProvider();
            _stateProvider.notify(ObserverState.LIST_CHANGED, null);
          }
        },
        color: Color(0xFFB40000),
        textColor: Colors.white,
        child: Text(
          "Complete",
          style: TextStyle(fontSize: 16, fontFamily: Constants.PrimaryFont),
        ),
      ),
    );
  }

  saveAccounts() {
    final Map<String, String> dictionary = {
      Parameters.xboxID: _xboxController.text,
      Parameters.psnID: _psnController.text,
      Parameters.facebookID: _facebookController.text,
      Parameters.instaID: _instaController.text,
      Parameters.nintendoID: _nintendoController.text,
      Parameters.twitchID: _twitchController.text,
      Parameters.twitterID: _twitterController.text
    };
    getuserID().then((id) {
      OnboardingRepository.updateAccounts(id, dictionary);
    });
  }

  addUserName() {
    return InkWell(
      child: Text(
        "$username",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 30,
            decoration: TextDecoration.underline,
            color: Color(0xFFC4C5C7),
            fontWeight: FontWeight.normal),
      ),
      onTap: () {
        _navigateUsernameSelection(context);
      },
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
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
                  : Container(),
            )),
        InkWell(
          child: Image.asset("assets/edit.webp", width: 24, height: 24),
          onTap: () {
            _avatarSelection(context);
          },
        )
      ],
    );
  }

  changeStageWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF279C44),
                const Color(0xFF20809B),
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
                "CHANGE STAGE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constants.PrimaryFont,
                    fontWeight: FontWeight.w500),
              ),
              InkWell(
                child: Image.asset("assets/edit.webp", width: 24, height: 24),
                onTap: () {
                  _stageSelection(context);
                },
              )
            ],
          ),
        ));
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
              InkWell(
                child: Image.asset("assets/edit.webp", width: 24, height: 24),
                onTap: () {
                  _navigateAndDisplaySelection(context);
                },
              )
            ],
          ),
        ));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result =
        await Navigator.pushNamed(context, SelectControllerClass.routeName);
    if (result != null)
      setState(() {
        getUserDetail();
      });
  }

  _navigateUsernameSelection(BuildContext context) async {
    final result = await Navigator.pushNamed(context, UsernameClass.routeName);
    if (result != null)
      setState(() {
        getUserDetail();
      });
  }

  _stageSelection(BuildContext context) async {
    final result =
        await Navigator.pushNamed(context, SelectStageClass.routeName);
    if (result != null)
      setState(() {
        getUserDetail();
      });
  }

  _avatarSelection(BuildContext context) async {
    final result = await Navigator.pushNamed(context, AvatarClass.routeName);
    if (result != null)
      setState(() {
        getUserDetail();
      });
  }

  _favFiveSelection(BuildContext context) async {
    final result =
        await Navigator.pushNamed(context, SelectFavFiveClass.routeName);
    if (result != null)
      setState(() {
        getUserDetail();
      });
  }

  selectedWeapon() {
    return CachedNetworkImage(
      imageUrl: "$weapon",
      width: MediaQuery.of(context).size.width * 0.70,
      height: 150,
    );
  }

  addListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 120.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _favFiveList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            print(_favFiveList[index]["image"]);
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
                  child: CachedNetworkImage(
                      imageUrl: _favFiveList[index]["image"],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height),
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
              InkWell(
                child: Image.asset("assets/edit.webp", width: 24, height: 24),
                onTap: () {
                  _favFiveSelection(context);
                },
              )
            ],
          ),
        ));
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
                      color: Colors.white.withOpacity(0.7),
                    ),
                    hintText: hint,
                    fillColor: color),
              ))
        ]);
  }
}
