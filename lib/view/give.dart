import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:json_to_form/json_to_form.dart';
import 'cart.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class Give extends StatefulWidget {
  Give({Key key}) : super(key: key);

  @override
  _GiveState createState() {
    return _GiveState();
  }
}

class _GiveState extends State<Give> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void donateFire() async {
    DateTime _now = DateTime.now();
    dynamic data = [
      {
        '${_now.day}, ${_now.month}, ${_now.year}, ${_now.hour}:${_now.minute}}':
            this.response
      }
    ];
    print("yes");
    print(data);
    User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .update({'Give': FieldValue.arrayUnion(data)}).then((value) {
      print("Success");
    }).catchError((error) => print("Failed to update user: $error"));
  }

  String form = json.encode([
    {
      'type': 'Checkbox',
      'title': 'Produce',
      'list': [
        {
          'title': "Lettuce",
          'value': false,
        },
        {
          'title': "Tomato",
          'value': false,
        },
        {
          'title': "Cabbage",
          'value': false,
        },
      ]
    },
    {
      'type': 'RadioButton',
      'title': 'Total Quantity (Approx.)',
      'value': 1,
      'list': [
        {
          'title': "200g",
          'value': 1,
        },
        {
          'title': "500g",
          'value': 2,
        },
        {
          'title': "1kg",
          'value': 3,
        },
        {
          'title': "2kg",
          'value': 4,
        },
        {
          'title': "5kg",
          'value': 5,
        },
        {
          'title': "10kg",
          'value': 6,
        },
      ]
    },
  ]);

  dynamic response;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig.screenHeight = size.height;
    SizeConfig.screenWidth = size.width;
    response = form;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.green,
              size: 24,
            ),
          ),
          title: Text(
            "Give",
            style: TextStyle(
                fontFamily: AppConfig.roboto,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Cart()));
                      },
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.green,
                        size: 30.0,
                      ))
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CoreForm(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(width: 2, color: Colors.green)),
                form: form,
                onChanged: (dynamic response) {
                  print(response);
                  this.response = response;
                },
              ),
              RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Give Produce'),
                onPressed: () {
                  print(this.response);
                  donateFire();
                },
              )
            ],
          ),
        ));
  }
}
