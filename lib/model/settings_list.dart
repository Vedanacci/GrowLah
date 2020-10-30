import 'package:grow_lah/model/settings_model.dart';
import 'package:grow_lah/utils/common_strings.dart';

class SettingsList {
  static getSettingsList() {
    List<SettingsModel> settingsList = [
      SettingsModel(0, CommonStrings.permissions, true, () {}),
      SettingsModel(1, CommonStrings.pushNotification, true, () {}),
      SettingsModel(2, CommonStrings.locationServices, true, () {}),
      SettingsModel(3, CommonStrings.privacyPolicy, false, () {}),
      SettingsModel(4, CommonStrings.termsAndCondition, false, () {}),
      SettingsModel(5, CommonStrings.appFeedback, false, () {}),
      SettingsModel(6, CommonStrings.logOut, false, () {
        print("Logout");
      })
    ];
    return settingsList;
  }
}
