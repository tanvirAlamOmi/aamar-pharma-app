import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class OrderFinalInvoicePage extends StatefulWidget {
  final Order order;

  OrderFinalInvoicePage({this.order, Key key}) : super(key: key);

  @override
  _OrderFinalInvoicePageState createState() => _OrderFinalInvoicePageState();
}

class _OrderFinalInvoicePageState extends State<OrderFinalInvoicePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;

  double subTotal = 0;
  double deliveryFee = 0;
  double totalAmount = 0;

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  @override
  void initState() {
    super.initState();
    calculatePricing();
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
            title: Text(
              'ORDER DETAILS',
              style: TextStyle(color: Colors.white),
            ),
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
                  subTotal: subTotal,
                  deliveryFee: deliveryFee,
                  totalAmount: totalAmount,
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

  void calculatePricing() {
    subTotal = 0;
    deliveryFee = 20;
    totalAmount = 0;
    for (final singleItem in widget.order.invoice.invoiceItemList) {
      final unitPrice = singleItem.itemUnitPrice;
      final quantity = singleItem.itemQuantity;
      subTotal = subTotal + (unitPrice * quantity);
    }

    totalAmount = subTotal + deliveryFee;
  }

  Widget buildReOrderButton() {
    if (widget.order.status != OrderEnum.ORDER_STATUS_DELIVERED)
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
            child: Text(
              "Amar Pharma",
              style: TextStyle(
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
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
    final DeliveryAddressDetails deliveryAddressDetails =
        Util.getDeliveryAddress(widget.order.idAddress);

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
                  child: Text(
                    "Invoice Number",
                    style: TextStyle(
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "0001",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date Of Issue",
                    style: TextStyle(
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "20/02/15",
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
                  child: Text(
                    "Billed to",
                    style: TextStyle(
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    deliveryAddressDetails.address,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    deliveryAddressDetails.area,
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
          title: Text("View Order Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Util.greenishColor(),
                  fontSize: 14)),
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
                orderType: OrderEnum.ORDER_WITH_ITEM_NAME_REORDER,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum CHOICE_ENUM { DELIVERY_DAY, DELIVERY_TIME }
