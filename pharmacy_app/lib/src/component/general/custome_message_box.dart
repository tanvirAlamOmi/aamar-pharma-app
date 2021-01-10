import 'package:flutter/cupertino.dart';

class CustomMessageClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height*0.60);
    path.quadraticBezierTo(0, size.height*0.80, 15, size.height*0.80);
    path.lineTo(size.width-60, size.height*0.80);
    path.lineTo(size.width-45, size.height*0.90);
    path.lineTo(size.width-30, size.height*0.80);
    path.lineTo(size.width-15, size.height*0.80);
    path.quadraticBezierTo(size.width, size.height*0.80, size.width, size.height*0.60);
    path.lineTo(size.width, 15);
    path.quadraticBezierTo(size.width, 0.0, size.width-15, 0.0);
    path.lineTo(15.0 , 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0,size.height*0.20);
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
