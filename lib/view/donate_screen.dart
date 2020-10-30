import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';

class DonateScreen extends StatefulWidget {
  DonateScreen({Key key}) : super(key: key);

  @override
  _DonateScreenState createState() {
    return _DonateScreenState();
  }
}

class _DonateScreenState extends State<DonateScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController cardHolder = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController ccv = TextEditingController();
  bool upiPayment = false;
  bool creditCard = false;
  bool gPay = false;
  bool upiId = false;
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
      backgroundColor: Colors.white,
      appBar: AppConfig.appBar(CommonStrings.donate, context, true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: ScrollPhysics()),
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  CommonStrings.makeDonation,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConfig.roboto),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Neumorphic(
                    style: AppConfig.neuStyle
                        .copyWith(boxShape: AppConfig.neuShape),
                    child: Container(
                      height: 158.0,
                      color: Colors.white,
                      width: 365.0,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                CommonStrings.enterAmnt,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontFamily: AppConfig.roboto,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 70.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                          depth: -2,
                                          intensity: 0.86,
                                          surfaceIntensity: 0.3,
                                          color: Colors.white12,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.all(
                                                      Radius.circular(10.0)))),
                                      child: Container(
                                        height: 50.0,
                                        width: 150.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: TextField(
                                          controller: textEditingController,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontFamily: AppConfig.roboto,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          maxLength: 10,
                                          buildCounter: (BuildContext context,
                                                  {int currentLength,
                                                  int maxLength,
                                                  bool isFocused}) =>
                                              null,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                  child: Text(
                    CommonStrings.payMethod,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: AppConfig.roboto,
                      color: Colors.green,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      upiPayment = !upiPayment;
                      creditCard = false;
                    });
                  },
                  child: Container(
                    height: 50.0,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          !upiPayment
                              ? Icons.radio_button_unchecked
                              : Icons.radio_button_checked,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            CommonStrings.upiPayment,
                            style: TextStyle(
                                color: Colors.green,
                                fontFamily: AppConfig.roboto,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      creditCard = !creditCard;
                      upiPayment = false;
                    });
                  },
                  child: Container(
                    height: 50.0,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          creditCard
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            CommonStrings.cards,
                            style: TextStyle(
                                color: Colors.green,
                                fontFamily: AppConfig.roboto,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Neumorphic(
                  child: AppConfig.divider(),
                ),
                Expanded(
                  child: upiPayment
                      ? loadUpiWidget()
                      : creditCard
                          ? loadCardWidget()
                          : Container(),
                ),
                // Expanded(child: Container()),
                donateBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget donateBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
        child: Container(
          height: 55.0,
          width: 374.0,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                CommonStrings.donate,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppConfig.roboto,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadUpiWidget() {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              gPay = !gPay;
              upiId = false;
            });
          },
          child: Container(
            height: 50.0,
            child: Row(
              children: <Widget>[
                Icon(
                  !gPay
                      ? Icons.radio_button_unchecked
                      : Icons.radio_button_checked,
                  color: Colors.green,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      CommonStrings.gPay,
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: AppConfig.roboto,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Image.asset(Assets.gPayIcon)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              upiId = !upiId;
              gPay = false;
            });
          },
          child: Container(
            height: 50.0,
            child: Row(
              children: <Widget>[
                Icon(
                  upiId
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.green,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    CommonStrings.upiId,
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: AppConfig.roboto,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  loadCardWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                color: Colors.green,
                fontFamily: AppConfig.roboto),
            controller: cardHolder,
            maxLines: 1,
            maxLength: 16,
            buildCounter: AppConfig.buildCounter(),
            decoration: InputDecoration.collapsed(
                hintText: CommonStrings.cardHolderName,
                hintStyle: TextStyle(
                    color: Colors.green, fontFamily: AppConfig.roboto),
                border: InputBorder.none),
          ),
          AppConfig.divider(),
          TextField(
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                color: Colors.green,
                fontFamily: AppConfig.roboto),
            controller: cardNumber,
            maxLines: 1,
            maxLength: 16,
            keyboardType: TextInputType.numberWithOptions(),
            buildCounter: AppConfig.buildCounter(),
            decoration: InputDecoration.collapsed(
                hintText: CommonStrings.cardNumber,
                hintStyle: TextStyle(
                    color: Colors.green, fontFamily: AppConfig.roboto),
                border: InputBorder.none),
          ),
          AppConfig.divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 150.0,
                child: Column(
                  children: <Widget>[
                    TextField(
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.green,
                          fontFamily: AppConfig.roboto),
                      controller: date,
                      maxLines: 1,
                      maxLength: 16,
                      buildCounter: AppConfig.buildCounter(),
                      decoration: InputDecoration.collapsed(
                          hintText: CommonStrings.date,
                          hintStyle: TextStyle(
                              color: Colors.green,
                              fontFamily: AppConfig.roboto),
                          border: InputBorder.none),
                    ),
                    AppConfig.divider(),
                  ],
                ),
              ),
              Container(
                width: 150.0,
                child: Column(
                  children: <Widget>[
                    TextField(
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.green,
                          fontFamily: AppConfig.roboto),
                      controller: ccv,
                      maxLines: 1,
                      maxLength: 3,
                      keyboardType: TextInputType.numberWithOptions(),
                      buildCounter: AppConfig.buildCounter(),
                      decoration: InputDecoration.collapsed(
                          hintText: CommonStrings.ccv,
                          hintStyle: TextStyle(
                              color: Colors.green,
                              fontFamily: AppConfig.roboto),
                          border: InputBorder.none),
                    ),
                    AppConfig.divider(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
