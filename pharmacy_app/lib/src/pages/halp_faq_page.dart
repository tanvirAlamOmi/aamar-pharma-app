import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
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
        title: 'DELIVERY CHARGE',
        textData: 'We do not take any delivery charge right now',
        collapseData: true),
    UIViewData(
        title: 'DELIVERY CHARGE 2',
        textData: 'We do not take any delivery charge right now',
        collapseData: true),
    UIViewData(
        title: 'DELIVERY CHARGE 4',
        textData: 'We do not take any delivery charge right now We do not ta',
        collapseData: true)
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBarBackButton(),
          elevation: 1,
          centerTitle: true,
          title: CustomText('FAQ',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                  height: 35,
                  color: Util.purplishColor(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        uiViewData.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
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
