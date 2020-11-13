import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/model/system_data.dart';
import 'package:grow_lah/view/product_card.dart';
import 'cart.dart';
import 'buy_home.dart';

const kDefaultPaddin = 20.0;

class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.indexIn}) : super(key: key);
  final int indexIn;
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
  List<SystemData> systemData = SystemData.defaultData;

  int index = 0;
  SystemData product;
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    index = widget.indexIn;
    product = systemData[index];
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
      product = systemData[index];
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
                margin: EdgeInsets.only(top: size.height * 0.33),
                padding: EdgeInsets.only(
                  top: size.height * 0.1,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            style: AppConfig.neuStyle.copyWith(
                                              boxShape:
                                                  NeumorphicBoxShape.circle(),
                                              border: NeumorphicBorder(
                                                  color: Colors.green,
                                                  width: 1),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                        ),
                                        Neumorphic(
                                            child: Padding(
                                              child: Icon(
                                                Icons.lightbulb,
                                                color: Colors.green,
                                              ),
                                              padding: EdgeInsets.all(5),
                                            ),
                                            style: AppConfig.neuStyle.copyWith(
                                              boxShape:
                                                  NeumorphicBoxShape.circle(),
                                              border: NeumorphicBorder(
                                                  color: Colors.green,
                                                  width: 1),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                        ),
                                        Neumorphic(
                                            child: Padding(
                                              child: Icon(
                                                Icons.thermostat_outlined,
                                                color: Colors.green,
                                              ),
                                              padding: EdgeInsets.all(5),
                                            ),
                                            style: AppConfig.neuStyle.copyWith(
                                              boxShape:
                                                  NeumorphicBoxShape.circle(),
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
                                      padding:
                                          EdgeInsets.all(kDefaultPaddin / 2),
                                    ),
                                    Text(
                                      product.pots.toString(),
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
                          ),
                          SizedBox(height: kDefaultPaddin / 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPaddin),
                            child: Text(
                              product.description +
                                  "\n \nSize: " +
                                  product.size[0].toString() +
                                  " x " +
                                  product.size[1].toString() +
                                  " x " +
                                  product.size[2].toString() +
                                  "cm \nLight Required: " +
                                  product.light,
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
                                  margin:
                                      EdgeInsets.only(right: kDefaultPaddin),
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
                                    onPressed: () {},
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
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Cart()));
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
                    ProductSwipe(systemData: systemData)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.type + " System",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: kDefaultPaddin),
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
                          child: Hero(
                            tag: "$index",
                            child: Image.asset(
                              "images/onboarding1.png",
                              height: size.height * 0.25,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )));
  }
}

// SingleChildScrollView(
//     child: Neumorphic(
//   style: AppConfig.neuStyle
//       .copyWith(color: index % 2 == 0 ? Colors.green : Colors.white),
//   margin: EdgeInsets.zero,
//   child: GestureDetector(
//     child: Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   "images/onboarding1.png", //+ (index + 1).toString() +
//                   height: MediaQuery.of(context).size.height * 0.19,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 20, bottom: 20),
//                   child: Text(
//                     systemData[index].name,
//                     style: TextStyle(
//                         fontSize:
//                             MediaQuery.of(context).size.height * 0.04,
//                         fontFamily: AppConfig.roboto,
//                         fontWeight: FontWeight.bold,
//                         color: index % 2 != 0
//                             ? Colors.green
//                             : Colors.white),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: 0, right: 0, bottom: 10),
//                   child: Text(
//                       "Size: " +
//                           systemData[index].size[0].toString() +
//                           " x " +
//                           systemData[index].size[1].toString() +
//                           " x " +
//                           systemData[index].size[2].toString() +
//                           "cm \n \nPlant Pots: " +
//                           systemData[index].pots.toString() +
//                           " \n \nType: " +
//                           systemData[index].type +
//                           " \n \nPrice: \$" +
//                           systemData[index].price.toString(),
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height *
//                               0.025,
//                           fontFamily: AppConfig.roboto,
//                           color: index % 2 != 0
//                               ? Colors.green
//                               : Colors.white)),
//                 ),
//                 Padding(
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                             width: 150,
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.circular(10.0),
//                                 color: Colors.white),
//                             child: TextField(
//                               controller: quantityController,
//                               keyboardType: TextInputType.number,
//                               textAlign: TextAlign.start,
//                               autofocus: false,
//                               maxLength: 2,
//                               buildCounter: (BuildContext context,
//                                       {int currentLength,
//                                       int maxLength,
//                                       bool isFocused}) =>
//                                   null,
//                               decoration: InputDecoration(
//                                   contentPadding:
//                                       const EdgeInsets.all(10.0),
//                                   hintText: "Quantity",
//                                   hintStyle: TextStyle(
//                                       color: Colors.green,
//                                       fontSize: MediaQuery.of(context)
//                                               .size
//                                               .height *
//                                           0.025),
//                                   border: InputBorder.none),
//                             )),
//                         Padding(padding: EdgeInsets.only(left: 20)),
//                         NeumorphicButton(
//                           padding: EdgeInsets.all(10),
//                           child: Text(
//                             "Add to Cart",
//                             style: TextStyle(
//                                 fontSize:
//                                     MediaQuery.of(context).size.height *
//                                         0.025,
//                                 fontFamily: AppConfig.roboto,
//                                 color: index % 2 != 0
//                                     ? Colors.white
//                                     : Colors.green),
//                           ),
//                           style: AppConfig.neuStyle.copyWith(
//                               color: index % 2 != 0
//                                   ? Colors.green
//                                   : Colors.white,
//                               shadowLightColor: Colors.transparent),
//                           onPressed: () {},
//                         ),
//                       ]),
//                   padding: EdgeInsets.only(top: 20),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//     onTap: () {},
//   ),
// ))
