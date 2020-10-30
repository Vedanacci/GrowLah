import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';

class MySubscriptions extends StatefulWidget {
  MySubscriptions({Key key}) : super(key: key);

  @override
  _MySubscriptionsState createState() {
    return _MySubscriptionsState();
  }
}

class _MySubscriptionsState extends State<MySubscriptions> {
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
      appBar: AppConfig.appBar(CommonStrings.mySubs, context, true),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          physics: ScrollPhysics(parent: ScrollPhysics()),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Neumorphic(
                style:
                    AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
                child: Container(
                  height: 121.0,
                  width: 374.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                            child: Container(
                                child: Image.asset(
                          Assets.sample6,
                          fit: BoxFit.cover,
                          width: 90.0,
                          height: 90.0,
                        ))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'CULTIVATION',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: AppConfig.roboto,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
