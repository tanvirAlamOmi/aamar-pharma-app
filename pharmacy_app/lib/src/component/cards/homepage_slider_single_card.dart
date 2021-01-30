import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/util/util.dart';

class HomePageSliderSingleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTitleText(),
        buildSideImage(),
      ],
    );
  }

  Widget buildTitleText() {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Text(
          Util.en_bn_du(
              text:
                  'We offer Medicines Wellness, Products Devices and More, products that you wont get any where in the world'),
          style: TextStyle(
              fontFamily: Util.en_bn_font(), color: Colors.grey, fontSize: 12)),
    ));
  }

  Widget buildSideImage() {
    return Container(
      width: 120,
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/detol.png",
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      ),
    );
  }
}
