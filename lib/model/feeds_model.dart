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

  Map<String, dynamic> toJson() => {
        'Title': this.title,
        'Text': this.content,
        'Likes': this.likes,
        'ProfilePhoto': this.profileImage,
        'Comments': this.comments,
        'Author': this.authorName,
        'likedBy': [],
        'Date': this.date,
        'Image': this.image
      };
}
