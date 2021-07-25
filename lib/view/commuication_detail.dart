import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/feeds_model.dart';
import 'package:grow_lah/model/sample_feeds.dart';
import 'package:grow_lah/model/user_model.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/article.dart';
import 'package:grow_lah/view/createpost.dart';
import 'package:grow_lah/view/feeds_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailCommunication extends StatefulWidget {
  DetailCommunication({Key key}) : super(key: key);

  @override
  _DetailCommunicationState createState() {
    return _DetailCommunicationState();
  }
}

class _DetailCommunicationState extends State<DetailCommunication> {
  List<FeedsModel> feedsList = List<FeedsModel>();
  List images = [];
  bool type = false;
  UserModel user;
  var anyposts = false;

  @override
  void initState() {
    feedsList = [];
    for (var feedModel in feedsList) {
      images.add(feedModel.image);
    }
    downloadUser();
    downloadFeed();
    super.initState();
  }

  void downloadUser() async {
    UserModel downloadedUser = await UserModel.getUser();
    setState(() {
      user = downloadedUser;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool check() {
    print('testing');
    print(user);
    print(new List<int>.generate(feedsList.length, (i) => i + 1));
    if (!type) {
      return true;
    }
    if (((feedsList.length == 0)) || user == null) {
      return false;
    }
    if (type) {
      for (var index
          in new List<int>.generate(feedsList.length, (i) => i + 1)) {
        print(index);
        if (feedsList[index - 1].profileImage.contains("${user.id}.jpg")) {
          print('true1');
          return true;
        }
      }
      print('false');
      return false;
    }
    print('true2');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    anyposts = check();
    return Scaffold(
        appBar: AppConfig.appBar(CommonStrings.newsFeed1, context, true),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(children: [
            Row(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      type = false;
                      print(type);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(
                          shadowLightColor: Colors.transparent,
                          color: type ? Colors.white : Colors.green),
                      child: Column(
                        children: [
                          Container(
                            // width: SizeConfig.screenWidth - 20,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Your Feed',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: type ? Colors.green : Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      type = true;
                      print(type);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(
                          shadowLightColor: Colors.transparent,
                          color: type ? Colors.green : Colors.white),
                      child: Column(
                        children: [
                          Container(
                            // width: SizeConfig.screenWidth - 20,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Your Posts',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: type ? Colors.white : Colors.green,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ]),
            anyposts
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(parent: ScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: feedsList.length,
                    itemBuilder: (context, index) {
                      if ((index == 0) && (feedsList.length < 5)) {
                        return Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/News%2FloadingGif.gif?alt=media&token=eb1cea40-8a88-4d4d-892f-a010e7554417",
                          height: 100,
                          color: Colors.green,
                        );
                      }
                      if (type) {
                        print("${user.id}.jpg");
                        print(feedsList[index].profileImage);
                        print(feedsList[index]
                            .profileImage
                            .contains("${user.id}.jpg"));
                        if (!feedsList[index]
                            .profileImage
                            .contains("${user.id}.jpg")) {
                          return Container();
                        }
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      // FeedsDetail(
                                      //       feedsModel: feedsList[index],
                                      //     )
                                      Article(
                                        feedsModel: feedsList[index],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //  Padding(padding: const  EdgeInsets.only(left: 10.0),
                              //  child: FeedsUtils.getTopView(feedsList[index])),
                              // Padding(padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                              // child:   AppConfig.divider(),),
                              //   Padding(padding: const EdgeInsets.all(20.0),
                              //   child:   FeedsUtils.getCenterView(feedsList[index])),
                              //   Padding(padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                              //     child:   AppConfig.divider(),),
                              //   getBottomView(feedsList[index]),
                              //   Container(
                              //     height:3.0,color: Colors.black12,)
                              Neumorphic(
                                style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.all(
                                            Radius.circular(10.0)))),
                                child: Container(
                                  height: 118.0,
                                  width: 374.0,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Neumorphic(
                                            style: NeumorphicStyle(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(BorderRadius.all(
                                                        Radius.circular(
                                                            10.0)))),
                                            child: Container(
                                                height: 94.5,
                                                width: 92.71,
                                                child: (images.length != 0 &&
                                                        images[index] != null)
                                                    ?
                                                    // ? FadeInImage(
                                                    //     fit: BoxFit.fill,
                                                    //     image: CachedNetworkImageProvider(
                                                    //       images[index],
                                                    //       //scale: 1,
                                                    //     ),
                                                    //     placeholder:
                                                    //         CachedNetworkImageProvider(
                                                    //       "https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/News%2FloadingGif.gif?alt=media&token=eb1cea40-8a88-4d4d-892f-a010e7554417",
                                                    //     ))

                                                    CachedNetworkImage(
                                                        imageUrl: images[index]
                                                                .startsWith(
                                                                    "https://")
                                                            ? images[index]
                                                            : "https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/News%2FloadingGif.gif?alt=media&token=eb1cea40-8a88-4d4d-892f-a010e7554417",
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            (context, url) {
                                                          return RefreshProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .green),
                                                          );
                                                        },
                                                      )

                                                    // ? Image.network(
                                                    //     images[index],
                                                    //     fit: BoxFit.fill,
                                                    //   )
                                                    : Icon(Icons.error))),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: type
                                                ? SizeConfig.screenWidth -
                                                    16 -
                                                    92.71 -
                                                    48 -
                                                    100
                                                : SizeConfig.screenWidth -
                                                    16 -
                                                    92.71 -
                                                    48,
                                            padding: const EdgeInsets.only(
                                                top: 32.0,
                                                bottom: 11.0,
                                                right: 0),
                                            child: Text(
                                              feedsList[index].title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontFamily: AppConfig.roboto,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          Text(
                                            feedsList[index].date,
                                            style: TextStyle(
                                                fontFamily: AppConfig.roboto,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      type
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 50),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  var delete = false;
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Confirm"),
                                                        content: const Text(
                                                            "Are you sure you wish to delete this item?"),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () {
                                                                delete = true;
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              },
                                                              child: const Text(
                                                                  "DELETE")),
                                                          FlatButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            child: const Text(
                                                                "CANCEL"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  print('next');
                                                  print(delete);
                                                  if (delete) {
                                                    var str =
                                                        feedsList[index].image;
                                                    const start = "%2F";
                                                    const end = "?alt";

                                                    final startIndex =
                                                        str.indexOf(start);
                                                    final endIndex =
                                                        str.indexOf(
                                                            end,
                                                            startIndex +
                                                                start.length);

                                                    print(str.substring(
                                                        startIndex +
                                                            start.length,
                                                        endIndex));
                                                    str = str.substring(
                                                        startIndex +
                                                            start.length,
                                                        endIndex);
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("NewsFeed")
                                                        .doc(
                                                            feedsList[index].id)
                                                        .delete()
                                                        .then((value) => print(
                                                            "Post Deleted"))
                                                        .catchError((error) =>
                                                            print(
                                                                "Failed to delete Post: $error"));
                                                    await FirebaseStorage
                                                        .instance
                                                        .ref("News")
                                                        .child(str)
                                                        .delete()
                                                        .then((value) => print(
                                                            "Image Deleted"))
                                                        .catchError((error) =>
                                                            print(
                                                                "Failed to delete Image: $error"));
                                                    setState(() {
                                                      feedsList.remove(
                                                          feedsList[index]);
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.green,
                                                  size: 50,
                                                ),
                                              ))
                                          : Container()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Neumorphic(
                      style: AppConfig.neuStyle.copyWith(
                          shadowLightColor: Colors.transparent,
                          color: type ? Colors.green : Colors.white),
                      child: Column(
                        children: [
                          Container(
                            width: SizeConfig.screenWidth - 20,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'No Posts',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: type ? Colors.white : Colors.green,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ])),
          Container(
              padding:
                  EdgeInsets.only(top: SizeConfig.screenHeight - 200, left: 20),
              child: FloatingActionButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePost())),
                child: Icon(Icons.add, color: Colors.white),
              ))
        ]));
  }

  downloadFeed() async {
    List<FeedsModel> downloadList = [];
    List newImages = [];
    List newProfile = [];
    User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collectionGroup("NewsFeed")
        .get()
        .then((feed) async {
      feed.docs.forEach((element) {
        Map<String, dynamic> data = element.data();
        print(data);
        List likedBy = data['likedBy'];
        print(data['Comments']);
        FeedsModel article = FeedsModel(
            element.id,
            data['Author'],
            data['Title'],
            data['Likes'],
            user != null ? (likedBy.contains(user.uid)) : false,
            data['Comments'],
            data['Image'],
            data['Text'],
            data['ProfilePhoto'],
            data['Date']);
        downloadList.add(article);
        newImages.add(data['Image']);
        newProfile.add(data['ProfilePhoto']);
      });
      feedsList = downloadList;
      images = newImages;
      await convertImage(images);
      await convertImage(newProfile, type: 1);
    });
  }

  convertImage(List imagesIn, {int type = 0}) async {
    print("Converting images");
    List updatedImages = [];
    for (var image in imagesIn) {
      if (image != null) {
        if (type == 1) {
          Reference ref =
              FirebaseStorage.instance.ref().child("Users").child(image);
          String link = await ref.getDownloadURL();
          updatedImages.add(link);
        } else {
          Reference ref =
              FirebaseStorage.instance.ref().child("News").child(image);
          String link = await ref.getDownloadURL();
          updatedImages.add(link);
        }
      } else {
        print("image null");
        updatedImages.add(null);
      }
    }
    setState(() {
      if (type == 0) {
        images = updatedImages;
      }
      for (var list in feedsList) {
        type == 1
            ? list.profileImage = updatedImages[feedsList.indexOf(list)]
            : list.image = images[feedsList.indexOf(list)];
      }
    });
  }
}
