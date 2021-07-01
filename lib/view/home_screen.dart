import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/app_drawer_list.dart';
import 'package:grow_lah/model/app_drawer_model.dart';
import 'package:grow_lah/model/options.dart';
import 'package:grow_lah/model/options_list.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/view/app_drawer.dart';
import 'package:grow_lah/view/ar_android_view.dart';
import 'package:grow_lah/view/authentication.dart';
import 'package:grow_lah/view/buy_sell.dart';
import 'package:grow_lah/view/chat_bot.dart';
import 'package:grow_lah/view/communication_section.dart';
import 'package:grow_lah/view/monitor_screen.dart';
import 'package:grow_lah/view/notification.dart';
import 'package:grow_lah/view/refer_earn.dart';
import 'package:grow_lah/view/take_picture.dart';
import 'package:grow_lah/view/video_screen.dart';
import 'package:grow_lah/view/buy_home.dart';
import 'commuication_detail.dart';
import 'package:grow_lah/view/my_garden.dart';
import 'my_orders.dart';
import 'ar_view.dart';
import 'ar_ios_view.dart';
import 'buttonexpand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grow_lah/utils/setUpContact.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

List<Options> optionsList = List<dynamic>();
List<AppDrawerModel> drawerList = List<AppDrawerModel>();

class _HomeScreenState extends State<HomeScreen> {
  var type = 0;
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  List<String> details = ["nothing"];
  @override
  void initState() {
    optionsList = OptionsList.optionList();
    drawerList = AppDrawerList.drawerList();

    print(optionsList);
    print(drawerList);
    getType();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getType() async {
    print("Running get");
    // print("getting type");
    // await FirebaseFirestore.instance
    //     .collection("Users")
    //     .doc(FirebaseAuth.instance.currentUser.uid)
    //     .get()
    //     .then((value) {
    //   print("type is");
    //   print(value['type']);
    //   setState(() {
    //     type = value['type'];
    //   });
    // });

    // FirebaseMessaging().requestNotificationPermissions(IosNotificationSettings(
    //   alert: true,
    //   badge: true,
    //   provisional: true,
    //   sound: true,
    // ));
    print(details);
    if (details.length != 3) {
      print("Running get details");
      FirebaseFirestore.instance
          .collection("Constants")
          .doc("contact details")
          .get()
          .then((value) {
        print("IS");
        print(value.data());
        var data = value.data();
        setState(() {
          details = [
            value["email"].toString(),
            value["phone"].toString(),
            value["sms"].toString()
          ];
        });
      }).onError((error, stackTrace) {
        print(error);
      });
    } else {
      print("Not running");
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.getToken().then((task) {
      // Get new FCM registration token
      print("CODE is: ");
      print(task);
    }).catchError((error) {
      print("messaging failed with");
      print(error);
    }).whenComplete(() => print("done messaging"));

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(FirebaseAuth.instance.currentUser);
    getType();
    return Stack(
      children: <Widget>[
        AppConfig.bgWave(context),
        Center(
            child: Container(
                height: 100.0,
                width: 100.0,
                child: Image.asset(
                  Assets.bigAppIcon,
                  fit: BoxFit.fill,
                ))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReferAndEarn()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.asset(
                    Assets.stock,
                    color: Colors.white,
                    height: 15.0,
                    width: 15.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Image.asset(
                    Assets.notification,
                    color: Colors.white,
                    height: 18.0,
                    width: 18.0,
                  ),
                ),
              )
            ],
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              AppConfig.growLah,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: AppConfig.roboto,
              ),
            ),
            elevation: 0.0,
          ),
          drawer: getDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            // physics: NeverScrollableScrollPhysics(),
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                  //   child: Text(
                  //     'Welcome !',
                  //     style: TextStyle(
                  //         fontSize: 20.0,
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily:AppConfig.roboto,
                  //         color: Colors.green),
                  //   ),
                  // ),
                  mainView(),
                  FirebaseAuth.instance.currentUser == null
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AuthenticationScreen()));
                          },
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              color: Colors.transparent,
                              boxShape: AppConfig.neuShape,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth - 40,
                              height: 110.0,
                              color: Colors.green,
                              child: Text(
                                  "Sign Up to Unlock full functionality",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppConfig.roboto,
                                      fontSize: 18)),
                            ),
                          ))
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 40),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  elevation: 16,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          child: GestureDetector(
                                              child: Neumorphic(
                                                style: AppConfig.neuStyle
                                                    .copyWith(
                                                        color: Colors.green),
                                                padding: EdgeInsets.all(30),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Text(
                                                        "Call ${details[1]}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              AppConfig.roboto,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () =>
                                                  _service.call(details[1])),
                                          padding: EdgeInsets.only(
                                              top: 30, left: 20, right: 20),
                                        ),
                                        Padding(
                                          child: GestureDetector(
                                              child: Neumorphic(
                                                style: AppConfig.neuStyle
                                                    .copyWith(
                                                        color: Colors.green),
                                                padding: EdgeInsets.all(30),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Text(
                                                        "Message ${details[2]}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              AppConfig.roboto,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () =>
                                                  _service.sendSms(details[2])),
                                          padding: EdgeInsets.only(
                                              top: 30, left: 20, right: 20),
                                        ),
                                        Padding(
                                          child: GestureDetector(
                                              child: Neumorphic(
                                                style: AppConfig.neuStyle
                                                    .copyWith(
                                                        color: Colors.green),
                                                padding: EdgeInsets.all(30),
                                                child: Text(
                                                  "Email ${details[0]}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontFamily:
                                                        AppConfig.roboto,
                                                  ),
                                                ),
                                              ),
                                              onTap: () => _service
                                                  .sendEmail(details[0])),
                                          padding: EdgeInsets.only(
                                              top: 30, left: 20, right: 20),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ARAndroid()));
                        },
                        child: Center(child: bottomIcon())),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  setHeightWidth(int index) {
    switch (index) {
      case 0:
        return 180.0;
        break;
      case 1:
        return 150.0;
        break;
      case 2:
        return 180.0;
        break;
      case 3:
        return 150.0;
        break;
      case 4:
        return 170.0;
        break;
      case 5:
        return 200.0;
        break;
      default:
        return 150.0;
    }
  }

  Widget mainView() {
    Size size = MediaQuery.of(context).size;
    SizeConfig.screenHeight = size.height;
    SizeConfig.screenWidth = size.width;
    User user = FirebaseAuth.instance.currentUser;
    List<Options> updatedList = (user != null)
        ? optionsList.sublist(0, 2) + optionsList.sublist(4)
        : [optionsList[0]] +
            optionsList.sublist(
                3); //((type != 2) ? optionsList : [optionsList[1]] + [optionsList[5]])
    return Container(
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: updatedList.length,
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("tapped");
                print(index);
                print(index + 2 * (index / 2).floor());
                user == null
                    ? itemSelected((index == 0) ? index : index + 2)
                    : itemSelected(index + 2 * (index / 2).floor());
                // : (type != 2)
                //     ? itemSelected(index)
                //     : itemSelected(index + 1 + 3 * (index));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Center(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shadowDarkColor: Colors.grey,
                      lightSource: LightSource.topLeft,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(25.0))),
                    ),
                    child: Container(
                      color: Colors.white,
                      height: getProportionateScreenHeight(150),
                      width: getProportionateScreenWidth(141),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            updatedList[index].image,
                            height: 44.0,
                            width: 60.0,
                          ),
                          Text(
                            updatedList[index].title,
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: AppConfig.roboto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  getDrawer() {
    return Drawer(child: AppDrawer());
  }

  Widget bottomIcon() {
    return Neumorphic(
      style: NeumorphicStyle(
        color: Colors.transparent,
        boxShape: AppConfig.neuShape,
      ),
      child: Container(
        width: 75.0,
        height: 55.0,
        color: Colors.green,
        child: Image.asset(Assets.chat),
      ),
    );
  }

  void itemSelected(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VideosScreen()));
        ;
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GardenScreen()));
        ;
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyOrders()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BuyHome()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailCommunication()));
        break;
      case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TakePicture()));
        break;
    }
  }
}

class CallsAndMessagesService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");
}
