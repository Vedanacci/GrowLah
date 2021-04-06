import 'package:grow_lah/model/system_data.dart';

import 'on_boarding.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:grow_lah/model/buyFlowItem.dart';

class BuyFlow extends StatefulWidget {
  BuyFlow({Key key, this.system}) : super(key: key);

  final SystemData system;

  @override
  _BuyFlowState createState() {
    return _BuyFlowState();
  }
}

class _BuyFlowState extends State<BuyFlow> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  int page = 0;
  LiquidController liquidController = LiquidController();
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  List<BuyItem> produceItems = [
    BuyItem("Lettuce", 2.75, 0),
    BuyItem("Tomato", 2.75, 0),
    BuyItem("Lettuce2", 2.75, 0),
    BuyItem("Tomato2", 2.75, 0),
    BuyItem("Lettuce3", 2.75, 0),
    BuyItem("Tomato3", 2.75, 0)
  ];

  List<BuyItem> sensorItems = [
    BuyItem("Light Sensor", 2.75, 0),
    BuyItem("PH Sensor", 2.75, 0),
    BuyItem("Temperature sensor", 2.75, 0),
    BuyItem("Sensor3", 2.75, 0),
    BuyItem("Sensor4", 2.75, 0),
    BuyItem("Sensor5", 2.75, 0)
  ];

  List<BuyItem> summary = [];

  bool light = false;

  int totalModules = 10;

  SystemData system = SystemData.defaultData[0];

  @override
  void initState() {
    super.initState();
    if (widget.system != null) {
      system = widget.system;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView(
          //   controller: _controller,
          //   children: [
          //     introSlides(1),
          //     introSlides(2),
          //     introSlides(3),
          //   ],
          // ),
          LiquidSwipe(
              pages: [
                introSlides(1),
                indoors(2),
                introSlides(3),
                introSlides(4)
              ],
              waveType: WaveType.liquidReveal,
              onPageChangeCallback: (pageNo) {
                setState(() {
                  print(pageNo);
                  page = pageNo;
                });
              },
              fullTransitionValue: 900,
              enableLoop: false,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true)
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 50, bottom: 20, top: 20, right: 50),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(
                  "Back",
                  style: page == 0
                      ? TextStyle(
                          fontSize: 18.0,
                          fontFamily: AppConfig.roboto,
                          color: Colors.transparent)
                      : TextStyle(
                          fontSize: 18.0,
                          fontFamily: AppConfig.roboto,
                          color: Colors.green),
                ),
                onPressed: page == 0
                    ? () {}
                    : () {
                        print("Pressed");
                        page -= 1;
                        page = page.isNegative ? 0 : page;
                        liquidController.animateToPage(
                            page: page, duration: _kDuration.inMilliseconds);
                      },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(4, _buildDot),
              ),
              TextButton(
                child: Text(
                  "Next",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: AppConfig.roboto,
                      color: page == 3 ? Colors.white : Colors.green),
                ),
                onPressed: page == 3
                    ? () {}
                    : () {
                        print("Pressed");
                        page += 1;
                        page = page > 3 ? 3 : page;
                        liquidController.animateToPage(
                            page: page, duration: _kDuration.inMilliseconds);
                      },
              )
            ],
          ),
        ),
      ),
    );
  }

  Scaffold introSlides(int index) {
    if (index == 4) {
      summary = [BuyItem(system.name, system.price, 1)];
      if (light) {
        summary.add(BuyItem("Light", 2.49, 1));
      }
      for (BuyItem produce in produceItems) {
        if (produce.quantity > 1) {
          summary.add(produce);
        }
      }
      for (BuyItem sensor in sensorItems) {
        if (sensor.quantity == 1) {
          summary.add(sensor);
        }
      }
    }
    List<Widget> products = [];
    for (BuyItem data in (index == 1)
        ? produceItems
        : (index == 4)
            ? summary
            : sensorItems) {
      Dismissible dismissible = Dismissible(
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content:
                      const Text("Are you sure you wish to delete this item?"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("DELETE")),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    ),
                  ],
                );
              },
            );
          },
          child: horizontalProductCard(
            data,
            index,
            EdgeInsets.all(10),
          ),
          key: Key(data.title),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            setState(() {
              (index == 1)
                  ? produceItems.remove(data)
                  : sensorItems.remove(data);
            });
          },
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFFFFE6E6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.delete, color: Colors.green),
              ],
            ),
          ));
      products.add(dismissible);
    }
    return Scaffold(
        backgroundColor: index % 2 == 0 ? Colors.green : Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          index == 1
                              ? "Produce"
                              : index == 2
                                  ? "Are you placing it Indoors or Outdoors?"
                                  : index == 3
                                      ? "Add-Ons"
                                      : "Order Summary",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: AppConfig.roboto,
                              fontWeight: FontWeight.bold,
                              color:
                                  index % 2 != 0 ? Colors.green : Colors.white),
                        ),
                      ),
                      index == 1
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 0),
                              child: Text(
                                  "You have space for $totalModules more produce modules",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: AppConfig.roboto,
                                      fontWeight: FontWeight.w200,
                                      color: index % 2 != 0
                                          ? Colors.green
                                          : Colors.white)))
                          : Container(),
                      Padding(
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(10)),
                        child: Wrap(
                          children: products,
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.end,
                        ),
                      ),
                      (index == 4)
                          ? Padding(
                              child: GestureDetector(
                                child: Neumorphic(
                                  style: AppConfig.neuStyle.copyWith(
                                      shadowLightColor: Colors.transparent,
                                      color: Colors.white,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(15))),
                                  padding: EdgeInsets.all(30),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontFamily: AppConfig.roboto,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {},
                              ),
                              padding: EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 10),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget indoors(int index) {
    return Scaffold(
      backgroundColor: index % 2 == 0 ? Colors.green : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("images/onboarding" + index.toString() + ".png"),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 50, bottom: 50, left: 10, right: 10),
                    child: Text(
                      "Indoors or Outdoors?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: AppConfig.roboto,
                          fontWeight: FontWeight.bold,
                          color: index % 2 != 0 ? Colors.green : Colors.white),
                    ),
                  ),
                  Padding(
                    child: GestureDetector(
                      child: Neumorphic(
                        style: AppConfig.neuStyle.copyWith(
                            shadowLightColor: Colors.transparent,
                            color: light ? Colors.black : Colors.white,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(15))),
                        padding: EdgeInsets.all(30),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                light
                                    ? "Indoors (Need Light)"
                                    : "Outdoors (No Light)",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontFamily: AppConfig.roboto,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        print("Tapped");
                        setState(() {
                          light = !light;
                        });
                      },
                    ),
                    padding: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 0),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget horizontalProductCard(BuyItem product, indexIn, padding) {
    return Padding(
        padding: padding,
        child: SizedBox(
            width: SizeConfig.screenWidth,
            height: (SizeConfig.screenWidth) / 4,
            child: Neumorphic(
              style: AppConfig.neuStyle.copyWith(
                  shadowLightColor: Colors.transparent,
                  color: Colors.transparent,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15))),
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(" x " + product.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(12),
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ))
                              ],
                            )
                          ]),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            iconSize: (SizeConfig.screenWidth) / 8,
                            onPressed: () {
                              setState(() {
                                // produceItems.remove(product);
                                if (indexIn == 1) {
                                  product.quantity += 1;
                                  totalModules -= 1;
                                  if (totalModules < 0) {
                                    product.quantity -= 1;
                                    totalModules = 0;
                                  }
                                } else {
                                  product.quantity = 1;
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.remove),
                            color: Colors.white,
                            iconSize: (SizeConfig.screenWidth) / 8,
                            onPressed: () {
                              setState(() {
                                // produceItems.remove(product);
                                if (indexIn == 1) {
                                  product.quantity -= 1;
                                  totalModules += 1;
                                  if (product.quantity < 0) {
                                    product.quantity = 0;
                                    totalModules -= 1;
                                  }
                                } else {
                                  product.quantity = 0;
                                }
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _buildDot(int index) {
    const double _kDotSize = 8.0;

    // The increase in the size of the selected dot
    const double _kMaxZoom = 2.0;

    // The distance between the center of each dot
    const double _kDotSpacing = 25.0;
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: Colors.green,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () {
                print("tapped");
                liquidController.animateToPage(page: index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.green,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: Colors.green,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
