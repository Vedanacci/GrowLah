import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/common_strings.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      appBar: AppConfig.appBar(CommonStrings.notifications, context, false),
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
                    padding: const EdgeInsets.all(10.0),
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    CommonStrings.alert,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      fontFamily: AppConfig.roboto,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'x',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: AppConfig.roboto,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'There is a disturbing weather condition..Please '
                                ' ensure your Field is met with all precautional'
                                'requirements.',
                                overflow: TextOverflow.clip,
                                maxLines: null,
                                style: TextStyle(
                                    fontFamily: AppConfig.roboto,
                                    color: Colors.green,
                                    fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
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
