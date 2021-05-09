import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/util/util.dart';

class RequestReceivedSuccessPage extends StatefulWidget {
  final IconData icon;
  final String pageTitle;
  final String title;
  final String message;

  const RequestReceivedSuccessPage(
      {Key key, this.icon, this.title, this.message, this.pageTitle})
      : super(key: key);

  @override
  _RequestReceivedSuccessPageState createState() =>
      _RequestReceivedSuccessPageState();
}

class _RequestReceivedSuccessPageState
    extends State<RequestReceivedSuccessPage> {
  @override
  void initState() {
    super.initState();
    AppVariableStates.instance.pageName = AppEnum.PAGE_REQUEST_RECEIVED_SUCCESS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBarBackButtonCross(),
          elevation: 1,
          centerTitle: true,
          title: CustomText(widget.pageTitle,
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            size: 80,
            color: Util.greenishColor(),
          ),
        ),
        SizedBox(height: 30),
        Container(
          child: CustomText(widget.title,
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        Container(
          width: 200,
          alignment: Alignment.center,
          child: CustomText(widget.message,
              textAlign: TextAlign.center, color: Colors.grey),
        ),
        SizedBox(height: 30),
        buildDoneButton(context)
      ],
    );
  }

  Widget buildDoneButton(BuildContext context) {
    return GeneralActionRoundButton(
      title: "DONE",
      isProcessing: false,
      callBackOnSubmit: () {
        Navigator.pop(context);
      },
    );
  }
}
