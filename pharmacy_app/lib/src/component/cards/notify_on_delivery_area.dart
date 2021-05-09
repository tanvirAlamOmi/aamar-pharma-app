import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

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
  final TextEditingController areaNameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  final List<String> areaDeliveryList = ['Mirpur DOHS'];

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      showOrderDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(),
    );
  }

  void showOrderDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)), //this right here
              child: Container(
                child: buildBody(),
              ));
        }).then((value) {
      widget.callBackAction();
      widget.callBackRefreshUI();
    });
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => Util.removeFocusNode(context),
        child: Column(children: [
          SizedBox(height: 10),
          buildCrossButton(),
          SizedBox(height: 10),
          buildAreaNameTitle(),
          SizedBox(height: 10),
          buildNotifyTitle(),
          SizedBox(height: 10),
          buildInputFields(),
          GeneralActionRoundButton(
            isProcessing: false,
            title: 'YES, NOTIFY ME',
            callBackOnSubmit: onSubmit,
          ),
          SizedBox(height: 20)
        ]),
      ),
    );
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

  Widget buildAreaNameTitle() {
    return Container(
      child: Text(
        '${EnBnDict.en_bn_convert(text: 'We are currently delivering in:')} \n ${getAreaNames()}',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Util.greenishColor(),
            fontSize: 15,
            fontWeight: FontWeight.bold),
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
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText('Area*',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
              SizedBox(height: 3),
              SizedBox(
                height: 35, // set this
                child: TextField(
                  controller: areaNameController,
                  decoration: new InputDecoration(
                    isDense: true,
                    hintText: EnBnDict.en_bn_convert(text: 'Mirpur, Banani...'),
                    hintStyle: TextStyle(fontSize: 11),
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
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

  String getAreaNames() {
    String areaName = '';
    for (int i = 0; i < areaDeliveryList.length; i++) {
      areaName += areaDeliveryList[i];
      if (i != areaDeliveryList.length - 1) {
        areaName += ', ';
      }
    }
    return areaName;
  }

  void onSubmit() async {
    if (phoneController.text.isEmpty || nameController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: widget.scaffoldKey,
          message: "Please fill all the information");
      return;
    }

    OrderRepo.instance.notifyOnDeliveryArea(
        name: nameController.text,
        area: areaNameController.text,
        phone: phoneController.text);

    Navigator.pop(context);
    widget.callBackRefreshUI();
  }
}
