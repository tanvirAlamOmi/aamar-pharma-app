import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/buttons/red_border_cancel_button.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/component/cards/upload_prescription_card.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/pages/order_final_invoice_page.dart';
import 'package:pharmacy_app/src/repo/delivery_repo.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/order_util.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class ConfirmInvoicePage extends StatefulWidget {
  final Order order;

  ConfirmInvoicePage({this.order, Key key}) : super(key: key);

  @override
  _ConfirmInvoicePageState createState() => _ConfirmInvoicePageState();
}

class _ConfirmInvoicePageState extends State<ConfirmInvoicePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;
  bool prescriptionRequired = false;
  bool collectPrescriptionOnDelivery = false;
  List<Uint8List> prescriptionImageFileList = [];

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  @override
  void initState() {
    super.initState();
    checkIfPrescriptionRequired();
    OrderUtil.calculatePricing(widget.order);
    AppVariableStates.instance.pageName = AppEnum.PAGE_CONFIRM_INVOICE;
    DeliveryRepo.instance.deliveryCharges();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void checkIfPrescriptionRequired() {
    for (int i = 0; i < widget.order.invoiceItemList.length; i++) {
      if (widget.order.invoiceItemList[i].isPrescriptionRequired == 'true') {
        prescriptionRequired = true;
        collectPrescriptionOnDelivery = true;
        break;
      }
    }
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
            title: CustomText('CONFIRM ORDER',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    if (isProcessing) return buildLoadingWidget();
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildViewOrderDetailsButton(),
                buildInvoiceNote(),
                buildWarningTitle(),
                SizedBox(height: 20),
                OrderInvoiceTableCard(
                  order: widget.order,
                  callBackIncrementItemQuantity: incrementItemQuantity,
                  callBackDecrementItemQuantity: decrementItemQuantity,
                  callBackRemoveItem: removeItem,
                  callBackRefreshUI: refreshUI,
                  showCrossColumn: true,
                  showItemNameColumn: true,
                  showUnitCostColumn: true,
                  showQuantityColumn: true,
                  showIncDecButtons: true,
                  showAmountColumn: true,
                  showSubTotalRow: true,
                  showGrandTotalRow: true,
                ),
                buildIsPrescriptionRequiredTitle(),
                SizedBox(height: 10),
                buildUploadPrescriptionCard(),
                SizedBox(height: 10),
                buildCashWarningTitle(),
                SizedBox(height: 10),
                GeneralActionRoundButton(
                  title: "CONFIRM ORDER",
                  isProcessing: false,
                  callBackOnSubmit: () {
                    showAlertDialog(
                        context: context,
                        height: 170,
                        message:
                            "Are you sure to confirm this invoice for this order?",
                        acceptFunc: confirmInvoiceOrder);
                  },
                ),
                SizedBox(height: 7),
                RedBorderCancelButton(
                  isProcessing: isProcessing,
                  callBackOnSubmit: cancelOrderSubmission,
                ),
                SizedBox(height: 20),
              ],
            ),
            buildTutorialBox()
          ],
        ),
      ),
    );
  }

  Widget buildLoadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingWidget(status: 'Confirming...'),
      ],
    );
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (Store.instance.appState.tutorialBoxNumberConfirmInvoicePage) {
      case 0:
        return Positioned(
          top: 60,
          left: 20,
          child: CustomMessageBox(
            width: size.width - 100,
            height: 150,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_TOP,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle:
                "View your order details to check if we got the correct item list",
          ),
        );
        break;
      case 1:
        return Positioned(
          top: 20,
          left: 15,
          child: CustomMessageBox(
            width: size.width - 100,
            height: 130,
            startPoint: 20,
            midPoint: 30,
            endPoint: 40,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle:
                "Tap to remove items from the list if you don’t want to order it",
          ),
        );
        break;
      case 2:
        return Positioned(
          top: 40,
          right: 50,
          child: CustomMessageBox(
            width: size.width - 200,
            height: 130,
            startPoint: 90,
            midPoint: 100,
            endPoint: 110,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle: "Plus or minus the quantity of items",
          ),
        );
        break;
      case 3:
        if (collectPrescriptionOnDelivery)
          return Positioned(
            bottom: 250,
            left: 30,
            child: CustomMessageBox(
              width: size.width - 60,
              height: 150,
              startPoint: 90,
              midPoint: 100,
              endPoint: 110,
              arrowDirection: ClientEnum.ARROW_BOTTOM,
              callBackAction: updateTutorialBox,
              callBackRefreshUI: refreshUI,
              messageTitle:
                  "Upload a picture of your prescription or have your prescription ready upon delivery",
            ),
          );
        return Container();
        break;
      default:
        return Container();
        break;
    }
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberConfirmInvoicePage += 1;
    await Store.instance.putAppData();
  }

  Widget buildIsPrescriptionRequiredTitle() {
    if (prescriptionRequired)
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              child: CustomText('*Prescription required',
                  color: Util.redishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  textAlign: TextAlign.start),
            ),
          ],
        ),
      );

    return Container();
  }

  Widget buildUploadPrescriptionCard() {
    if (prescriptionRequired)
      return UploadPrescriptionOrderCard(
        collectPrescriptionOnDelivery: collectPrescriptionOnDelivery,
        setCollectPrescriptionOnDelivery: setCollectPrescriptionOnDelivery,
        order: widget.order,
        scaffoldKey: _scaffoldKey,
        prescriptionImageFileList: prescriptionImageFileList,
        refreshUI: refreshUI,
      );

    return Container();
  }

  void setCollectPrescriptionOnDelivery(dynamic value) {
    collectPrescriptionOnDelivery = value;
  }

  Widget buildCashWarningTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: CustomText('We only accept cash on delivery.',
                color: Util.greenishColor(),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          Container(
            child: CustomText('Please keep cash ready upon delivery.',
                color: Util.greenishColor(),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget buildInvoiceNote() {
    if (widget.order.invoiceNote == null) return Container();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          color: Util.colorFromHex('#D2F2F4'),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(widget.order.invoiceNote,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ),
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

  Widget buildWarningTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Container(
        child: CustomText(
          'Before confirming order, please check invoice, edit quantity or remove items.',
          textAlign: TextAlign.start,
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void cancelOrderSubmission() async {
    isProcessing = true;
    refreshUI();

    final Tuple2<void, String> cancelOrderResponse =
        await OrderRepo.instance.cancelOrder(orderId: widget.order.id);

    if (cancelOrderResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Order is cancelled");
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
      await Future.delayed(Duration(milliseconds: 500));
      Streamer.putEventStream(Event(EventType.SWITCH_TO_ORDER_NAVIGATION_PAGE));
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again later.");
    }

    isProcessing = false;
    refreshUI();
  }

  void removeItem(dynamic singleItem) {
    if (widget.order.invoiceItemList.length == 1) {
      Util.showSnackBar(
          message: 'You can not remove the last item',
          scaffoldKey: _scaffoldKey);
      return;
    }
    widget.order.invoiceItemList.remove(singleItem);
  }

  void incrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoiceItemList) {
      if (singleItem == invoiceItem) {
        singleItem.quantity = singleItem.quantity + 1;
        break;
      }
    }
  }

  void decrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoiceItemList) {
      if (singleItem == invoiceItem) {
        if (singleItem.quantity == 1) {
          return;
        }
        singleItem.quantity = singleItem.quantity - 1;
        break;
      }
    }
  }

  void confirmInvoiceOrder() async {
    if (prescriptionRequired &&
        !collectPrescriptionOnDelivery &&
        prescriptionImageFileList.length == 0) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please upload the required prescriptions",
          duration: 1500);
      return;
    }

    isProcessing = true;
    refreshUI();

    if (prescriptionRequired && !collectPrescriptionOnDelivery) {
      List<String> newPrescriptionList = [];
      for (final image in prescriptionImageFileList) {
        newPrescriptionList.add(await Util.uploadImageToFirebase(
            imageFile: image, folderPath: 'prescription/'));
      }
      final List<String> previousPrescriptionList =
          Util.CSVToImageList(imagePathAsList: widget.order.prescription);

      newPrescriptionList.addAll(previousPrescriptionList);

      widget.order.prescription =
          Util.imageURLAsCSV(imageList: newPrescriptionList);
    }

    Tuple2<void, String> confirmInvoiceOrderResponse = await OrderRepo.instance
        .confirmInvoiceOrder(
            order: widget.order,
            collectPrescriptionOnDelivery: collectPrescriptionOnDelivery);

    if (confirmInvoiceOrderResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Order is confirmed.",
          duration: 1500);
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
      await Future.delayed(Duration(milliseconds: 100));
      Streamer.putEventStream(Event(EventType.REFRESH_ORDER_PAGE));
      Streamer.putEventStream(Event(EventType.REFRESH_NOTIFICATION_PAGE));
      Streamer.putEventStream(Event(EventType.SWITCH_TO_ORDER_NAVIGATION_PAGE));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderFinalInvoicePage(
                  order: widget.order,
                  showReOrder: false,
                  showOrderDetails: false,
                  showDoneButton: true,
                  pageName: AppEnum.PAGE_CONFIRM_INVOICE,
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
