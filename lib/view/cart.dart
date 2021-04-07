import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/model/system_data.dart';
import 'buy_home.dart';
import 'product_card.dart';
import 'product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  List<ProductData> cartData = List<ProductData>.from(SystemData.defaultData);

  @override
  void initState() {
    cartData.addAll(NutrientData.defaultData);
    super.initState();
    reloadSystems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future reloadSystems() async {
    List<ProductData> data = await CartData.getSystems();
    setState(() {
      cartData = data;
      for (ProductData productData in data) {
        cost += productData.price;
      }
    });
  }

  double cost = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> products = [];
    for (ProductData data in cartData) {
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
          child: HorizontalProductCard(
            product: data,
            indexIn: cartData.indexOf(data),
            padding: EdgeInsets.all(10),
          ),
          key: Key(data.name),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            setState(() {
              cartData.remove(data);
            });
            User user = FirebaseAuth.instance.currentUser;
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .update({
              "Cart." + data.name: 0,
            });
            setState(() {
              cost -= data.price * data.quantity;
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

    var addGreen = 0.0;

    if (products.length < 4) {
      addGreen = (SizeConfig.screenHeight -
          getProportionateScreenWidth(425) -
          products.length * SizeConfig.screenWidth / 4);
    }

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
          "Cart",
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
                          MaterialPageRoute(builder: (context) => BuyHome()));
                    },
                    child: Icon(
                      Icons.home,
                      color: Colors.green,
                      size: 30.0,
                    ))
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      extendBody: true,
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Neumorphic(
              margin: EdgeInsets.only(top: 20),
              style: AppConfig.neuStyle.copyWith(
                  shadowLightColor: Colors.transparent,
                  // shadowDarkColor: Colors.transparent,
                  lightSource: LightSource.bottom,
                  color: Colors.green,
                  boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.all(Radius.circular(30)))),
              child: Container(
                  padding: EdgeInsets.only(top: 30),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.green),
                  child: Column(children: [
                    SizedBox(height: getProportionateScreenWidth(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Text("${cartData.length} items",
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      child: Wrap(
                        children: products,
                        spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.end,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(174) - 20),
                    SizedBox(
                      height: addGreen,
                    )
                  ]))),
          Center(
              child: Neumorphic(
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 35,
                      color: Colors.green,
                    ),
                    padding: EdgeInsets.all(5),
                  ),
                  style: AppConfig.neuStyle.copyWith(
                    boxShape: NeumorphicBoxShape.circle(),
                    border: NeumorphicBorder(color: Colors.green, width: 1),
                  )))
        ],
      )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30),
        ),
        // height: 174,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[600],
              spreadRadius: 0,
              blurRadius: 10,
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Neumorphic(
                      style: AppConfig.neuStyle.copyWith(borderRadius: 10),
                      child: Container(
                        padding: EdgeInsets.all(0),
                        height: getProportionateScreenWidth(40),
                        width: getProportionateScreenWidth(40),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(Icons.favorite_rounded, color: Colors.white),
                      )),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BuyHome()));
                      },
                      child: Text("Continue Shopping")),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.green,
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      children: [
                        TextSpan(
                          text: "\$" + "${(cost * 100).round() / 100}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(190),
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(18))),
                      child: SizedBox(
                        height: 50,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart()));
                          },
                          child: Text(
                            "Checkout".toUpperCase(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
