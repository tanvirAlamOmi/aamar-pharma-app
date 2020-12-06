import 'package:pharmacy_app/src/pages/home_page.dart';
import 'package:pharmacy_app/src/pages/user_details_page.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/pages/order_page.dart';

class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentTabIndex;

  @override
  void initState() {
    super.initState();
    currentTabIndex = 0;
    Util.getPermissions();
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
        title: Text('Home', style: TextStyle(fontSize: 13)),
        icon: Icon(Icons.home, size: 24),
      ),
      BottomNavigationBarItem(
        title: Text('Order', style: TextStyle(fontSize: 13)),
        icon: Icon(Icons.add_shopping_cart, size: 24),
      ),
      BottomNavigationBarItem(
        title: Text('Account', style: TextStyle(fontSize: 13)),
        icon: Icon(Icons.account_circle, size: 24),
      ),
    ];
  }
}
