import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/ask_Refer.dart';

class ReferAndEarn extends StatefulWidget {
  ReferAndEarn({Key key}) : super(key: key);

  @override
  _ReferAndEarnState createState() {
    return _ReferAndEarnState();
  }
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  int isSelected = 0;
  String phone;

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
    User user = FirebaseAuth.instance.currentUser;
    phone = user.phoneNumber;
    return Scaffold(
      appBar: AppConfig.appBar('Points', context, true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(child: mainView()),
                    Container(
                      height: 20.0,
                    )
                  ],
                ),
                Positioned(bottom: 4.0, right: 180.0, child: shareIcon())
              ],
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Neumorphic(
                  style:
                      AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Redeem',
                        style: TextStyle(
                            fontFamily: AppConfig.roboto,
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AskRefer()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget mainView() {
    return Neumorphic(
      style: AppConfig.neuStyle.copyWith(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)))),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Neumorphic(
              style: AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
              child: Container(
                height: 119.0,
                width: 127.0,
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '40',
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                        ),
                        Text(
                          CommonStrings.coins,
                          style: TextStyle(
                              fontFamily: AppConfig.roboto,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Image.asset(Assets.coin)
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Image.asset(Assets.giftBox),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Image.asset(Assets.coinGreen),
            //     ),
            //   ],
            // ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 47.0, right: 47.0, top: 20.0),
              child: Center(
                child: Text(
                  'Get 20 coins on sharing Growlah'
                  'with your friends!',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                    fontFamily: AppConfig.roboto,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Neumorphic(
                style:
                    AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
                child: Container(
                  color: Colors.white,
                  width: 237.0,
                  height: 62.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, top: 5.0, right: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              CommonStrings.referCode,
                              style: TextStyle(
                                  fontFamily: AppConfig.roboto,
                                  color: Colors.green,
                                  fontSize: 12.0),
                            ),
                            Text(
                              phone,
                              style: TextStyle(
                                  fontFamily: AppConfig.roboto,
                                  color: Colors.green,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 25.0,
                        width: 2.0,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              CommonStrings.copy,
                              style: TextStyle(
                                  fontFamily: AppConfig.roboto,
                                  color: Colors.green,
                                  fontSize: 12.0),
                            ),
                            Text(
                              CommonStrings.code,
                              style: TextStyle(
                                fontFamily: AppConfig.roboto,
                                color: Colors.green,
                                fontSize: 12.0,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget shareIcon() {
    return Neumorphic(
      style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
      child: Container(
          color: Colors.white,
          height: 50.0,
          width: 50.0,
          child: Image.asset(Assets.shareIcon)),
    );
  }
}
