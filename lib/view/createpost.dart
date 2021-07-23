import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/feeds_model.dart';
import 'package:grow_lah/model/profile_model.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_lah/model/user_model.dart';
import 'package:grow_lah/model/extractImage.dart';

class CreatePost extends StatefulWidget {
  CreatePost();

  @override
  _CreatePostState createState() {
    return _CreatePostState();
  }
}

class _CreatePostState extends State<CreatePost> {
  var post = FeedsModel('', '', '', 0, false, [], '', '', '', '');
  @override
  void initState() {
    myList = ProfileModel.profileList();
    downloadUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void hideKeyBoard() {
    print('hiding');
    AppConfig.hideKeyBoard();
  }

  void loadImage() async {
    String urlImage = await FirebaseStorage.instance
        .ref()
        .child("Users")
        .child(user.id + ".jpg")
        .getDownloadURL();
    setState(() {
      imagePath = urlImage;
    });
    ;
  }

  void downloadUser() async {
    UserModel downloadedUser = await UserModel.getUser();
    setState(() {
      user = downloadedUser;
    });
    loadImage();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hasImage = false;
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath = '';
  PickedFile imageFile;
  List<dynamic> myList = List();
  UserModel user = UserModel("id", "name", "email", "phoneNumber");

  void uploadPost() async {
    print(post);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => hideKeyBoard(),
        child: Scaffold(
            appBar: AppConfig.appBar('Create a Post', context, true),
            // backgroundColor: Colors.green,
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: AppConfig.roboto,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          onSaved: (String value) {
                            post.title = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter your title',
                          ),
                          validator: (String value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Post Content',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: AppConfig.roboto,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          onSaved: (String value) {
                            post.content = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your post',
                          ),
                          validator: (String value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Choose a photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: AppConfig.roboto,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          changeImage();
                        },
                        child: Neumorphic(
                          style: AppConfig.neuStyle.copyWith(
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(10)))),
                          child: imagePath != null
                              ? cachedImage(imagePath)
                              : Image.asset(Assets.manIcon),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              print('Valid');
                              uploadPost();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Neumorphic(
                              style: AppConfig.neuStyle.copyWith(
                                  shadowLightColor: Colors.transparent,
                                  color: Colors.green),
                              child: Column(
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth - 20,
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ))));
  }

  void changeImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  seeImage();
                },
                title: Center(
                    child: Text(
                  CommonStrings.view,
                  style: TextStyle(
                      fontFamily: AppConfig.roboto,
                      fontWeight: FontWeight.bold),
                )),
              ),
              AppConfig.divider(),
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
                            fontFamily: AppConfig.roboto,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          );
        });
  }

  void updateImage(PickedFile image) {
    var image2 = File(image.path);
    var imageRef = FirebaseStorage.instance.ref().child("Users/${user.id}.jpg");
    imageRef.putFile(image2);
    print("Uploaded profile photo");
    loadImage();
  }

  openCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
    });
    updateImage(image);
    //Navigator.pop(context);
  }

  openGallery() async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    updateImage(picture);
    //Navigator.of(context).pop();
  }

  seeImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 300.0,
              width: 200.0,
              child: imagePath != null
                  ? cachedImage(imagePath)
                  : Image.asset(Assets.manIcon),
            ),
          );
        });
  }
}
