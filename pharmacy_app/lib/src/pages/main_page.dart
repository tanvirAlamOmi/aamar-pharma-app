import 'package:pharmacy_app/src/bloc/auto_refresh_timer.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/pages/home_page.dart';
import 'package:pharmacy_app/src/pages/user_details_page.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/pages/order_page.dart';
import 'package:pharmacy_app/src/services/dynamic_link_service.dart';

class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey bottomNavKey = new GlobalKey();
  int currentTabIndex;

  @override
  void initState() {
    super.initState();
    currentTabIndex = 0;
    Util.getPermissions();
    eventChecker();
    AutoRefreshTimer.instance.stopTimer();
    AutoRefreshTimer.instance.autoRefresh();
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_MAIN_PAGE) {}

      if (data.eventType == EventType.CHANGE_LANGUAGE) {
        refreshUI();
      }

      if (data.eventType == EventType.SWITCH_TO_ORDER_NAVIGATION_PAGE) {
        currentTabIndex = 1;
        refreshUI();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = getBottomNavPages();

    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: currentTabIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavKey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTabIndex,
        items: buildBottomBarItems(),
        elevation: 0,
        onTap: selectTab,
      ),
    );
  }

  void selectTab(int tabIndex) {
    setState(() {
      currentTabIndex = tabIndex;
    });
  }

  List<Widget> getBottomNavPages() {
    return [
      HomePage(),
      OrderPage(),
      AccountPage(),
    ];
  }

  List<BottomNavigationBarItem> buildBottomBarItems() {
    return [
      BottomNavigationBarItem(
        label: 'Home',
        icon: Icon(Icons.home, size: 24),
      ),
      BottomNavigationBarItem(
        label: 'Order',
        icon: Icon(Icons.add_shopping_cart, size: 24),
      ),
      BottomNavigationBarItem(
        label: 'Account',
        icon: Icon(Icons.account_circle, size: 24),
      ),
    ];
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
