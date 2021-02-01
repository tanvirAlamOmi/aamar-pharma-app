import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class GeneralActionRoundButton extends StatelessWidget {
  final bool isProcessing;
  final void Function() callBackOnSubmit;
  final String title;
  final EdgeInsetsGeometry padding;
  final double height;
  final Color color;

  GeneralActionRoundButton(
      {this.isProcessing,
      this.callBackOnSubmit,
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
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        minWidth: double.infinity,
        onPressed: () => (isProcessing == false) ? callBackOnSubmit() : () {},
        child: CustomText(
          title,
          color: Colors.white,
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
        return color;
      }
    }
    return Colors.grey;
  }
}
