import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/controller/post_ad_controller.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:image_picker/image_picker.dart';

class PostAdScreen extends StatefulWidget {
  PostAdScreen({Key key}) : super(key: key);

  @override
  _PostAdScreenState createState() {
    return _PostAdScreenState();
  }
}

class _PostAdScreenState extends State<PostAdScreen> {
  String imagePath = '';
  PickedFile imageFile;
  bool categorySelected = false;
  PostAdController controller = PostAdController();
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
    return Scaffold(
      appBar: AppConfig.appBar('POST AD', context, true),
      body: SingleChildScrollView(
        physics: ScrollPhysics(parent: ScrollPhysics()),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Category',
                style: getStyle(),
              ),
              Neumorphic(
                style: getNeuStyle(),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50.0,
                          child: getCategory(),
                        ),
                      ),
                      Container(
                        child: getPopUp(),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                'Purpose',
                style: getStyle(),
              ),
              getPurpose(),
              Text(
                'Add Image',
                style: getStyle(),
              ),
              getImage(),
              Text(
                'About Product',
                style: getStyle(),
              ),
              getAbout(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Quantity',
                              style: getStyle(),
                            ),
                            getQuantity()
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Units',
                              style: getStyle(),
                            ),
                            getUnits()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                'Price',
                style: getStyle(),
              ),
              getPrice(),
              postAdBtn()
            ],
          ),
        ),
      ),
    );
  }

  getStyle() {
    return TextStyle(
        color: Colors.green,
        fontFamily: AppConfig.roboto,
        fontWeight: FontWeight.bold,
        fontSize: 14.0);
  }

  getNeuShape() {
    return NeumorphicBoxShape.roundRect(
        BorderRadius.all(Radius.circular(10.0)));
  }

  getNeuStyle() {
    return NeumorphicStyle(
        depth: -8,
        intensity: 0.86,
        surfaceIntensity: 0.3,
        color: Colors.white12,
        boxShape: getNeuShape());
  }

  getCategory() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: PostAdController.category,
          textAlign: TextAlign.start,
          enabled: false,
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  getQuantity() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Neumorphic(
        style: getNeuStyle(),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: PostAdController.quantity,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.numberWithOptions(),
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  getUnits() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Neumorphic(
        style: getNeuStyle(),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: PostAdController.units,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.numberWithOptions(),
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  getPrice() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Neumorphic(
        style: getNeuStyle(),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: PostAdController.price,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.numberWithOptions(),
            maxLength: 10,
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  getPurpose() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Neumorphic(
        style: getNeuStyle(),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: PostAdController.purpose,
            textAlign: TextAlign.start,
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  getAbout() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Neumorphic(
        style: getNeuStyle(),
        child: Container(
          height: 123.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: PostAdController.aboutProduct,
            textAlign: TextAlign.start,
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  getImage() {
    return GestureDetector(
      onTap: () {
        attachments();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              imageFile != null
                  ? Container(
                      height: 150.0,
                      width: 150.0,
                      child: Image.file(
                        File(imageFile.path),
                        fit: BoxFit.cover,
                      ))
                  : Icon(
                      Icons.image,
                      color: Colors.green,
                      size: 100.0,
                    ),
              imageFile == null ? Image.asset(Assets.addIcon) : Container()
            ],
          ),
        ),
      ),
    );
  }

  postAdBtn() {
    return GestureDetector(
      onTap: () {
        if (validation()) {
          AppConfig.hideKeyBoard();
          AppConfig.showToast('validated');
          publish();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Neumorphic(
          style: AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
          child: Container(
            height: 55.0,
            width: 374.0,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'PUBLISH',
                  style: TextStyle(
                      fontFamily: AppConfig.roboto,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void attachments() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppConfig.divider(),
              ListTile(
                onTap: () {
                  openCamera();
                },
                title: Center(
                    child: Text('Camera',
                        style: TextStyle(
                            fontFamily: AppConfig.roboto,
                            fontWeight: FontWeight.bold))),
              ),
              AppConfig.divider(),
              ListTile(
                onTap: () {
                  openGallery();
                },
                title: Center(
                    child: Text('Gallery',
                        style: TextStyle(
                            fontFamily: AppConfig.roboto,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          );
        });
  }

  openCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
    });
    Navigator.pop(context);
  }

  openGallery() async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  getPopUp() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: Text(
              'Vegetables',
              style: getStyle(),
            )),
        PopupMenuItem(
            value: 1,
            child: Text(
              'Fruits',
              style: getStyle(),
            )),
        PopupMenuItem(
            value: 2,
            child: Text(
              'Flowers',
              style: getStyle(),
            )),
        PopupMenuItem(
            value: 3,
            child: Text(
              'Plants',
              style: getStyle(),
            )),
        PopupMenuItem(
            value: 4,
            child: Text(
              'Grains/Spices',
              style: getStyle(),
            )),
        PopupMenuItem(
            value: 5,
            child: Text(
              'Pulses/Nuts',
              style: getStyle(),
            )),
        PopupMenuItem(
            value: 6,
            child: Text(
              'Others',
              style: getStyle(),
            )),
      ],
      onSelected: (value) async {
        categorySelected = true;
        switch (value) {
          case 0:
            PostAdController.category.text = 'Vegetables';
            break;
          case 1:
            PostAdController.category.text = 'Fruits';
            break;
          case 2:
            PostAdController.category.text = 'Flowers';
            break;
          case 3:
            PostAdController.category.text = 'Plants';
            break;
          case 4:
            PostAdController.category.text = 'Grains/Spices';
            break;
          case 5:
            PostAdController.category.text = 'Pulses/Nuts';
            break;
          case 6:
            PostAdController.category.text = 'Others';
            break;
        }
      },
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.green,
      ),
      offset: Offset(0, 100),
    );
  }

  bool validation() {
    if (!categorySelected) {
      return AppConfig.showToast('Please select category');
    }
    if (PostAdController.purpose.text.trim() == '') {
      return AppConfig.showToast('Please enter purpose');
    }
    if (imageFile == null) {
      return AppConfig.showToast('Please add image');
    }
    if (PostAdController.aboutProduct.text.trim() == '') {
      return AppConfig.showToast('Please enter about the product');
    }
    if (PostAdController.quantity.text.trim() == '') {
      return AppConfig.showToast('Please enter quantity');
    }
    if (PostAdController.units.text.trim() == '') {
      return AppConfig.showToast('Please enter units');
    }
    if (PostAdController.price.text.trim() == '') {
      return AppConfig.showToast('Please enter price');
    }
    return true;
  }

  void publish() {}
}
