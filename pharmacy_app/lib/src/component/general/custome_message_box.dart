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
    return CustomPaint(
      painter: BoxShadowPainter(arrowDirection: arrowDirection),
      child: ClipPath(
        clipper: CustomMessageClipper(arrowDirection: arrowDirection),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
          width: width,
          height: height,
          color: Util.colorFromHex('#E5E5FA'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CrossButton(),
              SizedBox(height: 5),
              Text(
                messageTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Util.purplishColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CrossButton() {
    return ClipOval(
      child: Material(
        color: Colors.red, // button color
        child: InkWell(
          splashColor: Util.purplishColor(), // inkwell color
          child: SizedBox(
              width: 20,
              height: 20,
              child: Icon(
                Icons.clear,
                size:  10,
                color: Colors.white,
              )),
          onTap: () {
            callBackRefreshUI();
          },
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
          size.width, size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width, 30, size.width - 30, 30);
      path.lineTo(size.width - 60, 30);
      path.lineTo(size.width - 20, 0);
      path.lineTo(size.width - 30, 30);
      path.lineTo(30, 30);
      path.quadraticBezierTo(0, 30, 0, 60);
    }

    if (arrowDirection == ClientEnum.ARROW_TOP_LEFT) {
      path.moveTo(0.0, 30);
      path.lineTo(0.0, size.height * 0.70);
      path.quadraticBezierTo(0, size.height, 30, size.height);
      path.lineTo(30, size.height);
      path.lineTo(size.width - 30, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width, 30, size.width - 30, 30);
      path.lineTo(60, 30);
      path.lineTo(20, 0);
      path.lineTo(30, 30);
      path.lineTo(30, 30);
      path.quadraticBezierTo(0, 30, 0, 60);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class BoxShadowPainter extends CustomPainter {
  final String arrowDirection;

  BoxShadowPainter({this.arrowDirection});

  @override
  void paint(Canvas canvas, Size size) {
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
          size.width, size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width, 30, size.width - 30, 30);
      path.lineTo(size.width - 60, 30);
      path.lineTo(size.width - 20, 0);
      path.lineTo(size.width - 30, 30);
      path.lineTo(30, 30);
      path.quadraticBezierTo(0, 30, 0, 60);
    }

    if (arrowDirection == ClientEnum.ARROW_TOP_LEFT) {
      path.moveTo(0.0, 60);
      path.lineTo(0.0, size.height * 0.70);
      path.quadraticBezierTo(0, size.height, 30, size.height);
      path.lineTo(30, size.height);
      path.lineTo(size.width - 30, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width, 30, size.width - 30, 30);
      path.lineTo(60, 30);
      path.lineTo(20, 0);
      path.lineTo(30, 30);
      path.lineTo(30, 30);
      path.quadraticBezierTo(0, 30, 0, 60);
    }
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Util.purplishColor();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
