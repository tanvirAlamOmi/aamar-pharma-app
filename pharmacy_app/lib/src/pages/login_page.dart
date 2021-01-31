import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
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
    firebaseCloudMessagingListeners();
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
        body: Column(
          children: <Widget>[
            buildLogoTitle(),
            SizedBox(height: 10.0),
            buildBody(),
          ],
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
          child: AppBarBackButton(),
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
    return Column(
      children: <Widget>[
        SizedBox(height: 30),
        Text(
          Util.en_bn_du(text: 'LOGIN'),
          style: TextStyle(
              fontFamily: Util.en_bn_font(),
              color: Util.greenishColor(),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        SizedBox(height: 20),
        Text(
          Util.en_bn_du(text: 'Enter your mobile number'),
          style: TextStyle(
              fontFamily: Util.en_bn_font(),
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 13),
        ),
        SizedBox(height: 3),
        Text(
          Util.en_bn_du(
              text:
                  'We will send you a verification code by text message(SMS)'),
          style: TextStyle(
              fontFamily: Util.en_bn_font(),
              color: Colors.grey[500],
              fontWeight: FontWeight.normal,
              fontSize: 11),
        ),
      ],
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
    final isInternet = await Util.checkInternet();
    if (isInternet) {
      String phoneWithoutCC = phoneController.text;
      if (countryCode == '' || phoneWithoutCC == '') {
        Util.showSnackBar(
            scaffoldKey: _scaffoldKey,
            message: 'Please provide your phone number');
        return;
      }

      if (phoneController.text.length != 11) {
        Util.showSnackBar(
            scaffoldKey: _scaffoldKey,
            message:
                'Please provide a valid 11 digit Bangladeshi phone number');
        return;
      }

      final phone = countryCode + phoneController.text;
      await Store.instance.setPhoneNumber(phoneController.text);
      await AuthRepo.instance.sendSMSCode(phone);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPage(
                  phoneNumber: phoneController.text,
                  arrivedFromUserDetailsPage: true,
                )),
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/noInternet', (Route<dynamic> route) => false);
    }
  }

  String getHintTextPhone() {
    return "Enter your mobile number";
  }
}
