import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/view/scan_spot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grow_lah/utils/app_config.dart';

class TakePicture extends StatefulWidget {
  TakePicture({Key key}) : super(key: key);

  @override
  _TakePictureState createState() {
    return _TakePictureState();
  }
}

class _TakePictureState extends State<TakePicture> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  @override
  @override
  void initState() {
    super.initState();
    // 1
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          child: Stack(
        children: <Widget>[
          CameraPreview(controller),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: uploadImage,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: AppConfig.roboto,
                                  color: Colors.green),
                            ),
                            onTap: uploadImage),
                      )),
                )
              ],
            ),
          ),
          Center(
              child: Image.asset(
            Assets.scanIcon,
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  onTap: () {
                    _onCapturePressed(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Image.asset(Assets.capture),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  // 1, 2
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onCapturePressed(context) async {
    try {
      // 1
      final path =
          (await getTemporaryDirectory()).path + '${DateTime.now()}.png';
      // 2
      await controller.takePicture(path);
      // 3
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanAndSpot(imagePath: path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void uploadImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      AppConfig.showToast("Unable to load Image");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanAndSpot(imagePath: image.path),
      ),
    );
  }
}
