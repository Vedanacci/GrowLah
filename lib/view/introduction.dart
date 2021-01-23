import 'on_boarding.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class IntroductionScreen extends StatefulWidget {
  IntroductionScreen({Key key}) : super(key: key);

  @override
  _IntroductionScreenState createState() {
    return _IntroductionScreenState();
  }
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  int page = 0;
  LiquidController liquidController = LiquidController();
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView(
          //   controller: _controller,
          //   children: [
          //     introSlides(1),
          //     introSlides(2),
          //     introSlides(3),
          //   ],
          // ),
          LiquidSwipe(
              pages: [introSlides(1), introSlides(2), introSlides(3)],
              waveType: WaveType.liquidReveal,
              onPageChangeCallback: (pageNo) {
                setState(() {
                  print(pageNo);
                  page = pageNo;
                });
              },
              fullTransitionValue: 900,
              enableLoop: false,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true)
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 50, bottom: 20, top: 20, right: 50),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(
                  "Back",
                  style: page == 0
                      ? TextStyle(
                          fontSize: 18.0,
                          fontFamily: AppConfig.roboto,
                          color: Colors.transparent)
                      : TextStyle(
                          fontSize: 18.0,
                          fontFamily: AppConfig.roboto,
                          color: Colors.green),
                ),
                onPressed: page == 0
                    ? () {}
                    : () {
                        print("Pressed");
                        page -= 1;
                        page = page.isNegative ? 0 : page;
                        liquidController.animateToPage(
                            page: page, duration: _kDuration.inMilliseconds);
                      },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(3, _buildDot),
              ),
              // DotsIndicator(
              //   controller: _controller,
              //   itemCount: 3,
              //   onPageSelected: (int page) {
              //     _controller.animateToPage(
              //       page,
              //       duration: _kDuration,
              //       curve: _kCurve,
              //     );
              //   },
              // ),
              TextButton(
                child: Text(
                  page == 2 ? "Continue" : "Next",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: AppConfig.roboto,
                      color: Colors.green),
                ),
                onPressed: page == 2
                    ? () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnBoardingScreen()));
                      }
                    : () {
                        print("Pressed");
                        page += 1;
                        page = page > 2 ? 2 : page;
                        liquidController.animateToPage(
                            page: page, duration: _kDuration.inMilliseconds);
                      },
              )
            ],
          ),
        ),
      ),
    );
  }

  Scaffold introSlides(int index) {
    return Scaffold(
      backgroundColor: index == 2 ? Colors.green : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("images/onboarding" + index.toString() + ".png"),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Text(
                      index == 1
                          ? "Farming Methods at ease"
                          : index == 2
                              ? "Smart Agriculture"
                              : "Online Marketplace",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: AppConfig.roboto,
                          fontWeight: FontWeight.bold,
                          color: index != 2 ? Colors.green : Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Et rhoncus sed amet nibh curabitur amet at purus. Vel commodo a.",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: AppConfig.roboto,
                            color: index != 2 ? Colors.green : Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    const double _kDotSize = 8.0;

    // The increase in the size of the selected dot
    const double _kMaxZoom = 2.0;

    // The distance between the center of each dot
    const double _kDotSpacing = 25.0;
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: Colors.green,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () {
                print("tapped");
                liquidController.animateToPage(page: index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.green,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: Colors.green,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
