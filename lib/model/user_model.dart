import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  List cart;

  UserModel(this.id, this.name, this.email, this.phoneNumber, {this.cart});

  static Future<UserModel> getUser() async {
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    UserModel user;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUID)
        .get()
        .then((value) async {
      user = UserModel(
          currentUID, value['name'], value['email'], value['phoneNumber']);
    });
    return user;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'Cart': cart,
      };

  createProfilePhoto() async {
    var imageRef = FirebaseStorage.instance.ref().child("Users/$id.jpg");
    File image = await imageToFile(imageName: "profile", ext: "jpeg");
    imageRef.putFile(image).then((snapshot) {
      print("Uploaded profile photo");
    });
  }
}

Future<File> imageToFile({String imageName, String ext}) async {
  var bytes = await rootBundle.load('images/$imageName.$ext');
  String tempPath = (await getTemporaryDirectory()).path;
  File file = File('$tempPath/profile.png');
  await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  return file;
}
