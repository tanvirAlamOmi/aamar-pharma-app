import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';

class PersonalDetailsCard extends StatelessWidget {
  @override
  final listItems;

  const PersonalDetailsCard({Key key, this.listItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 5,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 32, 7),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("PERSONAL DETAILS"),
                SizedBox(height: 20),
                Text("Name"),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    decoration: new InputDecoration(
                      isDense: true,
                      hintText: "Mr. XYZ",
                      hintStyle: TextStyle(fontSize: 13),
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Email"),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          decoration: new InputDecoration(
                            isDense: true,
                            hintText: "Your Email",
                            hintStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Phone Number"),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          decoration: new InputDecoration(
                            isDense: true,
                            hintText: "Your Phone Number",
                            hintStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
