import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/util/util.dart';

class GeneralActionButton extends StatelessWidget {
  final bool isProcessing;
  final void Function() callBack;
  final String title;
  final EdgeInsetsGeometry padding;
  final double height;
  final Color color;

  GeneralActionButton(
      {this.isProcessing,
      this.callBack,
      this.height,
      this.title,
      this.color,
      this.padding,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.fromLTRB(25, 15, 25, 0),
      alignment: Alignment.center,
      child: MaterialButton(
        height: height ?? 50,
        shape: Border.all(width: 1.0, color: Colors.transparent),
        minWidth: double.infinity,
        onPressed: () => (isProcessing == false) ? callBack() : () {},
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        color: getButtonColor(),
      ),
    );
  }

  Color getButtonColor() {
    if (!isProcessing) {
      if (color == null) {
        return Util.purplishColor();
      } else {
        return color;
      }
    }
    return Colors.grey;
  }
}
