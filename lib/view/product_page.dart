import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/extractImage.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/model/system_data.dart';
import 'package:grow_lah/view/product_card.dart';
import 'package:grow_lah/view/signUptoContinue.dart';
import 'cart.dart';
import 'buy_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

const kDefaultPaddin = 20.0;

class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.data}) : super(key: key);
  final ProductData data;
  @override
  _ProductPageState createState() {
    return _ProductPageState();
  }
}

class CartCounter extends StatefulWidget {
  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int numOfItems = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                numOfItems--;
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                numOfItems++;
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}

class _ProductPageState extends State<ProductPage> {
  List<ProductData> productData =
      List<ProductData>.from(SystemData.defaultData);

  int index = 0;
  ProductData product;
  SystemData systemProduct;
  NutrientData nutrientProduct;
  SeedData seedProduct;
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    product = widget.data;
    productData.addAll(NutrientData.defaultData);
    productData.addAll(SeedData.defaultData);
    reloadSystems();
    if (product.productType == 1) {
      systemProduct = product;
    } else if (product.productType == 2) {
      nutrientProduct = product;
    } else if (product.productType == 3) {
      seedProduct = product;
    }
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
    Size size = MediaQuery.of(context).size;
    SizeConfig.screenHeight = size.height;
    SizeConfig.screenWidth = size.width;

    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.green,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            "Shop Systems",
            style: TextStyle(
                fontFamily: AppConfig.roboto,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BuyHome()));
                      },
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30.0,
                      ))
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: SizedBox(
                //height: size.height,
                child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: size.height * 0.275),
              padding: EdgeInsets.only(
                top: kDefaultPaddin * 2,
                left: 0,
                right: 0,
              ),
              // height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: kDefaultPaddin, right: kDefaultPaddin),
                      child: Column(children: [
                        (systemProduct != null)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Sensors"),
                                        SizedBox(height: kDefaultPaddin / 2),
                                        Row(
                                          children: <Widget>[
                                            Neumorphic(
                                                child: Padding(
                                                  child: Icon(
                                                    Icons.water_damage_outlined,
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                ),
                                                style:
                                                    AppConfig.neuStyle.copyWith(
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  border: NeumorphicBorder(
                                                      color: Colors.green,
                                                      width: 1),
                                                )),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Neumorphic(
                                                child: Padding(
                                                  child: Icon(
                                                    Icons.lightbulb,
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                ),
                                                style:
                                                    AppConfig.neuStyle.copyWith(
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  border: NeumorphicBorder(
                                                      color: Colors.green,
                                                      width: 1),
                                                )),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Neumorphic(
                                                child: Padding(
                                                  child: Icon(
                                                    Icons.thermostat_outlined,
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                ),
                                                style:
                                                    AppConfig.neuStyle.copyWith(
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  border: NeumorphicBorder(
                                                      color: Colors.green,
                                                      width: 1),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      //style: TextStyle(color: Colors.black),
                                      children: [
                                        Text("Pots Size\n"),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              kDefaultPaddin / 2),
                                        ),
                                        Text(
                                          systemProduct.pots.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1 / 20),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: kDefaultPaddin / 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddin),
                          child: Text(
                            (systemProduct != null)
                                ? product.description +
                                    "\n \nSize: " +
                                    product.size[0].toString() +
                                    " x " +
                                    product.size[1].toString() +
                                    " x " +
                                    product.size[2].toString() +
                                    "cm \nLight Required: " +
                                    systemProduct.light
                                : (nutrientProduct != null)
                                    ? product.description +
                                        "\n \nSize: " +
                                        product.size[0].toString() +
                                        " ml"
                                    : product.description +
                                        "\n \nSize: " +
                                        product.size[0].toString() +
                                        " Seeds",
                            style: TextStyle(height: 1.5),
                          ),
                        ),
                        SizedBox(height: kDefaultPaddin / 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CartCounter(),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(0),
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: kDefaultPaddin / 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddin),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: kDefaultPaddin),
                                height: 50,
                                width: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Cart()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignContinue()));
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    color: Colors.green,
                                    onPressed: () async {
                                      if (FirebaseAuth.instance.currentUser !=
                                          null) {
                                        print("Editing Cart");
                                        print(product.name);
                                        User user =
                                            FirebaseAuth.instance.currentUser;
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(user.uid)
                                            .update({
                                          "Cart." + product.name:
                                              FieldValue.increment(1),
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Cart()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignContinue()));
                                      }
                                    },
                                    child: Text(
                                      "Buy  Now".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: kDefaultPaddin / 2,
                        ),
                      ])),
                  ProductSwipe(productData: productData)
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (systemProduct != null)
                          ? systemProduct.type + " System"
                          : (nutrientProduct != null)
                              ? "Nutrient"
                              : "Seed",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    //SizedBox(height: kDefaultPaddin),
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Price\n"),
                              TextSpan(
                                text: "\$${product.price}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: kDefaultPaddin),
                        Expanded(
                            child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Hero(
                              tag: "$index",
                              child: cachedImage(
                                product.image,
                                height: size.height * 0.25,
                                //width: size.height * 0.25,
                              ),
                            ),
                            (seedProduct != null)
                                ? Positioned(
                                    right: -3,
                                    bottom: -3,
                                    child: Neumorphic(
                                      margin: EdgeInsets.all(5),
                                      style: AppConfig.neuStyle.copyWith(
                                          boxShape: NeumorphicBoxShape.circle(),
                                          border: NeumorphicBorder(
                                              color: Colors.green, width: 1)),
                                      child: cachedImage(
                                        seedProduct.plantImage,
                                        height: size.height * 0.07,
                                        width: size.height * 0.07,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ))
                      ],
                    )
                  ],
                )),
          ],
        ))));
  }
}
