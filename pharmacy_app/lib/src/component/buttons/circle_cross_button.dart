import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:flutter/material.dart';

class CircleCrossButton extends StatelessWidget {
  final void Function() callBack;

  final Color color;

  CircleCrossButton({this.callBack, this.color, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.red, // button color
        child: InkWell(
          splashColor: Colors.red, // inkwell color
          child: SizedBox(
              width: 20,
              height: 20,
              child: Icon(
                Icons.clear,
                size: 10,
                color: Colors.white,
              )),
          onTap: () {
            callBack();
          },
        ),
      ),
    );
  }
}
