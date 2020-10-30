import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';

class CreateFeed extends StatefulWidget {
  CreateFeed({Key key}) : super(key: key);

  @override
  _CreateFeedState createState() {
    return _CreateFeedState();
  }
}

class _CreateFeedState extends State<CreateFeed> {
  TextEditingController textEditingController=TextEditingController();
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
      appBar: AppConfig.appBar("Create Feed", context,true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SingleChildScrollView(
              physics: ScrollPhysics(parent: ScrollPhysics()),
              scrollDirection:
              Axis.vertical,
              child: Column(
                children: <Widget>[
                  getTopView(),
                  AppConfig.divider(),
                  Container(
                    height: 100.0,
                    child: TextField(
                      autofocus: true,
                      controller: textEditingController,
                      maxLines: null,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          getBottomView()
          ],
        ),
      ),
    );
  }

  Widget getTopView() {
    return Container(
      height:50.0,
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: Container(
                  height: 35.0,
                  width: 35.0,
                  child: Image.asset(Assets.dot),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('Author Name',style: TextStyle(color: Colors.black,
                    fontFamily:AppConfig.roboto,
                    fontSize: 14.0),),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getBottomView() {
    return   Column(
      children: <Widget>[
        AppConfig.divider(),
        Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.attach_file,color: Colors.black,size: 20.0,),
              Icon(Icons.send,color: Colors.black,size: 20.0,)
            ],
          ),
        )
      ],
    );
  }
}