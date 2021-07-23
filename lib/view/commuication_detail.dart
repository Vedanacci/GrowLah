import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/feeds_model.dart';
import 'package:grow_lah/model/sample_feeds.dart';
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

  @override
  void initState() {
    feedsList = [];
    for (var feedModel in feedsList) {
      images.add(feedModel.image);
    }

    downloadFeed();
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
        appBar: AppConfig.appBar(CommonStrings.newsFeed1, context, true),
        body: Stack(children: [
          ListView.builder(
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
                                BorderRadius.all(Radius.circular(10.0)))),
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
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.all(
                                                Radius.circular(10.0)))),
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
                                                        .startsWith("https://")
                                                    ? images[index]
                                                    : "https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/News%2FloadingGif.gif?alt=media&token=eb1cea40-8a88-4d4d-892f-a010e7554417",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) {
                                                  return RefreshProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.green),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.screenWidth -
                                        16 -
                                        92.71 -
                                        48,
                                    padding: const EdgeInsets.only(
                                        top: 32.0, bottom: 11.0, right: 0),
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
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
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

  Widget getBottomView(FeedsModel feedsList) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
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
              feedsList.likes.toString() + CommonStrings.likes,
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
              feedsList.comments.length.toString() + CommonStrings.comments,
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

  Widget getLikeIcon(bool isLiked) {
    return isLiked
        ? Image.asset(
            Assets.favRed,
            height: 20.0,
            width: 20.0,
          )
        : Image.asset(Assets.favBlack, height: 20.0, width: 20.0);
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
              FirebaseStorage.instance.ref().child("Products").child(image);
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
