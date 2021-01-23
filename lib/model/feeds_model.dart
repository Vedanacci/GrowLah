import 'dart:typed_data';

class FeedsModel {
  String id;
  String authorName;
  String title;
  String content;
  int likes;
  bool isLiked;
  List comments;
  String image;
  String profileImage;
  String date;

  FeedsModel(this.id, this.authorName, this.title, this.likes, this.isLiked,
      this.comments, this.image, this.content, this.profileImage, this.date);
}
