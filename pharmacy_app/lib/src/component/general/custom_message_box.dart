import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class CustomMessageBox extends StatelessWidget {
  final Function() callBackAction;
  final Function() callBackRefreshUI;
  final double height;
  final double width;
  final double startPoint;
  final double midPoint;
  final double endPoint;
  final String arrowDirection;
  final String messageTitle;

  const CustomMessageBox({
    Key key,
    this.callBackRefreshUI,
    this.height,
    this.width,
    this.arrowDirection,
    this.messageTitle,
    this.startPoint,
    this.midPoint,
    this.endPoint,
    this.callBackAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    if (arrowDirection == ClientEnum.ARROW_BOTTOM) padding = EdgeInsets.all(8);
    if (arrowDirection == ClientEnum.ARROW_TOP)
      padding = EdgeInsets.fromLTRB(15, 50, 15, 0);
    return CustomPaint(
      painter: BoxShadowPainter(
        arrowDirection: arrowDirection,
        startPoint: startPoint,
        midPoint: midPoint,
        endPoint: endPoint,
      ),
      child: ClipPath(
        clipper: CustomMessageClipper(
          arrowDirection: arrowDirection,
          startPoint: startPoint,
          midPoint: midPoint,
          endPoint: endPoint,
        ),
        child: Container(
          padding: padding,
          width: width,
          height: height,
          color: Util.colorFromHex('#E5E5FA'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CrossButton(),
              SizedBox(height: 8),
              CustomText(messageTitle,
                  textAlign: TextAlign.center,
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 15)
            ],
          ),
        ),
      ),
    );
  }

  Widget CrossButton() {
    return ClipOval(
      child: Material(
        color: Util.purplishColor(), // button color
        child: InkWell(
          splashColor: Util.purplishColor(), // inkwell color
          child: SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                Icons.clear,
                size: 18,
                color: Colors.white,
              )),
          onTap: () {
            callBackAction();
            callBackRefreshUI();
          },
        ),
      ),
    );
  }
}

class CustomMessageClipper extends CustomClipper<Path> {
  final String arrowDirection;
  final double startPoint;
  final double midPoint;
  final double endPoint;

  CustomMessageClipper({
    this.arrowDirection,
    this.startPoint,
    this.midPoint,
    this.endPoint,
  });

  @override
  getClip(Size size) {
    var path = Path();
    if (arrowDirection == ClientEnum.ARROW_BOTTOM) {
      path.moveTo(0.0, 20);
      path.lineTo(0.0, size.height * 0.60);
      path.quadraticBezierTo(0, size.height * 0.80, 15, size.height * 0.80);
      path.lineTo(startPoint, size.height * 0.80);
      path.lineTo(midPoint, size.height * 0.90);
      path.lineTo(endPoint, size.height * 0.80);
      path.lineTo(size.width - 15, size.height * 0.80);
      path.quadraticBezierTo(
          size.width, size.height * 0.80, size.width, size.height * 0.60);
      path.lineTo(size.width, 15);
      path.quadraticBezierTo(size.width, 0.0, size.width - 15, 0.0);
      path.lineTo(15.0, 0.0);
      path.quadraticBezierTo(0.0, 0.0, 0.0, 30);
    }

    if (arrowDirection == ClientEnum.ARROW_TOP) {
      path.moveTo(0.0, 60);
      path.lineTo(0.0, size.height * 0.70);
      path.quadraticBezierTo(0, size.height, 30, size.height);
      path.lineTo(30, size.height);
      path.lineTo(size.width - 30, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width, 30, size.width - 30, 30);
      path.lineTo(startPoint, 30);
      path.lineTo(midPoint, 0);
      path.lineTo(endPoint, 30);
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
  final double startPoint;
  final double midPoint;
  final double endPoint;

  BoxShadowPainter({
    this.arrowDirection,
    this.startPoint,
    this.midPoint,
    this.endPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    if (arrowDirection == ClientEnum.ARROW_BOTTOM) {
      path.moveTo(0.0, 20);
      path.lineTo(0.0, size.height * 0.60);
      path.quadraticBezierTo(0, size.height * 0.80, 15, size.height * 0.80);
      path.lineTo(startPoint, size.height * 0.80);
      path.lineTo(midPoint, size.height * 0.90);
      path.lineTo(endPoint, size.height * 0.80);
      path.lineTo(size.width - 15, size.height * 0.80);
      path.quadraticBezierTo(
          size.width, size.height * 0.80, size.width, size.height * 0.60);
      path.lineTo(size.width, 15);
      path.quadraticBezierTo(size.width, 0.0, size.width - 15, 0.0);
      path.lineTo(15.0, 0.0);
      path.quadraticBezierTo(0.0, 0.0, 0.0, 30);
    }

    if (arrowDirection == ClientEnum.ARROW_TOP) {
      path.moveTo(0.0, 60);
      path.lineTo(0.0, size.height * 0.70);
      path.quadraticBezierTo(0, size.height, 30, size.height);
      path.lineTo(30, size.height);
      path.lineTo(size.width - 30, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width, size.height * 0.70);
      path.lineTo(size.width, size.height * 0.30);
      path.quadraticBezierTo(size.width, 30, size.width - 30, 30);
      path.lineTo(startPoint, 30);
      path.lineTo(midPoint, 0);
      path.lineTo(endPoint, 30);
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
