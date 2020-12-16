import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> extractImage(DocumentReference ref) async {
  String imageName;
  await ref.get().then((value) {
    Map<String, dynamic> data = value.data();
    print(data);
    imageName = data["image"].toString();
    print(imageName);
  });
  Reference imageRef = FirebaseStorage.instance.ref("/Produce/" + imageName);
  String link = await imageRef.getDownloadURL();
  print(link);
  return link;
}
