import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/view/buy_home.dart';
import 'package:json_to_form/json_schema.dart';
import 'package:json_to_form/json_to_form.dart';
import 'cart.dart';
import 'package:json_to_form/json_schema.dart';
import 'dart:convert';

class CustomOrder extends StatefulWidget {
  CustomOrder({Key key}) : super(key: key);

  @override
  _CustomOrderState createState() {
    return _CustomOrderState();
  }
}

class _CustomOrderState extends State<CustomOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String form = json.encode([
    {
      'type': 'Checkbox',
      'title': 'Sensors',
      'list': [
        {
          'title': "Water Level",
          'value': true,
        },
        {
          'title': "PH Sensor",
          'value': false,
        },
        {
          'title': "Light Sensor",
          'value': false,
        },
      ]
    },
    {
      'type': 'RadioButton',
      'title': 'Type',
      'value': 1,
      'list': [
        {
          'title': "Aeroponic",
          'value': 1,
        },
        {
          'title': "Hydroponic",
          'value': 2,
        },
      ]
    },
  ]);
  // String form = json.encode([
  //   {
  //     'type': 'Input',
  //     'title': 'Hi Group',
  //     'placeholder': "Hi Group flutter",
  //     'validator': 'digitsOnly'
  //   },
  //   {
  //     'type': 'Password',
  //     'title': 'Password',
  //   },
  //   {'type': 'Email', 'title': 'Email test', 'placeholder': "hola a todos"},
  //   {
  //     'type': 'TareaText',
  //     'title': 'TareaText test',
  //     'placeholder': "hola a todos"
  //   },
  //   {
  //     'type': 'RadioButton',
  //     'title': 'Radio Button tests',
  //     'value': 2,
  //     'list': [
  //       {
  //         'title': "product 1",
  //         'value': 1,
  //       },
  //       {
  //         'title': "product 2",
  //         'value': 2,
  //       },
  //       {
  //         'title': "product 3",
  //         'value': 3,
  //       }
  //     ]
  //   },
  //   {
  //     'type': 'Switch',
  //     'title': 'Switch test',
  //     'switchValue': false,
  //   },
  //   {
  //     'type': 'Checkbox',
  //     'title': 'Sensors',
  //     'list': [
  //       {
  //         'title': "Water Level",
  //         'value': true,
  //       },
  //       {
  //         'title': "PH Sensor",
  //         'value': false,
  //       },
  //       {
  //         'title': "Light Sensor",
  //         'value': false,
  //       }
  //     ]
  //   },
  //   {
  //     'type': 'Checkbox',
  //     'title': 'Checkbox test 2',
  //     'list': [
  //       {
  //         'title': "product 1",
  //         'value': true,
  //       },
  //       {
  //         'title': "product 2",
  //         'value': true,
  //       },
  //       {
  //         'title': "product 3",
  //         'value': false,
  //       }
  //     ]
  //   },
  // ]);
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
            "Custom Order",
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
                child: Text('Place a Request'),
                onPressed: () {
                  print(this.response);
                },
              )
            ],
          ),
        ));
  }
}
