import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/buy_sell_detail.dart';

class BuyAndSell extends StatefulWidget {
  BuyAndSell({Key key}) : super(key: key);

  @override
  _BuyAndSellState createState() {
    return _BuyAndSellState();
  }
}

class _BuyAndSellState extends State<BuyAndSell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          CommonStrings.buyAndSell,
          style: TextStyle(
              fontFamily: AppConfig.roboto,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Image.asset(
              Assets.cart,
              color: Colors.green,
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  CommonStrings.topSeller,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: AppConfig.roboto,
                      color: Colors.green),
                ),
                Image.asset(Assets.filter)
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(parent: ScrollPhysics()),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, position) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuyAndSellDetail()));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                        child: Neumorphic(
                          style: AppConfig.neuStyle
                              .copyWith(boxShape: AppConfig.neuShape),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 152.0,
                                    width: 162.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Neumorphic(
                                          style: NeumorphicStyle(
                                              boxShape: AppConfig.neuShape),
                                          child: Image.asset(
                                            Assets.sample2,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 5.0),
                                  child: Text(
                                    CommonStrings.fertilizer,
                                    style: TextStyle(
                                        fontFamily: AppConfig.roboto,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 5.0),
                                  child: Text(
                                    "\$100",
                                    style: TextStyle(
                                        fontFamily: AppConfig.roboto,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
