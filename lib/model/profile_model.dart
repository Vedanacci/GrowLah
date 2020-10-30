import 'package:grow_lah/utils/common_strings.dart';

class ProfileModel{
  static profileList(){
    List<dynamic> profileViewLists=[
      CommonStrings.selectLanguage,
      CommonStrings.notifications,
      CommonStrings.myRewards,
      CommonStrings.myOrders,
      CommonStrings.logOut
    ];
    return profileViewLists;
  }
}