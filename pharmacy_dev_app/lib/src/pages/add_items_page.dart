import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';

class AddItemsPage extends StatefulWidget {
  final bool isRepeatOrder;
  AddItemsPage({Key key, this.isRepeatOrder}) : super(key: key);

  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController itemNameController = new TextEditingController();
  final TextEditingController itemUnitController = new TextEditingController();
  final TextEditingController itemQuantityController =
      new TextEditingController();
  final List<OrderManualItem> orderManualItemList = new List();
  final List<String> itemContainerTypeChoiceList = ['Piece', 'Box', 'Strip'];
  String itemContainerTypeChoice = 'Piece';

  @override
  void initState() {
    super.initState();
    AppVariableStates.instance.pageName = AppEnum.PAGE_ADD_ITEMS;
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
            title: CustomText('ADD ITEMS',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView(
            children: [
              Stack(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      buildAddItemBox(),
                      SizedBox(height: 13),
                      buildTitle(),
                      SizedBox(height: 7),
                      buildItemList(),
                    ],
                  ),
                  buildTutorialBox()
                ],
              )
            ],
          ),
        ),
        buildSubmitButton()
      ],
    ));
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (Store.instance.appState.tutorialBoxNumberAddItemsPage) {
      case 0:
        return Positioned(
          top: 45,
          right: 30,
          child: CustomMessageBox(
            width: size.width - 200,
            height: 140,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle: "The items you add will be listed under this",
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberAddItemsPage += 1;
    await Store.instance.putAppData();
  }

  Widget buildAddItemBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent, width: 0.5),
            borderRadius: BorderRadius.circular(5.0)),
        elevation: 7,
        clipBehavior: Clip.antiAlias, // Add This
        child: Column(
          children: [
            SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText('Item Name',
                      fontWeight: FontWeight.bold, color: Util.purplishColor()),
                  SizedBox(height: 3),
                  SizedBox(
                    height: 35, // set this
                    child: TextField(
                      controller: itemNameController,
                      decoration: new InputDecoration(
                        isDense: true,
                        hintText: EnBnDict.en_bn_convert(text: 'Napa'),
                        hintStyle: TextStyle(
                            fontFamily: EnBnDict.en_bn_font(), fontSize: 13),
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText('Unit',
                      fontWeight: FontWeight.bold, color: Util.purplishColor()),
                  SizedBox(height: 3),
                  SizedBox(
                    height: 35, // set this
                    child: TextField(
                      controller: itemUnitController,
                      decoration: new InputDecoration(
                        isDense: true,
                        hintText: EnBnDict.en_bn_convert(text: 'mg/ml'),
                        hintStyle: TextStyle(
                            fontFamily: EnBnDict.en_bn_font(), fontSize: 13),
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText('Quantity',
                          fontWeight: FontWeight.bold,
                          color: Util.purplishColor()),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: itemQuantityController,
                          decoration: new InputDecoration(
                            isDense: true,
                            hintText:
                                EnBnDict.en_bn_number_convert(number: '10'),
                            hintStyle: TextStyle(
                                fontFamily: EnBnDict.en_bn_font(),
                                fontSize: 13),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                buildItemTypeChipChoiceList(),
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Util.greenishColor(),
              height: 40,
              child: GeneralActionButton(
                title: "ADD ITEM",
                height: 40,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Util.greenishColor(),
                isProcessing: false,
                callBackOnSubmit: addItemsToList,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItemTypeChipChoiceList() {
    final children = List<Widget>();
    children.addAll(itemContainerTypeChoiceList.map((singleChoice) {
      return Container(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: ChoiceChip(
          elevation: 3.0,
          label: CustomText(
            singleChoice,
            fontSize: 14,
            color: Colors.white,
          ),
          selected: itemContainerTypeChoice == singleChoice,
          selectedColor: Util.purplishColor(),
          onSelected: (value) {
            itemContainerTypeChoice = singleChoice;
            refreshUI();
          },
          backgroundColor: Colors.grey[600],
          shape: StadiumBorder(
              side: BorderSide(
            width: 1,
            color: Colors.transparent,
          )),
        ),
      );
    }).toList());

    return Expanded(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    ));
  }

  Widget buildTitle() {
    if (orderManualItemList.length == 0) return Container();
    return Container(
      child: CustomText('ADDED ITEMS',
          color: Util.greenishColor(), fontWeight: FontWeight.bold),
    );
  }

  Widget buildItemList() {
    final children = List<Widget>();
    orderManualItemList.forEach((singleItem) {
      children.add(Container(
        padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
        color: Colors.transparent,
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 3,
          clipBehavior: Clip.antiAlias, // Add This
          child: ListTile(
            title: Text(singleItem.itemName + ' ' + singleItem.unit,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey[700])),
            subtitle: CustomText(
                EnBnDict.en_bn_convert(text: 'QUANTITY: ') +
                    EnBnDict.en_bn_number_convert(number: singleItem.quantity),
                textAlign: TextAlign.start,
                color: Colors.grey[500]),
            trailing: buildRemoveItemButton(singleItem),
          ),
        ),
      ));
    });
    return Column(children: children);
  }

  Widget buildRemoveItemButton(OrderManualItem singleItem) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleCrossButton(
            callBackDeleteItem: removeItemFromList,
            refreshUI: refreshUI,
            objectIdentifier: singleItem,
            iconSize: 16,
          ),
          SizedBox(height: 5),
          CustomText('REMOVE',
              fontWeight: FontWeight.w500, color: Colors.red, fontSize: 10)
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    if (orderManualItemList.length == 0) return Container();
    return GeneralActionRoundButton(
      title: "PROCEED",
      height: 40,
      isProcessing: false,
      callBackOnSubmit: proceedToConfirmOrderPage,
    );
  }

  void removeItemFromList(dynamic item) {
    orderManualItemList.remove(item);
  }

  void addItemsToList() {
    if (itemNameController.text.isEmpty || itemQuantityController.text.isEmpty)
      return;
    Util.removeFocusNode(context);
    orderManualItemList.add(OrderManualItem()
      ..itemName = itemNameController.text
      ..unit = itemUnitController.text
      ..quantity = int.parse(itemQuantityController.text));

    itemNameController.clear();
    itemUnitController.clear();
    itemQuantityController.clear();

    if (mounted) setState(() {});
  }

  void proceedToConfirmOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
                isRepeatOrder: widget.isRepeatOrder,
                orderType: AppEnum.ORDER_WITH_ITEM_NAME,
                orderManualItemList: orderManualItemList,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
