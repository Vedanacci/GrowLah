// // import 'dart:html';
// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// import 'package:grow_lah/model/feeds_model.dart';
// // import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class SampleFeeds {
//   FirebaseStorage storage = FirebaseStorage.instance;
//   static List<FeedsModel> feedsModel() {
//     List<FeedsModel> tempModel = [
//       FeedsModel(
//           "1", "user1", "FirstContent", 0, false, "test", 'sample2', 'Content'),
//       FeedsModel(
//           "2", "user2", "testestes", 0, true, "test", 'sample2', 'Content'),
//       FeedsModel("3", "user3", " example hormoponics", 0, false, "test",
//           'sample1', 'Content'),
//       FeedsModel("4", "user4", "test", 0, false, "test", 'sample2', 'Content'),
//     ];
//     return tempModel;
//   }
// }

// //FirebaseStorage.instance.ref('News').writeToFile(sample1.jpeg)

// downloadFileExample(String imageName) {
//   try {
//     FirebaseStorage.instance
//         .ref('News/' + imageName.trim() + '.jpeg')
//         .getData()
//         .then((data) {
//       return data;
//     });
//   } on FirebaseException catch (e) {
//     // e.g, e.code == 'canceled'g
//     print(e.code + e.message);
//     return null;
//   }
//   return null;
// }
