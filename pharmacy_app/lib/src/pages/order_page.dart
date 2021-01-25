import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/feed/feed_container.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/feed/feed_info.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
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
        print("GG ORDER PAGE");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text("ORDERS"),
        ),
        body: Stack(
          children: [
            FeedContainer(FeedInfo(ClientEnum.FEED_ORDER), key: key),
            buildTutorialBox()
          ],
        ));
  }

  Widget buildTutorialBox() {
    return StreamBuilder<int>(
      stream: Streamer.getTotalOrderStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        // snapshot.data means total order in one's list. So for the first time there would be
        // no order list hence we do not show them the tutorial box. When order list arrives
        // then we render the tutorial box for only one time
        if (snapshot.hasData && snapshot.data > 0) {
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
                  callBackRefreshUI: refreshUI,
                  messageTitle:
                      "This indicates the current status of your order",
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
                  callBackRefreshUI: refreshUI,
                  messageTitle:
                      "View your list of orders by specific order status",
                ),
              );
              break;
            default:
              return Container();
              break;
          }
        }
        return Container();
      },
    );
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberOrderPage += 1;
    await Store.instance.putAppData();
  }
}
