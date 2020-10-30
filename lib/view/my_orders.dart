import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() {
    return _MyOrdersState();
  }
}

class _MyOrdersState extends State<MyOrders> {
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
    return Scaffold(
        appBar: AppConfig.appBar(CommonStrings.myOrders, context, true),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Neumorphic(
            style: NeumorphicStyle(
                color: Colors.white,
                shadowDarkColor: Colors.black54,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)))),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'Last Six Months',
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: AppConfig.roboto,
                              fontSize: 16.0),
                        ),
                      ),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(parent: ScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 100.0,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            height: 86.0,
                                            width: 86.0,
                                            child: Image.asset(
                                              Assets.sample6,
                                              fit: BoxFit.fill,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Insecticide',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                        AppConfig.roboto,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
                                              Text(
                                                'Delivered on 12 Sep-2020',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        AppConfig.roboto,
                                                    color: Colors.green,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  AppConfig.divider()
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
