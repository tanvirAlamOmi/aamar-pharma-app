import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class ReferralLinkPage extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          leading: AppBarBackButtonCross(),
          elevation: 1,
          centerTitle: true,
          title: CustomText("REFER A FRIEND",
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Icon(
            Icons.share,
            size: 80,
            color: Util.greenishColor(),
          ),
        ),
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              height: 50,
              width: 250,
              child: SelectableText(
                Store.instance.appState.user.dynamicReferralLink,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 50,
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.copy),
                iconSize: 30,
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: Store.instance.appState.user.dynamicReferralLink));
                  Util.showSnackBar(scaffoldKey: _scaffoldKey, message: "Referral Link Copied");
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
