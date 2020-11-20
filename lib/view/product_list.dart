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
  ProductList({Key key}) : super(key: key);
  @override
  _ProductListState createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductList> {
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
        child: ProductGrid(systemData: systemData),
      ),
    );
  }
}
