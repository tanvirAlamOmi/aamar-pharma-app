import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:flutter/material.dart';

class GeneralActionButton extends StatelessWidget {
  final bool isProcessing;
  final void Function() callBack;
  final String title;

  GeneralActionButton({this.isProcessing, this.callBack, this.title, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
      alignment: Alignment.center,
      child: MaterialButton(
        height: 50,
        shape: Border.all(width: 1.0, color: Colors.transparent),
        minWidth: double.infinity,
        onPressed: () => (isProcessing == false) ? callBack() : () {},
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        color: (isProcessing == false) ? Colors.black : Colors.grey,
      ),
    );
  }
}
