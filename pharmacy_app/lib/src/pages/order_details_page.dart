import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/general/custom_caousel_slider.dart';
import 'package:tuple/tuple.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  final bool showRepeatOrderCancelButton;

  OrderDetailsPage({this.order, Key key, this.showRepeatOrderCancelButton})
      : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Order order;
  final TextStyle textStyle = new TextStyle(fontSize: 11);
  double currentScrollIndex = 0;
  final scrollController = ScrollController();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
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
            title: CustomText('ORDER DETAILS',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            buildCancelRepeatOrderButton(),
            SizedBox(height: 10),
            buildImageList(),
            buildItemList(),
            SizedBox(height: 20),
            buildDeliveryAddressDetails(),
            buildPersonalDetails(),
            buildCancelOrderButton(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildCancelRepeatOrderButton() {
    if (widget.showRepeatOrderCancelButton)
      return GeneralActionRoundButton(
        title: "CANCEL REPEAT ORDER",
        isProcessing: isProcessing,
        color: Util.redishColor(),
        callBackOnSubmit: () {
          showAlertDialog(
              context: context,
              message: "Are you sure to stop this repeat order?",
              acceptFunc: cancelRepeatOrderSubmission);
        },
      );
    return Container();
  }

  Widget buildImageList() {
    if (order.orderedWith != AppEnum.ORDER_WITH_PRESCRIPTION)
      return Container();

    final List<String> imageList =
        Util.CSVToImageList(imagePathAsList: order.prescription);

    final children = imageList.map((singleImageUrl) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: CachedNetworkImage(
          imageUrl: singleImageUrl,
          placeholder: (context, url) => new CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          fit: BoxFit.contain,
          width: 250,
          height: 300,
        ),
      );
    }).toList();

    return CustomCarouselSlider(
      carouselListWidget: children,
      showRemoveImageButton: false,
      height: 110,
      autoPlay: false,
      refreshUI: refreshUI,
    );
  }

  Widget buildItemList() {
    if (order.orderedWith != AppEnum.ORDER_WITH_ITEM_NAME) return Container();
    final children = List<Widget>();

    children.add(Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(30, 7, 30, 7),
      child: CustomText('ADDED ITEMS',
          color: Util.greenishColor(), fontWeight: FontWeight.bold),
    ));

    order.items.forEach((singleItem) {
      children.add(Container(
        padding: const EdgeInsets.fromLTRB(25, 7, 25, 7),
        color: Colors.transparent,
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 3,
          clipBehavior: Clip.antiAlias, // Add This
          child: ListTile(
            title: Text(singleItem.itemName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(
              "QUANTITY: " + singleItem.quantity.toString(),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ),
      ));
    });

    return Column(children: children);
  }

  Widget buildDeliveryAddressDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 7, 30, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText('DELIVERY ADDRESS',
              color: Util.greenishColor(), fontWeight: FontWeight.bold),
          SizedBox(height: 10),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText('Area',
                    color: Util.purplishColor(), fontWeight: FontWeight.bold),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    style: textStyle,
                    controller: TextEditingController(
                        text: widget.order.deliveryAddressDetails.area),
                    enabled: false,
                    decoration: new InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(fontSize: 13),
                      fillColor: Colors.grey,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText('Address',
                    color: Util.purplishColor(), fontWeight: FontWeight.bold),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    style: textStyle,
                    controller: TextEditingController(
                        text: widget.order.deliveryAddressDetails.address),
                    enabled: false,
                    decoration: new InputDecoration(
                      isDense: true,
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
        ],
      ),
    );
  }

  Widget buildPersonalDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 7, 30, 7),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText('PERSONAL DETAILS',
                    color: Util.greenishColor(), fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                CustomText('Name',
                    color: Util.purplishColor(), fontWeight: FontWeight.bold),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    style: textStyle,
                    controller: TextEditingController(text: order.name),
                    enabled: false,
                    decoration: new InputDecoration(
                      isDense: true,
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
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText('Email',
                          color: Util.purplishColor(),
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          controller: TextEditingController(text: order.email),
                          style: textStyle,
                          enabled: false,
                          decoration: new InputDecoration(
                            isDense: true,
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText('Phone Number*',
                          color: Util.purplishColor(),
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          controller:
                              TextEditingController(text: order.mobileNo),
                          enabled: false,
                          style: textStyle,
                          decoration: new InputDecoration(
                            isDense: true,
                            hintText: "Phone Number",
                            hintStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildCancelOrderButton() {
    if (widget.showRepeatOrderCancelButton) return Container();
    if (order.status == AppEnum.ORDER_STATUS_PENDING ||
        order.status == AppEnum.ORDER_STATUS_INVOICE_SENT)
      return GeneralActionRoundButton(
        title: "CANCEL ORDER",
        isProcessing: isProcessing,
        color: Util.redishColor(),
        callBackOnSubmit: () {
          showAlertDialog(
              context: context,
              message: "Are you sure to cancel this order?",
              acceptFunc: cancelOrderSubmission);
        },
      );
    return Container();
  }

  void cancelRepeatOrderSubmission() async {
    isProcessing = true;
    refreshUI();

    final Tuple2<void, String> cancelRepeatOrderResponse =
        await OrderRepo.instance.cancelRepeatOrder(orderId: order.id);

    if (cancelRepeatOrderResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Repeat Order is cancelled");
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.of(context).pop();
      await Future.delayed(Duration(milliseconds: 500));
      Streamer.putEventStream(Event(EventType.REFRESH_REPEAT_ORDER_PAGE));
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again later.");
    }

    isProcessing = false;
    refreshUI();
  }

  void cancelOrderSubmission() async {
    isProcessing = true;
    refreshUI();

    final Tuple2<void, String> cancelOrderResponse =
        await OrderRepo.instance.cancelOrder(orderId: order.id);

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

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
