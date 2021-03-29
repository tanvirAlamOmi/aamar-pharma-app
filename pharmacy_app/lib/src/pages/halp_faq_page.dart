import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/ui_view_data.dart';
import 'package:pharmacy_app/src/util/util.dart';

class HelpFAQPage extends StatefulWidget {
  HelpFAQPage({Key key}) : super(key: key);

  @override
  _HelpFAQPageState createState() => _HelpFAQPageState();
}

class _HelpFAQPageState extends State<HelpFAQPage> {
  List<UIViewData> faqList = [
    UIViewData(
        title: 'HOW IT WORKS',
        textData:
            '1. Place your prescription or item list, and wait a while. \n\n'
            '2. Pharmacy starts preparing your medicine just after you place an order.\n\n'
            '3. One of our troopers takes your medicine safely and drives to your home.\n\n'
            '4. You take the delivery having no anxiety of safety.\n',
        collapseData: true),
    UIViewData(
        title: 'Do you take delivery charges?',
        textData:
            'We only take BDT 20 as the delivery charges for the orders below 500.',
        collapseData: true),
    UIViewData(
        title: 'Can I select the pharmacy?',
        textData: 'No. It’s an automated process. Our software does the task.',
        collapseData: true),
    UIViewData(
        title: 'How do you select the pharmacy?',
        textData:
            'It’s automatically selected by the distance and availability.',
        collapseData: true),
    UIViewData(
        title: 'Do you take very large or small orders?',
        textData: 'Yes. We pay the same attention for every delivery.',
        collapseData: true),
    UIViewData(
        title: 'Do you courier medicines to other cities?',
        textData: 'No. We have selected areas where we can reach fast.',
        collapseData: true),
    UIViewData(
        title: 'Do you have other options of order except the app?',
        textData: 'No. You have to order from the app.',
        collapseData: true),
    UIViewData(
        title: 'Do you have emergency customer support?',
        textData:
            'Yes. Call ${AppEnum.HOTLINE_NUMBER} for customer support from 10 am to 10 pm.',
        collapseData: true),
    UIViewData(
        title: 'Do you deliver medicines without prescription?',
        textData:
            'We only deliver OTC (Over the Counter) medicines without prescription.',
        collapseData: true),
    UIViewData(
        title: 'Can I save my order in the app?',
        textData:
            'It’s automatically saved when you place an order. You can repeat it whenever you want.',
        collapseData: true),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBarBackButton(),
          elevation: 1,
          centerTitle: true,
          title: CustomText('FAQs',
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        body: Center(child: SingleChildScrollView(child: buildBody())));
  }

  Widget buildBody() {
    final children = List<Widget>();
    faqList.forEach((singleFaq) {
      children.add(buildFAQ(singleFaq));
    });

    return Column(
      children: children,
    );
  }

  Widget buildFAQ(UIViewData uiViewData) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3,
          clipBehavior: Clip.antiAlias, // Add This
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  uiViewData.collapseData = !uiViewData.collapseData;
                  if (mounted) setState(() {});
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: 50,
                  color: Util.purplishColor(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width - 100,
                        child: Text(
                          uiViewData.title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      (uiViewData.collapseData)
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 25,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_drop_up,
                                color: Colors.white,
                                size: 25,
                              ),
                            )
                    ],
                  ),
                ),
              ),
              (uiViewData.collapseData)
                  ? Container()
                  : Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Text(
                            uiViewData.textData,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
