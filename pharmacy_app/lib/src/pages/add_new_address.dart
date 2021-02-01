import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/repo/delivery_repo.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class AddNewAddressPage extends StatefulWidget {
  final Function() callBack;
  AddNewAddressPage({this.callBack, Key key}) : super(key: key);

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController addressTypeController =
      new TextEditingController();
  final TextEditingController fullAddressController =
      new TextEditingController();

  List<String> areaList = ["Mirupur", "Banani", "Gulshan"];
  String selectedArea;

  @override
  void initState() {
    super.initState();
    selectedArea = areaList[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: AppBarBackButton(),
          title: CustomText('ADD ADDRESS', color: Colors.white),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            buildAddressTypeTextField(),
            buildAreaSelectionDropDown(),
            buildFullAddressTextField(),
            GeneralActionRoundButton(
              title: "SUBMIT",
              height: 40,
              padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
              isProcessing: false,
              callBackOnSubmit: submitData,
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddressTypeTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText('Address Type',
              fontWeight: FontWeight.bold, color: Util.purplishColor()),
          SizedBox(height: 3),
          SizedBox(
            height: 35, // set this
            child: TextField(
              controller: addressTypeController,
              decoration: new InputDecoration(
                isDense: true,
                hintText: EnBnDict.en_bn_convert(text: 'Home/Office'),
                hintStyle:
                    TextStyle(fontFamily: EnBnDict.en_bn_font(), fontSize: 13),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFullAddressTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText('Address',
              fontWeight: FontWeight.bold, color: Util.purplishColor()),
          SizedBox(height: 3),
          SizedBox(
            height: 35, // set this
            child: TextField(
              controller: fullAddressController,
              decoration: new InputDecoration(
                isDense: true,
                hintText: EnBnDict.en_bn_convert(text: '39/A Housing Estate...'),
                hintStyle:
                    TextStyle(fontFamily: EnBnDict.en_bn_font(), fontSize: 13),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAreaSelectionDropDown() {
    return                     DropDownItem(
        dropDownList: areaList,
        selectedItem: selectedArea,
        setSelectedItem: setSelectedDeliveryTimeTime,
        callBackRefreshUI: refreshUI);

    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomText('Select Area',
              fontWeight: FontWeight.bold, color: Util.purplishColor()),
          SizedBox(height: 1),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
              ),
              color: Colors.transparent,
            ),
            height: 35,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: const Color.fromARGB(255, 45, 65, 89),
                isDense: true,
                isExpanded: true,
                value: selectedArea,
                onChanged: (value) {
                  if (value == null) return;
                  selectedArea = value;
                  if (mounted) setState(() {});
                },
                items: areaList.map((item) {
                  return buildDropDownMenuItem(item);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildDropDownMenuItem(String menuItem) {
    return DropdownMenuItem(
      value: menuItem,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Text(
              menuItem,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void submitData() async {
    if (addressTypeController.text.isEmpty ||
        fullAddressController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please fill all the data",
          duration: 1500);
      return;
    }

    final DeliveryAddressDetails deliveryAddressDetails =
        new DeliveryAddressDetails()
          ..addType = addressTypeController.text
          ..address = fullAddressController.text
          ..area = selectedArea;

    Util.showSnackBar(
        scaffoldKey: _scaffoldKey, message: "Please wait", duration: 1500);

    Tuple2<void, String> addDeliveryAddressResponse = await DeliveryRepo
        .instance
        .addDeliveryAddress(deliveryAddressDetails: deliveryAddressDetails);

    if (addDeliveryAddressResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Delivery Address Added Successfully",
          duration: 1500);
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again.",
          duration: 1500);
    }

    widget.callBack();
    closePage();

    return;
  }

  void closePage() {
    Navigator.pop(context);
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
