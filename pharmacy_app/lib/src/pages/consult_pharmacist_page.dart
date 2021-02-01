import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/pages/request_received_success_page.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';

class ConsultPharmacistPage extends StatefulWidget {
  ConsultPharmacistPage({Key key}) : super(key: key);

  @override
  _ConsultPharmacistPageState createState() => _ConsultPharmacistPageState();
}

class _ConsultPharmacistPageState extends State<ConsultPharmacistPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
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
            title: CustomText('REQUEST CALL BACK', color: Colors.white),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30),
          buildContactPharmacistMessageBox(),
          SizedBox(height: 10),
          buildNameInputWidget(),
          SizedBox(height: 10),
          buildPhoneInputWidget(),
          SizedBox(height: 30),
          buildSubmitButton()
        ],
      ),
    );
  }

  Widget buildContactPharmacistMessageBox() {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 150,
      alignment: Alignment.center,
      child: CustomText(
          'For any kind of queries, feel free to consult with a pharmacist.',
          textAlign: TextAlign.center,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 15),
    );
  }

  Widget buildNameInputWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText('Name',
                fontWeight: FontWeight.bold, color: Util.purplishColor()),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                controller: nameController,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: "Mr. XYZ",
                  hintStyle: TextStyle(fontSize: 13),
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPhoneInputWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText('Phone Number',
                fontWeight: FontWeight.bold, color: Util.purplishColor()),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: "01XXXXXXXXX",
                  hintStyle: TextStyle(fontSize: 13),
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return GeneralActionRoundButton(
      title: "SUBMIT",
      height: 40,
      isProcessing: isProcessing,
      callBackOnSubmit: onSubmit,
    );
  }

  void onSubmit() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Util.showSnackBar(
          message: 'Please fill all the data', scaffoldKey: _scaffoldKey);
      return;
    }

    if (phoneController.text.length != 11) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    isProcessing = true;
    refreshUI();

    Util.showSnackBar(
        message: 'Please wait...', scaffoldKey: _scaffoldKey, duration: 1000);

    Tuple2<void, String> consultPharmacistOrderResponse =
        await OrderRepo.instance.consultPharmacistOrder(
            name: nameController.text, phone: phoneController.text);

    if (consultPharmacistOrderResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequestReceivedSuccessPage(
                  icon: Icons.call,
                  pageTitle: 'REQUEST RECEIVED',
                  title: 'Your request has been received. ',
                  message: 'You will get a call back within 30 minutes.',
                )),
      );
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again.",
          duration: 1500);
    }

    isProcessing = false;
    refreshUI();
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
