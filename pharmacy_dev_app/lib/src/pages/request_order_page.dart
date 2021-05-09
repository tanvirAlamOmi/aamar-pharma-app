import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/feed/feed_container.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/feed/feed_info.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';

class RequestOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RequestOrderPageState();
}

class _RequestOrderPageState extends State<RequestOrderPage> {
  Key key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showTutorial = false;

  @override
  void initState() {
    super.initState();
    eventChecker();
    UIState.instance.scaffoldKey = scaffoldKey;
    AppVariableStates.instance.pageName = AppEnum.PAGE_REQUEST_ORDER;
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_REQUEST_ORDER_PAGE ||
          data.eventType == EventType.REFRESH_ALL_PAGES) {
        refreshUI();
      }
    });
  }

  void refreshUI() {
    if (mounted) {
      setState(() {
        key = UniqueKey();
      });
    }
  }

  void refreshTutorialBox() {
    if (mounted) {
      setState(() {});
    }
  }

  void showTutorialBox(dynamic value) {
    showTutorial = true;
    refreshTutorialBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: CustomText('SPECIAL REQUEST',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          leading: AppBarBackButton(),
        ),
        body: Stack(
          children: [
            FeedContainer(
                FeedInfo(AppEnum.FEED_REQUEST_ORDER, feedFunc: showTutorialBox),
                key: key),
            buildTutorialBox()
          ],
        ));
  }

  Widget buildTutorialBox() {
    if (showTutorial) {
      switch (Store.instance.appState.tutorialBoxNumberRequestOrderPage) {
        case 0:
          return Positioned(
            top: 70,
            right: 50,
            child: CustomMessageBox(
              width: 250,
              height: 150,
              startPoint: 60,
              midPoint: 70,
              endPoint: 80,
              arrowDirection: ClientEnum.ARROW_TOP,
              callBackAction: updateTutorialBox,
              callBackRefreshUI: refreshTutorialBox,
              messageTitle:
                  "Request a product by adding the name, photo, quantity and short notes about the product",
            ),
          );
          break;
        default:
          return Container();
          break;
      }
    }
    return Container();
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberRequestOrderPage += 1;
    await Store.instance.putAppData();
  }
}
