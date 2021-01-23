import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:video_player/video_player.dart';

class VideosScreen extends StatefulWidget {
  VideosScreen({Key key}) : super(key: key);

  @override
  _VideosScreenState createState() {
    return _VideosScreenState();
  }
}

class _VideosScreenState extends State<VideosScreen> {
  ChewieController _chewieController;
  List<String> videosList = List<String>();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    videosList.add(
        'https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/Videos%2FHow%20to%20build%20a%20low-tech%20hydroponics%20system%20-%20DIY%20Tutorial.mp4?alt=media&token=c80a0d00-50ea-4646-918a-6696a43cb3f3'); //https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4
    videosList.add(
        'https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/Videos%2FA%20Beginners%20Guide_%20Hydroponic%20Design.mp4?alt=media&token=db4c1370-37bb-4ab4-b1ec-3a5b49d900fe'); //http://techslides.com/demos/sample-videos/small.mp4 //https://www.youtube.com/watch?v=n67F-_A5Rrw
    videosList.add(
        "https://firebasestorage.googleapis.com/v0/b/growlah-bcb3f.appspot.com/o/Videos%2FHow%20to%20Start%20Your%20Seeds%20in%20a%20Hydroponics%20System.mp4?alt=media&token=900a3306-ec21-4d56-918b-a8d0343eada1");
    super.initState();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppConfig.appBar(CommonStrings.videoStory, context, true),
      body: SafeArea(
          child: Container(
        color: Colors.white12,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Neumorphic(
                style: NeumorphicStyle(
                    depth: -8,
                    shadowDarkColor: Colors.black54,
                    lightSource: LightSource.topLeft,
                    color: Colors.white,
                    intensity: 0.86,
                    surfaceIntensity: 0.5,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.all(Radius.circular(10.0)))),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      textAlign: TextAlign.start,
                      maxLength: 10,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search here....',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: videosList.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(parent: ScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          shadowDarkColor: Colors.black54,
                          lightSource: LightSource.topLeft,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.all(Radius.circular(10.0))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 250.0,
                              child: Chewie(
                                controller: getChewieController(index),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 40.0,
                              child: Center(
                                child: Text(
                                  'Cultivation',
                                  style: TextStyle(
                                      fontFamily: AppConfig.roboto,
                                      color: Colors.green),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }

  getChewieController(int index) {
    _chewieController = ChewieController(
        // placeholder: Container(
        //     width: SizeConfig.screenWidth - 20,
        //     color: Colors.white,
        //     child: RefreshProgressIndicator(
        //       valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        //     )),
        autoInitialize: true,
        aspectRatio: 3 / 2,
        videoPlayerController:
            VideoPlayerController.network(videosList[index]));
    return _chewieController;
  }
}
