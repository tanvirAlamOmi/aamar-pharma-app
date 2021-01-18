import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/ui_view_data.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/store/store.dart';

class InitialTutorialCard extends StatelessWidget {
  final UIViewData uiViewData;
  final bool showGetStartedButton;

  const InitialTutorialCard(
      {Key key, this.uiViewData, this.showGetStartedButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(color: Util.purplishColor(), child: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildIcon(),
        buildTitle(),
        buildTextData(),
        buildGetStartedButton(context),
      ],
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Text(uiViewData.title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 17)),
    );
  }

  Widget buildTextData() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text(uiViewData.textData,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 17)),
    );
  }

  Widget buildIcon() {
    return Container(
      width: 120,
      alignment: Alignment.center,
      child: uiViewData.icon,
    );
  }

  Widget buildGetStartedButton(BuildContext context) {
    if (showGetStartedButton)
      return Container(
        padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
        alignment: Alignment.center,
        child: MaterialButton(
          height: 40,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          minWidth: double.infinity,
          onPressed: () => onSubmit(context),
          child: Text(
            "GET STARTED",
            style: TextStyle(color: Util.purplishColor()),
          ),
          color: Colors.white,
        ),
      );
    return Container();
  }

  void onSubmit(BuildContext context) {
    Store.instance.appState.initialTutorialScrollingPage = 1;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }
}
