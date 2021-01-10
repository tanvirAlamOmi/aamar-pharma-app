import 'package:flutter/cupertino.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
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
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28, 5, 28, 5),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        // Add This
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ],
          ),
        ),
      ),
    );
  }
}

class CustomMessageClipper extends CustomClipper<Path> {
  final String arrowDirection;

  CustomMessageClipper(this.arrowDirection);

  @override
  getClip(Size size) {
    var path = Path();
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
    // path.moveTo(0.0, size.height*0.20);
    // path.lineTo(0.0, size.height*0.60);
    // path.quadraticBezierTo(0, size.height*0.80, 15, size.height*0.80);
    // path.lineTo(size.width-20, size.height*0.80);
    // path.quadraticBezierTo(size.width-10, size.height-10, size.width, size.height);
    // path.quadraticBezierTo(size.width-10, size.height*0.90, size.width-10, 15.0);
    // path.quadraticBezierTo(size.width-12, 0.0, size.width-30, 0.0);
    // path.lineTo(15.0 , 0.0);
    // path.quadraticBezierTo(0.0, 0.0, 0.0,size.height*0.20);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
