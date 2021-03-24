import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/repo/delivery_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
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

  List<String> areaList = ["Mirpur", "Banani", "Gulshan"];
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
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            leading: AppBarBackButton(),
            title: CustomText('ADD ADDRESS',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: FutureBuilder(
              future: DeliveryRepo.instance.coveredDeliveryPlaces(),
              builder: (_, snapshot) {
                if (snapshot.data == null) {
                  return LoadingWidget(status: "Loading Data");
                } else if (snapshot.data != null) {
                  Tuple2<List<DeliveryAddressDetails>, String>
                      coveredDeliveryAddressListResponse = snapshot.data;
                  List<DeliveryAddressDetails> coveredDeliveryAddressList =
                      coveredDeliveryAddressListResponse.item1;
                  String response = coveredDeliveryAddressListResponse.item2;

                  if (response == ClientEnum.RESPONSE_SUCCESS &&
                      coveredDeliveryAddressList.isNotEmpty) {
                    areaList.clear();
                    coveredDeliveryAddressList.forEach((singleDeliveryAddress) {
                      areaList.add(singleDeliveryAddress.name);
                    });
                    selectedArea = areaList[0];
                  }
                  return buildBody(context);
                }
                return LoadingWidget(status: "Loading Data");
              })),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
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
                hintText:
                    EnBnDict.en_bn_convert(text: '39/A Housing Estate...'),
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
    if (Store.instance.appState.user.rank == AppEnum.USER_RANK_AP_STAR)
      return Container();
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
            height: 38,
            child: DropDownItem(
                dropDownList: areaList,
                selectedItem: selectedArea,
                setSelectedItem: setSelectedArea,
                callBackRefreshUI: refreshUI),
          )
        ],
      ),
    );
  }

  void setSelectedArea(dynamic value) {
    selectedArea = value;
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
