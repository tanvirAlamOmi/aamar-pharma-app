import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class PersonalDetailsCard extends StatelessWidget {
  final bool enablePhoneController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const PersonalDetailsCard(
      {Key key,
      this.nameController,
      this.phoneController,
      this.emailController,
      this.enablePhoneController})
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
              CustomText('PERSONAL DETAILS',
                  color: Util.greenishColor(), fontWeight: FontWeight.bold),
              SizedBox(height: 20),
              CustomText('NAME*',
                  color: Util.purplishColor(), fontWeight: FontWeight.bold),
              SizedBox(height: 3),
              SizedBox(
                height: 35, // set this
                child: TextField(
                  controller: nameController,
                  decoration: new InputDecoration(
                    enabled: true,
                    isDense: true,
                    hintText: EnBnDict.en_bn_convert(text: 'Mr. XYZ'),
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
                    CustomText('EMAIL',
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 3),
                    SizedBox(
                      height: 35, // set this
                      child: TextField(
                        controller: emailController,
                        decoration: new InputDecoration(
                          enabled: true,
                          isDense: true,
                          hintText: 'myemail@pharma.com',
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
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText('Phone Number*',
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 3),
                    SizedBox(
                      height: 35, // set this
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: enablePhoneController
                                ? Colors.black
                                : Colors.grey),
                        decoration: new InputDecoration(
                          enabled: enablePhoneController,
                          isDense: true,
                          hintText:
                              EnBnDict.en_bn_convert(text: 'Your Phone Number'),
                          hintStyle: TextStyle(fontSize: 13),
                          fillColor: Colors.black,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
