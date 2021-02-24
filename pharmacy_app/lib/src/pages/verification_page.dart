import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String onVerificationNextStep;

  const VerificationPage({
    Key key,
    this.phoneNumber,
    this.onVerificationNextStep,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => new VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  final TextEditingController codeController = TextEditingController();
  bool isProcessing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    eventChecker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void eventChecker() async {
    Streamer.getErrorStream().listen((error) {
      if (error != null) {
        Util.showSnackBar(
            scaffoldKey: _scaffoldKey,
            message:
                "Something went wrong. Please try login after some moments. " +
                    error,
            duration: 30000);
      }
    });
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_VERIFICATION_PAGE) {
        onVerificationNextStep(
            responseCode: ClientEnum.RESPONSE_SUCCESS,
            user: Store.instance.appState.user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: CustomText('PHONE VERIFICATION',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          centerTitle: true,
          leading: isProcessing
              ? Container()
              : new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[buildBody()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return isProcessing
        ? buildVerificationLoadingWidget()
        : buildVerificationInputBox();
  }

  Widget buildVerificationLoadingWidget() {
    return Column(
      children: <Widget>[
        LoadingWidget(status: 'Verify login...'),
      ],
    );
  }

  Widget buildVerificationInputBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 5.0),
          buildOtpMessage(),
          SizedBox(height: 15.0),
          buildOtpInput(),
          SizedBox(height: 20.0),
          buildSubmitButton(),
          SizedBox(height: 10.0),
          buildResendButton(),
        ],
      ),
    );
  }

  Widget buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      // width: 128.0,
      height: 56.0,
    );
  }

  Widget buildOtpMessage() {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            child: Text(getOTPMessage(),
                maxLines: 2,
                style: TextStyle(fontSize: 13.0, color: Colors.grey))),
      ],
    );
  }

  String getOTPMessage() {
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return 'Enter the verification code sent to +88' + widget.phoneNumber;
    } else {
      return 'আপনার +৮৮${EnBnDict.en_bn_number_convert(number: widget.phoneNumber)} নাম্বারে পাঠানো ওটিপি কোড দিন';
    }
  }

  Widget buildOtpInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      height: 55,
      child: TextFormField(
        autofocus: true,
        controller: codeController,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          hintText: 'XXXXXXX',
          prefixIcon: Icon(Icons.input),
          contentPadding: EdgeInsets.symmetric(
            vertical: 7.0,
            horizontal: 20.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            borderSide: const BorderSide(color: Colors.grey, width: 0.7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return GeneralActionRoundButton(
      title: "SUBMIT CODE",
      isProcessing: false,
      callBackOnSubmit: onVerificationCodeSubmit,
    );
  }

  Widget buildResendButton() {
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: FlatButton.icon(
        icon: Icon(Icons.restore),
        label: CustomText('Resend Code',
            fontSize: 15.0, color: Colors.blueGrey),
        onPressed: () async {
          Util.showSnackBar(
              scaffoldKey: _scaffoldKey,
              message: "Resending code in 10 seconds");
          final String phoneNumber = '+88${Store.instance.appState.user.phone}';
          await Future.delayed(Duration(seconds: 10));
          await AuthRepo.instance.sendSMSCode(phoneNumber);
          Util.showSnackBar(scaffoldKey: _scaffoldKey, message: "Code Resent");
        },
      ),
    );
  }

  Future<void> onVerificationCodeSubmit() async {
    if (codeController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please enter the code.");
      return;
    }

    isProcessing = true;
    refreshUI();

    Tuple2<User, String> userResponse = await AuthRepo.instance
        .signInWithPhoneNumber(
            smsCode: codeController.text,
            firebaseToken: AppVariableStates.instance.firebaseSMSToken,
            phoneNumber: widget.phoneNumber);

    User user = userResponse.item1;
    String responseCode = userResponse.item2;

    onVerificationNextStep(responseCode: responseCode, user: user);
  }

  void onVerificationNextStep({String responseCode, User user}) {
    isProcessing = true;
    refreshUI();

    if (responseCode == ClientEnum.RESPONSE_SUCCESS && user != null) {
      if (widget.onVerificationNextStep ==
          AppEnum.ON_VERIFICATION_CONFIRM_ORDER) {
        Navigator.of(context).pop(); // pop verification Page
        AppVariableStates.instance.submitFunction();
        Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      } else if (widget.onVerificationNextStep ==
          AppEnum.ON_VERIFICATION_CONFIRM_REQUEST_ORDER) {
        Navigator.of(context).pop(); // pop verification Page
        AppVariableStates.instance.submitFunction();
        Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      } else if (widget.onVerificationNextStep ==
          AppEnum.ON_VERIFICATION_CONFIRM_CONSULT_PHARMACIST_ORDER) {
        Navigator.of(context).pop(); // pop verification Page
        AppVariableStates.instance.submitFunction();
      } else if (widget.onVerificationNextStep ==
          AppEnum.ON_VERIFICATION_FROM_USER_DETAILS_PAGE) {
        Navigator.of(context).pop(); // pop verification Page
        AppVariableStates.instance.submitFunction();
      } else if (widget.onVerificationNextStep ==
          AppEnum.LOGIN_USING_REFERRAL_CODE) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again.");
    }

    isProcessing = false;
    refreshUI();
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
