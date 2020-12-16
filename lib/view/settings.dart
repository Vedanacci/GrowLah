import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/settings_list.dart';
import 'package:grow_lah/model/settings_model.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/assets.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/authentication.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  List<SettingsModel> settingsList = List<SettingsModel>();
  @override
  void initState() {
    settingsList = SettingsList.getSettingsList();
    settingsList[6].onClick = () {
      print("Signing out");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthenticationScreen()));
      FirebaseAuth.instance.signOut();
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<bool> switchList = [true, true, true];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppConfig.appBar(CommonStrings.settings, context, true),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(parent: ScrollPhysics()),
            itemCount: settingsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Neumorphic(
                  style:
                      AppConfig.neuStyle.copyWith(boxShape: AppConfig.neuShape),
                  child: Container(
                    height: 55.0,
                    width: 374.0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                              onPressed: settingsList[index].onClick,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              child: Text(
                                settingsList[index].title,
                                style: TextStyle(
                                    fontFamily: AppConfig.roboto,
                                    color: Colors.green,
                                    fontSize: 16.0),
                              )),
                          settingsList[index].isChecked
                              ? Switch(
                                  activeColor: Colors.green,
                                  value: switchList[index],
                                  onChanged: (bool newValue) {
                                    print(newValue);
                                    setState(() {
                                      switchList[index] = newValue;
                                      print(switchList);
                                    });
                                  })
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
