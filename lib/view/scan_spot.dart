import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart' as ml;
//import 'package:firebase_livestream_ml_vision/firebase_livestream_ml_vision.dart' as livestream;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';

class ScanAndSpot extends StatefulWidget {
  ScanAndSpot({Key key, this.imagePath}) : super(key: key);
  String imagePath;
  Image image;
  @override
  _ScanAndSpotState createState() {
    return _ScanAndSpotState();
  }
}

class _ScanAndSpotState extends State<ScanAndSpot> {
  String _modelLoadStatus = 'unknown';
  File _imageFile;
  String _inferenceResult;
  @override
  void initState() {
    widget.image = Image.file(
      File(widget.imagePath),
      fit: BoxFit.cover,
    );
    _imageFile = File(widget.imagePath);
    //loadModel().then((value) => loadImageAndInfer());
    //detectPlant(File(widget.imagePath));
    super.initState();
  }

  // Future<void> loadModel() async {
  //   String dataset = "FlowersModel";
  //   await createLocalFiles(dataset);
  //   String modelLoadStatus;
  //   try {
  //     await AutomlMlkit.loadModelFromCache(dataset: dataset);
  //     modelLoadStatus = "AutoML model successfully loaded";
  //   } on Exception catch (e) {
  //     modelLoadStatus = "Error loading model";
  //     print("error from platform on calling loadModelFromCache");
  //     print(e.toString());
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _modelLoadStatus = modelLoadStatus;
  //   });
  // }

  // Future<void> createLocalFiles(String folder) async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   final Directory modelDir = Directory("${tempDir.path}/$folder");
  //   if (!modelDir.existsSync()) {
  //     modelDir.createSync();
  //   }
  //   final filenames = ["manifest.json", "model.tflite", "dict.txt"];

  //   for (String filename in filenames) {
  //     final File file = File("${modelDir.path}/$filename");
  //     if (!file.existsSync()) {
  //       print("Copying file: $filename");
  //       await copyFileFromAssets(filename, file);
  //     }
  //   }
  // }

  // /// copies file from assets to dst file
  // Future<void> copyFileFromAssets(String filename, File dstFile) async {
  //   ByteData data = await rootBundle.load("assets/$filename");
  //   final buffer = data.buffer;
  //   dstFile.writeAsBytesSync(
  //       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }

  // Future<void> loadImageAndInfer() async {
  //   final File imageFile = _imageFile;
  //   final results =
  //       await AutomlMlkit.runModelOnImage(imagePath: imageFile.path);
  //   print("Got results" + results[0].toString());
  //   if (results.isEmpty) {
  //     AppConfig.showToast("No Labels found :(");
  //   } else {
  //     final label = results[0]["label"];
  //     final confidence = (results[0]["confidence"] * 100).toStringAsFixed(2);
  //     setState(() {
  //       _imageFile = imageFile;
  //       _inferenceResult = "$label: $confidence \%";
  //     });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppConfig.appBar(CommonStrings.scanSpot, context, true),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(parent: ScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Neumorphic(
                    style: AppConfig.neuStyle
                        .copyWith(boxShape: AppConfig.neuShape),
                    child: Container(
                        height: 272.0,
                        width: 374.0,
                        child: Image.file(_imageFile)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Neumorphic(
                        style: AppConfig.neuStyle
                            .copyWith(boxShape: AppConfig.neuShape),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Rose',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: AppConfig.roboto,
                                color: Colors.green),
                          ),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 10.0),
                        child: Neumorphic(
                          style: AppConfig.neuStyle
                              .copyWith(boxShape: AppConfig.neuShape),
                          child: Container(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Rosaceae family',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: AppConfig.roboto,
                                  color: Colors.green),
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                  child: getWeatherCards(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    CommonStrings.about,
                    style: TextStyle(
                        fontFamily: AppConfig.roboto,
                        color: Colors.green,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing'
                    'elit. Facilisis lectus at a vulputate pellentesque'
                    'aliquet velit odio nullam. Mattis ut est ut enim.'
                    'Nullam lobortis dolor quis non mauris, dui sed'
                    'nunc quam. Gravida commodo vel at dignissim'
                    'integer.',
                    style: TextStyle(
                        fontFamily: AppConfig.roboto,
                        color: Colors.green,
                        fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getWeatherCards() {
    return Container(
      height: 150.0,
      child: Center(
        child: ListView.builder(
            itemCount: 3,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) {
              return Padding(
                padding: EdgeInsets.only(
                    left: position == 1 ? 50.0 : 0,
                    right: position == 1 ? 50.0 : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Neumorphic(
                    //   style: NeumorphicStyle(color: Colors.white12),
                    //   boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(10.0))),
                    //   child: Container(
                    //     height: 80.0,
                    //     width: 90.0,
                    //     child:Icon(getImage(position),color: Colors.green,
                    //     size: 30.0,) ,
                    //   ),
                    // ),
                    Container(
                        width: 90.0,
                        height: 80.0,
                        child: Image.asset(getImage(position))),
                    Text(
                      getTitle(position),
                      style: TextStyle(color: Colors.green, fontSize: 12.0),
                    ),
                    Text(
                      getPercentage(position),
                      style: TextStyle(
                          fontFamily: AppConfig.roboto,
                          color: Colors.green,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  getImage(int position) {
    return position == 0
        ? Assets.cloudBtn
        : position == 1
            ? Assets.lightBtn
            : Assets.tempBtn;
  }

  String getTitle(int position) {
    return position == 0
        ? CommonStrings.humidity
        : position == 1
            ? CommonStrings.light
            : CommonStrings.temperature;
  }

  String getPercentage(int position) {
    return position == 0
        ? '64 %'
        : position == 1
            ? 'Diffused'
            : '18-24 c';
  }
}

// void detectPlant(File image) async {
//   //List<livestream.FirebaseCameraDescription> cameras = await livestream.camerasAvailable();
//   final ml.FirebaseVisionImage visionimage =
//       ml.FirebaseVisionImage.fromFile(image);
//   //livestream.FirebaseVision _vision = livestream.FirebaseVision( cameras[0], livestream.ResolutionSetting.high);
//   //final livestream.VisionEdgeImageLabeler visionEdgeLabeler = livestream.FirebaseVision(visionimage)
// }
