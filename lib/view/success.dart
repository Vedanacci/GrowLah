import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/view/home_screen.dart';

class Success extends StatefulWidget {
  Success({Key key}) : super(key: key);

  @override
  _SuccessState createState() {
    return _SuccessState();
  }
}

class _SuccessState extends State<Success> {
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
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1, bottom: 50),
            child: Center(child: Image.asset(Assets.appLogo)),
          ),
          Text(
            "SUCCESS",
            style: new TextStyle(
                fontFamily: AppConfig.roboto,
                fontSize: 45.0,
                color: Colors.white,
                fontWeight: FontWeight.w100),
          ),
          SizedBox(
            height: 50,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text(
                "Continue".toUpperCase(),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    );
  }
}
