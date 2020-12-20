import 'package:arkit_plugin/utils/json_converters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math';
//import 'package:grow_lah/model/arIOSExtras.dart';

class PlaneClass {
  ARKitNode node;
  ARKitPlane plane;
  String identifier;
  String nodeName;
  ARKitPlaneAnchor anchor;

  PlaneClass(
      this.node, this.plane, this.anchor, this.identifier, this.nodeName);
}

class ARIOS extends StatefulWidget {
  @override
  _ARIOSState createState() => _ARIOSState();
}

class _ARIOSState extends State<ARIOS> with SingleTickerProviderStateMixin {
  ARKitController arkitController;
  ARKitNode node;
  ARKitPlane plane;

  vector.Vector3 lastPosition;
  bool planeSelected = false;
  int pointNo = 0;
  List<vector.Vector3> points = [];
  List<PlaneClass> planes = [];
  List<String> nodeNames = [];
  double angle = 0;

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;

  @override
  void dispose() {
    arkitController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.green,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: 0,
      end: SizeConfig.screenWidth / 4,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          //appBar: AppBar(title: const Text('ARKit in Flutter')),
          body: Stack(
        children: [
          ARKitSceneView(
            onARKitViewCreated: onARKitViewCreated,
            //showStatistics: false,
            enableTapRecognizer: true,
            //showFeaturePoints: true,
            planeDetection: ARPlaneDetection.horizontal,
            //showWorldOrigin: true,
          ),
          Transform.translate(
            offset: Offset(_translateButton.value, 0),
            child: home(),
          ),
          Transform.translate(
            offset: Offset(_translateButton.value * 2, 0),
            child: clear(),
          ),
          Transform.translate(
            offset: Offset(_translateButton.value * 3, 0),
            child: add(),
          ),
          toggle(),
          AnimatedSwitcher(
            child: planeSelected
                ? arInstructions(context, true, pointNo)
                : arInstructions(context, false, pointNo),
            duration: Duration(seconds: 1),
          )
        ],
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    print("Created");
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
    this.arkitController.onARTap = (List<ARKitTestResult> ar) {
      final planeTap = ar.firstWhere(
        (tap) => tap.type == ARKitHitTestResultType.existingPlaneUsingExtent,
        orElse: () => null,
      );
      List planesIdent = [];
      for (PlaneClass pln in planes) {
        planesIdent.add(pln.identifier);
      }
      if (planeTap != null) {
        if (planesIdent.indexOf(planeTap.anchor.identifier) != -1) {
          if (planeSelected) {
            _onPlaneTapHandler(planeTap.worldTransform);
          } else {
            print("Chaning plane selected");
            setState(() {
              planeSelected = true;
            });
            if (pointNo == 0) {
              for (PlaneClass pln in planes) {
                if (planeTap.anchor.identifier != pln.identifier) {
                  arkitController.remove(pln.nodeName);
                } else {
                  planes = [pln];
                }
              }
            }
          }
        } else {
          print("Not on existing plane");
        }
      } else {
        print("Not plane tap");
      }
    };
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor) || planeSelected) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (planeSelected) {
      return;
    }
    final ARKitPlaneAnchor planeAnchor = anchor;
    node.position =
        vector.Vector3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;
  }

  void _addPlane(
    ARKitController controller,
    ARKitPlaneAnchor anchor,
  ) {
    //addPlaneText(controller, anchor);
    ARKitMaterial material = ARKitMaterial(
      transparency: 0.5,
      diffuse: ARKitMaterialProperty(
          color: Colors.green, image: 'images/onboarding1.png'),
    );

    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [material],
    );
    final name = planes.length.toString();

    node = ARKitNode(
      name: "plane" + name,
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -pi / 2),
    );
    controller.add(node, parentNodeName: anchor.nodeName);

    planes.add(
        PlaneClass(node, plane, anchor, anchor.identifier, "plane" + name));
  }

  void _onPlaneTapHandler(Matrix4 transform) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    points.add(position);
    if (lastPosition != null) {
      final length = _calculateDistanceBetweenPoints(position, lastPosition);
      if (pointNo == 1) {
        print("editing plane image");
        print(planes[0].anchor.extent.y);
        print(position.y);
        joinVectors(lastPosition, position, length, displayPlane: 1);
        plotPoint(position);
        //images/growlah_icon.png

      } else if (pointNo == 2) {
        final dz = lastPosition.z - points[0].z;
        final dx = lastPosition.x - points[0].x;
        final y = position.y;
        double m = dz / dx;
        double c = lastPosition.z - m * lastPosition.x;
        double c2 = position.z - m * position.x;
        double c3 = lastPosition.z - (-1 / m * lastPosition.x);
        double c4 = points[0].z - (-1 / m * points[0].x);

        print(
            "Original: z = ${(m.toStringAsFixed(2))}x + ${(c.toStringAsFixed(2))}");
        print(
            "Parallel: z = ${(m.toStringAsFixed(2))}x + ${(c2.toStringAsFixed(2))}");
        print(
            "PurpendicularNew: z = ${((-1 / m).toStringAsFixed(2))}x + ${(c3.toStringAsFixed(2))}");
        print(
            "PurpendicularOld: z = ${((-1 / m).toStringAsFixed(2))}x + ${(c4.toStringAsFixed(2))}");

        double newX = (c3 - c2) / (m + (1 / m));
        double newZ = m * newX + c2;
        double oldX = (c4 - c2) / (m + (1 / m));
        double oldZ = m * oldX + c2;

        vector.Vector3 newPoint = vector.Vector3(newX, y, newZ);
        vector.Vector3 oldPoint = vector.Vector3(oldX, y, oldZ);

        double len2to3 = newPoint.distanceTo(lastPosition);
        double len3to4 = newPoint.distanceTo(oldPoint);
        double len4to1 = oldPoint.distanceTo(points[0]);

        plotPoint(newPoint);
        plotPoint(oldPoint);

        if ((angle > pi / 2) && (angle < 3 / 2 * pi)) {
          joinVectors(lastPosition, newPoint, len2to3,
              displayText: true,
              displayPlane: 2,
              lengths: [len2to3, len3to4],
              centerPoint: _getMiddleVector(
                  _getMiddleVector(points[0], points[1]),
                  _getMiddleVector(oldPoint, newPoint)));
          joinVectors(oldPoint, points[0], len4to1, displayText: false);
        } else {
          joinVectors(lastPosition, newPoint, len2to3, displayText: false);
          joinVectors(oldPoint, points[0], len4to1,
              displayText: true,
              displayPlane: 2,
              lengths: [len2to3, len3to4],
              centerPoint: _getMiddleVector(
                  _getMiddleVector(points[0], points[1]),
                  _getMiddleVector(oldPoint, newPoint)));
        }
        joinVectors(newPoint, oldPoint, len3to4, displayText: false);

        arkitController.remove("arrow");
      }
    } else {
      plotPoint(position);
      arkitController.remove(planes[0].nodeName);
    }
    lastPosition = position;
    setState(() {
      pointNo += 1;
    });
  }

  void plotPoint(vector.Vector3 position) {
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.constant,
      diffuse: ARKitMaterialProperty(color: Colors.green),
    );
    final sphere = ARKitSphere(
      radius: 0.01,
      materials: [material],
    );
    final node = ARKitNode(
      geometry: sphere,
      position: position,
    );
    arkitController.add(node);
    nodeNames.add(node.name);
  }

  void joinVectors(vector.Vector3 last, vector.Vector3 position, double length,
      {bool displayText = true,
      int displayPlane = 0,
      List<double> lengths,
      vector.Vector3 centerPoint}) {
    final midPoint = _getMiddleVector(position, last);

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.constant,
      diffuse: ARKitMaterialProperty(color: Colors.green),
    );

    final dz = position.z - last.z;
    final dx = position.x - last.x;
    double theta = -asin(dz / length);
    if (dx < 0) {
      theta = pi - theta;
    }

    final cyl = ARKitBox(
        materials: [material], width: length, height: 0.001, length: 0.005);
    final cylNode = ARKitNode(
      geometry: cyl,
      position: midPoint,
      eulerAngles: vector.Vector3(theta, 0, 0),
    );
    arkitController.add(cylNode);
    nodeNames.add(cylNode.name);

    if (displayPlane == 1) {
      angle = theta;
      ARKitMaterial material = ARKitMaterial(
        transparency: 0.65,
        diffuse: ARKitMaterialProperty(image: "/images/arrowAR.png"),
      );
      ARKitPlane arKitPlane = ARKitPlane(
        width: length,
        height: length,
        materials: [material],
      );
      ARKitNode arkitNode = ARKitNode(
        name: "arrow",
        geometry: arKitPlane,
        position: midPoint,
        //rotation: vector.Vector4(1, 0, 0, -pi / 2),
        eulerAngles: vector.Vector3(theta, -pi / 2, 0),
      );
      arkitController.add(arkitNode);
    } else if (displayPlane == 2) {
      if (lengths == null) {
        lengths = [length, length];
      }

      ARKitMaterial material = ARKitMaterial(
        transparency: 0.5,
        diffuse: ARKitMaterialProperty(color: Colors.green),
      );
      ARKitPlane arKitPlane = ARKitPlane(
        width: lengths[0],
        height: lengths[1],
        materials: [material],
      );

      ARKitNode arkitNode = ARKitNode(
        name: "area",
        geometry: arKitPlane,
        position: centerPoint,
        //rotation: vector.Vector4(1, 0, 0, -pi / 2),
        eulerAngles: vector.Vector3(theta, -pi / 2, 0),
      );
      arkitController.add(arkitNode);

      _drawText(
          "Area: ${(lengths[0] * lengths[1]).toStringAsFixed(2)} square meters",
          centerPoint,
          3);
    }

    if (displayText) {
      _drawText(
          '${(length * 100).toStringAsFixed(2)} cm', midPoint, displayPlane);
    }
  }

  double _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return length;
  }

  vector.Vector3 _getMiddleVector(vector.Vector3 A, vector.Vector3 B) {
    return vector.Vector3((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
  }

  void _drawText(String text, vector.Vector3 point, int type) {
    final textGeometry = ARKitText(
      text: text,
      extrusionDepth: 0,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.black),
        )
      ],
    );
    double rotate = angle;

    if ((rotate > pi / 2) && (rotate < 3 / 2 * pi)) {
      rotate = rotate - pi;
    }

    if (type == 2) {
      rotate += pi / 2;
    }

    double dst = points[0].distanceTo(points[1]);
    double adjustedScale = sqrt(dst) / 400;
    print("Adjusted");
    print(dst);
    print(adjustedScale);
    double scale = adjustedScale; // 0.002
    final vectorScale = vector.Vector3(scale, scale, scale);
    final node = ARKitNode(
        geometry: textGeometry,
        position: point,
        scale: vectorScale,
        eulerAngles: vector.Vector3(rotate, -pi / 2, 0));
    arkitController
        .getNodeBoundingBox(node)
        .then((List<vector.Vector3> result) {
      final minVector = result[0];
      final maxVector = result[1];
      double width = (maxVector.x - minVector.x).abs();
      final dx = cos(-rotate) * width;
      final dz = sin(-rotate) * width;
      vector.Vector3 mid = vector.Vector3(dx, -0.001, dz) / 2 * scale;
      final position = node.position - mid;
      node.position = position;
    });
    nodeNames.add(node.name);
    arkitController.add(node);
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget home() {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 20),
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        heroTag: 'Home',
        onPressed: () {
          print("Home Tapped");
          Navigator.pop(context);
        },
        tooltip: 'Home',
        child: Icon(Icons.home),
      ),
    );
  }

  Widget clear() {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 20),
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        heroTag: 'Clear',
        onPressed: () {
          // for (PlaneClass pln in planes) {
          //   arkitController.remove(pln.nodeName);
          // }
          // for (String names in nodeNames) {
          //   arkitController.remove(names);
          // }
          // arkitController.remove("area");
          // setState(() {
          //   nodeNames = [];
          //   planes = [];
          //   pointNo = 0;
          //   planeSelected = false;
          //   points = [];
          //   lastPosition = null;
          // });
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ARIOS()));
        },
        tooltip: 'Clear',
        child: Icon(Icons.layers_clear),
      ),
    );
  }

  Widget add() {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 20),
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        heroTag: 'Add',
        onPressed: null,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget toggle() {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 20),
      child: FloatingActionButton(
        heroTag: 'Toggle',
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
          color: (_buttonColor.value == Colors.white)
              ? Colors.green
              : Colors.white,
        ),
      ),
    );
  }

  static Widget arInstructions(
      BuildContext context, bool planeSelected, int pointNo) {
    List<IconData> icons = [
      Icons.open_with,
      Icons.touch_app,
      Icons.trending_flat_outlined,
      Icons.square_foot,
      Icons.done
    ];
    List<String> info = [
      "Move your phone around to mark area \n Tap on plane to select floor",
      "Tap to select the start point in the space",
      "Tap a point to mark the length of the space",
      "Tap a point to mark the depth of the space",
      "Done!"
    ];

    if (pointNo != 3) {
      return Align(
        key: ValueKey((planeSelected) ? pointNo : planeSelected),
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20, left: 0, right: 0),
          child: Container(
              alignment: Alignment.center,
              height: 150,
              width: SizeConfig.screenWidth - 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green
                      .withOpacity(0.65) //Color.fromRGBO(176, 176, 178, 0.65),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Select plane, Select point, Select rect, Measure
                  Icon(
                    (planeSelected) ? (icons[pointNo + 1]) : icons[0],
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    (planeSelected) ? (info[pointNo + 1]) : info[0],
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
        ),
      );
    } else {
      return Align(
        key: ValueKey((planeSelected) ? pointNo : planeSelected),
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20, left: 0, right: 0),
          child: Container(
              padding: EdgeInsets.all(10),
              //alignment: Alignment.center,
              height: 300,
              width: SizeConfig.screenWidth - 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green
                      .withOpacity(0.65) //Color.fromRGBO(176, 176, 178, 0.65),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Select plane, Select point, Select rect, Measure
                  GestureDetector(
                    child: Container(
                      width: SizeConfig.screenWidth - 70,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            fontFamily: AppConfig.roboto, fontSize: 20),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  GestureDetector(
                    child: Container(
                      width: SizeConfig.screenWidth - 70,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Text(
                        "Add Height",
                        style: TextStyle(
                            fontFamily: AppConfig.roboto, fontSize: 20),
                      ),
                    ),
                  )
                ],
              )),
        ),
      );
    }
  }
}
