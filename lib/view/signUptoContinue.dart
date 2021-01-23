import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/view/authentication.dart';

class SignContinue extends StatefulWidget {
  SignContinue({Key key}) : super(key: key);

  @override
  _SignContinueState createState() {
    return _SignContinueState();
  }
}

class _SignContinueState extends State<SignContinue> {
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "You need to Sign Up to view this page",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28),
                )),
            Padding(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthenticationScreen()));
                    },
                    child: Container(
                      width: SizeConfig.screenWidth - 60,
                      height: 75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 2),
                                color: Colors.grey[700],
                                blurRadius: 3,
                                spreadRadius: 1)
                          ]),
                      child: Text(
                        "Sign Up / Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green, fontSize: 22),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
