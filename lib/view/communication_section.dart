import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/commuication_detail.dart';

class CommunicationSection extends StatefulWidget {
  CommunicationSection({Key key}) : super(key: key);

  @override
  _CommunicationSectionState createState() {
    return _CommunicationSectionState();
  }
}

class _CommunicationSectionState extends State<CommunicationSection> {
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
      appBar: AppConfig.appBar(CommonStrings.communication, context, true),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(parent: ScrollPhysics()),
              itemCount: 6,
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailCommunication()));
                      },
                      child: Neumorphic(
                        style: AppConfig.neuStyle
                            .copyWith(boxShape: AppConfig.neuShape),
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          child: Image.asset(
                            getImage(index, false),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      getImage(index, true),
                      style: TextStyle(
                        fontFamily: AppConfig.roboto,
                        color: Colors.green,
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  getImage(int index, bool forText) {
    switch (index) {
      case 0:
        return forText ? 'Farmers' : Assets.comm1;
        break;
      case 1:
        return forText ? 'House workers' : Assets.comm2;
        break;
      case 2:
        return forText ? 'Labours' : Assets.comm3;
        break;
      case 3:
        return forText ? 'Workers' : Assets.comm4;
        break;
      case 4:
        return forText ? 'Sellers' : Assets.comm5;
        break;
      case 5:
        return forText ? 'Buyers' : Assets.comm6;
        break;
    }
  }
}
