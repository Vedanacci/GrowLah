import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> extractImage(DocumentReference ref, String folder) async {
  String imageName;
  await ref.get().then((value) {
    Map<String, dynamic> data = value.data();
    print(data);
    imageName = data["image"].toString();
    print(imageName);
  });
  Reference imageRef = FirebaseStorage.instance.ref("/$folder/" + imageName);
  String link = await imageRef.getDownloadURL();
  print(link);
  return link;
}

Widget cachedImage(String url, {double width, height}) {
  if (!url.startsWith("https://")) {
    return Container(
        child: RefreshProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    ));
  }
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: BoxFit.cover,
    errorWidget: (context, error, dynamicError) {
      return Icon(Icons.error);
    },
    placeholder: (context, url) {
      return RefreshProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      );
    },
  );
}
