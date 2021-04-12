import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_lah/view/introduction.dart';

import 'on_boarding.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';

class AskRefer extends StatefulWidget {
  AskRefer({Key key}) : super(key: key);

  @override
  _AskReferState createState() {
    return _AskReferState();
  }
}

class _AskReferState extends State<AskRefer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int valid = 0; //0 not started, 1 invalid, 2 valid
  static TextEditingController referController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Valid");
    print(valid);
    return Scaffold(
        appBar: AppConfig.appBar("Referal", context, false, showRefer: false),
        body: GestureDetector(
            onTap: () => AppConfig.hideKeyBoard(),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Neumorphic(
                      style: AppConfig.neuStyle
                          .copyWith(boxShape: AppConfig.neuShape),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.green,
                        child: Column(children: [
                          Text(
                            'Were you refered by someone else?',
                            style: TextStyle(
                                fontFamily: AppConfig.roboto,
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'If you were, type in their phone number to ensure they get points!',
                            style: TextStyle(
                                fontFamily: AppConfig.roboto,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w100),
                          )
                        ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Neumorphic(
                      style: AppConfig.neuStyle
                          .copyWith(boxShape: AppConfig.neuShape),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.green,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone number:',
                                style: TextStyle(
                                    fontFamily: AppConfig.roboto,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextField(
                                    controller: referController,
                                    textAlign: TextAlign.start,
                                    autofocus: false,
                                    maxLength: null,
                                    buildCounter: (BuildContext context,
                                            {int currentLength,
                                            int maxLength,
                                            bool isFocused}) =>
                                        null,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                        hintText: "Phone number (+65...)",
                                        hintStyle:
                                            TextStyle(color: Colors.green),
                                        border: InputBorder.none),
                                  ))
                            ]),
                      ),
                    ),
                  ),
                  valid == 0
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: double.infinity,
                            child: Neumorphic(
                              style: AppConfig.neuStyle
                                  .copyWith(boxShape: AppConfig.neuShape),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                color: valid == 1 ? Colors.red : Colors.green,
                                child: GestureDetector(
                                  child: Center(
                                      child: Text(
                                    valid == 1
                                        ? 'Invalid Phone number. Please make sure they used this phone number to sign up and you have written the number like so: +65...'
                                        : 'Phone Number Valid!',
                                    style: TextStyle(
                                        fontFamily: AppConfig.roboto,
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  )),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IntroductionScreen()));
                                  },
                                ),
                              ),
                            ),
                          )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Neumorphic(
                          style: AppConfig.neuStyle
                              .copyWith(boxShape: AppConfig.neuShape),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.green,
                            child: GestureDetector(
                              child: Center(
                                  child: Text(
                                valid == 0 ? 'Search' : 'Search Again',
                                style: TextStyle(
                                    fontFamily: AppConfig.roboto,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )),
                              onTap: () async {
                                print(referController.text);
                                await FirebaseFirestore.instance
                                    .collection("Users")
                                    .where("phoneNumber",
                                        isEqualTo: referController.text)
                                    .get()
                                    .then((value) {
                                  print(value.size);
                                  if (value.size != 0) {
                                    setState(() {
                                      valid = 2;
                                    });
                                  } else {
                                    setState(() {
                                      valid = 1;
                                    });
                                  }
                                }).catchError((error) {
                                  setState(() {
                                    valid = 1;
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Neumorphic(
                          style: AppConfig.neuStyle
                              .copyWith(boxShape: AppConfig.neuShape),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.green,
                            child: GestureDetector(
                              child: Center(
                                  child: Text(
                                valid == 2 ? "Use referal" : 'Skip',
                                style: TextStyle(
                                    fontFamily: AppConfig.roboto,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IntroductionScreen()));
                              },
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            )));
  }
}
