import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
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
      child: buildDrawer(context),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 150,
          color: Colors.black,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SizedBox(height: 15), buildName()],
          ),
        ),
        SizedBox(height: 5),
        ListTile(
            title: Text(
              'SPECIAL REQUEST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.ac_unit_sharp, color: Colors.black),
            onTap: () {}),
        ListTile(
            title: Text(
              'SPECIAL ORDERS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.add_shopping_cart, color: Colors.black),
            onTap: () {}),
        ListTile(
            title: Text(
              'LOG OUT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.all_out,
              color: Colors.black,
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

  Widget buildImageWidget() {
    final imageUrl = Util.getStaticImageURL();

    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 30,
      child: ClipOval(
          child: Container(
              child: CachedNetworkImage(
        imageUrl: imageUrl ?? Util.getStaticImageURL(),
        placeholder: (context, url) =>
            new Image.asset('assets/images/avatar.png'),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fit: BoxFit.cover,
        width: 150,
        height: 150,
      ))),
    );
  }
}
