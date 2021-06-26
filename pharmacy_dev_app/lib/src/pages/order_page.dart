import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/notification_action_button.dart';
import 'package:pharmacy_app/src/component/feed/feed_container.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/feed/feed_info.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Key key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showTutorial = false;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    eventChecker();
    UIState.instance.scaffoldKey = scaffoldKey;
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_ORDER_PAGE ||
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
    totalItems = value;
    refreshTutorialBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: CustomText('ORDERS',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          actions: [NotificationActionButton()],
        ),
        body: Stack(
          children: [
            FeedContainer(
                FeedInfo(AppEnum.FEED_ORDER, feedFunc: showTutorialBox),
                key: key),
            buildTutorialBox()
          ],
        ));
  }

  Widget buildTutorialBox() {
    if (showTutorial && totalItems > 0) {
      switch (Store.instance.appState.tutorialBoxNumberOrderPage) {
        case 0:
          return Positioned(
            top: 200,
            right: 20,
            child: CustomMessageBox(
              width: 190,
              height: 150,
              startPoint: 40,
              midPoint: 50,
              endPoint: 60,
              arrowDirection: ClientEnum.ARROW_TOP,
              callBackAction: updateTutorialBox,
              callBackRefreshUI: refreshTutorialBox,
              messageTitle: "This indicates the current status of your order",
            ),
          );
          break;
        case 1:
          return Positioned(
            top: 50,
            right: 50,
            child: CustomMessageBox(
              width: 190,
              height: 150,
              startPoint: 40,
              midPoint: 50,
              endPoint: 60,
              arrowDirection: ClientEnum.ARROW_TOP,
              callBackAction: updateTutorialBox,
              callBackRefreshUI: refreshTutorialBox,
              messageTitle: "View your list of orders by specific order status",
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
    Store.instance.appState.tutorialBoxNumberOrderPage += 1;
    await Store.instance.putAppData();
  }
}
