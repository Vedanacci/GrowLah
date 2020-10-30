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
import 'package:grow_lah/view/feeds_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailCommunication extends StatefulWidget {
  DetailCommunication({Key key}) : super(key: key);
  bool hasImage = false;
  bool hasVideo = false;

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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(parent: ScrollPhysics()),
        shrinkWrap: true,
        itemCount: feedsList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeedsDetail(
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
                                        ? Image.network(
                                            images[index],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.error))),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32.0, bottom: 11.0),
                                child: Text(
                                  feedsList[index].title,
                                  style: TextStyle(
                                      fontFamily: AppConfig.roboto,
                                      color: Colors.green),
                                ),
                              ),
                              Text(
                                'Wed 23, Sep 2020',
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
    );
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
    User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collectionGroup("NewsFeed")
        .get()
        .then((feed) {
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
            (likedBy.contains(user.uid)),
            data['Comments'],
            data['Image'],
            data['Text']);
        downloadList.add(article);
        newImages.add(data['Image']);
      });
      feedsList = downloadList;
      images = newImages;
      print(images + newImages);
      convertImage(images);
    });
  }

  convertImage(List imagesIn) async {
    print("Converting images");
    print(imagesIn);
    List updatedImages = [];
    for (var image in imagesIn) {
      if (image != null) {
        Reference ref = FirebaseStorage.instance.ref("/News/" + image);
        String link = await ref.getDownloadURL();
        print("Url" + link);
        updatedImages.add(link);
      } else {
        updatedImages.add(null);
      }
    }
    setState(() {
      images = updatedImages;
      for (var list in feedsList) {
        list.image = images[feedsList.indexOf(list)];
      }
    });
  }
}
