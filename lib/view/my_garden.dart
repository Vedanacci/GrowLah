import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:grow_lah/view/garden_monitor.dart';
import 'package:grow_lah/view/give.dart';
import 'package:grow_lah/view/monitor_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grow_lah/model/system_data.dart';
import 'package:grow_lah/view/product_list.dart';
import 'product_card.dart';

class Garden {
  String name;
  String image;
  String system;
  String path;

  static List potNames = ["Balcony 1", "Balcony 2", "Yard System"];
  static List<Garden> defaultData = [
    Garden(potNames[0], 'image.png', 'System Pro', 'vedantbahadur'),
    Garden(potNames[1], 'image.png', 'System Pro', 'vedantbahadur'),
    Garden(potNames[2], 'image.png', 'System Pro', 'vedantbahadur')
  ];

  Garden(this.name, this.image, this.system, this.path);

  static Future<List<Garden>> getGardens() async {
    List<Garden> gardenList = [];
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("myGarden")
        .get()
        .catchError((error) {
      print(error.code);
      gardenList = [];
    }).then((feed) async {
      await Future.forEach(feed.docs, (element) async {
        Map<String, dynamic> data = element.data();
        print(data);
        String image = data["image"];
        String urlImage = await FirebaseStorage.instance
            .ref()
            .child("Products")
            .child(image)
            .getDownloadURL();
        Garden gardenData =
            Garden(data["name"], urlImage, data["system"], data["path"]);
        gardenList.add(gardenData);
      });
    });
    return gardenList == [] ? defaultData : gardenList;
  }
}

class GardenScreen extends StatefulWidget {
  GardenScreen({Key key}) : super(key: key);

  @override
  _GardenScreenState createState() {
    return _GardenScreenState();
  }
}

class _GardenScreenState extends State<GardenScreen> {
  List images = [];
  List names = [];
  List<Garden> gardens = Garden.defaultData;
  List<ProductData> productData =
      List<ProductData>.from(SystemData.defaultData);

  @override
  void initState() {
    productData.addAll(NutrientData.defaultData);
    productData.addAll(SeedData.defaultData);
    reloadSystems();
    super.initState();
    download();
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

  download() async {
    CollectionReference ref = FirebaseFirestore.instance.collection("Produce");
    List extracted = [];
    List extrNames = [];
    List<Garden> downloaded = await Garden.getGardens();
    setState(() {
      gardens = downloaded;
    });
    await ref.get().then((value) {
      value.docs.forEach((element) async {
        String image = await extractImage(element.reference, "Produce");
        extracted.add(image);
        extrNames.add(element.id);
        setState(() {
          print("Extracted");
          print(extracted);
          images = extracted;
          names = extrNames;
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
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: gardens.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductList()));
                          },
                          child: Padding(
                            child: Neumorphic(
                              style: AppConfig.neuStyle.copyWith(
                                  color: Colors.green.withOpacity(0.5),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.all(Radius.circular(10.0)))),
                              child: SizedBox(
                                width: size.width - 20,
                                child: Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 0, sigmaY: 0),
                                      child: Container(
                                        color: Colors.green.withOpacity(0.5),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "You have no systems. Tap to unlock this experience",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                          ))
                      : CarouselSlider.builder(
                          itemCount: gardens.length,
                          itemBuilder: (context, index, heroIndex) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GardenMonitor(
                                                garden: gardens[index],
                                              )));
                                },
                                child: potSlides(context, gardens[index].image,
                                    gardens[index].name));
                          },
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              height: size.height * 0.275))),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 25),
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
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: ListView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Give()));
                            },
                            child: plantSlides(
                                context, images[index], names[index]));
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    height: size.height * 0.25,
                  )),
              Container(
                padding: EdgeInsets.all(0),
                width: SizeConfig.screenWidth,
                child: ProductSwipe(
                  productData: productData,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget potSlides(BuildContext context, String image, String name) {
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
            cachedImage(
              image,
              width: size.width - 20,
              //fit: BoxFit.fitWidth,
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

Widget plantSlides(BuildContext context, String link, String name) {
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
          name,
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
