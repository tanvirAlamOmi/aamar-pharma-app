import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'router.dart';
import 'package:pharmacy_app/src/util/util.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppSate();
  }
}

class _AppSate extends State<App> {
  @override
  void initState() {
    super.initState();
    initProject();
  }

  void initProject() async {
    await Store.initStore();
    await firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    // start app
    return MaterialApp(
      title: 'FOS',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Util.colorFromHex("#473FA8"),
        accentColor: Util.colorFromHex("#473FA8"),
      ),
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      onGenerateRoute: buildRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
