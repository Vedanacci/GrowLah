import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/view/notification.dart';
import 'package:grow_lah/view/refer_earn.dart';

class AppConfig {
  static String growLah = 'GrowLah';
  static String enterPh = 'Enter Phone Number';
  static String enterOtp = 'Enter OTP';
  static String getOtp = 'GET OTP';
  static String verification = 'Verification';
  static String otpMsg =
      'We will send you a One Time Password to your mobile number';
  static String otpSms = 'You will get a OTP via SMS';
  static String verify = 'VERIFY';
  static String pleaseEnterOtp = 'Please Enter OTP';
  static String pleaseEnterPh = 'Please Enter Phone Number';
  static String roboto = 'RobotoRegular';
  static showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey);
  }

  static divider() {
    return Divider(
      height: 2.0,
      color: Colors.grey,
    );
  }

  static NeumorphicStyle neuStyle = NeumorphicStyle(color: Colors.grey[100]);
  static NeumorphicBoxShape neuShape =
      NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(10.0)));
  static appBar(String title, BuildContext context, bool showNotification,
      {bool showRefer = false,
      Color color = Colors.green,
      double fontSize = 16}) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: (color == Colors.green) ? Colors.white : Colors.green,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: color,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: AppConfig.roboto,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color),
      ),
      actions: <Widget>[
        showRefer
            ? GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReferAndEarn()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.asset(
                    Assets.stock,
                    color: color,
                    height: 15.0,
                    width: 15.0,
                  ),
                ),
              )
            : Container(),
        showNotification
            ? InkWell(
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
                    color: color,
                    height: 18.0,
                    width: 18.0,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  static bgWave(BuildContext context) {
    return Image.asset(
      Assets.bg,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  static buildCounter() {
    return (BuildContext context,
            {int currentLength, int maxLength, bool isFocused}) =>
        null;
  }

  static void hideKeyBoard() =>
      //SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusManager.instance.primaryFocus.unfocus();
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
