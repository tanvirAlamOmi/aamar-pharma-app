import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
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
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
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
        ListTile(
            dense: true,
            title: Text(
              'SPECIAL ORDERS',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 15),
            ),
            leading: Icon(Icons.add_shopping_cart, color: Util.purplishColor()),
            onTap: () {}),
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
              await AuthRepo.instance.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            }),
      ],
    );
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
