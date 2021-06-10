import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/message.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:image_picker/image_picker.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key}) : super(key: key);

  @override
  _ChatBotState createState() {
    return _ChatBotState();
  }
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController textEditingController = TextEditingController();
  PickedFile imageFile;
  int length = 0;
  List<Messages> messageList = List<Messages>();
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
        resizeToAvoidBottomInset: true,
        appBar: AppConfig.appBar(CommonStrings.chatBot, context, true),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return chat(
                          messageList[index].msg, messageList[index].side);
                    },
                  ),
                ),
                AppConfig.divider(),
                Neumorphic(
                  style: NeumorphicStyle(color: Colors.transparent)
                      .copyWith(boxShape: AppConfig.neuShape),
                  child: ListTile(
                    trailing: GestureDetector(
                      onTap: () {
                        var msg = Messages(textEditingController.text, 1);
                        setState(() {
                          messageList.insert(0, msg);
                          textEditingController.clear();
                        });
                      },
                      child: Image.asset(
                        Assets.send,
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        // attachments();
                        var msg = Messages(textEditingController.text, 0);
                        setState(() {
                          messageList.insert(0, msg);
                          textEditingController.clear();
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 20.0,
                      ),
                    ),
                    title: TextField(
                      controller: textEditingController,
                      textAlign: TextAlign.start,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: CommonStrings.typeMessage,
                        hintStyle: TextStyle(
                          color: Colors.green,
                          fontFamily: AppConfig.roboto,
                        ),
                        border: InputBorder.none,
                      ),
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void attachments() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
                title: Center(
                    child: Text(CommonStrings.camera,
                        style: TextStyle(
                            fontFamily: AppConfig.roboto,
                            fontWeight: FontWeight.bold))),
              ),
              AppConfig.divider(),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
                title: Center(
                    child: Text(CommonStrings.gallery,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConfig.roboto,
                        ))),
              ),
            ],
          );
        });
  }

  openCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
    });
    Navigator.pop(context);
  }

  openGallery() async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Widget chat(String message, int data) {
    return Container(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(Assets.appLogo),
                  ),
                )
              : Container(),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Neumorphic(
                style: AppConfig.neuStyle.copyWith(
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                        topLeft: data == 0
                            ? Radius.circular(0.0)
                            : Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        topRight: data == 1
                            ? Radius.circular(0.0)
                            : Radius.circular(5.0)))),
                child: Container(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      message,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(Assets.appIcon),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
