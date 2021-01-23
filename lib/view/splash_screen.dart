import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grow_lah/main.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/authentication.dart';
import 'package:grow_lah/view/on_boarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

import 'authentication.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print("Loaded");
    Future.delayed(const Duration(seconds: 1), () async {
      loginNeeded
          ? Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AuthenticationScreen()))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
            child: Center(child: Image.asset(Assets.appLogo)),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              CommonStrings.growLah,
              style: new TextStyle(
                  fontFamily: AppConfig.roboto,
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              CommonStrings.growLocalEatLocal,
              style: new TextStyle(
                  fontFamily: AppConfig.roboto,
                  fontSize: 12.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            CommonStrings.poweredBy,
            style: new TextStyle(
                fontFamily: AppConfig.roboto,
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Image.asset(Assets.bottomLogo),
        ],
      ),
    );
  }
}
