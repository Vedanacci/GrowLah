import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/view/ar_android_view.dart';
import 'package:grow_lah/view/ar_ios_view.dart';
import 'package:grow_lah/view/buyflow.dart';
import 'package:grow_lah/view/custom_order.dart';
import 'package:grow_lah/view/signUptoContinue.dart';
import 'product_carousel.dart';
import 'package:grow_lah/model/system_data.dart';
import 'product_card.dart';
import 'home_screen.dart';
import 'product_page.dart';
import 'product_list.dart';
import 'cart.dart';
import 'dart:io' show Platform;

class BuyHome extends StatefulWidget {
  BuyHome({Key key}) : super(key: key);

  @override
  _BuyHomeState createState() {
    return _BuyHomeState();
  }
}

class _BuyHomeState extends State<BuyHome> {
  List<ProductData> productData =
      List<ProductData>.from(SystemData.defaultData);

  @override
  void initState() {
    productData.addAll(NutrientData.defaultData);
    productData.addAll(SeedData.defaultData);
    reloadSystems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future reloadSystems() async {
    List<ProductData> data =
        List<ProductData>.from(await SystemData.getSystems());
    data.addAll(await NutrientData.getNutrients());
    data.addAll(await SeedData.getSeeds());
    setState(() {
      productData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    SizeConfig.screenHeight = size.height;
    SizeConfig.screenWidth = size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.green,
                size: 24,
              ),
            ),
            title: Text(
              "Buy Home",
              style: TextStyle(
                  fontFamily: AppConfig.roboto,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignContinue()));
                          }
                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.green,
                          size: 30.0,
                        ))
                  ],
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Center(
                  child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: (SizeConfig.screenWidth - 60),
                        child: GestureDetector(
                          child: Neumorphic(
                              style: AppConfig.neuStyle
                                  .copyWith(color: Colors.green),
                              padding: EdgeInsets.only(
                                  top: 30, bottom: 30, left: 20, right: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          'images/scan_spot.png',
                                          color: Colors.white,
                                          fit: BoxFit.fill,
                                          height:
                                              (SizeConfig.screenWidth - 50) /
                                                      4 -
                                                  40,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Text(
                                            "Smart Order",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: AppConfig.roboto,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 30),
                                    Expanded(
                                        // padding: EdgeInsets.all(20),
                                        child: Text(
                                            "Click here to scan for a smart system recommendation",
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: AppConfig.roboto,
                                            )))
                                  ])),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (Platform.isAndroid)
                                        ? ARAndroid()
                                        : ARIOS()));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => BuyFlow()));
                          },
                        ),
                      ),
                      // Container(
                      //   width: (SizeConfig.screenWidth - 60) / 2,
                      //   child: GestureDetector(
                      //     child: Neumorphic(
                      //       style: AppConfig.neuStyle
                      //           .copyWith(color: Colors.green),
                      //       padding: EdgeInsets.only(top: 30, bottom: 30),
                      //       child: Column(
                      //         children: [
                      //           Icon(
                      //             Icons.add,
                      //             size: (SizeConfig.screenWidth - 50) / 4 - 40,
                      //             color: Colors.white,
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(top: 20),
                      //             child: Text(
                      //               "Custom Order",
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontFamily: AppConfig.roboto,
                      //               ),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => CustomOrder()));
                      //     },
                      //   ),
                      // )
                    ]),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                      "Click here to scan for a smart system recommendation",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontFamily: AppConfig.roboto,
                      )),
                ),
                Padding(
                  child: GestureDetector(
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(color: Colors.green),
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              "Shop Systems",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: AppConfig.roboto,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      print("tapped");
                      // for (SystemData system in SystemData.defaultData) {
                      //   system.writeSystems();
                      // }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList(
                                    filter: 1,
                                  )));
                    },
                  ),
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                ),
                Padding(
                  child: GestureDetector(
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(color: Colors.green),
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              "Shop Nutrients",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: AppConfig.roboto,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList(
                                    filter: 2,
                                  )));
                    },
                  ),
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                ),
                Padding(
                  child: GestureDetector(
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(color: Colors.green),
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              "Shop Seeds",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: AppConfig.roboto,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList(
                                    filter: 3,
                                  )));
                    },
                  ),
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                ProductSwipe(productData: productData)
              ],
            ),
          ))),
        )
      ],
    );
  }
}
