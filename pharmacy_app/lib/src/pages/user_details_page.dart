import 'dart:convert';
import 'dart:typed_data';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User user;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // In this page I do not want any delivery address should be highlighted as Selected one.
  // So no index would match -1 in delivery address List
  int selectedDeliveryAddressIndex = -1;

  final TextEditingController fullAddressController =
      new TextEditingController();
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    setUserDetailsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUserDetailsData() {
    user = Store.instance.appState.user;
    print(user);

    nameController = new TextEditingController(text: user.name);
    emailController = new TextEditingController(text: user.email);
    phoneController = new TextEditingController(text: user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
        drawer: MainDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text('MY DETAILS', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(child: buildBody(context)),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        PersonalDetailsCard(
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController),
        AddDeliveryAddressButton(callBack: refreshUI),
        AllAddressCard(
            selectedDeliveryAddressIndex: selectedDeliveryAddressIndex,
            setSelectedDeliveryAddressIndex: setSelectedDeliveryAddressIndex,
            callBackRefreshUI: refreshUI),
        GeneralActionRoundButton(
          title: "SAVE",
          isProcessing: false,
          callBackOnSubmit: submitData,
        )
      ],
    );
  }

  void setSelectedDeliveryAddressIndex(int index) {}

  void submitData() {}

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
