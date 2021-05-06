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
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';

class RepeatOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RepeatOrderPageState();
}

class _RepeatOrderPageState extends State<RepeatOrderPage> {
  Key key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    eventChecker();
    UIState.instance.scaffoldKey = scaffoldKey;
    AppVariableStates.instance.pageName = AppEnum.PAGE_REPEAT_ORDER;
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_REPEAT_ORDER_PAGE ||
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: CustomText('REPEAT ORDERS',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          leading: AppBarBackButton(),
        ),
        body: Stack(
          children: [
            FeedContainer(FeedInfo(AppEnum.FEED_REPEAT_ORDER), key: key),
            buildTutorialBox()
          ],
        ));
  }

  Widget buildTutorialBox() {
    switch (Store.instance.appState.tutorialBoxNumberRepeatOrderPage) {
      case 0:
        return Positioned(
          top: 100,
          right: 20,
          child: CustomMessageBox(
            width: 250,
            height: 170,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_TOP,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshTutorialBox,
            messageTitle:
                "Tap to add a new order you would like to get delivered multiple times on a regular basis",
          ),
        );
        break;
      case 1:
        return StreamBuilder<int>(
          stream: Streamer.getTotalRepeatOrderStream(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            }
            // snapshot.data means total order in one's list. So for the first time there would be
            // no order list hence we do not show them the tutorial box. When order list arrives
            // then we render the tutorial box for only one time
            if (snapshot.hasData && snapshot.data > 0) {
              return Positioned(
                top: 250,
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
                  messageTitle:
                      "This states the date you’ll have this order delivered next",
                ),
              );
            }
            return Container();
          },
        );
        break;
      default:
        return Container();
        break;
    }
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberRepeatOrderPage += 1;
    await Store.instance.putAppData();
    if (Store.instance.appState.tutorialBoxNumberRepeatOrderPage == 1)
      refreshUI(); // Only to refresh this page only . This is limited to repeat Order Page only.
  }
}
