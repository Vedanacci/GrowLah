import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grow_lah/view/product_list.dart';
import 'my_garden.dart';
import 'dart:math';
import 'package:clippy_flutter/arc.dart';
import 'package:grow_lah/model/extractImage.dart';

//https://www.google.com/url?sa=i&url=https%3A%2F%2Ftwitter.com%2Fdribbble%2Fstatus%2F1030427833548648449&psig=AOvVaw1uWt8AZxzOW2_MEY4ZrrcY&ust=1608714478583000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMiktsqe4e0CFQAAAAAdAAAAABA3

class GardenMonitor extends StatefulWidget {
  GardenMonitor({Key key, @required this.garden}) : super(key: key);

  final Garden garden;

  @override
  _GardenMonitorState createState() {
    return _GardenMonitorState();
  }
}

class _GardenMonitorState extends State<GardenMonitor>
    with TickerProviderStateMixin {
  @override
  Color grey = Colors.grey.shade700;

  bool forward = true;
  int current = 1;
  int last = 0;
  AnimationController _animationController;
  AnimationController _progressController;
  Animation<double> _translateButton;
  Animation<Color> _colortoWhite;
  Animation<Color> _colortoGrey;
  Curve _curve = Curves.easeOut;
  Tween<double> progressTween = Tween<double>(begin: 0, end: 1);
  Animation<double> _progress;
  Tween<double> _tween = Tween<double>(
    begin: 0,
    end: 1,
  );
  double radius = 0;
  double rotateAngle = pi / 8 - pi * (1.5 / 180.0);

  bool isOpened = false;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateMenu;
  AnimationController _menuController;

  List<double> lightData = [79.0];
  List<double> phData = [7.0];
  List<double> tempData = [27.0];
  List<double> humidityData = [65.0];

  Future getSensorData() async {
    print("started");
    final databaseReference =
        FirebaseDatabase.instance.reference().child("vedantbahadur");

    StreamSubscription<Event> subscription =
        databaseReference.onValue.listen((event) {
      var count = (event.snapshot.value["count"] == null)
          ? 0
          : event.snapshot.value["count"] - 1;
      databaseReference
          .child("light")
          .child(count.toString())
          .once()
          .then((snapshot) {
        print("In light");
        print(snapshot.value);
        var val = snapshot.value;
        val = (val * 10000 / 4095.0).round() / 100;
        print("Val: $val");
        if (val != lightData[0]) {
          print("Mounted");
          setState(() {
            lightData = [val];
            animate(1);
          });
        }
      });
      databaseReference
          .child("temp")
          .child(count.toString())
          .once()
          .then((snapshot) {
        print("In temp");
        print(snapshot.value);
        var val = snapshot.value;
        print("Val: $val");
        if (val != tempData[0]) {
          print("Mounted");
          setState(() {
            tempData = [val];
            animate(1);
          });
        }
      });
      databaseReference
          .child("humidity")
          .child(count.toString())
          .once()
          .then((snapshot) {
        print("In humidity");
        print(snapshot.value);
        var val = snapshot.value;
        print("Val: $val");
        if (val != humidityData[0]) {
          print("Mounted");
          setState(() {
            humidityData = [val];
            animate(1);
          });
        }
      });
      databaseReference
          .child("ph")
          .child(count.toString())
          .once()
          .then((snapshot) {
        print("In PH");
        print(snapshot.value);
        var val = snapshot.value;
        print("PH Val: $val");
        if (mounted) {
          setState(() {
            phData = [val];
            animate(1);
          });
        }
      });
    });
    return subscription;
  }

  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500), value: 0)
      ..addListener(() {
        setState(() {});
      });
    _progressController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3000))
          ..addListener(() {
            setState(() {});
          });
    _translateButton = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    _progress = progressTween.animate(CurvedAnimation(
      parent: _progressController,
      curve: Interval(
        0.0,
        0.75,
        curve: Curves.easeOutSine,
      ),
    ));

    _colortoGrey = ColorTween(
      begin: Colors.green,
      end: grey,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _colortoWhite = ColorTween(
      begin: grey,
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    radius =
        (pow((SizeConfig.screenWidth / 2.0), 2) + pow(50.0, 2)) / (2.0 * 50.0);
    // print("Radius");
    // print(radius);

    _menuController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_menuController);
    _buttonColor = ColorTween(
      begin: Colors.green,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateMenu = Tween<double>(
      begin: 0,
      end: SizeConfig.screenWidth / 4,
    ).animate(CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    animate(1);
    //animateMenu();
    _progressController.forward();
    super.initState();
    getSensorData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  animate(int to) {
    _tween.begin = current.toDouble();
    _animationController.reset();
    _tween.end = to.toDouble();
    _animationController.forward();
    _progressController.reset();
    _progressController.forward();
    last = current;
    current = to;
  }

  animateMenu() {
    print("AmimateMenu");
    print(isOpened);
    if (!isOpened) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    // print(_translateButton.value);
    // print(current);
    List<Widget> labelText = getLabelText(["Levels", "Metrics", "Activity"]);
    print("building");
    print(lightData);
    print(phData);

    Widget share() {
      return Container(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight - 200, left: 20),
        child: FloatingActionButton(
          backgroundColor: _buttonColor.value,
          heroTag: 'Share',
          onPressed: () {
            print("Share Tapped");
            Navigator.pop(context);
          },
          tooltip: 'Home',
          child: Icon(Icons.send, color: Colors.green),
        ),
      );
    }

    Widget refresh() {
      return Container(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight - 200, left: 20),
        child: FloatingActionButton(
          backgroundColor: _buttonColor.value,
          heroTag: 'Refresh',
          onPressed: () {},
          tooltip: 'Refresh',
          child: Icon(Icons.refresh, color: Colors.green),
        ),
      );
    }

    Widget add() {
      return Container(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight - 200, left: 20),
        child: FloatingActionButton(
          backgroundColor: _buttonColor.value,
          heroTag: 'Add',
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProductList())),
          tooltip: 'Add',
          child: Icon(Icons.add, color: Colors.green),
        ),
      );
    }

    Widget toggle() {
      return Container(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight - 200, left: 20),
        child: FloatingActionButton(
          heroTag: 'Toggle',
          backgroundColor: _buttonColor.value,
          onPressed: animateMenu,
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

    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppConfig.appBar(widget.garden.name, context, true,
            showRefer: false, color: Colors.green, fontSize: 20),
        body: GestureDetector(
            onHorizontalDragEnd: (details) {
              print("Swiped");
              print(details);
              if (details.primaryVelocity < 0) {
                if (current != 2) {
                  animate(current + 1);
                }
              } else if (details.primaryVelocity > 0) {
                if (current != 0) {
                  animate(current - 1);
                }
              }
            },
            child: Stack(children: [
              SingleChildScrollView(
                  child: Stack(
                children: [
                  Arc(
                      arcType: ArcType.CONVEX,
                      edge: Edge.BOTTOM,
                      height: 50.0,
                      clipShadows: [ClipShadow(color: Colors.black)],
                      child: Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.3 + 100,
                          padding: EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(color: Colors.white))),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.transparent,
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.center,
                          height: SizeConfig.screenHeight * 0.3,
                          child: cachedImage(
                            widget.garden.image,
                            //fit: BoxFit.fitWidth,
                          ),
                        ),
                        Column(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: labelText,
                          ),
                          Transform.rotate(
                            origin: Offset(0, -radius),
                            angle: (1 - _translateButton.value) * rotateAngle,
                            child: Icon(
                              Icons.maximize_rounded,
                              color: Colors.green,
                              size: 50,
                            ),
                          ),
                          Stack(
                            children: [
                              Transform.rotate(
                                origin: Offset(0, -radius - 100),
                                angle: pi / 2 * _translateButton.value,
                                child: levels(),
                              ),
                              Transform.rotate(
                                origin: Offset(0, -radius - 100),
                                angle:
                                    -pi / 2 + pi / 2 * _translateButton.value,
                                child: metrics(),
                              ),
                              Transform.rotate(
                                origin: Offset(0, -radius - 100),
                                angle: -pi + pi / 2 * _translateButton.value,
                                child: activity(),
                              )
                            ],
                          )
                        ]),
                      ]),
                ],
              )),
              Transform.translate(
                offset: Offset(_translateMenu.value, 0),
                child: add(),
              ),
              Transform.translate(
                offset: Offset(_translateMenu.value * 2, 0),
                child: refresh(),
              ),
              Transform.translate(
                offset: Offset(_translateMenu.value * 3, 0),
                child: share(),
              ),
              toggle(),
            ])));
  }

  Widget levels() {
    print("building");
    print(lightData);
    print(phData);
    return Column(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            "Water Levels (%) : ${90}",
            textAlign: TextAlign.start,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: 24,
              //decoration: TextDecoration.underline
            ),
          ),
        ),
        curvedProgress(_progress.value, 0, 100, 90),
        SizedBox(
          height: 50,
        ),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            "Nutrient Levels (%) : ${23}",
            textAlign: TextAlign.start,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: 24,
              //decoration: TextDecoration.underline
            ),
          ),
        ),
        curvedProgress(_progress.value, 0, 100, 23),
        SizedBox(
          height: 100,
        )
      ],
    );
  }

  Widget metrics() {
    return Column(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            "PH Measurements : ${(phData == null) ? 'Error' : phData[0]}",
            textAlign: TextAlign.start,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: 24,
              //decoration: TextDecoration.underline
            ),
          ),
        ),
        curvedProgress(_progress.value, 0, 14,
            (phData == null) ? 0 : phData[0].toDouble()),
        SizedBox(
          height: 50,
        ),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            "Light Ambience (%) : ${(lightData == null) ? 'Error' : lightData[0]}",
            textAlign: TextAlign.start,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: 24,
              //decoration: TextDecoration.underline
            ),
          ),
        ),
        curvedProgress(
            _progress.value, 0, 100, (lightData == null) ? 0 : lightData[0]),
        SizedBox(
          height: 50,
        ),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            "Temperature (˚C) : ${(tempData == null) ? 'Error' : tempData[0]}",
            textAlign: TextAlign.start,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: 24,
              //decoration: TextDecoration.underline
            ),
          ),
        ),
        curvedProgress(_progress.value, 0, 50,
            (tempData == null) ? 0 : tempData[0].toDouble()),
        SizedBox(
          height: 50,
        ),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            "Humidity (%) : ${(humidityData == null) ? 'Error' : humidityData[0]}",
            textAlign: TextAlign.start,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: 24,
              //decoration: TextDecoration.underline
            ),
          ),
        ),
        curvedProgress(_progress.value, 0, 100,
            (humidityData == null) ? 0 : humidityData[0])
      ],
    );
  }

  Widget activity() {
    return Container(
        width: SizeConfig.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            activityCard("URGENT!", "The pot need cleaning!"),
            activityCard("22 December 2020", "Nutrients and Water Refilled"),
            activityCard(
                "21 December 2020", "Water dropped below optimal level!"),
            activityCard(
                "5 December 2020", "Tomatos and Lettuce seeds planted"),
            SizedBox(
              height: 100,
            )
          ],
        ));
  }

  Widget activityCard(String title, String description) {
    return Container(
      padding: EdgeInsets.all(10),
      width: SizeConfig.screenWidth - 20,
      child: Neumorphic(
        style:
            AppConfig.neuStyle.copyWith(shadowLightColor: Colors.transparent),
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth - 20,
              padding: EdgeInsets.all(10),
              child: Text(
                title,
                style: TextStyle(fontSize: 24, color: Colors.green),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: SizeConfig.screenWidth - 20,
              padding: EdgeInsets.all(10),
              child: Text(
                description,
                style: TextStyle(fontSize: 18, color: Colors.green),
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getLabelText(List<String> labels) {
    List<Widget> labelText = [];
    for (String text in labels) {
      Widget textWdg = Text(
        text,
        style: GoogleFonts.varelaRound(
            color: current == labels.indexOf(text)
                ? _colortoWhite.value
                : last == labels.indexOf(text)
                    ? _colortoGrey.value
                    : grey, //Color.fromRGBO(101, 117, 144, 1),
            fontSize: 20,
            fontWeight: current == labels.indexOf(text)
                ? FontWeight.bold
                : FontWeight.normal),
      );
      textWdg = Container(
        child: textWdg,
        //color: Colors.blue,
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: SizeConfig.screenWidth / 3,
      );
      textWdg = Transform.rotate(
        angle: pi / 8 * (1 - labels.indexOf(text)),
        child: textWdg,
        origin: Offset(
            (1 - labels.indexOf(text)) * SizeConfig.screenWidth / 6, -(0.0)),
      );
      textWdg = GestureDetector(
        child: textWdg,
        onTap: () {
          print("Tapped");
          print(text);
          animate(labels.indexOf(text));
        },
      );
      labelText.add(textWdg);
    }
    return labelText;
  }
}

Widget curvedProgress(
    double progress, double start, double end, double position) {
  return Container(
    width: SizeConfig.screenWidth,
    height: 20,
    padding: EdgeInsets.symmetric(horizontal: 15),
    //alignment: Alignment.topLeft,
    //color: Colors.black,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: pi / 8,
          child: Text(start.toString(),
              style: GoogleFonts.varelaRound(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        CustomPaint(
          painter: CurvedPainter(progress * position / end),
        ),
        // SizedBox(
        //   width: SizeConfig.screenWidth - 90,
        // ),
        Transform.rotate(
          angle: -pi / 8,
          child: Text(
            end.toString(),
            style: GoogleFonts.varelaRound(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

class CurvedPainter extends CustomPainter {
  final double progress;
  CurvedPainter(this.progress);

  final radius =
      (pow((SizeConfig.screenWidth / 2.0), 2) + pow(50.0, 2)) / (2.0 * 50.0);

  final hyp = sqrt(50 * 50 + pow((SizeConfig.screenWidth / 2.0), 2));

  @override
  void paint(Canvas canvas, Size size) {
    final theta =
        acos((2 * pow(radius, 2) - pow(hyp, 2)) / (2 * pow(radius, 2)));
    // print("Theta");
    // print(theta * 180 / pi);
    //print(progress);
    Paint paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.green;

    Paint outer = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    Paint border = Paint()
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    drawCurve(border, canvas, 1);
    drawCurve(outer, canvas, 1);
    drawCurve(paint, canvas, progress);
  }

  void drawCurve(Paint paint, Canvas canvas, double progress) {
    canvas.drawArc(
        Offset(-SizeConfig.screenWidth / 2 + 25, -70) &
            Size(SizeConfig.screenWidth - 50, 100),
        2 * pi / 8 + (pi - 4 * pi / 8) * (1 - progress), //radians
        (pi - 4 * pi / 8) * progress, //radians
        false,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
