import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class RedBorderCancelButton extends StatelessWidget {
  final bool isProcessing;
  final void Function() callBackOnSubmit;

  RedBorderCancelButton({
    this.isProcessing,
    this.callBackOnSubmit,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: GestureDetector(
        onTap: () => (isProcessing == false) ? callBackOnSubmit() : () {},
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              border: Border.all(width: 2, color: Colors.red)),
          alignment: Alignment.center,
          child: CustomText('CANCEL ORDER',
              color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
