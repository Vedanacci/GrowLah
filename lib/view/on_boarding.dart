import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/on_boarding_model.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() {
    return _OnBoardingScreenState();
  }
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoardingModel> onBoardsList = List<OnBoardingModel>();
  int selectedIndex = 0;
  bool isSelected = false;
  @override
  void initState() {
    onBoardsList = OnBoardingList.onBoardingList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        AppConfig.bgWave(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // AppConfig.clippedPath(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Text(
                      CommonStrings.selectCategory,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConfig.roboto,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, right: 50.0, left: 50.0),
                    child: Center(
                      child: Text(
                        'Select the category type which you would like to know'
                        ' about through this app !',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConfig.roboto,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: onBoardsList.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              selectedIndex = index;
                              isSelected = true;
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: index == 2 ? 20 : 0),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: 8,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.all(Radius.circular(10.0))),
                                ),
                                child: Container(
                                  color: isSelected
                                      ? getColor(index)
                                      : Colors.white,
                                  height: 50.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Center(
                                    child: Text(onBoardsList[index].content),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                  isSelected
                      ? GestureDetector(
                          onTap: () async {
                            String user = FirebaseAuth.instance.currentUser.uid;
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(user)
                                .update({'type': selectedIndex});
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 100.0, bottom: 20.0),
                            child: Center(
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      color: Colors.white,
                                      boxShape: NeumorphicBoxShape.circle()),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.green,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  getColor(int index) {
    return index == selectedIndex ? Colors.green : Colors.white;
  }
}
