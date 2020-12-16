import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'product_carousel.dart';
import 'package:grow_lah/model/system_data.dart';
import 'product_card.dart';
import 'home_screen.dart';
import 'product_page.dart';
import 'product_list.dart';
import 'cart.dart';

class BuyHome extends StatefulWidget {
  BuyHome({Key key}) : super(key: key);

  @override
  _BuyHomeState createState() {
    return _BuyHomeState();
  }
}

class _BuyHomeState extends State<BuyHome> {
  List<SystemData> systemData = SystemData.defaultData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future reloadSystems() async {
    List<SystemData> data = await SystemData.getSystems();
    setState(() {
      systemData = data;
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Cart()));
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
                GestureDetector(
                  child: Neumorphic(
                    style: AppConfig.neuStyle.copyWith(color: Colors.green),
                    padding: EdgeInsets.only(
                        top: 30, bottom: 30, left: 50, right: 50),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/scan_spot.png',
                          color: Colors.white,
                          fit: BoxFit.fill,
                          height: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Scan Area",
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
                            builder: (context) => ProductCarousel()));
                  },
                ),
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
                              builder: (context) => ProductList()));
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
                    onTap: () {},
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
                    onTap: () {},
                  ),
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                ProductSwipe(systemData: systemData)
              ],
            ),
          ))),
        )
      ],
    );
  }
}
