import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/initial_tutorial_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/general/ui_view_data.dart';

class RequestReceivedSuccessPage extends StatelessWidget {
  final IconData icon;
  final String pageTitle;
  final String title;
  final String message;

  const RequestReceivedSuccessPage(
      {Key key, this.icon, this.title, this.message, this.pageTitle})
      : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBarBackButtonCross(),
          elevation: 1,
          centerTitle: true,
          title: Text(Util.en_bn_du(text: pageTitle),
              style: TextStyle(
                  fontFamily: Util.en_bn_font(), color: Colors.white)),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 80,
            color: Util.greenishColor(),
          ),
        ),
        SizedBox(height: 30),
        Container(
          child: Text(Util.en_bn_du(text: title),
              style: TextStyle(
                  fontFamily: Util.en_bn_font(),
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 17)),
        ),
        Container(
          width: 200,
          alignment: Alignment.center,
          child: Text(Util.en_bn_du(text: message),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: Util.en_bn_font(),color: Colors.grey)),
        )
      ],
    );
  }
}
