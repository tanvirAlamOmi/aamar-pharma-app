import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
import 'package:pharmacy_app/src/component/cards/aamar_pharma_address_card.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_address_card.dart';
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
  final bool showReOrder;
  final bool showOrderDetails;

  OrderFinalInvoicePage(
      {this.order, Key key, this.showReOrder, this.showOrderDetails})
      : super(key: key);

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
                AamarPharmaAddressCard(),
                buildDivider(),
                OrderInvoiceAddressCard(order: widget.order),
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
                  showGrandTotalRow: true,
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
    if (!widget.showReOrder ||
        widget.order.status != AppEnum.ORDER_STATUS_DELIVERED)
      return Container();
    return GeneralActionRoundButton(
      title: "REORDER",
      isProcessing: isProcessing,
      callBackOnSubmit: () => proceedToConfirmOrderPage(),
    );
  }

  Widget buildViewOrderDetailsButton() {
    if (!widget.showOrderDetails) return Container();
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
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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
