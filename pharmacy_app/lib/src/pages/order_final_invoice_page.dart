import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';

class OrderFinalInvoicePage extends StatefulWidget {
  final Order order;

  OrderFinalInvoicePage({this.order, Key key}) : super(key: key);

  @override
  _OrderFinalInvoicePageState createState() => _OrderFinalInvoicePageState();
}

class _OrderFinalInvoicePageState extends State<OrderFinalInvoicePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

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
            title: CustomText('ORDER INVOICE DETAILS',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                buildReOrderButton(),
                buildPharmaAddress(),
                buildDivider(),
                buildOrderAddress(),
                buildDivider(),
                buildViewOrderDetailsButton(),
                SizedBox(height: 20),
                OrderInvoiceTableCard(
                  order: widget.order,
                  showCrossColumn: false,
                  showItemNameColumn: true,
                  showUnitCostColumn: true,
                  showQuantityColumn: true,
                  showIncDecButtons: false,
                  showAmountColumn: true,
                  showSubTotalRow: true,
                  showTotalRow: true,
                ),
                SizedBox(height: 20)
              ],
            ),
            buildTutorialBox()
          ],
        ),
      ),
    );
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (Store.instance.appState.tutorialBoxNumberOrderFinalInvoicePage) {
      case 0:
        if (widget.order.status != AppEnum.ORDER_STATUS_DELIVERED)
          return Container();
        return Positioned(
          top: 60,
          left: 60,
          child: CustomMessageBox(
            width: size.width - 100,
            height: 150,
            startPoint: 100,
            midPoint: 110,
            endPoint: 130,
            arrowDirection: ClientEnum.ARROW_TOP,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle: "Tap this if you want to order the same items again",
          ),
        );
        break;

      default:
        return Container();
        break;
    }
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberOrderFinalInvoicePage += 1;
    await Store.instance.putAppData();
  }

  Widget buildReOrderButton() {
    if (widget.order.status != AppEnum.ORDER_STATUS_DELIVERED)
      return Container();
    return GeneralActionRoundButton(
      title: "REORDER",
      isProcessing: isProcessing,
      callBackOnSubmit: () => proceedToConfirmOrderPage(),
    );
  }

  Widget buildPharmaAddress() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Aamar Pharma',
              color: Util.purplishColor(),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width / 2 - 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "31 Street, Mirpur DOHS \n"
                  "Dhaka, Bangladesh. ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
              Container(
                width: size.width / 2 - 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "+88012-35359552\n"
                  "arbree@amarpharma.com",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildOrderAddress() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width / 2 - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Invoice Number',
                    color: Util.purplishColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    EnBnDict.en_bn_number_convert(number: widget.order.id),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Date Of Issue',
                    color: Util.purplishColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    EnBnDict.en_bn_number_convert(
                        number: widget.order.deliveryDate),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: size.width / 2 - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Billed to',
                    color: Util.purplishColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.deliveryAddressDetails.address,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.deliveryAddressDetails.area,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.mobileNo,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildViewOrderDetailsButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 3,
        clipBehavior: Clip.antiAlias, // Add This
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(
                        showRepeatOrderCancelButton: false,
                        order: widget.order,
                      )),
            );
          },
          title: CustomText('View Order Details',
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              color: Util.greenishColor(),
              fontSize: 14),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Divider(height: 3, thickness: 2),
    );
  }

  void proceedToConfirmOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
                order: widget.order,
                orderType: AppEnum.ORDER_WITH_ITEM_NAME_REORDER,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
