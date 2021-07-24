import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/garden_monitor.dart' as not;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<not.Notification> notifications = [];
  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future getNotifications() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      print('value is');
      print(value);
      print(value['notifs']);
      List<not.Notification> data = [];
      for (var notif in value['notifs']) {
        data.add(not.Notification(
            notif['title'], notif['description'], notif['system']));
      }
      print(data);
      setState(() {
        notifications = data;
      });
    });
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
            physics: ScrollPhysics(parent: ScrollPhysics()),
            scrollDirection: Axis.vertical,
            itemCount: notifications.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return not.activityCard(
                  notifications[index].title, notifications[index].description,
                  color1: Colors.green, color2: Colors.white);
            }));
  }
}
