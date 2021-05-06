import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:package_info/package_info.dart';
import 'package:tuple/tuple.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initAppAndNavigate();
    AppVariableStates.instance.pageName = AppEnum.PAGE_SPLASH;
  }

  Future initAppAndNavigate() async {
    final isInternet = await Util.checkInternet();
    if (isInternet) {
      var _duration = new Duration(seconds: 1);
      return new Timer(_duration, navigationPage);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/noInternet', (Route<dynamic> route) => false);
    }
  }

  Future initAppVersionCheck() async {}

  void navigationPage() {
    if (Store.instance.appState.initialTutorialScrollingPage == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/initial_tutorial_page', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        alignment: Alignment.center,
        color: Util.purplishColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildLogo(),
            SizedBox(height: 100.0),
            buildSpinner(),
          ],
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Container(
      height: 200,
      width: 200,
      child: Image.asset(
        'assets/images/amar_pharma_small_logo.png',
        alignment: Alignment.center,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildSpinner() {
    return SizedBox(
        height: 30.0,
        width: 30.0,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Util.greenishColor()),
            strokeWidth: 4.0));
  }
}
