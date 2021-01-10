import 'package:flutter/cupertino.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class CustomMessageBox extends StatelessWidget {
  final Function() callBackRefreshUI;
  final double height;
  final double width;
  final String arrowDirection;
  final String messageTitle;

  const CustomMessageBox({
    Key key,
    this.callBackRefreshUI,
    this.height,
    this.width,
    this.arrowDirection,
    this.messageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomMessageClipper(arrowDirection: arrowDirection),
      child: Container(
        padding: EdgeInsets.fromLTRB(15,50,15,0),
        width: width,
        height: height,
        color: Util.purplishColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleCrossButton(),
            SizedBox(height: 5),
            Text(
              messageTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class CustomMessageClipper extends CustomClipper<Path> {
  final String arrowDirection;

  CustomMessageClipper({this.arrowDirection});

  @override
  getClip(Size size) {
    var path = Path();
    if (arrowDirection == ClientEnum.ARROW_BOTTOM_RIGHT) {
      path.lineTo(0.0, size.height * 0.60);
      path.quadraticBezierTo(0, size.height * 0.80, 15, size.height * 0.80);
      path.lineTo(size.width - 60, size.height * 0.80);
      path.lineTo(size.width - 45, size.height * 0.90);
      path.lineTo(size.width - 30, size.height * 0.80);
      path.lineTo(size.width - 15, size.height * 0.80);
      path.quadraticBezierTo(
          size.width, size.height * 0.80, size.width, size.height * 0.60);
      path.lineTo(size.width, 15);
      path.quadraticBezierTo(size.width, 0.0, size.width - 15, 0.0);
      path.lineTo(15.0, 0.0);
      path.quadraticBezierTo(0.0, 0.0, 0.0, size.height * 0.20);
    }

    if (arrowDirection == ClientEnum.ARROW_BOTTOM_LEFT) {
      path.lineTo(0.0, size.height * 0.60);
      path.quadraticBezierTo(0, size.height * 0.80, 15, size.height * 0.80);
      path.lineTo(60, size.height * 0.80);
      path.lineTo(45, size.height * 0.90);
      path.lineTo(30, size.height * 0.80);
      path.lineTo(size.width - 15, size.height * 0.80);
      path.quadraticBezierTo(
          size.width, size.height * 0.80, size.width, size.height * 0.60);
      path.lineTo(size.width, 15);
      path.quadraticBezierTo(size.width, 0.0, size.width - 15, 0.0);
      path.lineTo(15.0, 0.0);
      path.quadraticBezierTo(0.0, 0.0, 0.0, size.height * 0.20);
    }

    if (arrowDirection == ClientEnum.ARROW_TOP_RIGHT) {
      path.moveTo(0.0, 30);
      path.lineTo(0.0, size.height * 0.70);
      path.quadraticBezierTo(0, size.height, 30, size.height);
      path.lineTo(30, size.height);
      path.lineTo(size.width - 30, size.height);
      path.quadraticBezierTo(
          size.width , size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width , 30, size.width - 30, 30);
      path.lineTo(size.width - 60, 0.0);
      path.lineTo(size.width - 45, 20);
      path.lineTo(size.width - 30, 30);

      // path.moveTo(0.0, 50);
      // path.lineTo(0.0, size.height * 0.70);
      // path.quadraticBezierTo(0, size.height, 30, size.height);
      // path.lineTo(30, size.height);
      // path.lineTo(size.width - 30, size.height);
      // path.quadraticBezierTo(
      //     size.width , size.height, size.width, size.height * 0.70);
      // path.lineTo(size.width, size.height * 0.10);
      // path.lineTo(60, 0.0);
      // path.lineTo(45, 20);
      // path.lineTo(30, 30);
      // path.lineTo(15.0, 0.0);
      // path.quadraticBezierTo(0.0, 0.0, 0.0, size.height * 0.20);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

// path.moveTo(0.0, size.height*0.20);
// path.lineTo(0.0, size.height*0.60);
// path.quadraticBezierTo(0, size.height*0.80, 15, size.height*0.80);
// path.lineTo(size.width-20, size.height*0.80);
// path.quadraticBezierTo(size.width-10, size.height-10, size.width, size.height);
// path.quadraticBezierTo(size.width-10, size.height*0.90, size.width-10, 15.0);
// path.quadraticBezierTo(size.width-12, 0.0, size.width-30, 0.0);
// path.lineTo(15.0 , 0.0);
// path.quadraticBezierTo(0.0, 0.0, 0.0,size.height*0.20);
