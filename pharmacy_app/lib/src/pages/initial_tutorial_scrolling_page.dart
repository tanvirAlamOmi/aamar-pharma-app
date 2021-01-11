import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/initial_tutorial_card.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/general/ui_view_data.dart';

class InitialTutorialScrollingPage extends StatefulWidget {
  @override
  _InitialTutorialScrollingPageState createState() =>
      _InitialTutorialScrollingPageState();
}

class _InitialTutorialScrollingPageState
    extends State<InitialTutorialScrollingPage> {
  final listItems = [
    UIViewData()
      ..title = "REPEAT ORDERS"
      ..textData =
          "Make an order once and have the same items delivered to you on a regular basis on a specified time"
      ..icon = Icon(
        Icons.shopping_bag,
        color: Util.greenishColor(),
        size: 70,
      ),
    UIViewData()
      ..title = "SPECIAL REQUESTS"
      ..textData =
          "Request for a product which is not available at the time and we will try to manage it for you"
      ..icon = Icon(
        Icons.favorite,
        color: Util.greenishColor(),
        size: 70,
      ),
    UIViewData()
      ..title = "CONSULT PHARMACIST"
      ..textData =
          "Request a call back to consult with a pharmacist for any kind of queries you might have"
      ..icon = Icon(
        Icons.call,
        color: Util.greenishColor(),
        size: 70,
      ),
    UIViewData()
      ..title = "ORDER MEDICINES & MORE"
      ..textData =
          "Order medicines or other items and get it immediately delivered to your doorstep whenever you want"
      ..icon = Icon(
        Icons.shopping_bag,
        color: Util.greenishColor(),
        size: 70,
      )
  ];
  int _currentIndex = 0;
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Util.purplishColor(),
          width: double.infinity,
          child: buildBody()),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
              viewportFraction: 1,
              height: 300,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
          items: listItems.map((singleUiViewData) {
            bool showGetStartedButton = false;
            if (_currentIndex == listItems.length - 1)
              showGetStartedButton = true;
            return Builder(
              builder: (BuildContext context) {
                return InitialTutorialCard(
                  showGetStartedButton: showGetStartedButton,
                  uiViewData: singleUiViewData,
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 130),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildScrollBar(),
        ),
      ],
    );
  }

  List<Widget> buildScrollBar() {
    final children = List<Widget>();
    children.add(GestureDetector(
      onTap: () {
        _carouselController.previousPage(
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        width: 50,
        height: 50,
        child: Icon(
          Icons.arrow_back,
          color: Util.purplishColor(),
        ),
      ),
    ));
    listItems.forEach((image) {
      int index = listItems.indexOf(image);
      children.add(Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentIndex == index ? Util.greenishColor() : Colors.white),
      ));
    });

    children.add(GestureDetector(
      onTap: () {
        _carouselController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Util.purplishColor(),
        ),
      ),
    ));

    return children;

    listItems.map(
      (image) {
        int index = listItems.indexOf(image);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4)),
        );
      },
    );
  }
}
