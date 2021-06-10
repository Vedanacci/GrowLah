import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:grow_lah/model/plant_types_model.dart';

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
  Image newImage;
  String path;
  PlantData extractedData;

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
    path = widget.imagePath;
    loadLocalModel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  TensorImage _preProcess(TensorImage _inputImage, List<int> _inputShape,
      NormalizeOp preProcessNormalizeOp) {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  Future predictImagePicker() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // if (image == null) return;

    loadLocalModel();
  }

  Future<void> loadLocalModel() async {
    print("loading local model");

// Create a TensorImage object from a File
    TensorImage tensorImage = TensorImage.fromFile(File(path));

// Create a container for the result and specify that this is a quantized model.
// Hence, the 'DataType' is defined as UINT8 (8-bit unsigned integer)
    TensorBuffer probabilityBuffer;
    Interpreter interpreter;

    try {
      // Create interpreter from asset.
      interpreter = await Interpreter.fromAsset("model.tflite");
    } catch (e) {
      print('Error loading model: ' + e.toString());
    }

    NormalizeOp postProcessNormalizeOp = NormalizeOp(0, 1);
    List<int> outputShape = interpreter.getOutputTensor(0).shape;
    TfLiteType outputType = interpreter.getOutputTensor(0).type;
    List<int> _inputShape = interpreter.getInputTensor(0).shape;
    NormalizeOp preProcessNormalizeOp = NormalizeOp(0, 1);

    tensorImage = _preProcess(tensorImage, _inputShape, preProcessNormalizeOp);

    probabilityBuffer = TensorBuffer.createFixedSize(outputShape, outputType);
    TensorProcessorBuilder().add(postProcessNormalizeOp);
    interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);
    print(interpreter);

    List<String> labels =
        await FileUtil.loadLabels("assets/labels_Grow_Lah_Flowers.txt");

    var probabilityProcessor =
        TensorProcessorBuilder().add(NormalizeOp(0, 1)).build();

    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, probabilityProcessor.process(probabilityBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);

    print("helper");
    print(pred);

    PlantData extractedPlantData = await extractPlantData(pred.key);

    setState(() {
      extractedData = extractedPlantData;
    });
  }

  MapEntry<String, double> getTopProbability(Map<String, double> labeledProb) {
    var pq = PriorityQueue<MapEntry<String, double>>(compare);
    pq.addAll(labeledProb.entries);

    return pq.first;
  }

  int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
    if (e1.value > e2.value) {
      return -1;
    } else if (e1.value == e2.value) {
      return 0;
    } else {
      return 1;
    }
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                            : Image.file(File(path))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Neumorphic(
                        style: AppConfig.neuStyle
                            .copyWith(boxShape: AppConfig.neuShape),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            extractedData != null ? extractedData.name : 'Rose',
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
                              extractedData != null
                                  ? extractedData.family
                                  : 'Rosaceae family',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: AppConfig.roboto,
                                  color: Colors.green),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: getWeatherCards(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    CommonStrings.about,
                    style: TextStyle(
                        fontFamily: AppConfig.roboto,
                        color: Colors.green,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 20.0, right: 20),
                  child: Text(
                    extractedData != null
                        ? extractedData.about
                        : 'Lorem ipsum dolor sit amet, consectetur adipiscing'
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
                SizedBox(
                  height: 30,
                )
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
        child: Container(
          width: (90 * 3 + 50 * 2).toDouble(),
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
        ? (extractedData != null ? extractedData.humidty : '64 %')
        : position == 1
            ? (extractedData != null ? extractedData.light : 'Diffused')
            : (extractedData != null ? extractedData.temp : '18-24 c');
  }
}
