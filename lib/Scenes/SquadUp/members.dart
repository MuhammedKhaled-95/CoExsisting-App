import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Models/userModel.dart';
import 'package:coexist_gaming/Repositiory/eventRepository.dart';
import 'package:coexist_gaming/Scenes/Profile/memberProfile.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;

class MembersClass extends StatefulWidget {
  static const routeName = '/MembersClass';
  MembersClass({Key key}) : super(key: key);

  @override
  _MembersClassState createState() => _MembersClassState();
}

class _MembersClassState extends State<MembersClass> {
  List<UserModelClass> users = List<UserModelClass>();
  String name = "";

  @override
  void initState() {
    super.initState();
    getSearchData();
  }

  getSearchData() {
    if (name == "" || name == null) {
      EventRepository.getuserModelClass().then((value) {
        setState(() {
          users = value;
        });
      });
    } else {
      EventRepository.getSearchUser(name).then((value) {
        value.snapshots().listen((event) {
          setState(() {
            users = [];
            print(event.docs);
            if (event.docs.length != 0) {
              event.docs.forEach((element) {
                var obj = UserModelClass(
                    userName: element["Username"],
                    userId: element["Userid"],
                    avatarImage: element["AvatarImage"]);
                users.add(obj);
              });
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D1D1D),
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            "MEMBERS",
            style: Constants.navigationTitleStyle,
          ),
          leading: IconButton(
            icon: Image.asset(
              "assets/back.png",
              width: 33,
              height: 33,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              addSearchWidget(),
              SizedBox(
                height: 10,
              ),
              users.length != 0 ? _addListView() : CircularProgressIndicator(),
            ],
          ),
        ));
  }

  addSearchWidget() {
    return new SizedBox(
      child: TextField(
        onChanged: (val) {
          setState(() {
            name = val;
          });
          getSearchData();
        },
        style: new TextStyle(color: Colors.white),
        decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(28.0),
              ),
              borderSide: BorderSide(color: Color(0xFF2D2D2D)),
            ),
            filled: true,
            hintStyle: new TextStyle(
                color: Colors.white, fontFamily: Constants.PrimaryFont),
            hintText: "SEARCH MEMBERS.....",
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            fillColor: Color(0xFF2D2D2D)),
      ),
      height: 50,
    );
  }

  _addListView() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          UserModelClass data = users[index];
          return InkWell(
            child: Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: data.avatarImage,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          data.userName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: Constants.PrimaryFont),
                        )
                      ],
                    ),
                  ],
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberProfile(data.userId),
                  ));
            },
          );
        },
      ),
    );
  }
}
