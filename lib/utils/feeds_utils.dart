import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grow_lah/model/feeds_model.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'app_config.dart';
import 'assets.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FeedsUtils {
  static getTopView(FeedsModel feedsList) {
    return Container(
      height: 50.0,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Row(
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
                child: Text(
                  feedsList.authorName ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConfig.roboto,
                      fontSize: 14.0),
                ),
              )
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: Container(
                height: 20.0, width: 20.0, child: Image.asset(Assets.options)),
          )
        ],
      ),
    );
  }

  static getBottomView(bool isLiked) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  getColor(true);
                },
                child: Image.asset(
                  Assets.favBlack,
                  height: 20.0,
                  width: 20.0,
                  color: getColor(isLiked),
                )),
            Text(
              '0' + CommonStrings.likes,
              style: TextStyle(
                fontFamily: AppConfig.roboto,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                Assets.favBlack,
                height: 20.0,
                width: 20.0,
              ),
            ),
            Text(
              '0' + CommonStrings.comments,
              style: TextStyle(
                fontFamily: AppConfig.roboto,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                Assets.favBlack,
                height: 20.0,
                width: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static getCenterView(FeedsModel feedsList) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            feedsList.content ?? '',
            style: TextStyle(
              fontFamily: AppConfig.roboto,
            ),
          ),
          loadForImage(feedsList.image),
          loadForVideo()
        ],
      ),
    );
  }

  static loadForImage(String image) {
    return image != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150.0,
                width: 150.0,
                child:
                    (image != null) ? Image.network(image) : Icons.error_sharp,
              ),
            ),
          )
        : Container();
  }

  static loadForVideo() {
    return Container();
  }

  static getColor(bool isLiked) {
    return isLiked ? Colors.red : null;
  }
}
