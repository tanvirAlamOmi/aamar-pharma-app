import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/util/util.dart';

class GeneralActionRoundButton extends StatelessWidget {
  final bool isProcessing;
  final void Function() callBack;
  final String title;
  final EdgeInsetsGeometry padding;
  final double height;
  final Color color;

  GeneralActionRoundButton(
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
      padding: padding ?? EdgeInsets.fromLTRB(25, 5, 25, 5),
      alignment: Alignment.center,
      child: MaterialButton(
        height: height ?? 40,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
    if (isProcessing == false) {
      if (color == null) {
        return Util.purplishColor();
      } else {
        return Colors.black;
      }
    }
    return Colors.grey;
  }
}
