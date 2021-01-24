import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Models/FavFiveModel.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:coexist_gaming/Services/Webservice.dart';
import 'package:coexist_gaming/SupportingClass/Strings.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectFavFiveClass extends StatefulWidget {
  final Function callback;
  static const routeName = '/SelectFavFiveClass';
  SelectFavFiveClass(this.callback);
  @override
  _SelectFavFiveClassState createState() => _SelectFavFiveClassState();
}

class _SelectFavFiveClassState extends State<SelectFavFiveClass> {
  List<int> _selectedIndexList = List();
  List<Results> _selectedItemList = List<Results>();
  bool _selectionMode = true;
  ScrollController _sc = new ScrollController();
  String stage = "";
  String username = "USERNAME";
  String avatar = "";
  String weapon = "";
  List<Results> _games = List();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  String nextURL = Constants.FavFiveApi;
  String userID = "";
  List favFiveArray = List();

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttons = List();
    if (_selectionMode) {
      _buttons.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _selectedIndexList.sort();
            print(
                'Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
          }));
    }
    return Scaffold(
        body: Stack(children: [
      stage != "" ? _loadBgImage() : Container(),
      Container(
        height: MediaQuery.of(context).size.height - 80,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: _buildMainWidget(),
        ),
      )
    ]));
  }

  @override
  void initState() {
    super.initState();
    WebserviceClass.fetchGames(nextURL).then((value) {
      this.nextURL = value.next;
      setState(() {
        isLoading = false;
        this._games = value.results;
      });
    });

    getuserID().then((id) {
      userID = id;
      OnboardingRepository.getUser(id).then((value) {
        setState(() {
          username = value['Username'];
          avatar = value['AvatarImage'];
          stage = value['StageImage'];
          weapon = value["WeaponImage"];
        });
      });
    });
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERID);
  }

  Widget _loadBgImage() {
    return CachedNetworkImage(
      imageUrl: stage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.lighten),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMainWidget() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          WebserviceClass.fetchGames(nextURL).then((value) {
            this.nextURL = value.next;
            setState(() {
              this._games.addAll(value.results);
              isLoading = false;
            });
          });
        }
      }
    });

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 40, 10, 100),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              "SELECT YOUR",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: Constants.PrimaryFont,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "FAV FIVE",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: Constants.PrimaryFont,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              height: 49,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                onPressed: () {
                  if (_selectedItemList.length < 5) {
                    Fluttertoast.showToast(msg: "Select five favorite games");
                  } else {
                    updateFav();
                  }
                },
                color: Color(0xFFB40000),
                textColor: Colors.white,
                child: Text(
                  "CONTINUE",
                  style: TextStyle(
                      fontSize: 16, fontFamily: Constants.PrimaryFont),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //  child:
            buildGridView(),
            //height: MediaQuery.of(context).size.height * 0.50,
            // )
          ],
        ));
  }

  Widget buildGridView() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - size.height * 0.50) / 2.5;
    final double itemWidth = size.width / 3;

    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: _sc,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: (itemWidth / itemHeight),
      children: List.generate(_games.length, (index) {
        return getGridTile(index);
      }),
    );
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    _selectedItemList.add(_games[index]);
    if (index == -1) {
      _selectedIndexList.clear();
      _selectedItemList.clear();
    }
  }

  updateFav() {
    List favs = List();
    for (var i = 0; i < _selectedItemList.length; i++) {
      var value = _selectedItemList[i];
      List categories = List();
      for (var j = 0; j < value.genres.length; j++) {
        var cat = value.genres[j];
        categories.add({"category_id": cat.id, "category_name": cat.name});
      }
      Map<String, dynamic> dictionary = {
        "id": value.id,
        "name": value.name,
        "image": value.backgroundImage,
        "categories": categories,
      };
      favs.add(dictionary);
    }
    OnboardingRepository.updateFavFiveGames(favs, userID);
    if (widget.callback != null) {
      widget.callback(2);
    } else {
      Navigator.pop(context, "datalaodingg");
    }
  }

  Widget getGridTile(int index) {
    if (_selectionMode) {
      return GestureDetector(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                        bottomRight: const Radius.circular(8.0),
                        bottomLeft: const Radius.circular(8.0)),
                    border: _selectedIndexList.contains(index)
                        ? Border.all(color: Color(0xFF66BB00), width: 5.0)
                        : Border.all(color: Colors.transparent, width: 0.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
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
                      imageUrl: _games[index].backgroundImage,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              ),
            )),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 40,
                height: 40,
                child: new IconButton(
                    icon: _selectedIndexList.contains(index)
                        ? Container()
                        : Image.asset("assets/plus.webp"),
                    onPressed: () {}),
              ),
            )),
            Positioned.fill(
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _games[index].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Constants.PrimaryFont,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
        onTap: () {
          setState(() {
            if (_selectedIndexList.contains(index)) {
              _selectedIndexList.remove(index);
              _selectedItemList.remove(_games[index]);
            } else {
              if (_selectedItemList.length < 5) {
                _selectedIndexList.add(index);
                _selectedItemList.add(_games[index]);
              } else {
                Fluttertoast.showToast(msg: "Maximum 5 can be selected.");
              }
            }
          });
        },
      );
    } else {
      return GridTile(
        child: InkResponse(
          child: CachedNetworkImage(imageUrl: _games[index].backgroundImage),
          onLongPress: () {
            setState(() {
              _selectedIndexList = [];
              _selectedItemList = [];
              _changeSelection(enable: true, index: index);
            });
          },
          onTap: () {},
        ),
      );
    }
  }
}
