import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            'HOME',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CarouselSliderCard(),
          buildText(),
          GeneralActionButton(title: "UPLOAD PRESCRIPTION"),
          GeneralActionButton(title: "UPLOAD PRESCRIPTION"),
          SizedBox(height: 20),
          buildHotlineText()
        ],
      ),
    );
  }

  Widget buildText() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "ORDER MEDICINES AND MORE",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildHotlineText() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "HOTLINE\n"
        "+88-0126823410",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
