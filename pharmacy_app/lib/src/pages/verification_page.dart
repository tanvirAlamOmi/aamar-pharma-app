import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  final bool arrivedFromConfirmOrderPage;
  final bool arrivedFromUserDetailsPage;

  const VerificationPage(
      {Key key,
      this.arrivedFromConfirmOrderPage,
      this.phoneNumber,
      this.arrivedFromUserDetailsPage})
      : super(key: key);
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
          title: CustomText(
            'Phone Verification',
          ),
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
    return Container(
        alignment: Alignment.center,
        child: Text(
            'Enter the verification code sent to +88-' + widget.phoneNumber,
            maxLines: 2,
            style: TextStyle(fontSize: 13.0, color: Colors.grey)));
  }

  Widget buildOtpInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      height: 55,
      child: TextFormField(
        autofocus: true,
        controller: codeController,
        keyboardType: TextInputType.phone,
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
        label: Text('Resend Code',
            style: TextStyle(fontSize: 15.0, color: Colors.blueGrey)),
        onPressed: () async {
          Util.showSnackBar(
              scaffoldKey: _scaffoldKey,
              message: "Resending code in 10 seconds");
          await Future.delayed(Duration(seconds: 10));
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

    onVerificationNextStep(responseCode: userResponse.item2, user: user);
  }

  void onVerificationNextStep({String responseCode, User user}) {
    isProcessing = true;
    refreshUI();

    if (responseCode == ClientEnum.RESPONSE_SUCCESS && user != null) {
      if (widget.arrivedFromConfirmOrderPage == true) {
        Navigator.of(context).pop();
        AppVariableStates.instance.submitOrder();
      }

      if (widget.arrivedFromUserDetailsPage == true) {
        Streamer.putEventStream(Event(EventType.REFRESH_USER_DETAILS_PAGE));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
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
