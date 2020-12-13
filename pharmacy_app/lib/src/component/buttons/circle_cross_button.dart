import 'package:flutter/material.dart';

class CircleCrossButton extends StatelessWidget {
  final void Function(dynamic objectIdentifier) callBack;
  final Function() refreshUI;
  final dynamic objectIdentifier;

  final Color color;

  CircleCrossButton(
      {this.callBack, this.color, Key key, this.objectIdentifier, this.refreshUI})
      : super(key: key);

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
            callBack(objectIdentifier);
            refreshUI();
          },
        ),
      ),
    );
  }
}
