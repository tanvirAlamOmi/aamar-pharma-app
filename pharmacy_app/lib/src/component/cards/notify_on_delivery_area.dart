import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/repo/delivery_repo.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class NotifyOnDeliveryArea extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function() callBackAction;
  final Function() callBackRefreshUI;

  NotifyOnDeliveryArea({
    Key key,
    this.callBackAction,
    this.callBackRefreshUI,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  _NotifyOnDeliveryAreaState createState() => _NotifyOnDeliveryAreaState();
}

class _NotifyOnDeliveryAreaState extends State<NotifyOnDeliveryArea> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      showAlertDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(),
    );
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)), //this right here
              child: Container(
                height: 430,
                child: buildBody(),
              ));
        }).then((value) {
      widget.callBackAction();
      widget.callBackRefreshUI();
    });
  }

  Widget buildBody() {
    return Column(children: [
      SizedBox(height: 20),
      buildCrossButton(),
      SizedBox(height: 20),
      buildAreaNameTitle(),
      SizedBox(height: 20),
      buildNotifyTitle(),
      SizedBox(height: 20),
      buildInputFields(),
      GeneralActionRoundButton(
        isProcessing: false,
        title: 'YES, NOTIFY ME',
        callBackOnSubmit: onSubmit,
      )
    ]);
  }

  Widget buildCrossButton() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
      child: ClipOval(
        child: Material(
          color: Util.purplishColor(), // button color
          child: InkWell(
            splashColor: Util.purplishColor(), // inkwell color
            child: SizedBox(
                width: 25,
                height: 25,
                child: Icon(
                  Icons.clear,
                  size: 18,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(context);
              widget.callBackRefreshUI();
            },
          ),
        ),
      ),
    );
  }

  Widget buildNotifyTitle() {
    return Column(
      children: [
        Container(
          child: CustomText(
              'Don\'t have your area in our delivering area list?',
              color: Colors.grey[700],
              fontSize: 13,
              fontWeight: FontWeight.normal),
        ),
        Container(
          child: CustomText('Want us to notify you when we do?',
              color: Colors.grey[700],
              fontSize: 13,
              fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  Widget buildAreaNameTitle() {
    return Container(
      child: CustomText('We are currently delivering in: \n Mirpur DOHS',
          color: Util.greenishColor(),
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }

  Widget buildInputFields() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText('NAME*',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
              SizedBox(height: 3),
              SizedBox(
                height: 35, // set this
                child: TextField(
                  controller: nameController,
                  decoration: new InputDecoration(
                    isDense: true,
                    hintText: EnBnDict.en_bn_convert(text: 'Mr. XYZ'),
                    hintStyle: TextStyle(fontSize: 11),
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText('Phone Number*',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
              SizedBox(height: 3),
              SizedBox(
                height: 35, // set this
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    isDense: true,
                    hintText: EnBnDict.en_bn_convert(text: 'Your Phone Number'),
                    hintStyle: TextStyle(fontSize: 11),
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void onSubmit() async {
    if (phoneController.text.isEmpty || nameController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: widget.scaffoldKey,
          message: "Please fill all the information");
      return;
    }

    OrderRepo.instance.notifyOnDeliveryArea(
        name: nameController.text, phone: phoneController.text);

    Navigator.pop(context);
    widget.callBackAction();
    widget.callBackRefreshUI();
  }
}
