import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/services.dart' show rootBundle;
//import 'package:firebase_ml_vision/firebase_ml_vision.dart' as ml;
//import 'package:firebase_livestream_ml_vision/firebase_livestream_ml_vision.dart' as livestream;
import 'package:firebase_ml_custom/firebase_ml_custom.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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
  Image newImage;

  @override
  void initState() {
    if (Firebase.app() == null) {
      print("no firebase app");
      Firebase.initializeApp();
    }
    widget.image = Image.file(
      File(widget.imagePath),
      fit: BoxFit.cover,
    );
    _imageFile = File(widget.imagePath);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //List<Map<dynamic, dynamic>> _labels;
  //When the model is ready, _loaded changes to trigger the screen state change.
  //Future<String> _loaded = loadModel();

  /// Triggers selection of an image and the consequent inference.
  // Future<void> getImageLabels() async {
  //   try {
  //     final image = _imageFile;
  //     print("path");
  //     print(image.path);
  //     var labels = List<Map>.from(await Tflite.runModelOnImage(
  //       path: image.path,
  //       imageStd: 127.5,
  //     ));
  //     setState(() {
  //       _labels = labels;
  //       print(_labels);
  //     });
  //   } catch (exception) {
  //     print("Failed on getting your image and it's labels: $exception");
  //     print('Continuing with the program...');
  //     rethrow;
  //   }
  // }

  // static Future<String> loadModel() async {
  //   final modelFile = await loadModelFromFirebase();
  //   return await loadTFLiteModel(modelFile);
  // }

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Uint8List imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = img.getRed(pixel);
        buffer[pixelIndex++] = img.getGreen(pixel);
        buffer[pixelIndex++] = img.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Future<void> loadLocalModel() async {
    print("loading local model");
    String res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels_Grow_Lah_Flowers.txt");
    print(res);
    print("loaded tf model");
    var imageBytes = (await _imageFile.readAsBytes()).buffer;
    img.Image oriImage = img.decodeImage(imageBytes.asUint8List());
    img.Image resizedImage = img.copyResize(oriImage, width: 224, height: 224);

    setState(() {
      newImage = Image.memory(imageBytes.asUint8List());
    });

    var recognitions = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImage, 224, 127.5, 127.5),
      numResults: 5,
      threshold: 0.1,
    );
    print("recognitions");
    print(recognitions);

    // await Tflite.runModelOnImage(path: _imageFile.path, numResults: 3)
    //     .then((value) {
    //   if (value.isEmpty) {
    //     print("value is empty");
    //   } else {
    //     print("value");
    //     print(value);
    //   }
    // });
  }

  // static Future<File> loadModelFromFirebase() async {
  //   try {
  //     // Create model with a name that is specified in the Firebase console
  //     final model = FirebaseCustomRemoteModel('Grow_Lah_Flowers');

  //     // Specify conditions when the model can be downloaded.
  //     // If there is no wifi access when the app is started,
  //     // this app will continue loading until the conditions are satisfied.
  //     final conditions = FirebaseModelDownloadConditions(
  //         androidRequireWifi: true, iosAllowCellularAccess: false);

  //     // Create model manager associated with default Firebase App instance.
  //     final modelManager = FirebaseModelManager.instance;

  //     // Begin downloading and wait until the model is downloaded successfully.
  //     await modelManager.download(model, conditions).whenComplete(() {
  //       print("successfully downloaded model");
  //     });
  //     assert(await modelManager.isModelDownloaded(model) == true);
  //     print("Downloading latest model");
  //     // Get latest model file to use it for inference by the interpreter.
  //     var modelFile =
  //         await modelManager.getLatestModelFile(model).catchError((error) {
  //       print("Unable to get latest model" + error);
  //     });
  //     assert(modelFile != null);
  //     print("modefile: " + modelFile.path);
  //     return modelFile;
  //   } catch (exception) {
  //     print('Failed on loading your model from Firebase: $exception');
  //     print('The program will not be resumed');
  //     rethrow;
  //   }
  // }

  // static Future<String> loadTFLiteModel(File modelFile) async {
  //   try {
  //     File localModel = File("assets/model.tflite");
  //     final appDirectory = await getApplicationDocumentsDirectory();
  //     final labelsData =
  //         await rootBundle.load("assets/labels_Grow_Lah_Flowers.txt");
  //     final labelsFile =
  //         await File(appDirectory.path + "/_labels_Grow_Lah_Flowers.txt")
  //             .writeAsBytes(labelsData.buffer.asUint8List(
  //                 labelsData.offsetInBytes, labelsData.lengthInBytes));

  //     assert(await Tflite.loadModel(
  //           model: modelFile.path,
  //           labels: labelsFile.path,
  //           isAsset: false,
  //         ) ==
  //         "success");
  //     return "Model is loaded";
  //   } catch (exception) {
  //     print(
  //         'Failed on loading your model to the TFLite interpreter: $exception');
  //     print('The program will not be resumed');
  //     rethrow;
  //   }
  // }

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
                        child: (newImage != null)
                            ? newImage
                            : Image.file(_imageFile)),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 10.0),
                        child: Neumorphic(
                          style: AppConfig.neuStyle
                              .copyWith(boxShape: AppConfig.neuShape),
                          child: Container(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Text("Run Model"),
                              onTap: loadLocalModel,
                            ),
                          )),
                        ),
                      ),
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
