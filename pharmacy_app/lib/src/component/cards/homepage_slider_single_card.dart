import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageSliderSingleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Row(
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "We offer Medicines\n"
              "Wellness Products\n"
              "Devices and More",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            SizedBox(height: 10),
          ]),
          SizedBox(height: 20),
          Container(
            child: Image.asset(
              "assets/images/avatar.png",
              height: 100,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
