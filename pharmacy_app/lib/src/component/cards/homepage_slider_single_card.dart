import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        SizedBox(width: 20),
        buildSideImage(),
      ],
    );
  }

  Widget buildTitleText() {
    return Container(
      width: 150,
      child: IntrinsicHeight(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("We offer Medicines Wellness ",
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
              Text("Products Devices and More ",
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
              Text("products that you wont get",
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      )),
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
