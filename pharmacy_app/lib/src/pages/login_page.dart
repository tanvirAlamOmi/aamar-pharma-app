import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/pages/verification_page.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/services/notification_service.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final phoneController = new TextEditingController();
  final String countryCode = "+88";
  bool isProcessing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildLogoTitle(),
              SizedBox(height: 10.0),
              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogoTitle() {
    return Stack(
      children: <Widget>[
        Container(
          height: 150,
          width: double.infinity,
          child: Image.asset(
            "assets/images/logo_aamarpharma.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 30, 0, 0),
          child: (AppVariableStates.instance.loginWithReferral == false)
              ? AppBarBackButton()
              : Container(),
        ),
      ],
    );
  }

  Widget buildBody() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: <Widget>[
          buildTitle(),
          SizedBox(height: 20.0),
          buildPhoneInput(),
          SizedBox(height: 25.0),
          buildOTPLoginButton(),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget buildTitle() {
    final children = List<Widget>();

    if (Store.instance.appState.referralCode.isNotEmpty) {
      children.addAll([
        SizedBox(height: 3),
        CustomText('Referral Code ${Store.instance.appState.referralCode}',
            color: Colors.red[500], fontWeight: FontWeight.bold, fontSize: 15),
      ]);
    }

    children.addAll([
      SizedBox(height: 30),
      CustomText('LOGIN',
          color: Util.greenishColor(),
          fontWeight: FontWeight.bold,
          fontSize: 20),
      SizedBox(height: 20),
      CustomText('Enter your mobile number',
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13),
      SizedBox(height: 3),
      CustomText('We will send you a verification code by text message(SMS)',
          color: Colors.grey[500], fontWeight: FontWeight.normal, fontSize: 11),
    ]);

    return Column(
      children: children,
    );
  }

  Widget buildPhoneInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 45,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
            child: TextFormField(
              autofocus: false,
              controller: TextEditingController(text: countryCode),
              enabled: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              child: TextFormField(
                autofocus: false,
                controller: phoneController,
                enabled: true,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOTPLoginButton() {
    return GeneralActionRoundButton(
      title: "CONTINUE",
      callBackOnSubmit: makePhoneLogin,
      isProcessing: false,
    );
  }

  void makePhoneLogin() async {
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

    AppVariableStates.instance.submitFunction = onVerificationNextStep;

    final phone = countryCode + phoneController.text;
    await Store.instance.setPhoneNumber(phoneController.text);
    await AuthRepo.instance.sendSMSCode(phone);

    if (Store.instance.appState.referralCode.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPage(
                  phoneNumber: phoneController.text,
                  onVerificationNextStep: AppEnum.LOGIN_USING_REFERRAL_CODE,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPage(
                  phoneNumber: phoneController.text,
                  onVerificationNextStep:
                      AppEnum.ON_VERIFICATION_FROM_USER_DETAILS_PAGE,
                )),
      );
    }
  }

  void onVerificationNextStep() {
    Navigator.of(context).pop();
    Streamer.putEventStream(Event(EventType.REFRESH_USER_DETAILS_PAGE));
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
