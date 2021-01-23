import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/model/system_data.dart';
import 'package:grow_lah/view/product_card.dart';
import 'buy_home.dart';
import 'product_page.dart';

class ProductList extends StatefulWidget {
  ProductList({Key key, this.filter = 0}) : super(key: key);

  final int filter;

  @override
  _ProductListState createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductList> {
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
    List<ProductData> data = [];
    if (widget.filter == 1) {
      data = List<ProductData>.from(await SystemData.getSystems());
    } else if (widget.filter == 2) {
      data = List<ProductData>.from(await NutrientData.getNutrients());
    } else if (widget.filter == 3) {
      data = List<ProductData>.from(await SeedData.getSeeds());
    } else {
      data = List<ProductData>.from(await SystemData.getSystems());
      data.addAll(await NutrientData.getNutrients());
      data.addAll(await SeedData.getSeeds());
    }
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
        child: ProductGrid(productData: productData),
      ),
    );
  }
}
