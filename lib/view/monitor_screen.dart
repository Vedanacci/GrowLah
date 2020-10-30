import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';

class MonitorScreen extends StatefulWidget {
  MonitorScreen({Key key}) : super(key: key);

  @override
  _MonitorScreenState createState() {
    return _MonitorScreenState();
  }
}

class _MonitorScreenState extends State<MonitorScreen> {
  bool isSelected = false;
  int selectedIndex = 0;
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
      appBar: AppConfig.appBar('Monitor', context, true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            alertView(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Smart Farming',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0),
              ),
            ),
            weatherCard(),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: getCards(),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              child: Text(
                'Hi.. you’re field is in very good condition. Soil moisture '
                'and field analysis is ensured.Water use efficiency level'
                'has been optimized.',
                style: TextStyle(color: Colors.green, fontSize: 14.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget alertView() {
    return Neumorphic(
      style: NeumorphicStyle(
          color: Colors.white12,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.all(Radius.circular(10.0)))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    CommonStrings.alert,
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: AppConfig.roboto,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'There is a disturbing weather condition.'
              '.Please ensure your Field is met with all precautional requirements.',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14.0,
                fontFamily: AppConfig.roboto,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherCard() {
    return Neumorphic(
      style: NeumorphicStyle(
        color: Colors.white,
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.all(Radius.circular(10.0))),
      ),
      child: Container(
        color: Colors.lightBlueAccent[100],
        height: 205.0,
        width: 374.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: 30.0,
                width: 330.0,
                child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: ScrollPhysics(parent: ScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          selectedIndex = index;
                          isSelected = true;
                          setState(() {});
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                getTitle(index),
                                style: TextStyle(color: getColor(index, true)),
                              ),
                              Container(
                                height: 4.0,
                                width: 20.0,
                                color: getColor(index, false),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Container(
              color: Colors.lightBlue[300],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  CommonStrings.partiallyCloudy,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: getCenterView(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: getBottomView(),
            )
          ],
        ),
      ),
    );
  }

  getColor(int index, bool forText) {
    return selectedIndex == index
        ? Colors.white
        : forText
            ? Colors.black54
            : Colors.lightBlueAccent[100];
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return CommonStrings.today;
        break;
      case 1:
        return CommonStrings.tomorrow;
        break;
      case 2:
        return CommonStrings.tenDays;
        break;
    }
  }

  Widget getCenterView() {
    return Container(
        height: 60.0,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(Assets.yellowCircle),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(Assets.cloud),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: Text(
                    '35°C',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
            Container(
              // color: Color.fromRGBO(1,108,132,1),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 65.0,
                      width: 23.0,
                      child: Image.asset(
                        Assets.halfCircle,
                        fit: BoxFit.fill,
                      )),
                  Center(
                      child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ))
                ],
              ),
            )
          ],
        ));
  }

  Widget getBottomView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.asset(Assets.nav),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Thu, 24 September 2020',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Yishun, Singapore',
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            )
          ],
        ),
      ),
    );
  }

  Widget getCards() {
    return Container(
      height: 88.0,
      child: Center(
        child: ListView.builder(
            itemCount: 3,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) {
              return Padding(
                padding: EdgeInsets.only(
                    left: position == 1 ? 50.0 : 0,
                    right: position == 1 ? 50.0 : 0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      color: Colors.white12,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(10.0)))),
                  child: Container(
                    height: 80.0,
                    width: 90.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          getList(position),
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getPercentage(position),
                          style: TextStyle(
                              color: Colors.lightBlue, fontSize: 24.0),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  String getList(int position) {
    switch (position) {
      case 0:
        return CommonStrings.light;
        break;
      case 1:
        return CommonStrings.humidity;
        break;
      case 2:
        return CommonStrings.fertilizer;
        break;
    }
  }

  String getPercentage(int position) {
    switch (position) {
      case 0:
        return '79 %';
        break;
      case 1:
        return '60%';
        break;
      case 2:
        return '87 %';
        break;
    }
  }
}
