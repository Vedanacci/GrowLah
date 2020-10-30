import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import
'package:vector_math/vector_math_64.dart' as vector;

class ARScreen extends StatefulWidget {
  ARScreen({Key key}) : super(key: key);

  @override
  _ARScreenState createState() {
    return _ARScreenState();
  }
}

class _ARScreenState extends State<ARScreen> {
  ArCoreController arCoreController;
  ArCoreNode node;
  int i=0;
  String distance="";
  String pointName="";
  var startPose=null;
  var endPose=null;
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
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ArCoreView(
              enableTapRecognizer: true,
              onArCoreViewCreated: _onArCoreViewCreated),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 30.0,
              color: Colors.green,
              child: Center(
                child: Text("Distance: $distance",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
              ),
            ),),
          )
        ],
      ),
    );
  }

  _onArCoreViewCreated(ArCoreController _arCoreController) {
    arCoreController = _arCoreController;
    arCoreController.onNodeTap=(name)=>_nodeTap(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;

  }

  _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    addImage(hit);
  }
   addImage(ArCoreHitTestResult hit)async {
    i+=1;
    final ByteData textureBytes = await rootBundle.load(Assets.circle);
    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    node = ArCoreNode(
         name:"Point$i",
        shape: sphere,
        position:hit.pose.translation,
        rotation: hit.pose.rotation);
   setState(() {
     distance=hit.distance.toString();
     pointName=node.name;
   });
   // startPose=hit.pose;
    arCoreController.addArCoreNodeWithAnchor(node);
  }


   void _nodeTap(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            Text('Remove $name?'),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  arCoreController.removeNode(nodeName: name);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
