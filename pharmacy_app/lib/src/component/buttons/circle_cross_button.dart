import 'package:flutter/material.dart';

class CircleCrossButton extends StatelessWidget {
  final void Function(dynamic objectIdentifier) callBack;
  final Function() refreshUI;
  final Function() callBackAdditional;
  final dynamic objectIdentifier;
  final double width;
  final double height;
  final double iconSize;

  final Color color;

  CircleCrossButton(
      {this.callBack,
      this.color,
      Key key,
      this.objectIdentifier,
      this.refreshUI,
      this.width,
      this.height,
      this.iconSize, this.callBackAdditional})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.red, // button color
        child: InkWell(
          splashColor: Colors.red, // inkwell color
          child: SizedBox(
              width: width ?? 20,
              height: height ?? 20,
              child: Icon(
                Icons.clear,
                size: iconSize ?? 10,
                color: Colors.white,
              )),
          onTap: () {
            callBack(objectIdentifier);
            if(callBackAdditional != null) callBackAdditional();
            refreshUI();
          },
        ),
      ),
    );
  }
}
