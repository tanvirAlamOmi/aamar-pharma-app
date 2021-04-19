import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:flutter/material.dart';

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
  bool enableNameField = true;
  bool enableEmailField = true;
  bool enablePhoneField = false;

  @override
  void initState() {
    super.initState();
    setUserDetailsData();
    eventChecker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_USER_DETAILS_PAGE) {
        setUserDetailsData();
        refreshUI();
      }
    });
  }

  void setUserDetailsData() {
    user = Store.instance.appState.user;
    if (user.id == null) {
      user = User.none();
      enableNameField = false;
      enableEmailField = false;
    } else {
      enableNameField = true;
      enableEmailField = true;
    }

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
          title: CustomText('MY DETAILS',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        body: SingleChildScrollView(child: buildBody(context)),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        PersonalDetailsCard(
            enableNameField: enableNameField,
            enableEmailField: enableEmailField,
            enablePhoneField: enablePhoneField,
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController),
        buildAddDeliveryAddressButtonBasedOnLoginState(),
        buildAllAddressCardBasedOnLoginState(),
        buildGeneralActionRoundButtonBasedOnLoginState(),
      ],
    );
  }

  buildAddDeliveryAddressButtonBasedOnLoginState() {
    if (user.id == null) return Container();
    return AddDeliveryAddressButton(callBack: refreshUI);
  }

  buildAllAddressCardBasedOnLoginState() {
    if (user.id == null) return Container();
    return AllAddressCard(
        selectedDeliveryAddressIndex: selectedDeliveryAddressIndex,
        setSelectedDeliveryAddressIndex: setSelectedDeliveryAddressIndex,
        callBackRefreshUI: refreshUI);
  }

  buildGeneralActionRoundButtonBasedOnLoginState() {
    if (user.id == null)
      return GeneralActionRoundButton(
        title: "LOGIN",
        isProcessing: false,
        callBackOnSubmit: routeToLoginPage,
      );

    return GeneralActionRoundButton(
      title: "SAVE",
      isProcessing: false,
      callBackOnSubmit: onSubmit,
    );
  }

  void setSelectedDeliveryAddressIndex(int index) {}

  void routeToLoginPage() {
    Navigator.of(context).pushNamed('/login');
  }

  void onSubmit() async {
    if (phoneController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please provide phone number");
      return;
    }

    if (nameController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please provide your name");
      return;
    }

    if (!Util.isEmail(emailAddress: emailController.text)) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid email address");
      return;
    }

    if (phoneController.text.length != 11) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    if (!Util.verifyNumberDigitOnly(numberText: phoneController.text)) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    Util.removeFocusNode(context);

    AuthRepo.instance.updateProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text);

    Util.showSnackBar(
        scaffoldKey: _scaffoldKey, message: "Updated user", duration: 1000);
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
