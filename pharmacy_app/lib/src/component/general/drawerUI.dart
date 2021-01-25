import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/pages/login_page.dart';
import 'package:pharmacy_app/src/pages/special_request_product_page.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  static final MainDrawer _drawer = new MainDrawer._internal();

  factory MainDrawer() {
    return _drawer;
  }

  MainDrawer._internal();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            child: buildImageLogoWidget(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: buildDrawer(context),
          )
        ],
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    // if (Store.instance.appState.user.id == null) {
    //   return ListView(
    //     shrinkWrap: true,
    //     children: [
    //       ListTile(
    //           dense: true,
    //           title: Text(
    //             'LOGIN',
    //             style: TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.grey[700],
    //                 fontSize: 15),
    //           ),
    //           leading: Icon(Icons.login, color: Util.purplishColor()),
    //           onTap: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => LoginPage()),
    //             );
    //           }),
    //     ],
    //   );
    // }
    final children = List<Widget>();
    children.add(
      ListTile(
          dense: true,
          title: Text(
            'REPEAT ORDERS',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 15),
          ),
          leading: Icon(Icons.shopping_bag, color: Util.purplishColor()),
          onTap: () {}),
    );

    children.add(
      ListTile(
          dense: true,
          title: Text(
            'SPECIAL REQUEST',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 15),
          ),
          leading: Icon(Icons.ac_unit_sharp, color: Util.purplishColor()),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpecialRequestProductPage()),
            );
          }),
    );
    children.add(
      ListTile(
          dense: true,
          title: Text(
            'CONSULT PHARMACIST',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 15),
          ),
          leading: Icon(Icons.call, color: Util.purplishColor()),
          onTap: () {}),
    );
    children.add(
      ListTile(
          dense: true,
          title: Text(
            'HELP & FAQ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 15),
          ),
          leading:
              Icon(Icons.mark_email_read_rounded, color: Util.purplishColor()),
          onTap: () {}),
    );
    children.add(
      ListTile(
          dense: true,
          title: Text(
            'ABOUT',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 15),
          ),
          leading: Icon(Icons.info, color: Util.purplishColor()),
          onTap: () {}),
    );
    if (Store.instance.appState.user.id != null)
      children.add(
        ListTile(
            dense: true,
            title: Text(
              'LOG OUT',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 15),
            ),
            leading: Icon(
              Icons.logout,
              color: Util.purplishColor(),
            ),
            onTap: () async {
              await Store.instance.updateUser(User.none());
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            }),
      );

    return ListView(shrinkWrap: true, children: children);
  }

  Widget buildName() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Arbree",
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        maxLines: 2,
      ),
    );
  }

  Widget buildImageLogoWidget() {
    return Image.asset(
      'assets/images/logo_aamarpharma.jpg',
      width: double.infinity,
      height: 150,
      fit: BoxFit.cover,
    );
  }
}
