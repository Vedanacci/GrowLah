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
import 'package:grow_lah/view/take_picture.dart';
import 'package:grow_lah/view/video_screen.dart';
import 'package:grow_lah/view/buy_home.dart';
import 'commuication_detail.dart';
import 'package:grow_lah/view/my_garden.dart';
import 'my_orders.dart';
import 'ar_view.dart';
import 'ar_ios_view.dart';
import 'buttonexpand.dart';

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
  @override
  void initState() {
    optionsList = OptionsList.optionList();
    drawerList = AppDrawerList.drawerList();

    print(optionsList);
    print(drawerList);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(FirebaseAuth.instance.currentUser);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ARAndroid()));
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
    List<Options> updatedList =
        user != null ? optionsList : [optionsList[0]] + optionsList.sublist(3);
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
                user == null
                    ? itemSelected((index == 0) ? index : index + 2)
                    : itemSelected(index);
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
