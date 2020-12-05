import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageSliderSingleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
        SizedBox(width: 20),
        buildSideImage(),
      ],
    );
  }

  Widget buildTitleText() {
    return Container(
      alignment: Alignment.centerLeft,
      width: 120,
      child: Text(
        "We offer Medicines Wellness Products Devices and More",
        softWrap:true,
        maxLines:3,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  Widget buildSideImage() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/google-logo.png",
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      ),
    );
  }
}
