import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class VerificationPage extends StatefulWidget {
  final Order order;
  final bool arrivedFromConfirmOrderPage;

  const VerificationPage(
      {Key key, this.order, this.arrivedFromConfirmOrderPage})
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
    sendSMS();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {});
  }

  void sendSMS() {
    if (widget.arrivedFromConfirmOrderPage) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Phone Verification"),
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
        buildLogo(),
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
            'Enter the verification code sent to +88-' +
                widget.order.userDetails.phoneNumber,
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
      callBackOnSubmit: onSubmit,
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

  Future<void> onSubmit() async {
    if (codeController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please enter the code.");
      return;
    }

    isProcessing = true;
    refreshUI();
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
