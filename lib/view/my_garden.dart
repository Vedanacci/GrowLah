import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:grow_lah/model/extractImage.dart';
import 'package:grow_lah/view/monitor_screen.dart';

class GardenScreen extends StatefulWidget {
  GardenScreen({Key key}) : super(key: key);

  @override
  _GardenScreenState createState() {
    return _GardenScreenState();
  }
}

class _GardenScreenState extends State<GardenScreen> {
  List images = [];
  List potImages = [
    "images/onboarding1.png",
    "images/onboarding2.png",
    "images/onboarding3.png"
  ];
  List potNames = ["Balcony 1", "Balcony 2", "Yard System"];

  @override
  void initState() {
    super.initState();
    download();
  }

  download() async {
    CollectionReference ref = FirebaseFirestore.instance.collection("Produce");
    List extracted = [];
    await ref.get().then((value) {
      value.docs.forEach((element) async {
        String image = await extractImage(element.reference);
        extracted.add(image);
        setState(() {
          print("Extracted");
          print(extracted);
          images = extracted;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig.screenHeight = size.height;
    SizeConfig.screenWidth = size.width;
    return Scaffold(
      appBar: AppConfig.appBar('My Garden', context, true),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                  itemCount: potImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MonitorScreen()));
                        },
                        child: potSlides(
                            index, context, potImages[index], potNames[index]));
                  },
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      height: size.height * 0.275)),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 25, bottom: 25),
                child: Text(
                  'Smart Farming',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              // CarouselSlider.builder(
              //     itemCount: images.length,
              //     itemBuilder: (context, index) {
              //       return plantSlides(index, context, images[index]);
              //     },
              //     options: CarouselOptions(
              //         enlargeCenterPage: true,
              //         viewportFraction: 0.5,
              //         enableInfiniteScroll: false,
              //         height: size.height * 0.25)),
              Container(
                child: ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return plantSlides(index, context, images[index]);
                  },
                  scrollDirection: Axis.horizontal,
                ),
                height: size.height * 0.25,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget potSlides(int index, BuildContext context, String image, String name) {
  Size size = MediaQuery.of(context).size;
  return Padding(
    child: Neumorphic(
      style: AppConfig.neuStyle.copyWith(
          color: Colors.white12,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.all(Radius.circular(10.0)))),
      child: SizedBox(
        width: size.width - 20,
        child: Stack(
          children: [
            Image.asset(
              image,
              width: size.width - 20,
              fit: BoxFit.fitWidth,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                color: Colors.green.withOpacity(0.5),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    ),
    padding: EdgeInsets.only(top: 10, bottom: 10),
  );
}

Widget plantSlides(int index, BuildContext context, String link) {
  Size size = MediaQuery.of(context).size;
  return Container(
    width: size.width / 2,
    height: size.height * 0.25,
    padding: EdgeInsets.only(left: 0, right: 0),
    child: Column(
      children: [
        Neumorphic(
          style: AppConfig.neuStyle.copyWith(
              color: Colors.white12, boxShape: NeumorphicBoxShape.circle()),
          child: Image.network(
            link,
            fit: BoxFit.fitHeight,
            width: size.width / 2,
            height: size.height * 0.175,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Title",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              fontFamily: AppConfig.roboto),
        )
      ],
    ),
  );
}
