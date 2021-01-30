import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/util/util.dart';

class PersonalDetailsCard extends StatelessWidget {
  @override
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const PersonalDetailsCard(
      {Key key,
      this.nameController,
      this.phoneController,
      this.emailController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(33, 10, 33, 10),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Util.en_bn_du(text: 'PERSONAL DETAILS')   ,
                style: TextStyle(
                    fontFamily: Util.en_bn_font(),
                    color: Util.greenishColor(), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                Util.en_bn_du(text: 'NAME')   ,
                style: TextStyle(
                    fontFamily: Util.en_bn_font(),
                    color: Util.purplishColor(), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3),
              SizedBox(
                height: 35, // set this
                child: TextField(
                  controller: nameController,
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
                    Text(
                      Util.en_bn_du(text: 'EMAIL')   ,
                      style: TextStyle(
                          fontFamily: Util.en_bn_font(),
                          color: Util.purplishColor(),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    SizedBox(
                      height: 35, // set this
                      child: TextField(
                        controller: emailController,
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
                    Text(
                      Util.en_bn_du(text: 'Phone Number')   ,
                      style: TextStyle(
                          fontFamily: Util.en_bn_font(),
                          color: Util.purplishColor(),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    SizedBox(
                      height: 35, // set this
                      child: TextField(
                        controller: phoneController,
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
    );
  }
}
