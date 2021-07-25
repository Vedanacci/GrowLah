import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_lah/model/extractImage.dart';
import 'package:grow_lah/model/feeds_model.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/utils/feeds_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Article extends StatefulWidget {
  FeedsModel feedsModel;
  Article({Key key, this.feedsModel}) : super(key: key);

  @override
  _ArticleState createState() {
    return _ArticleState();
  }
}

class _ArticleState extends State<Article> {
  var users = [];
  var comment = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget loadImage(String image) {
    return (image != null) ? cachedImage(image) : Icons.error_sharp;
  }

  Future getUser() async {
    print('in');
    var u = [];
    for (var i in widget.feedsModel.comments) {
      print(i['user']);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(i['user'])
          .get()
          .then((userIn) async {
        var doc = i["user"].toString() + '.jpg';
        print(doc);
        Reference ref =
            FirebaseStorage.instance.ref().child("Users").child(doc);
        String link = await ref.getDownloadURL();
        u.add({'name': userIn['name'], 'photo': link});
      });
    }
    setState(() {
      users = u;
    });
  }

  void hideKeyBoard() {
    print('hiding');
    AppConfig.hideKeyBoard();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.feedsModel.likes.toString());
    return GestureDetector(
        onTap: () => hideKeyBoard(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
            actions: [
              // GestureDetector(
              //   onTap: () {},
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              //     child: Icon(
              //       Icons.share,
              //       color: Colors.white,
              //     ),
              //   ),
              // )
            ],
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Neumorphic(
                  style: NeumorphicStyle(
                      shadowDarkColor: Colors.black,
                      depth: 10,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)))),
                  child: Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight * 0.5,
                        width: SizeConfig.screenWidth,
                        child: loadImage(widget.feedsModel.image),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          height: SizeConfig.screenHeight * 0.5,
                          width: SizeConfig.screenWidth,
                          color: Colors.green.withOpacity(0.2),
                        ),
                      ),
                      Container(
                          // left: 30,
                          // top: SizeConfig.screenHeight * 0.5 - 140,
                          height: SizeConfig.screenHeight * 0.5,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.green,
                                  child: CircleAvatar(
                                    backgroundImage: Image.network(
                                            widget.feedsModel.profileImage)
                                        .image,
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text("DEC 23 \n 2020",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                //width: SizeConfig.screenWidth,
                                child: Text(widget.feedsModel.title,
                                    maxLines: 4,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                    )),
                              ),
                              Container(
                                  //width: SizeConfig.screenWidth,
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "By " + widget.feedsModel.authorName,
                                    style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ))
                    ],
                  )),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(widget.feedsModel.content,
                    style: GoogleFonts.mavenPro(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ),
              getBottomView(widget.feedsModel),
              comments(),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10, top: 10),
                        child: TextFormField(
                            onSaved: (String value) {
                              comment = value;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your Comment',
                            ),
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            })),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          print('Valid');
                          _formKey.currentState.save();
                          uploadComment();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 30, top: 10),
                        child: Neumorphic(
                          style: AppConfig.neuStyle.copyWith(
                              shadowLightColor: Colors.transparent,
                              color: Colors.green),
                          child: Container(
                            width: SizeConfig.screenWidth - 20,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Comment!',
                              style: TextStyle(
                                  // fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]))
            ],
          )),
        ));
  }

  Widget getBottomView(FeedsModel feedsList) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    feedsList.isLiked
                        ? feedsList.isLiked = false
                        : feedsList.isLiked = true;
                    feedsList.isLiked
                        ? feedsList.likes += 1
                        : feedsList.likes -= 1;
                  });
                },
                child: getLikeIcon(feedsList.isLiked ?? false)),
            Text(
              feedsList.likes.toString() + " " + CommonStrings.likes,
              style: TextStyle(
                fontFamily: AppConfig.roboto,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                Assets.comment,
                height: 20.0,
                width: 20.0,
              ),
            ),
            Text(
              feedsList.comments.length.toString() +
                  " " +
                  CommonStrings.comments,
              style: TextStyle(
                fontFamily: AppConfig.roboto,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left:8.0),
            //   child: Image.asset(Assets.favBlack,height: 20.0,width: 20.0,),
            // ),
          ],
        ),
      ),
    );
  }

  Widget comments() {
    print(widget.feedsModel.comments.length);
    return ListView.builder(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(parent: ScrollPhysics()),
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Neumorphic(
              style: AppConfig.neuStyle.copyWith(
                  shadowLightColor: Colors.transparent, color: Colors.green),
              child: Column(children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          backgroundImage:
                              Image.network(users[index]['photo']).image,
                          backgroundColor: Colors.white,
                          radius: 15,
                        )),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        users[index]['name'],
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: SizeConfig.screenWidth - 20,
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    widget.feedsModel.comments[index]['comment'],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              ])),
        );
      },
    );
  }

  void uploadComment() async {
    var updatedComments = widget.feedsModel.comments;
    updatedComments.add(
        {'comment': comment, 'user': FirebaseAuth.instance.currentUser.uid});
    _formKey.currentState.reset();
    print(updatedComments);
    setState(() {
      widget.feedsModel.comments = updatedComments;
      getUser();
    });
    await FirebaseFirestore.instance
        .collection("NewsFeed")
        .doc(widget.feedsModel.id)
        .update({'Comments': updatedComments});
  }

  Widget getLikeIcon(bool isLiked) {
    return isLiked
        ? Image.asset(
            Assets.favRed,
            height: 20.0,
            width: 20.0,
          )
        : Image.asset(Assets.favBlack, height: 20.0, width: 20.0);
  }
}
