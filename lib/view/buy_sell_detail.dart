import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';

class BuyAndSellDetail extends StatefulWidget {
  BuyAndSellDetail({Key key}) : super(key: key);

  @override
  _BuyAndSellDetailState createState() {
    return _BuyAndSellDetailState();
  }
}

class _BuyAndSellDetailState extends State<BuyAndSellDetail> {
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
      appBar: AppConfig.appBar(CommonStrings.buyAndSell, context, true),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(parent: ScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Neumorphic(
                            style: AppConfig.neuStyle
                                .copyWith(boxShape: AppConfig.neuShape),
                            child: Container(
                                height: 272.0,
                                width: 374.0,
                                child: Image.asset(Assets.sample2,
                                    fit: BoxFit.cover))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Seeds',
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.green,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "\$200",
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.green,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          CommonStrings.productDetails,
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.green,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing'
                          'elit. Facilisis lectus at a vulputate pellentesque'
                          'aliquet velit odio nullam. Mattis ut est ut enim.'
                          'Nullam lobortis dolor quis non mauris, dui sed'
                          'nunc quam. Gravida commodo vel at dignissim'
                          'integer.',
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.green,
                              fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              buyButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buyButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
        child: Container(
          height: 55.0,
          width: 374.0,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                CommonStrings.buyNow,
                style: TextStyle(
                    fontFamily: AppConfig.roboto,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
