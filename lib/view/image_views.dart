import 'package:flutter/material.dart';
import 'package:grow_lah/utils/assets.dart';
class FullSizeImageView extends StatefulWidget {
  const FullSizeImageView();
  @override
  _FullSizeImageViewState createState() {
    return _FullSizeImageViewState();
  }

}

class _FullSizeImageViewState extends State<FullSizeImageView> {

  List<String> imageList =List<String>();
@override
  void initState() {
  imageList.add(Assets.sample1);
  imageList.add(Assets.sample2);
  imageList.add(Assets.sample3);
  imageList.add(Assets.sample4);
  imageList.add(Assets.sample5);
  imageList.add(Assets.sample6);
  imageList.add(Assets.sample7);
  imageList.add(Assets.sample8);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      title: Text("Hydroponics",style: TextStyle(fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 16.0),),),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: PageView.builder(
          itemCount: imageList.length,
          // store this controller in a State to save the carousel scroll position
          controller: PageController(viewportFraction: 1.0,initialPage:0,keepPage: true),
          onPageChanged: (count) {},
          itemBuilder: (BuildContext context, int itemIndex) {
            return Container(
                color: Colors.white,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Card(
                      elevation: 0.0,
                      color: Colors.white,
                      child: Container(
                          child:
                        Image.asset(imageList[itemIndex])
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))),
                          child: Text(
                            (++itemIndex).toString() +
                                "/" +
                                imageList.length.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                ));
          },
        ),
      ),
    );
  }


}
