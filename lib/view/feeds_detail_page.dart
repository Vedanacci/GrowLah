import 'package:flutter/material.dart';
import 'package:grow_lah/model/feeds_model.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/utils/feeds_utils.dart';

class FeedsDetail extends StatefulWidget {
  FeedsModel feedsModel;
  FeedsDetail({Key key, this.feedsModel}) : super(key: key);

  @override
  _FeedsDetailState createState() {
    return _FeedsDetailState();
  }
}

class _FeedsDetailState extends State<FeedsDetail> {
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
      appBar: AppConfig.appBar(CommonStrings.feedsDetail, context, true),
      body: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: FeedsUtils.getTopView(widget.feedsModel)),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: AppConfig.divider(),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: FeedsUtils.getCenterView(widget.feedsModel)),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: AppConfig.divider(),
          ),
          getBottomView(widget.feedsModel),
          Container(
            height: 3.0,
            color: Colors.black12,
          )
        ],
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
