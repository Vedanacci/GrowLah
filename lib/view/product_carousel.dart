import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:grow_lah/model/system_data.dart';
import 'product_page.dart';

class ProductCarousel extends StatefulWidget {
  ProductCarousel({Key key}) : super(key: key);

  @override
  _ProductCarouselState createState() {
    return _ProductCarouselState();
  }
}

class _ProductCarouselState extends State<ProductCarousel> {
  List<SystemData> systemData = SystemData.defaultData;

  @override
  void initState() {
    reloadSystems();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
            size: 24,
          ),
        ),
        title: Text(
          "Recommended Systems",
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
                Icon(
                  Icons.home,
                  color: Colors.green,
                  size: 30.0,
                )
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            CarouselSlider(
                items: [
                  introSlides(0),
                  introSlides(1),
                  introSlides(2),
                  introSlides(3)
                ],
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    initialPage: 1,
                    autoPlay: false,
                    aspectRatio: (MediaQuery.of(context).size.width) /
                        (MediaQuery.of(context).size.height *
                            0.76), //MediaQuery.of(context).size.height * 0.75,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale)),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Area Scanned: 2m^2",
                style: TextStyle(
                    fontFamily: AppConfig.roboto,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, right: 35),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                          fontFamily: AppConfig.roboto,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, top: 20),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                      size: 15.0,
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    print(MediaQuery.of(context).size);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget introSlides(int index) {
    return Container(
        child: PageView(
      children: [
        Neumorphic(
          style: AppConfig.neuStyle
              .copyWith(color: index % 2 == 0 ? Colors.green : Colors.white),
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: Center(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/onboarding1.png", //+ (index + 1).toString() +
                          height: MediaQuery.of(context).size.height * 0.19,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            systemData[index].name,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04,
                                fontFamily: AppConfig.roboto,
                                fontWeight: FontWeight.bold,
                                color: index % 2 != 0
                                    ? Colors.green
                                    : Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 0, right: 0, bottom: 10),
                          child: Text(
                              "Size: " +
                                  systemData[index].size[0].toString() +
                                  " x " +
                                  systemData[index].size[1].toString() +
                                  " x " +
                                  systemData[index].size[2].toString() +
                                  "cm \n \nPlant Pots: " +
                                  systemData[index].pots.toString() +
                                  " \n \nType: " +
                                  systemData[index].type +
                                  " \n \nPrice: \$" +
                                  systemData[index].price.toString(),
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.024,
                                  fontFamily: AppConfig.roboto,
                                  color: index % 2 != 0
                                      ? Colors.green
                                      : Colors.white)),
                        ),
                        Padding(
                          child: NeumorphicButton(
                            child: Text(
                              "View More",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.024,
                                  fontFamily: AppConfig.roboto,
                                  color: index % 2 != 0
                                      ? Colors.white
                                      : Colors.green),
                            ),
                            style: AppConfig.neuStyle.copyWith(
                                color: index % 2 != 0
                                    ? Colors.green
                                    : Colors.white,
                                shadowLightColor: Colors.transparent),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                            indexIn: index,
                                          )));
                            },
                          ),
                          padding: EdgeInsets.only(top: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(indexIn: index)));
            },
          ),
        )
      ],
    ));
  }
}
