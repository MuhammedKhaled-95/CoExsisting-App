import 'package:cached_network_image/cached_network_image.dart';
import 'package:coexist_gaming/Models/partnerModel.dart';
import 'package:coexist_gaming/Repositiory/onboardRepository.dart';
import 'package:flutter/material.dart';
import 'package:coexist_gaming/SupportingClass/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';

class PartnersClass extends StatefulWidget {
  PartnersClass({Key key}) : super(key: key);
  static const routeName = '/PartnersClass';
  @override
  _PartnersClassState createState() => _PartnersClassState();
}

class _PartnersClassState extends State<PartnersClass> {
  List<Partners> partners = List<Partners>();
  var isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    isLoading = true;
    OnboardingRepository.getPartnersList().then((value) {
      setState(() {
        isLoading = false;
        partners = value;
      });
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D1D1D),
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            "PARTNERS",
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
            child: !isLoading
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: partners.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          addPartnerName(partners[index]),
                          space(),
                          addDescription(partners[index]),
                          space(),
                          addLearnMore(partners[index]),
                          space(),
                          space(),
                        ],
                      ));
                    })
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )));
  }

  space() {
    return SizedBox(
      height: 15,
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  addPartnerName(Partners partner) {
    return Row(
      children: <Widget>[
        Container(
            width: 60,
            height: 60,
            child: CachedNetworkImage(
              imageUrl: partner.companyLogo,
              fit: BoxFit.cover,
            ),
            color: Colors.white),
        SizedBox(
          width: 20,
        ),
        Text(partner.companyname,
            style: TextStyle(
                color: Colors.white,
                fontFamily: Constants.PrimaryFont,
                fontSize: 18,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  addDescription(Partners partner) {
    return Text(partner.description,
        style: TextStyle(
          color: Colors.white,
          fontFamily: Constants.PrimaryFont,
          fontSize: 18,
        ));
  }

  addLearnMore(Partners partner) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.white, width: 2)),
        color: Colors.transparent,
        textColor: Colors.white,
        onPressed: () {
          _launchInBrowser(partner.website);
        },
        child: Text(
          "LEARN MORE",
          style: TextStyle(fontSize: 16.0, fontFamily: Constants.PrimaryFont),
        ),
      ),
    );
  }
}
